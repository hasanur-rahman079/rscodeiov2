get_stylesheets_location <- function(){

  ## We shouldn't get here on mac
  if(host_os_is_mac()) stop("Qss Stylesheets are not used on Mac")

  # Try multiple methods to find RStudio installation
  rstudio_dirs <- list(
    pandoc_dir = Sys.getenv("RSTUDIO_PANDOC"),
    msys_ssh_dir = Sys.getenv("RSTUDIO_MSYS_SSH"),
    rstudio_win_utils_dir = Sys.getenv("RSTUDIO_WINUTILS"),
    rs_postback_path = Sys.getenv("RS_RPOSTBACK_PATH"),
    rmarkdown_mathjax_path = Sys.getenv("RMARKDOWN_MATHJAX_PATH")
  )
  
  # Additional environment variables to check for newer RStudio versions
  additional_dirs <- list(
    rstudio_session_port = Sys.getenv("RSTUDIO_SESSION_PORT"),
    rstudio_session_stream = Sys.getenv("RSTUDIO_SESSION_STREAM"),
    rstudio_desktop_exe = Sys.getenv("RSTUDIO_DESKTOP_EXE"),
    rstudio_resources = Sys.getenv("RSTUDIO_RESOURCES"),
    rstudio_which_r = Sys.getenv("RSTUDIO_WHICH_R")
  )
  
  rstudio_dirs <- c(rstudio_dirs, additional_dirs)
  
  # Debug: Print environment variables
  cat("Debug: Checking environment variables...\n")
  for(name in names(rstudio_dirs)) {
    value <- rstudio_dirs[[name]]
    if(value != "") {
      cat("  ", name, ":", value, "\n")
    }
  }

  extract_rstudio_path_parts <- function(path){
    if(is.null(path) || path == "") return(NULL)
    cat("Debug: Extracting path parts from:", path, "\n")
    dir_parts <- fs::path_split(path)[[1]]
    rstudio_ind <- which(dir_parts %in% c("RStudio","rstudio", "Posit", "posit"))
    if(length(rstudio_ind) != 1) {
      cat("Debug: No RStudio/Posit directory found in path\n")
      return(NULL)
    }
    
    result_parts <- dir_parts[seq(rstudio_ind)]
    cat("Debug: Extracted parts:", paste(result_parts, collapse = "/"), "\n")
    return(result_parts)
  }

  potential_paths <-
    Filter(function(path_parts) {
           if(is.null(path_parts)) return(FALSE)
           test_path <- fs::path_join(c(path_parts, "resources", "stylesheets"))
           cat("Debug: Testing path:", test_path, "\n")
           exists <- dir.exists(test_path)
           cat("Debug: Path exists:", exists, "\n")
           return(exists)
          },
          lapply(rstudio_dirs, extract_rstudio_path_parts)
    )
  
  # If no paths found via environment variables, try common installation locations
  if(length(potential_paths) == 0) {
    cat("Debug: No paths found via environment variables, trying common locations...\n")
    
    common_paths <- character(0)
    
    if(Sys.info()["sysname"] == "Windows") {
      common_paths <- c(
        file.path(Sys.getenv("PROGRAMFILES"), "RStudio"),
        file.path(Sys.getenv("PROGRAMFILES(X86)"), "RStudio"),
        file.path(Sys.getenv("LOCALAPPDATA"), "Programs", "RStudio"),
        file.path(Sys.getenv("PROGRAMFILES"), "Posit", "RStudio"),
        file.path(Sys.getenv("PROGRAMFILES(X86)"), "Posit", "RStudio"),
        file.path(Sys.getenv("LOCALAPPDATA"), "Programs", "Posit", "RStudio"),
        # Additional potential paths for RStudio 2025
        file.path(Sys.getenv("PROGRAMFILES"), "RStudio-2025.05.0"),
        file.path(Sys.getenv("PROGRAMFILES(X86)"), "RStudio-2025.05.0"),
        file.path(Sys.getenv("LOCALAPPDATA"), "Programs", "RStudio-2025.05.0")
      )
    } else {
      # Linux paths
      common_paths <- c(
        "/usr/lib/rstudio",
        "/opt/rstudio",
        "/usr/local/lib/rstudio",
        "/opt/posit/rstudio",
        "/usr/lib/posit/rstudio"
      )
    }
    
    cat("Debug: Checking common installation paths...\n")
    for(path in common_paths) {
      cat("Debug: Checking:", path, "\n")
      if(dir.exists(path)) {
        cat("Debug: Directory exists, checking for stylesheets...\n")
        stylesheet_path <- file.path(path, "resources", "stylesheets")
        cat("Debug: Testing stylesheet path:", stylesheet_path, "\n")
        if(dir.exists(stylesheet_path)) {
          cat("Debug: Found stylesheets at:", stylesheet_path, "\n")
          return(stylesheet_path)
        }
      }
    }
    
    # Try to find RStudio executable and derive path from it
    cat("Debug: Trying to find RStudio executable...\n")
    if(Sys.info()["sysname"] == "Windows") {
      # Check registry or common executable locations
      possible_exes <- c(
        file.path(Sys.getenv("PROGRAMFILES"), "RStudio", "rstudio.exe"),
        file.path(Sys.getenv("PROGRAMFILES(X86)"), "RStudio", "rstudio.exe"),
        file.path(Sys.getenv("LOCALAPPDATA"), "Programs", "RStudio", "rstudio.exe")
      )
      
      for(exe_path in possible_exes) {
        if(file.exists(exe_path)) {
          exe_dir <- dirname(exe_path)
          stylesheet_path <- file.path(exe_dir, "resources", "stylesheets")
          cat("Debug: Found exe, testing:", stylesheet_path, "\n")
          if(dir.exists(stylesheet_path)) {
            cat("Debug: Found stylesheets via executable path:", stylesheet_path, "\n")
            return(stylesheet_path)
          }
        }
      }
    }
  }

  if(length(potential_paths) == 0) {
    stop("Could not find location of your RStudio installation. Please ensure RStudio is properly installed and you are running this from within RStudio with administrator privileges.")
  }

  ## return first path that existed
  result_path <- fs::path_join(c(potential_paths[[1]], "resources", "stylesheets"))
  cat("Debug: Final result path:", result_path, "\n")
  return(result_path)

}

