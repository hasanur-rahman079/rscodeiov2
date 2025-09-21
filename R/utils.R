#' ==============================================================================
#' UTILITY FUNCTIONS FOR RSCODEIOV2 PACKAGE
#' ==============================================================================
#' 
#' This file contains utility functions for detecting RStudio installations,
#' managing stylesheet locations, and providing diagnostic capabilities.
#' 
#' NOTE: These utilities primarily support legacy RStudio versions (pre-2025)
#' that use QSS-based theming. RStudio 2025+ uses CSS-based theming handled
#' in the main rscodeio.R file.
#' ==============================================================================

# ==============================================================================
# LEGACY QSS SUPPORT FUNCTIONS (RStudio < 2025)
# ==============================================================================

#' Get RStudio stylesheets location (Legacy QSS method)
#'
#' Attempts to locate the RStudio stylesheets directory for older RStudio versions
#' that use Qt Style Sheets (QSS) for theming. This function is not used for
#' RStudio 2025+ which uses web-based CSS theming.
#'
#' @details 
#' The function tries multiple detection methods:
#' \itemize{
#'   \item Environment variables set by RStudio
#'   \item Common installation directories
#'   \item Windows Registry (Windows only)
#'   \item Manual path override via RSTUDIO_MANUAL_PATH
#' }
#'
#' @return Character string with path to stylesheets directory
#' @keywords internal
get_stylesheets_location <- function(){

  ## QSS stylesheets are not used on macOS
  if(host_os_is_mac()) {
    stop("QSS Stylesheets are not used on macOS", call. = FALSE)
  }
  
  # Check if user has manually set the path
  manual_path <- Sys.getenv("RSTUDIO_MANUAL_PATH", unset = "")
  if(manual_path != "") {
    cat("📍 Using manually set RStudio path:", manual_path, "\n")
    stylesheet_path <- file.path(manual_path, "resources", "stylesheets")
    if(dir.exists(stylesheet_path)) {
      cat("✅ Manual path stylesheets found at:", stylesheet_path, "\n")
      return(stylesheet_path)
    } else {
      cat("⚠️ Manual path set but stylesheets not found, falling back to auto-detection\n")
    }
  }

  # Try multiple methods to find RStudio installation
  rstudio_dirs <- list(
    pandoc_dir = Sys.getenv("RSTUDIO_PANDOC"),
    winutils_dir = Sys.getenv("RSTUDIO_WINUTILS"),
    rs_postback_path = Sys.getenv("RS_RPOSTBACK_PATH"),
    rmarkdown_mathjax_path = Sys.getenv("RMARKDOWN_MATHJAX_PATH"),
    rstudio_session_port = Sys.getenv("RSTUDIO_SESSION_PORT"),
    rstudio_desktop_exe = Sys.getenv("RSTUDIO_DESKTOP_EXE")
  )
  
  # Debug: Print environment variables (only if debug mode)
  if(getOption("rscodeiov2.debug", FALSE)) {
    cat("🔍 Checking environment variables...\n")
    for(name in names(rstudio_dirs)) {
      value <- rstudio_dirs[[name]]
      if(value != "") {
        cat("  ", name, ":", value, "\n")
      }
    }
  }

  # Extract RStudio path from environment variables
  extract_rstudio_path_parts <- function(path){
    if(is.null(path) || path == "") return(NULL)
    
    if(getOption("rscodeiov2.debug", FALSE)) {
      cat("🔍 Extracting path parts from:", path, "\n")
    }
    
    dir_parts <- fs::path_split(path)[[1]]
    rstudio_ind <- which(dir_parts %in% c("RStudio","rstudio", "Posit", "posit"))
    
    if(length(rstudio_ind) != 1) {
      if(getOption("rscodeiov2.debug", FALSE)) {
        cat("❌ No RStudio/Posit directory found in path\n")
      }
      return(NULL)
    }
    
    result_parts <- dir_parts[seq(rstudio_ind)]
    if(getOption("rscodeiov2.debug", FALSE)) {
      cat("✅ Extracted parts:", paste(result_parts, collapse = "/"), "\n")
    }
    return(result_parts)
  }

  # Find potential stylesheet paths
  potential_paths <-
    Filter(function(path_parts) {
           if(is.null(path_parts)) return(FALSE)
           
           # Try multiple possible stylesheet locations for different RStudio versions
           possible_stylesheet_paths <- c(
             fs::path_join(c(path_parts, "resources", "stylesheets")),           # Classic location
             fs::path_join(c(path_parts, "resources", "app", "resources", "stylesheets")), # RStudio 2025 location
             fs::path_join(c(path_parts, "bin", "resources", "stylesheets")),    # Alternative location
             fs::path_join(c(path_parts, "share", "resources", "stylesheets"))   # Linux-style location
           )
           
           for(test_path in possible_stylesheet_paths) {
             if(getOption("rscodeiov2.debug", FALSE)) {
               cat("🔍 Testing path:", test_path, "\n")
               cat("📁 Path exists:", dir.exists(test_path), "\n")
             }
             if(dir.exists(test_path)) {
               # Store the successful path for later use
               attr(path_parts, "stylesheet_path") <- test_path
               return(TRUE)
             }
           }
           return(FALSE)
          },
          lapply(rstudio_dirs, extract_rstudio_path_parts)
    )
  
  # If no paths found via environment variables, try common installation locations
  if(length(potential_paths) == 0) {
    cat("🔍 No paths found via environment variables, trying common locations...\n")
    
    common_paths <- get_common_rstudio_paths()
    
    for(path in common_paths) {
      if(getOption("rscodeiov2.debug", FALSE)) {
        cat("🔍 Checking:", path, "\n")
      }
      
      if(dir.exists(path)) {
        stylesheet_path <- find_stylesheets_in_path(path)
        if(!is.null(stylesheet_path)) {
          return(stylesheet_path)
        }
      }
    }
    
    # Try Windows Registry as last resort
    if(Sys.info()["sysname"] == "Windows") {
      registry_path <- try_windows_registry()
      if(!is.null(registry_path)) {
        return(registry_path)
      }
    }
  }

  if(length(potential_paths) == 0) {
    stop("Could not find location of your RStudio installation. Please ensure RStudio is properly installed and you are running this from within RStudio with administrator privileges.", call. = FALSE)
  }

  ## Return the successful path that was found
  successful_path <- attr(potential_paths[[1]], "stylesheet_path")
  if(!is.null(successful_path)) {
    cat("✅ Found stylesheets at:", successful_path, "\n")
    return(successful_path)
  } else {
    # Fallback to classic path construction if attribute is missing
    result_path <- fs::path_join(c(potential_paths[[1]], "resources", "stylesheets"))
    cat("✅ Found stylesheets at (fallback):", result_path, "\n")
    return(result_path)
  }
}

