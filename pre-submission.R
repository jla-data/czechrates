# pre-submission routine

rhub::check_on_windows()
rhub::check_for_cran(platforms = "macos-highsierra-release-cran")
devtools::check_win_release()
devtools::check_win_devel()

# once ready
devtools::release()