gnome_theme_dark <- function() {
  fs::path(get_stylesheets_location(),"rstudio-gnome-dark.qss")
}

gnome_theme_dark_backup <- function() {
  fs::path(get_stylesheets_location(), "rstudio-gnome-dark-rscodeio-backup.qss")
}

windows_theme_dark <- function() {
  fs::path(get_stylesheets_location(),"rstudio-windows-dark.qss")
}

windows_theme_dark_backup <- function() {
  fs::path(get_stylesheets_location(),"rstudio-windows-dark-rscodeio-backup.qss")
}

host_os_is_mac <- function() {
  Sys.info()["sysname"] == "Darwin"
}

is_rstudio_server <- function() {
  rstudioapi::versionInfo()$mode == "server"
}

rscodeiov2_installed <- function() {
  themes <- rstudioapi::getThemes()
  theme_names <- names(themes)
  
  # Check for any theme name containing "rscodeio"
  any(grepl("rscodeio", theme_names, ignore.case = TRUE))
}

#' Test RStudio path detection
#'
#' @return Invisible TRUE if successful
#' @export
test_rstudio_path <- function() {
  cat("Testing RStudio path detection...\n\n")
  
  tryCatch({
    path <- get_stylesheets_location()
    cat("\nSUCCESS: Found RStudio stylesheets at:", path, "\n")
    
    # Test if we can read the files
    gnome_file <- file.path(path, "rstudio-gnome-dark.qss")
    windows_file <- file.path(path, "rstudio-windows-dark.qss")
    
    cat("\nFile check:\n")
    cat("  Gnome QSS exists:", file.exists(gnome_file), "\n")
    cat("  Windows QSS exists:", file.exists(windows_file), "\n")
    
    if(file.exists(gnome_file) || file.exists(windows_file)) {
      cat("\nPath detection successful!\n")
      return(invisible(TRUE))
    } else {
      cat("\nWARNING: Stylesheets directory found but no QSS files present.\n")
      return(invisible(FALSE))
    }
    
  }, error = function(e) {
    cat("\nERROR:", e$message, "\n\n")
    cat("Please try running: rscodeio_diagnose() for more information\n")
    return(invisible(FALSE))
  })
}
  themes <- rstudioapi::getThemes()
  theme_names <- names(themes)
  
  # Check for any theme name containing "rscodeio"
  any(grepl("rscodeio", theme_names, ignore.case = TRUE))
}