#' Get common RStudio installation paths
#' @return Character vector of common paths
#' @keywords internal
get_common_rstudio_paths <- function() {
  if(Sys.info()["sysname"] == "Windows") {
    c(
      file.path(Sys.getenv("PROGRAMFILES"), "RStudio"),
      file.path(Sys.getenv("PROGRAMFILES(X86)"), "RStudio"),
      file.path(Sys.getenv("LOCALAPPDATA"), "Programs", "RStudio"),
      file.path(Sys.getenv("PROGRAMFILES"), "Posit", "RStudio"),
      file.path(Sys.getenv("PROGRAMFILES(X86)"), "Posit", "RStudio"),
      file.path(Sys.getenv("LOCALAPPDATA"), "Programs", "Posit", "RStudio"),
      file.path(Sys.getenv("USERPROFILE"), "AppData", "Local", "Programs", "RStudio"),
      file.path(Sys.getenv("USERPROFILE"), "AppData", "Local", "Programs", "Posit", "RStudio"),
      file.path(Sys.getenv("PROGRAMDATA"), "chocolatey", "lib", "rstudio", "tools"),
      file.path(Sys.getenv("USERPROFILE"), "scoop", "apps", "rstudio", "current")
    )
  } else {
    # Linux paths
    c(
      "/usr/lib/rstudio",
      "/opt/rstudio",
      "/usr/local/lib/rstudio",
      "/opt/posit/rstudio",
      "/usr/lib/posit/rstudio"
    )
  }
}

