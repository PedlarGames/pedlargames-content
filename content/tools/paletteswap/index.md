# PaletteSwap - Color Palette Remapping Tool

A desktop utility application built with Godot 4.5 for batch color palette remapping of images. Useful for game developers, pixel artists, and designers who need to quickly retheme sprite sets or apply color transformations to multiple images at once.

Works best with pixel art with low resolution images, but can also handle photos with quantized palettes.

## Features

**Batch Processing** - Process multiple images at once  
**Palette Extraction** - Exact color enumeration or quantized palette reduction  
**Color Mapping** - Visual interface to remap source colors to target colors  
**Save/Load Mappings** - Persist palette mappings as JSON for reuse  
**Lospec Import** - Import color palettes directly from Lospec.com  
**Flexible Input** - Load entire folders or individual images  
**Format Support** - PNG, JPG, WebP, BMP  
**Performance** - Efficient pixel processing with progress tracking  
**Alpha Handling** - Option to preserve or include alpha in mapping  
**RGB Grouping** - Group colors by RGB values, ignoring alpha variations

## Installation

Download the Windows installer from the link at the bottom of the page. Run the installer and follow the prompts to install PaletteSwap on your system.

You may see a SmartScreen warning on first run; this is normal for new apps. Click "More info" and "Run anyway" to proceed.

## Usage

### Basic Workflow

1. **Load Images**
   - Click "Select Folder" to load all images from a directory
   - Or click "Add Images" to select individual files

2. **Extract Palette**
   - Choose mode:
     - **Exact** - All unique colors (best for pixel art)
     - **Quantized** - Reduce to N colors (best for photos)
   - Click "Extract Palette"
   - Wait for extraction to complete

3. **Map Colors**
   - For each source color (left), click the color picker (right)
   - Select the target color you want to map to
   - **OR** use the Lospec importer:
     - Paste a Lospec palette URL (e.g., `https://lospec.com/palette-list/resurrect-64`)
     - Click "Import" to retrieve colors from the Lospec palette
     - Click a lospec color to assign it to the selected source color
     - Click the target color picker to finalize

4. **Export**
   - Click "Export Images"
   - Select output directory
   - Configure suffix (default: "_remap")
   - Wait for processing to complete

### Advanced Features

#### Lospec Integration

- **Import from Lospec.com** - Paste a palette URL to automatically load colors
- Browse [Lospec Palette List](https://lospec.com/palette-list) for thousands of curated palettes
- After importing, lospec colors will be shown above your current mappings for easy selection
- Click a lospec color to assign it to the selected source color, then click the target color picker to finalize

#### Save/Load Mappings

- **Save Mapping** - Export your color mappings as JSON
- **Load Mapping** - Import previously saved mappings
- Mappings are stored in `user://mappings/`

#### Palette Options

- **Skip Fully Transparent Pixels** - Exclude pixels with alpha = 0 from palette extraction (reduces palette clutter)
- **Group by RGB (Alpha Variations)** - Merge colors with identical RGB but different alpha values (useful for transparency gradients and anti-aliased sprites)

#### Settings

- **File Suffix** - Customize output filename suffix
- **Preserve Alpha** - Keep original alpha channel when mapping RGB only
- **Text Size** - Adjust UI font size for accessibility

#### Before/After Preview

- Select an image from the list to see a side-by-side comparison
- Preview updates automatically when you change color mappings
- Thumbnails are cached for performance

## Limitations

- **Color Space** - Works in sRGB; gamma considerations apply
- **Format Support** - JPG has no alpha channel
- **Large Palettes** - Photos may have thousands of colors (use quantization)
- **Memory** - All images loaded into memory during processing

## Examples

### Example 1: Forest to Desert Theme

```markdown
1. Load forest sprite set
2. Extract exact palette (greens, browns)
3. Map:
   - Dark Green → Sand Brown
   - Light Green → Light Sand
   - Grass Green → Desert Yellow
4. Export with suffix "_desert"
```

### Example 2: Photo Color Grading

```markdown
1. Load photo
2. Extract quantized palette (64 colors)
3. Shift all hues toward warm tones
4. Export with suffix "_warm"
```

## Troubleshooting

**Q: "No colors extracted"**  
A: Ensure images are loaded first. Check status bar for errors.

**Q: "Export fails"**  
A: Verify output directory exists and has write permissions.

**Q: "Too many colors"**  
A: Use Quantized mode to reduce palette size.

**Q: "Colors don't match exactly"**  
A: Try toggling "Include Alpha" - alpha channel affects color matching.

## License

This project is provided as-is for educational and commercial use. See LICENSE file for details.

## Acknowledgments

- Built with **Godot Engine 4.5**
- Inspired by the fantastic pixel art community on [**Lospec.com**](https://lospec.com)

## Roadmap

- [ ] HSV-based color mapping
- [ ] Per-channel mapping (hue/saturation/lightness)
- [ ] GPU shader-based processing
- [ ] Godot editor plugin variant
- [ ] Batch undo/redo
- [ ] Nearest-color matching for partial mappings
