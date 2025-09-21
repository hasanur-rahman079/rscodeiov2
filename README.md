# rscodeiov2 🎨

> **Revolutionary RStudio 2025+ Support!** 🚀  
> A Visual Studio Code inspired theme for RStudio with world-first support for RStudio 2025's new web-based architecture.

**📜 This package is a continuation of Anthony North's original [`rscodeio`](https://github.com/anthonynorth/rscodeio) package, updated and enhanced with RStudio 2025+ support since the original was no longer maintained.**

<p align=center>
  <img src="./inst/media/rscodeio.png" width="580" height="270">
</p>

[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/hasanur-rahman079/rscodeiov2/workflows/R-CMD-check/badge.svg)](https://github.com/hasanur-rahman079/rscodeiov2/actions)

## ✨ Features

- 🎨 **VS Code-inspired dark theme** with modern color schemes
- 🔥 **World-first RStudio 2025+ support** with CSS-based theming
- 🔄 **Automatic version detection** - works with both legacy and modern RStudio
- 📱 **Dual theming approach**: 
  - CSS-based theming for RStudio 2025+ (web architecture)
  - QSS-based theming for legacy RStudio versions
- 🎯 **Menu styling** for complete IDE transformation
- 🛠️ **Easy installation** with comprehensive diagnostics

## 🚀 Quick Start

### Installation

```r
# Install from GitHub
remotes::install_github("hasanur-rahman079/rscodeiov2")

# Load and install the theme
rscodeiov2::install_theme()

# Restart RStudio to see the magic! ✨
```

### Requirements

- **RStudio 1.2.0 or higher**
- **Administrator privileges** (Windows/Linux) for menu theming
- **macOS**: Editor themes supported, menu theming not available

## 🔥 RStudio 2025+ Revolutionary Support

This package includes **world-first support** for RStudio 2025's new web-based architecture! 

### What's New in RStudio 2025?

RStudio 2025+ completely changed its theming system:
- ❌ **Old**: Qt-based QSS stylesheets
- ✅ **New**: Web-based CSS architecture

### Our Solution

rscodeiov2 automatically detects your RStudio version and uses the appropriate theming method:

```r
# The package automatically detects your RStudio version
rscodeiov2::install_theme()

# For RStudio 2025+: Uses revolutionary CSS-based theming
# For older RStudio: Uses traditional QSS-based theming
```

## 📋 Usage

### Basic Installation

```r
# Install complete theme with menu styling
rscodeiov2::install_theme()
```

### Editor-only Installation

```r
# Skip menu theming (useful if you don't have admin rights)
rscodeiov2::install_theme(menus = FALSE)
```

### Uninstall

```r
# Remove the theme completely
rscodeiov2::uninstall_theme()
```

## 🔧 Troubleshooting

### Diagnostic Tools

If you encounter issues, use our comprehensive diagnostic tools:

```r
# Get detailed diagnostic information
rscodeiov2::rscodeio_diagnose()

# Test RStudio path detection
rscodeiov2::test_rstudio_path()

# Explore RStudio directory structure
rscodeiov2::explore_rstudio_structure()
```

### Manual Path Configuration

For non-standard installations:

```r
# Set custom RStudio installation path
rscodeiov2::set_rstudio_path("C:/Your/Custom/RStudio/Path")
```

### Common Issues

#### 🚨 "Could not find location of your RStudio installation"

**For RStudio 2025+ users**: This is normal! RStudio 2025 doesn't have the old stylesheet directories. The package will automatically use CSS-based theming instead.

**Solutions**:
1. **Make sure you're running RStudio as Administrator** (Windows/Linux)
2. Try manual path setting: `rscodeiov2::set_rstudio_path("C:/Program Files/RStudio")`
3. Run diagnostics: `rscodeiov2::rscodeio_diagnose()`

#### 🚨 Permission Errors

- **Windows**: Run RStudio as Administrator
- **Linux**: Run RStudio with sudo or adjust file permissions
- **macOS**: Menu theming not supported, use `install_theme(menus = FALSE)`

#### 🚨 Theme Not Applying

1. **Restart RStudio** - This is essential for changes to take effect
2. Check if theme is installed: Look in Tools → Global Options → Appearance
3. For RStudio 2025+: Check if CSS backup exists at `C:/Program Files/RStudio/resources/app/www/rstudio.css.rscodeiov2.backup`

## 🎨 Theme Variants

The package includes multiple theme variants:

- **rscodeiov2 Default** - Main VS Code-inspired dark theme
- **rscodeiov2 Tomorrow Night Bright** - Alternative color scheme

## 🏗️ Architecture

### Smart Version Detection

```r
# The package automatically detects RStudio version
rstudio_version <- rstudioapi::versionInfo()$version

if(utils::compareVersion(as.character(rstudio_version), "2025.0.0") >= 0) {
  # Use CSS-based theming for RStudio 2025+
  activate_css_menu_theme()
} else {
  # Use QSS-based theming for legacy RStudio
  activate_menu_theme()
}
```

### File Locations

#### RStudio 2025+ (CSS-based)
- **Main CSS**: `C:/Program Files/RStudio/resources/app/www/rstudio.css`
- **Backup**: `C:/Program Files/RStudio/resources/app/www/rstudio.css.rscodeiov2.backup`

#### Legacy RStudio (QSS-based)
- **Stylesheets**: `[RStudio Install]/resources/stylesheets/`
- **Files**: `rstudio-gnome-dark.qss`, `rstudio-windows-dark.qss`

## 🔄 Migration from Original rscodeio

This package (`rscodeiov2`) is a **continuation and modernization** of Anthony North's original [`rscodeio` package](https://github.com/anthonynorth/rscodeio) which was last updated in 2020 and is no longer maintained.

### Why a New Package?

- ❌ **Original rscodeio**: No longer maintained, incompatible with RStudio 2025+
- ✅ **rscodeiov2**: Active development with revolutionary RStudio 2025+ support

### What's New in rscodeiov2:

- ✅ **RStudio 2025+ support** with CSS-based theming
- ✅ **Improved path detection** and error handling
- ✅ **Better diagnostics** and troubleshooting tools
- ✅ **Modern package structure** and documentation
- ✅ **Backward compatibility** with older RStudio versions

### Migrating from Original rscodeio

If you previously used the original `rscodeio` package:

```r
# Uninstall old rscodeio themes first (if any)
# Then install rscodeiov2
remotes::install_github("hasanur-rahman079/rscodeiov2")
rscodeiov2::install_theme()
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Setup

```r
# Clone the repository
git clone https://github.com/hasanur-rahman079/rscodeiov2.git

# Install development dependencies
devtools::install_dev_deps()

# Load the package for development
devtools::load_all()
```

## 📄 License

MIT License - see [LICENSE](LICENSE) and [LICENSE.md](LICENSE.md) files for details.

**Why two license files?**
- **`LICENSE`**: Standard R package license format (required by CRAN)
- **`LICENSE.md`**: Full MIT license text (GitHub standard)

Both files contain proper attribution to Anthony North (original work) and Md. Hasanur Rahman (RStudio 2025+ updates).

## 🔗 Repository Links

- **🎆 Current Package**: [hasanur-rahman079/rscodeiov2](https://github.com/hasanur-rahman079/rscodeiov2) 
- **📜 Original Package**: [anthonynorth/rscodeio](https://github.com/anthonynorth/rscodeio) (no longer maintained)

## 👤 Authors & Contributors

- **Md. Hasanur Rahman** (hasanurrahman.bge@gmail.com) - Current maintainer, RStudio 2025+ revolutionary support
- **Anthony North** - Original rscodeio package creator (2019-2020)
- **Miles McBain** - Contributor to original package

## 🙏 Acknowledgments

- **Anthony North** - For creating the original `rscodeio` package that inspired this work
- **Miles McBain** - For contributions to the original package
- **RStudio/Posit Team** - For creating an amazing IDE
- **VS Code Team** - For the inspiring color schemes
- **R Community** - For testing and feedback

## 🎯 Roadmap

- [ ] Support for more VS Code theme variants
- [ ] Linux distribution-specific installation paths
- [ ] Integration with RStudio addins
- [ ] Custom color scheme editor
- [ ] Theme preview functionality

---

**🎉 Enjoy your new VS Code-inspired RStudio experience!**

> If you love this theme, please ⭐ star the repository and share it with fellow R users!