#' Find stylesheets in a given path
#' @param base_path Base path to search
#' @return Path to stylesheets directory or NULL
#' @keywords internal
find_stylesheets_in_path <- function(base_path) {
  possible_stylesheet_paths <- c(
    file.path(base_path, "resources", "stylesheets"),           # Classic location
    file.path(base_path, "resources", "app", "resources", "stylesheets"), # RStudio 2025 location
    file.path(base_path, "bin", "resources", "stylesheets"),    # Alternative location
    file.path(base_path, "share", "resources", "stylesheets")   # Linux-style location
  )
  
  for(stylesheet_path in possible_stylesheet_paths) {
    if(getOption("rscodeiov2.debug", FALSE)) {
      cat("🔍 Testing stylesheet path:", stylesheet_path, "\n")
    }
    if(dir.exists(stylesheet_path)) {
      cat("✅ Found stylesheets at:", stylesheet_path, "\n")
      return(stylesheet_path)
    }
  }
  return(NULL)
}

#' Try Windows Registry to find RStudio
#' @return Path to stylesheets or NULL
#' @keywords internal
try_windows_registry <- function() {
  tryCatch({
    cat("🔍 Checking Windows registry...\n")
    reg_cmd <- 'reg query "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall" /s /f "RStudio" 2>nul | findstr "InstallLocation"'
    reg_result <- suppressWarnings(system(reg_cmd, intern = TRUE, ignore.stderr = TRUE))
    
    if(length(reg_result) > 0) {
      for(line in reg_result) {
        if(grepl("InstallLocation", line)) {
          install_path <- gsub(".*InstallLocation\\s+REG_SZ\\s+", "", line)
          install_path <- trimws(install_path)
          cat("📍 Found registry install path:", install_path, "\n")
          
          stylesheet_path <- find_stylesheets_in_path(install_path)
          if(!is.null(stylesheet_path)) {
            return(stylesheet_path)
          }
        }
      }
    }
    return(NULL)
  }, error = function(e) {
    if(getOption("rscodeiov2.debug", FALSE)) {
      cat("❌ Registry check failed:", e$message, "\n")
    }
    return(NULL)
  })
}

# ==============================================================================
# QSS FILE PATH FUNCTIONS
# ==============================================================================

#' Get path to Gnome dark theme QSS file
#' @return Character string with file path
#' @keywords internal
gnome_theme_dark <- function() {
  fs::path(get_stylesheets_location(),"rstudio-gnome-dark.qss")
}

#' Get path to Gnome dark theme backup QSS file
#' @return Character string with file path
#' @keywords internal
gnome_theme_dark_backup <- function() {
  fs::path(get_stylesheets_location(), "rstudio-gnome-dark-rscodeio-backup.qss")
}

#' Get path to Windows dark theme QSS file
#' @return Character string with file path
#' @keywords internal
windows_theme_dark <- function() {
  fs::path(get_stylesheets_location(),"rstudio-windows-dark.qss")
}

#' Get path to Windows dark theme backup QSS file
#' @return Character string with file path
#' @keywords internal
windows_theme_dark_backup <- function() {
  fs::path(get_stylesheets_location(),"rstudio-windows-dark-rscodeio-backup.qss")
}

# ==============================================================================
# SYSTEM DETECTION FUNCTIONS
# ==============================================================================

#' Check if the host OS is macOS
#' @return Logical
#' @keywords internal
host_os_is_mac <- function() {
  Sys.info()["sysname"] == "Darwin"
}

#' Check if running on RStudio Server
#' @return Logical
#' @keywords internal
is_rstudio_server <- function() {
  rstudioapi::versionInfo()$mode == "server"
}

#' Check if rscodeiov2 themes are installed
#' @return Logical
#' @keywords internal
rscodeiov2_installed <- function() {
  themes <- rstudioapi::getThemes()
  theme_names <- names(themes)
  
  # Check for any theme name containing "rscodeio"
  any(grepl("rscodeio", theme_names, ignore.case = TRUE))
}

# ==============================================================================
# EXPORTED UTILITY FUNCTIONS
# ==============================================================================

