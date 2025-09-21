# 🎉 rscodeiov2 v2.0.0 - Revolutionary RStudio 2025+ Support!

## 📋 About This Package

This package is a **continuation and modernization** of Anthony North's beloved [`rscodeio` package](https://github.com/anthonynorth/rscodeio). The original package provided excellent VS Code theming for RStudio but was last maintained in 2020 and became incompatible with modern RStudio versions.

**Why rscodeiov2?**
- ❌ Original `rscodeio`: No longer maintained, incompatible with RStudio 2025+
- ✅ `rscodeiov2`: Active development, revolutionary RStudio 2025+ support
- 🙏 Full credit to Anthony North for the original brilliant concept and implementation

## 🚀 What's New

We're excited to announce **rscodeiov2 v2.0.0** - featuring **world-first support** for RStudio 2025's new web-based architecture!

### 🔥 Revolutionary Features

- **🌟 RStudio 2025+ Support**: First package to support RStudio 2025's new CSS-based theming
- **🤖 Smart Detection**: Automatically detects your RStudio version and chooses the right theming method
- **🎨 Enhanced VS Code Theme**: Beautiful, authentic Visual Studio Code dark theme colors
- **🛠️ Comprehensive Diagnostics**: Advanced troubleshooting tools and error handling

## ⚡ Quick Start

```r
# Install the revolutionary new version
remotes::install_github("hasanur-rahman079/rscodeiov2")

# Apply the theme (works with both RStudio 2025+ and legacy versions!)
rscodeiov2::install_theme()

# Restart RStudio and enjoy! ✨
```

## 🎯 Key Improvements

### For RStudio 2025+ Users
- **CSS-based theming**: Direct modification of RStudio's web interface
- **Automatic backup**: Your original styles are safely backed up
- **Revolutionary approach**: Pioneering solution for RStudio's new architecture

### For Legacy RStudio Users  
- **Enhanced QSS support**: Improved traditional theming for older versions
- **Better path detection**: More reliable installation process
- **Backwards compatibility**: All existing functionality preserved

### For Everyone
- **🔍 Diagnostic tools**: `rscodeio_diagnose()`, `test_rstudio_path()`, `explore_rstudio_structure()`
- **🎨 Beautiful themes**: Multiple VS Code-inspired color schemes
- **📚 Comprehensive documentation**: Detailed guides and examples
- **🛡️ Error resilience**: Graceful fallbacks when issues occur

## 🔧 New Functions

| Function | Purpose |
|----------|---------|
| `activate_css_menu_theme()` | Apply CSS theming (RStudio 2025+) |
| `deactivate_css_menu_theme()` | Remove CSS theming |
| `rscodeio_diagnose()` | Complete system diagnostics |
| `explore_rstudio_structure()` | Explore RStudio directories |
| `test_rstudio_path()` | Test path detection |
| `set_rstudio_path()` | Manual path configuration |

## 🚨 Important Notes

### Requirements
- **RStudio 1.2.0+** (any version supported)
- **Administrator privileges** (Windows/Linux) for menu theming
- **Restart required** after installation

### Compatibility
- ✅ **RStudio 2025+**: Full CSS-based theming support
- ✅ **Legacy RStudio**: Traditional QSS-based theming  
- ✅ **Windows**: Complete support
- ✅ **Linux**: Complete support
- ⚠️ **macOS**: Editor themes only (menu theming not supported by RStudio)

## 🔄 Migration from Original rscodeio

If you're using Anthony North's original `rscodeio` package:

```r
# Uninstall old themes through RStudio UI first
# Then install the new modernized package
remotes::install_github("hasanur-rahman079/rscodeiov2")
rscodeiov2::install_theme()
```

**What's Different:**
- 👨‍💻 **New Maintainer**: Md. Hasanur Rahman (hasanurrahman.bge@gmail.com)
- 🙏 **Original Credit**: Full attribution to Anthony North's original work
- 🔥 **Revolutionary Features**: RStudio 2025+ support with CSS-based theming
- 🚪 **Repository**: Moved to `hasanur-rahman079/rscodeiov2`

## 🆘 Troubleshooting

Having issues? Our diagnostic tools make troubleshooting easy:

```r
# Get complete diagnostic information
rscodeiov2::rscodeio_diagnose()

# Test if your RStudio installation can be detected
rscodeiov2::test_rstudio_path()

# For permission issues, try:
rscodeiov2::install_theme(menus = FALSE)  # Editor themes only
```

## 🌟 What Makes This Special

This release represents a **major breakthrough** in RStudio theming:

1. **First package** to support RStudio 2025's new architecture
2. **Automatic detection** between CSS and QSS theming methods
3. **Complete backwards compatibility** with all RStudio versions
4. **Professional-grade diagnostics** for easy troubleshooting
5. **Beautiful, authentic** VS Code color schemes

## 📋 Full Changelog

See [NEWS.md](NEWS.md) for complete details of all changes.

## 🤝 Contributing

We welcome contributions! Check out our [GitHub repository](https://github.com/hasanur-rahman079/rscodeiov2) for:
- 🐛 Bug reports
- 💡 Feature requests  
- 📖 Documentation improvements
- 🧪 Testing and feedback

## 🙏 Acknowledgments

- **Anthony North** - Creator of the original [`rscodeio` package](https://github.com/anthonynorth/rscodeio) that made this all possible
- **Miles McBain** - Contributor to the original package
- **The R Community** - For testing and feedback on both original and updated versions
- **RStudio/Posit Team** - For creating amazing development tools
- **VS Code Team** - For the inspiring interface design

---

**🎉 Ready to transform your RStudio experience?**

```r
remotes::install_github("hasanur-rahman079/rscodeiov2")
rscodeiov2::install_theme()
```

**Enjoy your new VS Code-inspired RStudio! ✨**