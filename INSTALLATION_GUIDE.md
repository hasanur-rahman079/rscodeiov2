# rscodeiov2 - Installation and Testing Guide for RStudio 2025

## Quick Start

1. **Install the updated package from this repository:**
   ```r
   # Install devtools if you haven't already
   install.packages("devtools")
   
   # Install rscodeiov2 from local directory or GitHub
   devtools::install_local("path/to/rscodeiov2")
   # OR
   devtools::install_github("hasanur-rahman079/rscodeiov2")
   ```

2. **Run diagnostics to check compatibility:**
   ```r
   library(rscodeiov2)
   rscodeio_diagnose()
   ```

3. **Install the theme (run RStudio as Administrator on Windows/Linux):**
   ```r
   rscodeiov2::install_theme()
   ```

4. **Restart RStudio for full effect**

## What's Been Updated for RStudio 2025

### Code Changes:
- ✅ **Removed purrr dependency** - Eliminated dependency on purrr package
- ✅ **Enhanced path detection** - Added support for Posit branding and additional environment variables
- ✅ **Improved error handling** - Better error messages and debugging information
- ✅ **Updated stylesheets** - Modernized QSS files with VS Code 2025 colors
- ✅ **Added diagnostic function** - New `rscodeio_diagnose()` for troubleshooting
- ✅ **Robust installation paths** - Fallback to common installation directories
- ✅ **Better version checking** - Updated R and RStudio version requirements

### Key Improvements:

1. **Path Detection**: Now checks multiple environment variables and common installation locations
2. **Error Messages**: Clearer error messages with specific next steps  
3. **Compatibility**: Updated for RStudio/Posit rebranding
4. **Debugging**: New diagnostic function shows system state
5. **Robustness**: Better handling of edge cases and permissions

## Testing Checklist

### Basic Functionality:
- [ ] `library(rscodeiov2)` loads without errors
- [ ] `rscodeio_diagnose()` shows system information
- [ ] `rscodeiov2::install_theme()` completes without errors
- [ ] Editor themes appear in RStudio theme picker
- [ ] Menu styling is applied (Windows/Linux with admin privileges)

### Error Handling:
- [ ] Appropriate error when not run from RStudio
- [ ] Clear message when admin privileges needed
- [ ] Graceful fallback when menu theming fails
- [ ] Informative messages during installation process

### Uninstallation:
- [ ] `rscodeiov2::uninstall_theme()` removes themes
- [ ] `rscodeiov2::deactivate_menu_theme()` restores original menus
- [ ] No leftover files after complete uninstallation

## Troubleshooting

If you encounter issues:

1. **Run diagnostics first:**
   ```r
   rscodeio::rscodeio_diagnose()
   ```

2. **Check RStudio version:**
   - Minimum: RStudio 1.2.x
   - Tested up to: RStudio 2025.x

3. **Verify administrator privileges:**
   - Windows: Right-click RStudio → "Run as Administrator"  
   - Linux: `sudo rstudio --no-sandbox`
   - macOS: Regular permissions (menu theming not supported)

4. **Check for permission errors:**
   - Ensure write permissions to RStudio installation directory
   - Try running `rscodeiov2::activate_menu_theme()` separately

5. **Environment variables:**
   - Check if RStudio environment variables are set correctly
   - Run `rscodeio_diagnose()` to see all environment variables

## Common Issues and Solutions

### "Could not find location of your RStudio installation"
- **Solution**: Run `rscodeio_diagnose()` to check environment variables
- **Alternative**: Ensure RStudio is properly installed and you're running from within RStudio

### "Failed to backup/install theme files"  
- **Solution**: Run RStudio as Administrator (Windows/Linux)
- **Check**: File permissions in RStudio installation directory

### "Themes not appearing in theme picker"
- **Solution**: Restart RStudio after installation
- **Check**: Run `rscodeio_diagnose()` to verify theme installation

### Menu theming not working
- **macOS**: Not supported (use system dark theme)
- **RStudio Server**: Not supported
- **Desktop**: Requires administrator privileges

## Support

If you continue to have issues after trying these solutions:

1. Run `rscodeio_diagnose()` and save the output
2. Check the GitHub issues page for similar problems
3. Create a new issue with the diagnostic output included

The updated package should now work reliably with RStudio 2025!