#' Test RStudio path detection
#'
#' This function tests whether the package can successfully detect your RStudio
#' installation and locate the necessary stylesheet files for theming.
#'
#' @return Invisible logical. TRUE if successful, FALSE otherwise
#' @examples
#' \dontrun{
#' rscodeiov2::test_rstudio_path()
#' }
#' @export
test_rstudio_path <- function() {
  cat("🔍 Testing RStudio path detection...\n\n")
  
  tryCatch({
    path <- get_stylesheets_location()
    cat("\n✅ SUCCESS: Found RStudio stylesheets at:", path, "\n")
    
    # Test if we can read the files
    gnome_file <- file.path(path, "rstudio-gnome-dark.qss")
    windows_file <- file.path(path, "rstudio-windows-dark.qss")
    
    cat("\n📁 File check:\n")
    cat("  📄 Gnome QSS exists:", file.exists(gnome_file), "\n")
    cat("  📄 Windows QSS exists:", file.exists(windows_file), "\n")
    
    if(file.exists(gnome_file) || file.exists(windows_file)) {
      cat("\n🎉 Path detection successful!\n")
      return(invisible(TRUE))
    } else {
      cat("\n⚠️ WARNING: Stylesheets directory found but no QSS files present.\n")
      cat("💡 This suggests RStudio 2025+ which uses CSS theming instead.\n")
      return(invisible(FALSE))
    }
    
  }, error = function(e) {
    cat("\n❌ ERROR:", e$message, "\n\n")
    cat("💡 Try running: rscodeiov2::rscodeio_diagnose() for more information\n")
    return(invisible(FALSE))
  })
}

#' Manually set RStudio installation path
#'
#' If automatic detection fails, you can manually specify the RStudio installation
#' directory. This is useful for non-standard installations or portable versions.
#'
#' @param rstudio_path Character string with path to RStudio installation directory
#' @return Invisible logical. TRUE if successful, FALSE otherwise
#' @examples
#' \dontrun{
#' # For a custom installation location
#' rscodeiov2::set_rstudio_path("C:/MyCustomLocation/RStudio")
#' }
#' @export
set_rstudio_path <- function(rstudio_path) {
  
  if(!dir.exists(rstudio_path)) {
    stop("Directory does not exist: ", rstudio_path, call. = FALSE)
  }
  
  stylesheet_path <- file.path(rstudio_path, "resources", "stylesheets")
  
  if(!dir.exists(stylesheet_path)) {
    stop("Stylesheets directory not found at: ", stylesheet_path, call. = FALSE)
  }
  
  # Set environment variable for future use
  Sys.setenv(RSTUDIO_MANUAL_PATH = rstudio_path)
  
  cat("📍 RStudio path manually set to:", rstudio_path, "\n")
  cat("📁 Stylesheets found at:", stylesheet_path, "\n")
  
  # Test the files
  gnome_file <- file.path(stylesheet_path, "rstudio-gnome-dark.qss")
  windows_file <- file.path(stylesheet_path, "rstudio-windows-dark.qss")
  
  cat("\n📄 QSS Files:\n")
  cat("  Gnome QSS:", file.exists(gnome_file), "\n")
  cat("  Windows QSS:", file.exists(windows_file), "\n")
  
  if(file.exists(gnome_file) || file.exists(windows_file)) {
    cat("\n✅ RStudio path successfully configured!\n")
    cat("🚀 You can now run: rscodeiov2::install_theme()\n")
    return(invisible(TRUE))
  } else {
    warning("Stylesheets directory found but no QSS files present.", call. = FALSE)
    return(invisible(FALSE))
  }
}

