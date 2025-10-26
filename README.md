# pedlargames-content

Website Contents for Pedlar Games

This repository contains all content for the Pedlar Games showcase site, including games, tools, articles, and blog posts.

## Directory Structure

```
content/
  games/
    published/          # Released games
      <slug>/
        index.md        # Game metadata and description
        cover.jpg       # Cover image
        gallery/        # Screenshots and media
          *.jpg
        downloads/      # Downloadable files
          *.zip
    wip/                # Work-in-progress games
      <slug>/
        index.md
        ...
  tools/                # Development tools and utilities
    <slug>/
      index.md
      cover.jpg
      downloads/
        *.zip
  articles/             # Technical articles and tutorials
    YYYY-MM-DD-title/
      index.md
      images/...
  blog/                 # Blog posts and devlogs
    YYYY-MM-DD-title/
      index.md
      images/...
  manifest.json         # Content index for the showcase site
```

## Content Guidelines

### Games (Published)
- Place completed, released games in `content/games/published/<slug>/`
- Include `index.md` with frontmatter containing title, description, release date, platforms, and tags
- Add a `cover.jpg` for the game thumbnail
- Store screenshots in the `gallery/` subdirectory
- Place downloadable files in the `downloads/` subdirectory

### Games (WIP)
- Place games currently in development in `content/games/wip/<slug>/`
- Follow the same structure as published games
- Include development status and expected release date in frontmatter

### Tools
- Place tools and utilities in `content/tools/<slug>/`
- Include version information and system requirements
- Provide downloads for different platforms if applicable

### Articles
- Create articles in `content/articles/` with date-prefixed folder names
- Use format: `YYYY-MM-DD-title/`
- Include technical content, tutorials, and guides

### Blog
- Create blog posts in `content/blog/` with date-prefixed folder names
- Use format: `YYYY-MM-DD-title/`
- Include devlogs, updates, and general posts

## Manifest File

The `content/manifest.json` file serves as an index of all content, making it easy for the showcase site to discover and display content without crawling the directory structure.

Update this file whenever adding new content to ensure it appears on the site.

## Adding New Content

1. Create the appropriate directory structure
2. Add `index.md` with proper frontmatter
3. Include required assets (cover images, downloads, etc.)
4. Update `manifest.json` with the new content entry
