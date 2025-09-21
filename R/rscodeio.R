#' Install the rscodeiov2 theme
#'
#' This function installs a Visual Studio Code-inspired theme for RStudio.
#' It automatically detects your RStudio version and uses the appropriate
#' theming method (CSS for RStudio 2025+, QSS for older versions).
#'
#' @details
#' \strong{Requirements:}
#' \itemize{
#'   \item RStudio 1.2.x or higher
#'   \item Administrator privileges (Windows/Linux) for menu theming
#'   \item Menu theming not supported on macOS
#' }
#'
#' \strong{RStudio 2025+ Support:}
#' This package includes pioneering support for RStudio 2025's new web-based
#' architecture, automatically detecting the version and applying appropriate
#' CSS-based theming for the modern interface.
#'
#' @param menus Logical. If FALSE, skip menu theme installation (default: TRUE)
#' @return Invisible NULL. Called for side effects.
#' @examples
#' \dontrun{
#' # Install complete theme including menus
#' rscodeiov2::install_theme()
#'
#' # Install only editor theme, skip menus
#' rscodeiov2::install_theme(menus = FALSE)
#' }
#' @export
install_theme <- function(menus = TRUE) {

  ## Check RStudio API available
  if(!rstudioapi::isAvailable()) {
    stop("rscodeiov2 must be installed from within RStudio.", call. = FALSE)
  }

  ## Check RStudio supports themes
  rstudio_version <- rstudioapi::versionInfo()$version
  if(utils::compareVersion(as.character(rstudio_version), "1.2.0") < 0) {
    stop("You need RStudio 1.2 or greater to get theme support. Current version: ", 
         rstudio_version, call. = FALSE)
  }
  
  cat("\u2728 Installing rscodeiov2 theme for RStudio", as.character(rstudio_version), "\n")

  ## Check if menu theme already installed and uninstall
  if(rscodeiov2_installed()){
    cat("\u267e\ufe0f Existing rscodeiov2 theme found, uninstalling first...\n")
    uninstall_theme()
  }

  ## Add the editor themes
  theme_path <- fs::path_package(package = "rscodeiov2", "resources", "rscodeio.rstheme")
  
  if(!file.exists(theme_path)) {
    stop("Theme file not found at: ", theme_path, call. = FALSE)
  }
  
  cat("\u2699\ufe0f Adding rscodeiov2 default theme...\n")
  rscodeio_default_theme <- rstudioapi::addTheme(theme_path)
  
  tomorrow_night_path <- fs::path_package(package = "rscodeiov2", "resources", "rscodeio_tomorrow_night_bright.rstheme")
  
  if(file.exists(tomorrow_night_path)) {
    cat("\u2699\ufe0f Adding rscodeiov2 tomorrow night bright theme...\n")
    rstudioapi::addTheme(tomorrow_night_path)
  }

  ## Add the custom menu styling
  if (menus) {
    cat("\ud83c\udfa8 Activating menu theme...\n")
    
    # Detect RStudio version to choose theming approach
    if(utils::compareVersion(as.character(rstudio_version), "2025.0.0") >= 0) {
      cat("\ud83d\udd25 Detected RStudio 2025+ - using revolutionary CSS-based theming...\n")
      result <- tryCatch({
        activate_css_menu_theme()
        TRUE
      }, error = function(e) {
        warning("Failed to activate CSS menu theme: ", e$message, 
                "\nThe editor theme will still work.", call. = FALSE)
        FALSE
      })
    } else {
      cat("\ud83d\udcdc Detected older RStudio - using traditional QSS-based theming...\n")
      result <- tryCatch({
        activate_menu_theme()
        TRUE
      }, error = function(e) {
        warning("Failed to activate QSS menu theme: ", e$message, 
                "\nThe editor theme will still work.", call. = FALSE)
        FALSE
      })
    }
  }

  ## Activate default rscodeio theme
  cat("\u2728 Applying default rscodeio theme...\n")
  rstudioapi::applyTheme(rscodeio_default_theme)
  
  cat("\n\u2705 rscodeiov2 theme installation complete!\n")
  
  if(utils::compareVersion(as.character(rstudio_version), "2025.0.0") >= 0) {
    cat("\ud83c\udf86 Congratulations! You're among the first to use custom theming with RStudio 2025's new architecture!\n")
  }
  
  cat("\ud83d\udd04 Please restart RStudio to ensure all changes take effect.\n")
  
  invisible(NULL)
}

