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
- Required files:
  - `index.md` - Game metadata and description with frontmatter
  - `cover.jpg` or `cover.png` - Game thumbnail/cover image
- Optional directories:
  - `gallery/` - Screenshots and media files (*.jpg, *.png)
  - `downloads/` - Downloadable game files (*.zip)
- Frontmatter fields:
  - `title` (required) - Game title
  - `slug` (required) - URL-friendly identifier
  - `description` (required) - Brief game description
  - `releaseDate` (required) - Release date (YYYY-MM-DD)
  - `platforms` (optional) - Array of supported platforms
  - `tags` (optional) - Array of categorization tags
  - `featured` (optional) - Boolean to feature on homepage

### Games (WIP)
- Place games currently in development in `content/games/wip/<slug>/`
- Follow the same structure as published games
- Additional frontmatter fields:
  - `status` - Should be set to "wip"
  - `startDate` (optional) - Development start date
  - `expectedRelease` - Expected release date (YYYY-MM-DD)

### Tools
- Place tools and utilities in `content/tools/<slug>/`
- Required files:
  - `index.md` - Tool metadata and documentation
  - `cover.jpg` or `cover.png` - Tool thumbnail
- Optional directories:
  - `downloads/` - Tool downloads for different platforms
- Frontmatter fields:
  - `title` (required) - Tool name
  - `slug` (required) - URL-friendly identifier
  - `description` (required) - Tool description
  - `version` (required) - Current version number
  - `releaseDate` (required) - Release date (YYYY-MM-DD)
  - `license` (optional) - License type
  - `platforms` (optional) - Supported platforms
  - `tags` (optional) - Categorization tags

### Articles
- Create articles in `content/articles/` with date-prefixed folder names
- Use format: `YYYY-MM-DD-title/`
- Required files:
  - `index.md` - Article content with frontmatter
- Optional directories:
  - `images/` - Article images and diagrams
- Frontmatter fields:
  - `title` (required) - Article title
  - `slug` (required) - URL-friendly identifier
  - `date` (required) - Publication date (YYYY-MM-DD)
  - `author` (optional) - Author name
  - `category` (required) - Article category (e.g., "tutorial", "guide")
  - `tags` (optional) - Array of tags
  - `featured` (optional) - Boolean to feature on homepage

### Blog
- Create blog posts in `content/blog/` with date-prefixed folder names
- Use format: `YYYY-MM-DD-title/`
- Required files:
  - `index.md` - Blog post content with frontmatter
- Optional directories:
  - `images/` - Blog post images
- Frontmatter fields:
  - `title` (required) - Blog post title
  - `slug` (required) - URL-friendly identifier
  - `date` (required) - Publication date (YYYY-MM-DD)
  - `author` (optional) - Author name
  - `category` (required) - Post category (e.g., "devlog", "announcement")
  - `tags` (optional) - Array of tags

## Manifest File

The `content/manifest.json` file serves as an index of all content, making it easy for the showcase site to discover and display content without crawling the directory structure.

### Structure

The manifest contains the following top-level properties:
- `version` - Manifest schema version
- `lastUpdated` - ISO 8601 timestamp of last update
- `games` - Object containing `published` and `wip` arrays
- `tools` - Array of tool entries
- `articles` - Array of article entries
- `blog` - Array of blog post entries

### Entry Properties

**Published Games:**
- `slug` - Unique identifier
- `title` - Game title
- `path` - Relative path to game directory
- `coverImage` - Filename of cover image
- `gallery` - Array of gallery image paths (relative to game directory)
- `downloads` - Array of download file paths (relative to game directory)
- `releaseDate` - Release date (YYYY-MM-DD)
- `featured` - Boolean for homepage featuring

**WIP Games:**
- Same as published games, plus:
- `status` - Should be "wip"
- `expectedRelease` - Expected release date (YYYY-MM-DD)

**Tools:**
- `slug` - Unique identifier
- `title` - Tool name
- `path` - Relative path to tool directory
- `coverImage` - Filename of cover image
- `downloads` - Array of download file paths
- `version` - Version number
- `releaseDate` - Release date (YYYY-MM-DD)

**Articles:**
- `slug` - Unique identifier
- `title` - Article title
- `path` - Relative path to article directory
- `date` - Publication date (YYYY-MM-DD)
- `category` - Article category
- `featured` - Boolean for homepage featuring (optional)

**Blog Posts:**
- `slug` - Unique identifier
- `title` - Post title
- `path` - Relative path to blog post directory
- `date` - Publication date (YYYY-MM-DD)
- `category` - Post category

### Schema

A JSON Schema file (`manifest.schema.json`) is provided in the repository root to validate the manifest structure. Use it with your editor or build tools to ensure manifest validity.

Update this file whenever adding new content to ensure it appears on the site.

## Adding New Content

1. Create the appropriate directory structure
2. Add `index.md` with proper frontmatter
3. Include required assets (cover images, downloads, etc.)
4. Update `manifest.json` with the new content entry
