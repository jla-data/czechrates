library(czechrates)
library(gganimate)
library(ggplot2)

chart_src <- pribor(seq(from = as.Date("1997-05-01"),
                        to = as.Date("1997-06-30"),
                        by = 1))

animation <- ggplot(data = chart_src, aes(x = date_valid, y = PRIBOR_1D)) +
  geom_line(color = "red", size = 1.25) +
  geom_point(color = "red", size = 2) +
  scale_x_date(date_labels = "%d.%m.%Y") +
  scale_y_continuous(labels = scales::percent_format()) +
  theme_bw() +
  labs(title = "A ghost of the times past, when the Asian Fever meant *monetary* contagion...",
       x = "Date",
       y = "Overnight PRIBOR (per annum)") +
  theme(plot.title = ggtext::element_markdown(size = 22)) +
  transition_reveal(date_valid) +
  enter_fade() +
  exit_fade()

animate(animation, height = 600, width = 800)
anim_save("./img/asian_fever.gif")