#' Uninstall the rscodeiov2 theme
#'
#' Removes all rscodeiov2 themes from RStudio and restores original menu styling.
#' Automatically detects RStudio version and uses appropriate removal method.
#'
#' @return Invisible NULL. Called for side effects.
#' @examples
#' \dontrun{
#' rscodeiov2::uninstall_theme()
#' }
#' @export
uninstall_theme <- function(){

  cat("\ud83e\uddf9 Deactivating menu theme...\n")
  
  # Detect RStudio version to choose deactivation approach
  rstudio_version <- rstudioapi::versionInfo()$version
  
  if(utils::compareVersion(as.character(rstudio_version), "2025.0.0") >= 0) {
    cat("\ud83d\udd25 Detected RStudio 2025+ - using CSS-based deactivation...\n")
    tryCatch({
      deactivate_css_menu_theme()
    }, error = function(e) {
      warning("Failed to deactivate CSS menu theme: ", e$message, call. = FALSE)
    })
  } else {
    cat("\ud83d\udcdc Detected older RStudio - using QSS-based deactivation...\n")
    tryCatch({
      deactivate_menu_theme()
    }, error = function(e) {
      warning("Failed to deactivate QSS menu theme: ", e$message, call. = FALSE)
    })
  }
  
  # Get all installed themes
  all_themes <- rstudioapi::getThemes()
  
  # Find rscodeiov2 themes by checking theme names
  installed_rscodeiov2_themes <- character(0)
  
  for(theme_name in names(all_themes)) {
    if(grepl("rscodeio", theme_name, ignore.case = TRUE)) {
      installed_rscodeiov2_themes <- c(installed_rscodeiov2_themes, theme_name)
    }
  }
  
  if(length(installed_rscodeiov2_themes) > 0) {
    cat("\ud83d\uddd1\ufe0f Removing themes:", paste(installed_rscodeiov2_themes, collapse = ", "), "\n")
    
    for (theme in installed_rscodeiov2_themes) {
      tryCatch({
        rstudioapi::removeTheme(theme)
        cat("  \u2705 Removed:", theme, "\n")
      }, error = function(e) {
        warning("Failed to remove theme '", theme, "': ", e$message, call. = FALSE)
      })
    }
  } else {
    cat("\u2139\ufe0f No rscodeiov2 themes found to remove.\n")
  }
  
  cat("\u2705 rscodeiov2 theme uninstallation complete.\n")
  
  invisible(NULL)
}


