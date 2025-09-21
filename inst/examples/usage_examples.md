# rscodeiov2 Usage Examples 🎨

This document provides comprehensive examples of how to use the rscodeiov2 package.

## 🚀 Basic Usage

### Standard Installation

```r
# Install the package
remotes::install_github("hasanur-rahman079/rscodeiov2")

# Install the complete theme (recommended)
rscodeiov2::install_theme()

# Restart RStudio to see the changes
```

### Editor-Only Installation

If you don't have administrator privileges or only want the editor theme:

```r
# Install only editor themes, skip menu styling
rscodeiov2::install_theme(menus = FALSE)
```

## 🔧 Troubleshooting Examples

### Diagnostic Workflow

When things don't work, follow this diagnostic workflow:

```r
# Step 1: Get comprehensive diagnostic information
rscodeiov2::rscodeio_diagnose()

# Step 2: Test if RStudio installation can be detected
rscodeiov2::test_rstudio_path()

# Step 3: Explore the RStudio directory structure
rscodeiov2::explore_rstudio_structure()
```

### Manual Configuration

For non-standard RStudio installations:

```r
# Set custom RStudio path
rscodeiov2::set_rstudio_path("C:/MyCustom/RStudio/Location")

# Verify the path works
rscodeiov2::test_rstudio_path()

# Now install the theme
rscodeiov2::install_theme()
```

### Debug Mode

Enable debug mode for verbose output:

```r
# Enable debug mode
options(rscodeiov2.debug = TRUE)

# Now run any function to see detailed debug information
rscodeiov2::test_rstudio_path()

# Disable debug mode
options(rscodeiov2.debug = FALSE)
```

## 🔄 Theme Management

### Installing Multiple Themes

```r
# Install all available theme variants
rscodeiov2::install_theme()

# The package installs:
# - rscodeiov2 Default (main theme)
# - rscodeiov2 Tomorrow Night Bright (if available)
```

### Switching Themes

After installation, you can switch themes through RStudio:

1. Go to **Tools → Global Options → Appearance**
2. Select your preferred rscodeiov2 theme from the dropdown
3. Click **Apply** or **OK**

### Uninstalling

```r
# Remove all rscodeiov2 themes and restore original styling
rscodeiov2::uninstall_theme()

# Restart RStudio to complete the uninstallation
```

## 🏗️ Advanced Usage

### Version-Specific Functions

For advanced users who want to use specific theming methods:

```r
# Check RStudio version
rstudio_version <- rstudioapi::versionInfo()$version
cat("RStudio version:", as.character(rstudio_version))

# For RStudio 2025+ users - use CSS theming directly
if(utils::compareVersion(as.character(rstudio_version), "2025.0.0") >= 0) {
  rscodeiov2::activate_css_menu_theme()
} else {
  # For older RStudio - use QSS theming
  rscodeiov2::activate_menu_theme()
}
```

### CSS Theming (RStudio 2025+)

```r
# Apply CSS-based menu theming (RStudio 2025+ only)
rscodeiov2::activate_css_menu_theme()

# Remove CSS-based menu theming
rscodeiov2::deactivate_css_menu_theme()
```

### QSS Theming (Legacy RStudio)

```r
# Apply QSS-based menu theming (RStudio < 2025)
rscodeiov2::activate_menu_theme()

# Remove QSS-based menu theming
rscodeiov2::deactivate_menu_theme()
```

## 🔍 Diagnostic Examples

### Example Diagnostic Output

Here's what you might see when running diagnostics:

```r
rscodeiov2::rscodeio_diagnose()
```

**Expected output for RStudio 2025+:**
```
🔬 === rscodeiov2 Diagnostic Information ===

📊 RStudio Information:
  📋 Version: 2025.5.0.496
  🖥️ Mode: desktop
  🌐 Theming Architecture: Web-based CSS (Modern)

🖥️ System Information:
  💻 OS: Windows 10.0.22631
  🏗️ Machine: x86-64

🎨 Theme Information:
  📊 Total themes installed: 15
  🎯 rscodeiov2 themes found: 2
    📄 Themes:
      - rscodeiov2 Default
      - rscodeiov2 Tomorrow Night Bright

📁 Path Information:
  ❌ Error getting legacy path information: Could not find stylesheets
  ℹ️ This is normal for RStudio 2025+ which uses CSS-based theming

🌐 RStudio 2025+ CSS Information:
  📄 Main CSS file: C:/Program Files/RStudio/resources/app/www/rstudio.css
    ✅ Exists: TRUE
  💾 CSS backup: C:/Program Files/RStudio/resources/app/www/rstudio.css.rscodeiov2.backup
    ✅ Exists: TRUE

✅ === End Diagnostic Information ===
```

