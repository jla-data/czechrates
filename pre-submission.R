# pre-submission routine

# nepřeskakovat, důležité! encoding je sviň
rhub::check_for_cran(platforms = "debian-clang-devel")
# možno nahrát jedním vrzem na https://win-builder.r-project.org/upload.aspx
devtools::check_win_release()
devtools::check_win_devel()

# once ready
devtools::release()