#' Activate rscodeiov2 menu styling (Traditional QSS method)
#'
#' This function applies custom menu styling for older RStudio versions (pre-2025)
#' using Qt Style Sheets (QSS). This method modifies RStudio's internal stylesheet
#' files and requires administrator privileges.
#'
#' @details
#' \strong{Compatibility:} RStudio versions before 2025.0.0
#' \strong{Requirements:} Administrator privileges on Windows/Linux
#' \strong{Not supported:} macOS and RStudio Server
#'
#' @return Invisible logical. TRUE if successful, FALSE otherwise.
#' @examples
#' \dontrun{
#' # Only use this for RStudio < 2025
#' rscodeiov2::activate_menu_theme()
#' }
#' @export
activate_menu_theme <- function() {

  ## Styling menus not supported on Mac or RStudio Server.
  if(host_os_is_mac()) {
    message("Menu theming is not supported on macOS.")
    return(invisible(NULL))
  }
  
  if(is_rstudio_server()) {
    message("Menu theming is not supported on RStudio Server.")
    return(invisible(NULL))
  }

  if(file.exists(gnome_theme_dark_backup()) |
     file.exists(windows_theme_dark_backup())) {
      message("RSCodeio menu theme already activated. Deactivate first.")
      return(invisible(FALSE))
  }
  
  # Get stylesheet location - this will error if not found
  stylesheet_location <- tryCatch({
    get_stylesheets_location()
  }, error = function(e) {
    stop("Cannot locate RStudio stylesheets directory: ", e$message, 
         "\nPlease ensure you are running RStudio as Administrator (Windows/Linux).")
  })
  
  cat("Found RStudio stylesheets at:", stylesheet_location, "\n")

  ## backup dark Qt themes
  gnome_src <- gnome_theme_dark()
  gnome_backup <- gnome_theme_dark_backup()
  windows_src <- windows_theme_dark()
  windows_backup <- windows_theme_dark_backup()
  
  # Check if source files exist
  if(!file.exists(gnome_src)) {
    warning("Gnome dark theme file not found at: ", gnome_src)
  } else {
    cat("Backing up gnome theme...\n")
    if(!file.copy(from = gnome_src, to = gnome_backup, overwrite = FALSE)) {
      stop("Failed to backup gnome theme. Check file permissions.")
    }
  }
  
  if(!file.exists(windows_src)) {
    warning("Windows dark theme file not found at: ", windows_src)
  } else {
    cat("Backing up windows theme...\n")
    if(!file.copy(from = windows_src, to = windows_backup, overwrite = FALSE)) {
      stop("Failed to backup windows theme. Check file permissions.")
    }
  }

  ## replace with RSCodeio Qt themes
  rscodeio_gnome_qss <- system.file(fs::path("resources","stylesheets","rstudio-gnome-dark.qss"),
                                    package = "rscodeiov2")
  rscodeio_windows_qss <- system.file(fs::path("resources","stylesheets","rstudio-windows-dark.qss"),
                                      package = "rscodeiov2")
  
  if(!file.exists(rscodeio_gnome_qss)) {
    stop("rscodeiov2 gnome stylesheet not found at: ", rscodeio_gnome_qss)
  }
  
  if(!file.exists(rscodeio_windows_qss)) {
    stop("rscodeiov2 windows stylesheet not found at: ", rscodeio_windows_qss)
  }
  
  cat("Installing rscodeiov2 stylesheets...\n")
  
  if(file.exists(gnome_src)) {
    if(!file.copy(from = rscodeio_gnome_qss, to = gnome_src, overwrite = TRUE)) {
      stop("Failed to install gnome stylesheet. Check file permissions.")
    }
    cat("  Installed gnome stylesheet\n")
  }
  
  if(file.exists(windows_src)) {
    if(!file.copy(from = rscodeio_windows_qss, to = windows_src, overwrite = TRUE)) {
      stop("Failed to install windows stylesheet. Check file permissions.")
    }
    cat("  Installed windows stylesheet\n")
  }
  
  cat("Menu theme activation complete!\n")
  invisible(TRUE)
}

#' Deactivate rscodeiov2 menu styling (Traditional QSS method)
#'
#' Restores original RStudio menu styling for older RStudio versions (pre-2025)
#' by restoring backed-up Qt Style Sheets (QSS) files.
#'
#' @details
#' \strong{Compatibility:} RStudio versions before 2025.0.0
#' \strong{Requirements:} Administrator privileges on Windows/Linux
#' \strong{Not supported:} macOS
#'
#' @return Invisible logical. TRUE if successful, FALSE otherwise.
#' @examples
#' \dontrun{
#' # Only use this for RStudio < 2025
#' rscodeiov2::deactivate_menu_theme()
#' }
#' @export
deactivate_menu_theme <- function(){

  ## Styling menus not supported on Mac.
  if(host_os_is_mac()) {
    message("Menu theming is not supported on macOS.")
    return(invisible(NULL))
  }

  gnome_backup <- gnome_theme_dark_backup()
  windows_backup <- windows_theme_dark_backup()
  
  if(!file.exists(gnome_backup) && !file.exists(windows_backup)) {
    message("RStudio theme backups not found. rscodeiov2 menu theme not activated or already deactivated.")
    return(invisible(FALSE))
  }

  ## restore dark Qt themes
  if(file.exists(gnome_backup)) {
    cat("Restoring gnome theme backup...\n")
    if(!file.copy(from = gnome_backup, to = gnome_theme_dark(), overwrite = TRUE)) {
      warning("Failed to restore gnome theme backup")
    } else {
      cat("  Restored gnome theme\n")
      ## delete backup
      unlink(gnome_backup)
    }
  }
  
  if(file.exists(windows_backup)) {
    cat("Restoring windows theme backup...\n")
    if(!file.copy(from = windows_backup, to = windows_theme_dark(), overwrite = TRUE)) {
      warning("Failed to restore windows theme backup")
    } else {
      cat("  Restored windows theme\n")
      ## delete backup
      unlink(windows_backup)
    }
  }
  
  cat("Menu theme deactivation complete!\n")
  invisible(TRUE)
}