### Path Detection Examples

```r
# Test path detection
rscodeiov2::test_rstudio_path()
```

**For RStudio 2025+ (expected):**
```
🔍 Testing RStudio path detection...

❌ ERROR: Could not find location of your RStudio installation
💡 Try running: rscodeiov2::rscodeio_diagnose() for more information
```

**For Legacy RStudio:**
```
🔍 Testing RStudio path detection...

✅ SUCCESS: Found RStudio stylesheets at: C:/Program Files/RStudio/resources/stylesheets

📁 File check:
  📄 Gnome QSS exists: TRUE
  📄 Windows QSS exists: TRUE

🎉 Path detection successful!
```

## 🚨 Common Scenarios

### Scenario 1: RStudio 2025+ User

```r
# You have RStudio 2025+, installation should work automatically
rscodeiov2::install_theme()

# Expected output:
# 🔥 Detected RStudio 2025+ - using revolutionary CSS-based theming...
# 🎆 Congratulations! You're among the first to use custom theming with RStudio 2025's new architecture!
```

### Scenario 2: Legacy RStudio User

```r
# You have RStudio < 2025, traditional QSS theming will be used
rscodeiov2::install_theme()

# Expected output:
# 📜 Detected older RStudio - using traditional QSS-based theming...
```

### Scenario 3: Permission Issues

```r
# If you get permission errors, try:

# 1. Run RStudio as Administrator (Windows)
# 2. Or install without menu theming
rscodeiov2::install_theme(menus = FALSE)

# 3. Or set manual path with proper permissions
rscodeiov2::set_rstudio_path("C:/Program Files/RStudio")
```

### Scenario 4: Portable RStudio

```r
# For portable RStudio installations
rscodeiov2::set_rstudio_path("D:/PortableApps/RStudio")
rscodeiov2::install_theme()
```

### Scenario 5: Multiple RStudio Versions

```r
# If you have multiple RStudio versions, specify the one you want
rscodeiov2::set_rstudio_path("C:/Program Files/RStudio-2025")
rscodeiov2::install_theme()
```

## 🔄 Migration Examples

### From Original rscodeio

```r
# If you had the original rscodeio package:

# 1. Uninstall old themes (through RStudio UI or manually)
# 2. Install new package
remotes::install_github("hasanur-rahman079/rscodeiov2")

# 3. Install new themes
rscodeiov2::install_theme()
```

### Switching Between Packages

```r
# To completely clean up and start fresh:

# 1. Uninstall current theme
rscodeiov2::uninstall_theme()

# 2. Restart RStudio

# 3. Reinstall if needed
rscodeiov2::install_theme()
```

## 📱 Platform-Specific Examples

### Windows

```r
# Standard Windows installation
rscodeiov2::install_theme()

# Custom Windows path
rscodeiov2::set_rstudio_path("C:/Program Files/RStudio")

# Chocolatey installation
rscodeiov2::set_rstudio_path("C:/ProgramData/chocolatey/lib/rstudio/tools")
```

### Linux

```r
# Standard Linux installation
rscodeiov2::install_theme()

# Custom Linux paths
rscodeiov2::set_rstudio_path("/opt/rstudio")
rscodeiov2::set_rstudio_path("/usr/lib/rstudio")
```

### macOS

```r
# macOS - menu theming not supported, but editor themes work
rscodeiov2::install_theme(menus = FALSE)

# This will install editor themes only
```

## 🎯 Pro Tips

### Quick Theme Testing

```r
# Test different theme components separately
rscodeiov2::install_theme(menus = FALSE)  # Editor only
# Apply and test

# Then add menu theming
rstudio_version <- rstudioapi::versionInfo()$version
if(utils::compareVersion(as.character(rstudio_version), "2025.0.0") >= 0) {
  rscodeiov2::activate_css_menu_theme()
} else {
  rscodeiov2::activate_menu_theme()
}
```

### Backup and Restore

```r
# The package automatically creates backups, but you can check them:

# For RStudio 2025+
backup_file <- "C:/Program Files/RStudio/resources/app/www/rstudio.css.rscodeiov2.backup"
cat("CSS backup exists:", file.exists(backup_file))

# Manual restore (if needed)
if(file.exists(backup_file)) {
  rscodeiov2::deactivate_css_menu_theme()
}
```

### Development and Testing

```r
# For package developers or advanced users
options(rscodeiov2.debug = TRUE)

# Explore RStudio structure in detail
rscodeiov2::explore_rstudio_structure()

# Test specific paths
rscodeiov2::explore_rstudio_structure("C:/Program Files/RStudio")
```

This covers most common usage scenarios! For more specific cases, check the package documentation or open an issue on GitHub.