#' Get diagnostic information about the rscodeiov2 installation
#'
#' @return A list containing diagnostic information
#' @export
rscodeio_diagnose <- function() {
  
  cat("\n=== rscodeiov2 Diagnostic Information ===\n\n")
  
  # RStudio information
  cat("RStudio Information:\n")
  if(rstudioapi::isAvailable()) {
    version_info <- rstudioapi::versionInfo()
    cat("  Version:", as.character(version_info$version), "\n")
    cat("  Mode:", version_info$mode, "\n")
    if(!is.null(version_info$long_version)) {
      cat("  Long version:", version_info$long_version, "\n")
    }
  } else {
    cat("  RStudio API not available\n")
  }
  
  # System information
  cat("\nSystem Information:\n")
  sys_info <- Sys.info()
  cat("  OS:", sys_info["sysname"], sys_info["release"], "\n")
  cat("  Machine:", sys_info["machine"], "\n")
  
  # Theme information
  cat("\nTheme Information:\n")
  if(rstudioapi::isAvailable()) {
    tryCatch({
      all_themes <- rstudioapi::getThemes()
      theme_names <- names(all_themes)
      rscodeio_themes <- grep("rscodeio", theme_names, ignore.case = TRUE, value = TRUE)
      
      cat("  Total themes installed:", length(theme_names), "\n")
      cat("  rscodeiov2 themes found:", length(rscodeio_themes), "\n")
      if(length(rscodeio_themes) > 0) {
        cat("    -", paste(rscodeio_themes, collapse = "\n    - "), "\n")
      }
    }, error = function(e) {
      cat("  Error getting theme information:", e$message, "\n")
    })
  }
  
  # Path information
  cat("\nPath Information:\n")
  if(!host_os_is_mac()) {
    tryCatch({
      stylesheet_path <- get_stylesheets_location()
      cat("  Stylesheets directory:", stylesheet_path, "\n")
      cat("  Directory exists:", dir.exists(stylesheet_path), "\n")
      
      # Check individual files
      gnome_file <- gnome_theme_dark()
      windows_file <- windows_theme_dark()
      gnome_backup <- gnome_theme_dark_backup()
      windows_backup <- windows_theme_dark_backup()
      
      cat("  Gnome theme file:", gnome_file, "\n")
      cat("    Exists:", file.exists(gnome_file), "\n")
      cat("    Backup exists:", file.exists(gnome_backup), "\n")
      
      cat("  Windows theme file:", windows_file, "\n")
      cat("    Exists:", file.exists(windows_file), "\n")
      cat("    Backup exists:", file.exists(windows_backup), "\n")
      
    }, error = function(e) {
      cat("  Error getting path information:", e$message, "\n")
    })
  } else {
    cat("  Stylesheet theming not supported on macOS\n")
  }
  
  # Environment variables
  cat("\nRStudio Environment Variables:\n")
  env_vars <- c("RSTUDIO_PANDOC", "RSTUDIO_MSYS_SSH", "RSTUDIO_WINUTILS", 
                "RS_RPOSTBACK_PATH", "RMARKDOWN_MATHJAX_PATH",
                "RSTUDIO_SESSION_PORT", "RSTUDIO_SESSION_STREAM", "RSTUDIO_DESKTOP_EXE")
  
  for(var in env_vars) {
    value <- Sys.getenv(var, unset = "<not set>")
    cat("  ", var, ":", value, "\n")
  }
  
  cat("\n=== End Diagnostic Information ===\n\n")
  
  invisible(TRUE)
}