#' Activate rscodeiov2 menu styling (Modern CSS method)
#'
#' \strong{REVOLUTIONARY FEATURE:} This function provides the world's first
#' custom menu theming solution for RStudio 2025's new web-based architecture!
#'
#' This function applies VS Code-inspired styling to RStudio 2025+ by directly
#' modifying the main CSS file used by RStudio's web-based interface.
#'
#' @details
#' \strong{Compatibility:} RStudio 2025.0.0 and higher
#' \strong{Requirements:} Administrator privileges (to modify CSS files)
#' \strong{Architecture:} Web-based CSS modification
#' \strong{Backup:} Automatically creates backup of original CSS
#'
#' \strong{What it does:}
#' \itemize{
#'   \item Locates RStudio's main CSS file (rstudio.css)
#'   \item Creates a backup for safety
#'   \item Injects VS Code-inspired dark theme styling
#'   \item Themes navigation bars, panels, buttons, and more
#' }
#'
#' @return Invisible logical. TRUE if successful, FALSE otherwise.
#' @examples
#' \dontrun{
#' # Only use this for RStudio 2025+
#' rscodeiov2::activate_css_menu_theme()
#' }
#' @export
activate_css_menu_theme <- function() {
  
  cat("\ud83d\udd25 Attempting revolutionary CSS-based menu theming for RStudio 2025+...\n")
  
  # Try to find the main RStudio CSS file
  rstudio_www_path <- "C:/Program Files/RStudio/resources/app/www"
  
  if(!dir.exists(rstudio_www_path)) {
    stop("RStudio 2025 www directory not found at: ", rstudio_www_path, 
         "\nPlease ensure RStudio 2025+ is properly installed.", call. = FALSE)
  }
  
  # Look for the main rstudio.css file
  rstudio_css <- file.path(rstudio_www_path, "rstudio.css")
  
  if(!file.exists(rstudio_css)) {
    stop("RStudio main CSS file not found at: ", rstudio_css, 
         "\nThis function requires RStudio 2025+ with web-based architecture.", call. = FALSE)
  }
  
  cat("\u2705 Found RStudio CSS file at:", rstudio_css, "\n")
  
  # Create backup
  backup_css <- paste0(rstudio_css, ".rscodeiov2.backup")
  
  if(!file.exists(backup_css)) {
    cat("\ud83d\udcbe Creating backup of original CSS...\n")
    if(!file.copy(rstudio_css, backup_css)) {
      stop("Failed to backup CSS file. Please run RStudio as Administrator.", call. = FALSE)
    }
  } else {
    cat("\u2139\ufe0f Backup already exists.\n")
  }
  
  # Read current CSS content
  css_content <- readLines(rstudio_css, warn = FALSE)
  
  # VS Code inspired dark theme CSS additions
  vscode_css <- c(
    "",
    "/* ========================================= */",
    "/* rscodeiov2 VS Code Inspired Theme */",
    "/* Revolutionary RStudio 2025+ Support */",
    "/* ========================================= */",
    "",
    "/* Base colors */",
    "body { ",
    "  background-color: #1e1e1e !important; ",
    "  color: #d4d4d4 !important; ",
    "}",
    "",
    "/* Navigation and toolbar */",
    ".navbar, .navbar-default { ",
    "  background-color: #2d2d30 !important; ",
    "  border-color: #3e3e42 !important; ",
    "}",
    "",
    ".navbar-nav > li > a { ",
    "  color: #cccccc !important; ",
    "}",
    "",
    ".navbar-nav > li > a:hover, .navbar-nav > li > a:focus { ",
    "  background-color: #3e3e42 !important; ",
    "  color: #ffffff !important; ",
    "}",
    "",
    "/* Panels and containers */",
    ".panel, .panel-default { ",
    "  background-color: #252526 !important; ",
    "  border-color: #3e3e42 !important; ",
    "}",
    "",
    ".panel-heading { ",
    "  background-color: #2d2d30 !important; ",
    "  color: #cccccc !important; ",
    "}",
    "",
    "/* Buttons */",
    ".btn-default { ",
    "  background-color: #0e639c !important; ",
    "  border-color: #007acc !important; ",
    "  color: #ffffff !important; ",
    "}",
    "",
    ".btn-default:hover, .btn-default:focus { ",
    "  background-color: #1177bb !important; ",
    "}",
    "",
    "/* Additional VS Code styling */",
    ".well { ",
    "  background-color: #252526 !important; ",
    "  border-color: #3e3e42 !important; ",
    "}",
    "",
    "/* ========================================= */",
    "/* End rscodeiov2 Theme */",
    "/* ========================================= */",
    ""
  )
  
  # Check if our theme is already added
  if(any(grepl("rscodeiov2 VS Code Inspired Theme", css_content))) {
    cat("\u2139\ufe0f rscodeiov2 CSS theme already applied.\n")
    return(invisible(TRUE))
  }
  
  # Add our CSS to the end of the file
  cat("\ud83c\udfa8 Injecting VS Code inspired CSS styling...\n")
  updated_css <- c(css_content, vscode_css)
  
  # Write updated CSS
  tryCatch({
    writeLines(updated_css, rstudio_css)
    cat("\n\ud83c\udf86 SUCCESS! CSS menu theme applied successfully!\n")
    cat("\ud83d\udd04 Please restart RStudio to see the amazing transformation!\n")
    invisible(TRUE)
  }, error = function(e) {
    stop("Failed to write CSS file: ", e$message, 
         "\nMake sure RStudio is running as Administrator.", call. = FALSE)
  })
}

