# rscodeiov2 2.0.0

## 📋 About This Release

This package is a **continuation and modernization** of Anthony North's original [`rscodeio` package](https://github.com/anthonynorth/rscodeio), which provided VS Code theming for RStudio but was last updated in 2020 and became incompatible with modern RStudio versions, especially RStudio 2025+.

**Key Changes from Original:**
- Maintained by **Md. Hasanur Rahman** (hasanurrahman.bge@gmail.com)
- Full credit and attribution maintained for **Anthony North**'s original work
- Revolutionary RStudio 2025+ support added
- Enhanced error handling and diagnostics
- Modern R package standards and documentation

## 🔥 Revolutionary Features

### RStudio 2025+ Support
- **WORLD-FIRST**: Complete support for RStudio 2025's new web-based architecture
- **CSS-based theming**: Direct modification of RStudio's web-based CSS files
- **Automatic detection**: Smart version detection chooses appropriate theming method
- **Dual approach**: CSS for RStudio 2025+, QSS for legacy versions

### Enhanced Architecture
- **Automatic version detection**: `utils::compareVersion()` determines RStudio version
- **CSS injection**: Revolutionary approach for RStudio 2025+ menu theming
- **Backup system**: Automatic backup and restore for both CSS and QSS files
- **Error resilience**: Graceful fallback when theming methods fail

## 🛠️ New Functions

### CSS-based Theming (RStudio 2025+)
- `activate_css_menu_theme()`: Apply VS Code-inspired CSS styling
- `deactivate_css_menu_theme()`: Restore original CSS with backup

### Enhanced Diagnostics
- `rscodeio_diagnose()`: Comprehensive system and theme diagnostics
- `explore_rstudio_structure()`: Directory structure exploration
- `test_rstudio_path()`: Enhanced path detection testing
- `set_rstudio_path()`: Manual path configuration

## 🎨 Theme Improvements

### Visual Enhancements
- **VS Code color palette**: Authentic Visual Studio Code dark theme colors
- **Improved contrast**: Better readability and visual hierarchy
- **Modern styling**: Web-based CSS with `!important` declarations
- **Comprehensive coverage**: Navigation bars, panels, buttons, and more

### CSS Styling Features
- **Body styling**: `#1e1e1e` background with `#d4d4d4` text
- **Navigation theming**: `#2d2d30` navbar with `#3e3e42` borders
- **Interactive elements**: Hover effects and focus states
- **Panel styling**: `#252526` panels with consistent border colors
- **Button theming**: VS Code blue (`#0e639c`) with hover effects

## 🔧 Technical Improvements

### Path Detection
- **Enhanced environment variables**: Support for multiple RStudio environment variables
- **Registry support**: Windows Registry fallback for path detection
- **Common paths**: Extensive list of standard installation directories
- **Portable support**: Detection of portable and custom installations

### Error Handling
- **Graceful degradation**: Editor themes work even if menu theming fails
- **Clear messaging**: Informative error messages with troubleshooting hints
- **Debug mode**: Optional verbose output via `options(rscodeiov2.debug = TRUE)`
- **Call stack protection**: `call. = FALSE` for cleaner error messages

### Code Quality
- **Modern R practices**: Updated to current R package standards
- **Comprehensive documentation**: Detailed roxygen2 documentation
- **Clean structure**: Organized utility functions and clear separation of concerns
- **Unicode support**: Emoji indicators for better user experience

## 📦 Package Infrastructure

### Dependencies
- **Minimal dependencies**: Only essential packages (`fs`, `rstudioapi`, `utils`)
- **Version requirements**: Updated minimum versions for compatibility
- **System requirements**: Clear RStudio version requirements

### Documentation
- **Comprehensive README**: Detailed installation and troubleshooting guide
- **Usage examples**: Extensive examples for all functions
- **Lifecycle badges**: Clear experimental status indication
- **GitHub integration**: Issues, CI/CD, and contribution guidelines

## 🔄 Migration Changes

### Breaking Changes
- **Package name**: Changed from `rscodeio` to `rscodeiov2`
- **Repository**: Moved to `hasanur-rahman079/rscodeiov2`
- **Function signatures**: Some internal functions have updated parameters

### Backwards Compatibility
- **Theme installation**: `install_theme()` API remains the same
- **Basic usage**: Core functionality unchanged for end users
- **Legacy support**: Full support for older RStudio versions maintained

## 🚨 Known Issues

### RStudio 2025+ Specific
- **Administrator privileges**: Required for CSS file modification
- **Restart required**: RStudio restart needed to see CSS changes
- **Experimental status**: First implementation of CSS-based RStudio theming

### Platform Limitations
- **macOS**: Menu theming still not supported (RStudio limitation)
- **RStudio Server**: Limited theming capabilities (server environment)
- **Permissions**: File system permissions may prevent installation

## 🎯 Future Roadmap

### Planned Features
- **Theme variants**: Additional VS Code theme variations
- **Live preview**: Real-time theme preview without restart
- **Theme editor**: GUI for custom color scheme creation
- **Auto-update**: Automatic detection of RStudio updates

### Technical Debt
- **Cross-platform testing**: Enhanced testing on Linux distributions
- **Performance optimization**: Faster path detection algorithms
- **Theme validation**: Verify theme integrity after installation

---

## rscodeiov2 0.2.0 (Previous)

### Initial Features
- Basic VS Code-inspired theme for RStudio
- QSS-based menu theming for legacy RStudio
- Editor theme installation via `rstudioapi`
- Windows and Linux support

### Limitations Addressed in 2.0.0
- No RStudio 2025+ support
- Limited path detection capabilities
- Minimal error handling and diagnostics
- Basic documentation and examples