#' Explore RStudio directory structure
#'
#' This function explores the RStudio installation directory to help diagnose
#' theming issues and understand the file structure. Useful for debugging
#' when automatic detection fails.
#'
#' @param base_path Character string with path to explore (defaults to detected RStudio path)
#' @return Invisible logical. Always TRUE
#' @examples
#' \dontrun{
#' # Explore default RStudio installation
#' rscodeiov2::explore_rstudio_structure()
#' 
#' # Explore specific directory
#' rscodeiov2::explore_rstudio_structure("C:/Program Files/RStudio")
#' }
#' @export
explore_rstudio_structure <- function(base_path = NULL) {
  
  if(is.null(base_path)) {
    # Try to find RStudio base path from environment variables
    pandoc_path <- Sys.getenv("RSTUDIO_PANDOC")
    if(pandoc_path != "") {
      # Extract base RStudio path from pandoc path
      path_parts <- fs::path_split(pandoc_path)[[1]]
      rstudio_ind <- which(path_parts %in% c("RStudio", "rstudio", "Posit", "posit"))
      if(length(rstudio_ind) > 0) {
        base_path <- fs::path_join(path_parts[seq(rstudio_ind)])
      }
    }
    
    if(is.null(base_path)) {
      base_path <- "C:/Program Files/RStudio"
    }
  }
  
  cat("🔍 Exploring RStudio directory structure at:", base_path, "\n\n")
  
  if(!dir.exists(base_path)) {
    cat("❌ ERROR: Base directory does not exist:", base_path, "\n")
    return(invisible(FALSE))
  }
  
  # Function to explore directory recursively but limit depth
  explore_dir <- function(path, prefix = "", max_depth = 3, current_depth = 0) {
    if(current_depth >= max_depth) return()
    
    tryCatch({
      items <- list.files(path, full.names = FALSE, include.dirs = TRUE)
      
      for(item in items) {
        item_path <- file.path(path, item)
        is_dir <- dir.exists(item_path)
        
        if(is_dir) {
          cat(prefix, "📁", item, "/\n", sep = "")
          
          # Look specifically for files that might be stylesheets
          if(grepl("stylesheets?", item, ignore.case = TRUE) || 
             grepl("theme", item, ignore.case = TRUE) ||
             grepl("css", item, ignore.case = TRUE) ||
             grepl("qss", item, ignore.case = TRUE)) {
            cat(prefix, "  ⭐ POTENTIAL STYLESHEET DIRECTORY!\n")
            
            # List contents of potential stylesheet directories
            stylesheet_files <- list.files(item_path, pattern = "\\.(css|qss)$", ignore.case = TRUE)
            if(length(stylesheet_files) > 0) {
              cat(prefix, "  📄 Found stylesheet files: ", paste(stylesheet_files, collapse = ", "), "\n")
            }
          }
          
          # Recursively explore subdirectories
          if(current_depth < max_depth - 1) {
            explore_dir(item_path, paste0(prefix, "  "), max_depth, current_depth + 1)
          }
        } else {
          # Check for potential stylesheet files
          if(grepl("\\.(css|qss)$", item, ignore.case = TRUE)) {
            cat(prefix, "📄", item, " ⭐ STYLESHEET FILE!\n", sep = "")
          } else {
            cat(prefix, "📄", item, "\n", sep = "")
          }
        }
      }
    }, error = function(e) {
      cat(prefix, "❌ Error reading directory: ", e$message, "\n")
    })
  }
  
  # Start exploration
  explore_dir(base_path)
  
  cat("\n🔍 Looking specifically for stylesheet files...\n")
  
  # Search for stylesheet files recursively
  tryCatch({
    stylesheet_files <- list.files(base_path, pattern = "\\.(qss|css)$", 
                                  recursive = TRUE, full.names = TRUE, ignore.case = TRUE)
    
    if(length(stylesheet_files) > 0) {
      css_files <- grep("\\.css$", stylesheet_files, ignore.case = TRUE, value = TRUE)
      qss_files <- grep("\\.qss$", stylesheet_files, ignore.case = TRUE, value = TRUE)
      
      cat("📊 Summary:\n")
      cat("  📄 Total stylesheet files found:", length(stylesheet_files), "\n")
      cat("  🌐 CSS files (RStudio 2025+):", length(css_files), "\n")
      cat("  🎨 QSS files (Legacy RStudio):", length(qss_files), "\n\n")
      
      if(length(css_files) > 0) {
        cat("🌐 CSS Files found (RStudio 2025+ web-based theming):\n")
        for(file in css_files) {
          cat("  📄", file, "\n")
        }
        cat("\n")
      }
      
      if(length(qss_files) > 0) {
        cat("🎨 QSS Files found (Legacy RStudio theming):\n")
        for(file in qss_files) {
          cat("  📄", file, "\n")
        }
      } else {
        cat("ℹ️ No QSS files found - this indicates RStudio 2025+ with web-based architecture.\n")
      }
    } else {
      cat("❌ No QSS or CSS files found in the RStudio directory.\n")
    }
  }, error = function(e) {
    cat("❌ Error searching for stylesheet files:", e$message, "\n")
  })
  
  invisible(TRUE)
}

