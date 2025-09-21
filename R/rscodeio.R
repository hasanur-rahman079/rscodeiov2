#' Install the rscodeiov2 theme
#'
#' You'll need RStudio at least 1.2.x and if your RStudio
#' is installed to a default location on Windows or Linux,
#' you'll need to be running RStudio as
#' Administrator to install the menu theme files (Just required for install).
#'
#' You can elect not to install the menu theme files with `menus = FALSE`.
#'
#' @param menus if FALSE do not install the RStudio menu theme qss files.
#' @return nothing.
#' @export
install_theme <- function(menus = TRUE) {

  ## check RStudio API available
  if(!rstudioapi::isAvailable()) {
    stop("RSCodeio must be installed from within RStudio.")
  }

  ## check RStudio supports themes
  rstudio_version <- rstudioapi::versionInfo()$version
  if(utils::compareVersion(as.character(rstudio_version), "1.2.0") < 0) {
    stop("You need RStudio 1.2 or greater to get theme support. Current version: ", rstudio_version)
  }
  
  cat("Installing rscodeiov2 theme for RStudio version:", as.character(rstudio_version), "\n")

  ## check if menu theme already installed and uninstall
  if(rscodeiov2_installed()){
    cat("Existing rscodeiov2 theme found, uninstalling first...\n")
    uninstall_theme()
  }

  ## add the themes
  theme_path <- fs::path_package(package = "rscodeiov2", "resources", "rscodeio.rstheme")
  
  if(!file.exists(theme_path)) {
    stop("Theme file not found at: ", theme_path)
  }
  
  cat("Adding rscodeiov2 default theme...\n")
  rscodeio_default_theme <- rstudioapi::addTheme(theme_path)
  
  tomorrow_night_path <- fs::path_package(package = "rscodeiov2", "resources", "rscodeio_tomorrow_night_bright.rstheme")
  
  if(file.exists(tomorrow_night_path)) {
    cat("Adding rscodeiov2 tomorrow night bright theme...\n")
    rstudioapi::addTheme(tomorrow_night_path)
  }

  ## add the custom Qt CSS
  if (menus) {
    cat("Activating menu theme...\n")
    result <- tryCatch({
      activate_menu_theme()
      TRUE
    }, error = function(e) {
      warning("Failed to activate menu theme: ", e$message, "\nThe editor theme will still work.")
      FALSE
    })
  }

  ## activate default rscodeio theme
  cat("Applying default rscodeio theme...\n")
  rstudioapi::applyTheme(rscodeio_default_theme)
  
  cat("\nrscodeiov2 theme installation complete!\n")
  cat("Please restart RStudio to ensure all changes take effect.\n")
}

#' Uninstall the rscodeiov2 theme
#'
#' @return nothing.
#' @export
uninstall_theme <- function(){

  cat("Deactivating menu theme...\n")
  deactivate_menu_theme()
  
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
    cat("Removing themes:", paste(installed_rscodeiov2_themes, collapse = ", "), "\n")
    
    for (theme in installed_rscodeiov2_themes) {
      tryCatch({
        rstudioapi::removeTheme(theme)
        cat("  Removed:", theme, "\n")
      }, error = function(e) {
        warning("Failed to remove theme '", theme, "': ", e$message)
      })
    }
  } else {
    cat("No rscodeiov2 themes found to remove.\n")
  }
  
  cat("rscodeiov2 theme uninstallation complete.\n")
}


#' Activate rscodeiov2 styling in file menu.
#'
#' @return nothing.
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

#' Deactivate rscodeiov2 style in file menu.
#'
#' @return nothing.
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
