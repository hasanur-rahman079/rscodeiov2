<p align=center>
  <img src="./inst/media/rscodeio.png" width="480" height="270">
</p>

<p align="center">
  <a href="https://cran.r-project.org/package=rscodeio">
    <img src="https://img.shields.io/cran/l/rscodeio?style=flat-square" alt="cran">
  </a>
  <a href="https://github.com/hasanur-rahman079/rscodeiov2/releases/latest">
    <img src="https://img.shields.io/github/v/release/hasanur-rahman079/rscodeiov2?sort=semver&style=flat-square" alt="release">
  </a>
  <a href="https://www.tidyverse.org/lifecycle/#experimental">
    <img src="https://img.shields.io/badge/lifecycle-experimental-orange?style=flat-square" alt="lifecycle" />
  </a>
</p>

# rscodeiov2

An RStudio theme inspired by Visual Studio Code. **Updated for RStudio 2025 compatibility!**

## Prerequisites

- RStudio 1.2.x or higher (tested up to RStudio 2025)
- R 4.0.0 or higher
- Administrator privileges on Windows/Linux for menu theming

## Installation

Get the package:

```r
remotes::install_github("hasanur-rahman079/rscodeiov2")
```

### Important: Administrator Privileges Required

`rscodeio` modifies the theme of RStudio menus by editing style sheets in the RStudio installation directory. This requires administrator privileges:

**Windows:**
- Right-click on RStudio shortcut → "Run as Administrator"
- Or start from Command Prompt as Administrator: `"C:\Program Files\RStudio\rstudio.exe"`

**Linux:**
- Start RStudio with: `sudo rstudio --no-sandbox`

**macOS:**
- No administrator privileges needed
- Menu theming is not supported (menus inherit from macOS system theme)
- Editor themes will still work perfectly

### Install and Apply Theme

From within RStudio running as administrator:

```r
# Install and activate the theme
rscodeiov2::install_theme()

# Restart RStudio for full effect
```

### Troubleshooting

If you encounter issues, run the diagnostic function:

```r
# Get detailed diagnostic information
rscodeio::rscodeio_diagnose()
```

This will show:
- RStudio version and configuration
- System information
- Theme installation status
- File paths and permissions
- Environment variables

## Theme Options

The package includes two themes:
1. **rscodeio** - Main VS Code inspired theme
2. **rscodeio tomorrow night bright** - Alternative color variant

Once installed, both themes are available in:
**Tools** → **Global Options** → **Appearance** → **Editor theme**

## Menu Theming

By default, `install_theme()` applies custom styling to RStudio menus. You can:

```r
# Install without menu theming
rscodeiov2::install_theme(menus = FALSE)

# Manually activate/deactivate menu theming
rscodeiov2::activate_menu_theme()
rscodeiov2::deactivate_menu_theme()
```

## Recommended RStudio Settings

For the best experience, enable these settings:

- **Tools** → **Global Options** → **Code** → **Display**
  - ☑ **Highlight selected line**
  - ☑ **Show indent guides**  
  - ☑ **Show syntax highlighting in console input**
  - ☑ **Highlight R function calls**

## Uninstalling

To completely remove the theme:

```r
# Remove all rscodeiov2 themes and restore menu styling
rscodeiov2::uninstall_theme()
```

## Switching Themes

`rscodeiov2` modifies UI elements not covered by standard theming. If you switch to another theme, the RStudio menus will remain dark. To revert them:

```r
# Restore original menu styling (requires administrator privileges)
rscodeiov2::deactivate_menu_theme()

# Reactivate when needed
rscodeiov2::activate_menu_theme()
```

## What's New in v0.2.0

- **RStudio 2025 compatibility** - Updated path detection for modern RStudio versions
- **Improved error handling** - Better error messages and debugging information
- **Enhanced stylesheets** - Updated QSS files for better compatibility
- **Removed purrr dependency** - Simplified dependencies
- **New diagnostic function** - `rscodeio_diagnose()` for troubleshooting
- **Better fallback paths** - Automatic detection of common RStudio installation locations
- **Posit brand support** - Compatible with RStudio/Posit rebranding

## Supported Platforms

- ✅ **Windows** (tested on Windows 10/11)
- ✅ **Linux** (tested on Ubuntu, Pop!_OS, RHEL)
- ⚠️ **macOS** (editor themes work, menu theming not supported)
- ❌ **RStudio Server** (menu theming not supported)

## Contributing

Issues and pull requests are welcome! Please check existing issues before reporting new ones.

## License

MIT License - see LICENSE file for details.