#' Get comprehensive diagnostic information
#'
#' Provides detailed diagnostic information about your RStudio installation,
#' theme status, and system configuration. Useful for troubleshooting
#' theme installation issues.
#'
#' @return Invisible logical. Always TRUE
#' @examples
#' \dontrun{
#' rscodeiov2::rscodeio_diagnose()
#' }
#' @export
rscodeio_diagnose <- function() {
  
  cat("\n🔬 === rscodeiov2 Diagnostic Information ===\n\n")
  
  # RStudio information
  cat("📊 RStudio Information:\n")
  if(rstudioapi::isAvailable()) {
    version_info <- rstudioapi::versionInfo()
    cat("  📋 Version:", as.character(version_info$version), "\n")
    cat("  🖥️ Mode:", version_info$mode, "\n")
    if(!is.null(version_info$long_version)) {
      cat("  📝 Long version:", version_info$long_version, "\n")
    }
    
    # Detect theming architecture
    if(utils::compareVersion(as.character(version_info$version), "2025.0.0") >= 0) {
      cat("  🌐 Theming Architecture: Web-based CSS (Modern)\n")
    } else {
      cat("  🎨 Theming Architecture: QSS-based (Legacy)\n")
    }
  } else {
    cat("  ❌ RStudio API not available\n")
  }
  
  # System information
  cat("\n🖥️ System Information:\n")
  sys_info <- Sys.info()
  cat("  💻 OS:", sys_info["sysname"], sys_info["release"], "\n")
  cat("  🏗️ Machine:", sys_info["machine"], "\n")
  
  # Theme information
  cat("\n🎨 Theme Information:\n")
  if(rstudioapi::isAvailable()) {
    tryCatch({
      all_themes <- rstudioapi::getThemes()
      theme_names <- names(all_themes)
      rscodeio_themes <- grep("rscodeio", theme_names, ignore.case = TRUE, value = TRUE)
      
      cat("  📊 Total themes installed:", length(theme_names), "\n")
      cat("  🎯 rscodeiov2 themes found:", length(rscodeio_themes), "\n")
      if(length(rscodeio_themes) > 0) {
        cat("    📄 Themes:\n")
        for(theme in rscodeio_themes) {
          cat("      -", theme, "\n")
        }
      }
    }, error = function(e) {
      cat("  ❌ Error getting theme information:", e$message, "\n")
    })
  }
  
  # Path information (only for legacy RStudio)
  cat("\n📁 Path Information:\n")
  if(!host_os_is_mac()) {
    tryCatch({
      stylesheet_path <- get_stylesheets_location()
      cat("  📂 Stylesheets directory:", stylesheet_path, "\n")
      cat("  ✅ Directory exists:", dir.exists(stylesheet_path), "\n")
      
      # Check individual files
      gnome_file <- gnome_theme_dark()
      windows_file <- windows_theme_dark()
      gnome_backup <- gnome_theme_dark_backup()
      windows_backup <- windows_theme_dark_backup()
      
      cat("  🐧 Gnome theme file:", gnome_file, "\n")
      cat("    📄 Exists:", file.exists(gnome_file), "\n")
      cat("    💾 Backup exists:", file.exists(gnome_backup), "\n")
      
      cat("  🪟 Windows theme file:", windows_file, "\n")
      cat("    📄 Exists:", file.exists(windows_file), "\n")
      cat("    💾 Backup exists:", file.exists(windows_backup), "\n")
      
    }, error = function(e) {
      cat("  ❌ Error getting legacy path information:", e$message, "\n")
      cat("  ℹ️ This is normal for RStudio 2025+ which uses CSS-based theming\n")
    })
  } else {
    cat("  🍎 Stylesheet theming not supported on macOS\n")
  }
  
  # RStudio 2025+ CSS path check
  cat("\n🌐 RStudio 2025+ CSS Information:\n")
  css_path <- "C:/Program Files/RStudio/resources/app/www/rstudio.css"
  backup_css <- paste0(css_path, ".rscodeiov2.backup")
  
  cat("  📄 Main CSS file:", css_path, "\n")
  cat("    ✅ Exists:", file.exists(css_path), "\n")
  cat("  💾 CSS backup:", backup_css, "\n")
  cat("    ✅ Exists:", file.exists(backup_css), "\n")
  
  # Environment variables
  cat("\n🌍 RStudio Environment Variables:\n")
  env_vars <- c("RSTUDIO_PANDOC", "RSTUDIO_WINUTILS", "RS_RPOSTBACK_PATH", 
                "RMARKDOWN_MATHJAX_PATH", "RSTUDIO_SESSION_PORT", "RSTUDIO_DESKTOP_EXE")
  
  for(var in env_vars) {
    value <- Sys.getenv(var, unset = "<not set>")
    cat("  🔧", var, ":", value, "\n")
  }
  
  cat("\n✅ === End Diagnostic Information ===\n\n")
  
  invisible(TRUE)
}