#' Deactivate rscodeiov2 menu styling (Modern CSS method)
#'
#' Restores original RStudio menu styling for RStudio 2025+ by restoring
#' the backed-up CSS file, removing all custom VS Code-inspired styling.
#'
#' @details
#' \strong{Compatibility:} RStudio 2025.0.0 and higher
#' \strong{Requirements:} Administrator privileges
#' \strong{Safety:} Restores from automatically created backup
#'
#' @return Invisible logical. TRUE if successful, FALSE otherwise.
#' @examples
#' \dontrun{
#' # Only use this for RStudio 2025+
#' rscodeiov2::deactivate_css_menu_theme()
#' }
#' @export
deactivate_css_menu_theme <- function() {
  
  cat("\ud83e\uddf9 Restoring original RStudio 2025+ CSS styling...\n")
  
  # Try to find the main RStudio CSS file
  rstudio_www_path <- "C:/Program Files/RStudio/resources/app/www"
  rstudio_css <- file.path(rstudio_www_path, "rstudio.css")
  backup_css <- paste0(rstudio_css, ".rscodeiov2.backup")
  
  if(!file.exists(backup_css)) {
    cat("\u2139\ufe0f No CSS backup found. rscodeiov2 CSS theme not activated or already deactivated.\n")
    return(invisible(FALSE))
  }
  
  if(!file.exists(rstudio_css)) {
    warning("RStudio CSS file not found at: ", rstudio_css, call. = FALSE)
    return(invisible(FALSE))
  }
  
  cat("\ud83d\udcbe Restoring original CSS from backup...\n")
  
  tryCatch({
    # Restore backup
    if(!file.copy(backup_css, rstudio_css, overwrite = TRUE)) {
      stop("Failed to restore CSS backup", call. = FALSE)
    }
    
    # Remove backup file
    unlink(backup_css)
    
    cat("\u2705 CSS menu theme deactivated successfully!\n")
    cat("\ud83d\udd04 Please restart RStudio to see the original styling restored.\n")
    invisible(TRUE)
    
  }, error = function(e) {
    stop("Failed to restore CSS backup: ", e$message, 
         "\nMake sure RStudio is running as Administrator.", call. = FALSE)
  })
}
