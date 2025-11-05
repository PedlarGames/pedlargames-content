# Integrating Location Graph Editor with Dialogue Manager

This is a high level article describing how I integrated my [Location Graph Editor](https://pedlargames.com/tools/location-graph-editor) plugin with [Nathan Hoad's Dialogue Manager](https://github.com/nathanhoad/godot_dialogue_manager) plugin for my **interactive fiction** game [The Bog Mother](https://pedlargames.com/games/the-bog-mother) made with Godot.

## NOT A Tutorial

This article is not intended as a step-by-step tutorial, but rather a high-level overview of how I approached the problem of managing locations in my game using Location Graph Editor and Dialogue Manager. My goal is to demonstrate how Location Graph Editor can be useful in a real world example, and to provide some ideas for how you might implement similar functionality in your own projects.

Code samples are provided to illustrate key concepts, but they are not complete or fully functional on their own. You will need to adapt the ideas and code snippets to fit your specific game architecture and requirements.

## The Problem

In a typical text adventure, or indeed any RPG or adventure game, the player moves between locations. "Go North", "Enter the Cave", "Open the Cellar Door". How do we represent this in a way that is easy to author, easy to maintain, and easy to use in the game? We need a way to define locations, and the connections between them, as well as a means of accessing this data in our game logic.

## The Solution

I used Godot's [GraphEdit](https://docs.godotengine.org/en/stable/classes/class_graphedit.html) feature (used in the Visual Shader Editor, for example) to create my Location Graph Editor plugin. This allows me to visually create locations as nodes, and draw connecting lines between them. Each location node can have properties such as name, id, description, and any other metadata needed for the game. Each connection can be defined as one-way or bi-directional, locked/unlocked, and hidden/visible.

I also created a runtime script that exposes functions to query the location graph. This script can return a list of connected locations from a given location, check if a path is locked, and so on.

![Location Graph Editor Screenshot](https://raw.githubusercontent.com/PedlarGames/location-graph-editor/refs/heads/main/screenshots/example_graph.png)

## Why Use Dialogue Manager?

Dialogue Manager is a highly adaptable plugin for managing dialogue trees and branching narratives in Godot. It provides a robust framework for handling player choices, dialogue states, and narrative flow, and it can interact with other game functions and variables from within dialogue scripts. *The Bog Mother* is a text-heavy game, in which almost every action the player takes is mediated through dialogue, so integrating location management with Dialogue Manager seemed like a good fit.

![Example Dialogue Script](https://github.com/PedlarGames/pedlargames-content/blob/main/content/articles/2025-11-05-location-graphs-and-dialogue-manager/gallery/example-dialogue-script.png?raw=true)

### Note

Whenever you see me write 'dialogue', assume I'm referring to both dialogue and narrative text, since in my game these are often the same thing. Instead of the standard pattern of displaying one line of dialogue at a time next to a character's portrait, I'm using Dialogue Manager to display blocks of narrative text in a continuously appended log.

![Narrative Log Example](https://raw.githubusercontent.com/PedlarGames/location-graph-editor/refs/heads/main/screenshots/in-game-example.png)

## How I Did It

This is very much a rough overview, since my implementation is quite specific to my game, and my game code is, shall we say, idiosyncratic.

Much of the glue that connects the location graph to Dialogue Manager is handled by a story.gd script, which builds the UI from dialogue resources and manages the flow of the game. Additionally, there is an autoload State Manager script, with state data stored in a custom resource for easy reference. Dialogue Manager can easily call autoload scripts from within dialogue scripts, which makes things very easy.

### Loading Dialogue Resources Based on Location

My first insight was to create a dialogue script for each location node in the graph. The name of the dialogue script file corresponds to the location id in the graph, e.g. a location node with id "forest_clearing" would have a dialogue script file named "forest_clearing.dialogue". Thus, when the player enters a location, we load an associated dialogue resource based on the current location id.

```python
story.gd

## Given a location node, attempt to load the associated DialogueResource.
## The naming convention is that the dialogue resource is named after the location id.
func _get_dialogue_resource_from_location(location_node: LocationNodeData) -> DialogueResource:
    # Convention-based naming
    var dialogue_path: String = String(location_node.id) + ".dialogue"
    return load_dialogue(dialogue_path)
    
## Load a DialogueResource from a given path.
func load_dialogue(dialogue_path: String) -> DialogueResource:
    var path_prefix: String = "res://game/resources/dialogues/"
    dialogue_path = path_prefix + dialogue_path
    if ResourceLoader.exists(dialogue_path):
        var resource: Resource = null
        resource = ResourceLoader.load(dialogue_path)
        if resource is DialogueResource:
            return resource
    return null
```

Once we have the DialogueResource for the current location, we use it in a DialogueLabel node to present the dialogue to the player just like any other dialogue in Dialogue Manager.

### Moving Between Locations

On some trigger activated by the player, or when the dialogue ends, we give the player the option to move to a connected location. We query the Location Graph Editor runtime script to get the list of connected locations, and present these as if they were choices in the dialogue. Then when the player selects a location, we update the current location in the State Manager, and load the dialogue for the new location.

```python
story.gd

## Add buttons to travel container for each neighbor (including locked ones)
func _populate_travel_options() -> void:
    for neighbor_id in runtime.get_all_neighbors(State.get_current_location()):
        _create_travel_button(neighbor_id)
        
## Create and configure a travel button for a neighboring location.
func _create_travel_button(neighbor_id: String) -> void:
    var neighbor_node: LocationNodeData = runtime.get_location_node(neighbor_id)
    var is_locked: bool = runtime.is_edge_locked(State.get_current_location(), neighbor_id)
    var is_hidden: bool = runtime.is_edge_hidden(State.get_current_location(), neighbor_id)
    
    # Don't show hidden connections at all
    if is_hidden:
        return
    
    # Create the button
    var button: ChoiceButton = choice_button_scene.instantiate()
    
    # Set button text to the port label (e.g., "Go North")
    if neighbor_node:
        var port_label: String = runtime.get_port_label_between(State.get_current_location(), neighbor_id, true, false)
        button.text = port_label
    
    # Handle locked connections
    if is_locked:
        button.disabled = true
        button.tooltip_text = "This path is locked"
    else:
        button.pressed.connect(func(id: String=neighbor_id) -> void:
            go_to_location(id)
        )
    
    # travel_container is a VBoxContainer holding the travel buttons
    travel_container.add_child(button)

## Handle moving to a new location.
func go_to_location(location_id: String) -> void:
    # Update current location in State Manager and add it to visit history
    State.visit_location(location_id)
    # Get the location node data from the runtime
    var node_data: LocationNodeData = runtime.get_location_node(State.get_current_location())
    if node_data:
        # Load the dialogue resource associated with this location
        dialogue_resource = _get_dialogue_resource_from_location(node_data)
        if dialogue_resource:
            # Get the first line of dialogue from the resource
            current_dialogue_line = await DialogueManager.get_next_dialogue_line(dialogue_resource, dialogue_resource.first_title)
            if current_dialogue_line:
                # Display the dialogue line
                _update_story_text(current_dialogue_line)
```

## Further Integration

We don't always want the same dialogue to play when the player re-enters a location. In my State Manager, I keep track of which locations have been visited (and in which order), allowing me to branch dialogues based on visit history.

```python
## In a dialogue script:
~ start
if State.get_visit_count("forest_clearing") == 0:
    => first_time_forest_clearing
else:
    => returning_forest_clearing
```

```python
## In a dialogue script:
~ start
if State.get_previous_location() == "ancient_tree":
    => arrived_from_ancient_tree
else:
    => arrived_from_elsewhere
```

This allows for a dynamic narrative that responds to the player's journey through the game world.

## Conclusion

Hopefully this article has given you some ideas on how to use Location Graph Editor in your game, especially in conjunction with Dialogue Manager. The visual nature of the location graph makes it easy to design and maintain complex worlds, and Dialogue Manager is flexible enough to integrate with various game systems. If you're building an interactive fiction game in Godot, this may be a useful approach, but you can also use Location Graph Editor in other scenarios - for example by using hidden connections to gradually reveal nodes on a world map as the player explores, and use the built-in pathfinding to determine whether the player can reach a given destination from their current location.

### Resources

- [Location Graph Editor](https://pedlargames.com/tools/location-graph-editor)
  - [GitHub Repository](https://github.com/PedlarGames/location-graph-editor)
  - [Godot Asset Library](https://godotengine.org/asset-library/asset/4444)
- [Dialogue Manager](https://dialogue.nathanhoad.net/)
  - [GitHub Repository](https://github.com/nathanhoad/godot_dialogue_manager)
  - [Godot Asset Library](https://godotengine.org/asset-library/asset/3654)

### Comments or Questions?

Reach me on Bluesky at [@hugepedlar.bsky.social](https://bsky.app/profile/hugepedlar.bsky.social) or visit the [Discussions section of the Location Graph Editor GitHub repository](https://github.com/PedlarGames/location-graph-editor/discussions).
