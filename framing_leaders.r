library (tidyverse)
library(mlbplotR)

# Read the CSV file
df <- read.csv("leaderboard_framing_runs_above_average.csv")

# Sort the DataFrame
df_sorted <- df[order(-df$Framing_Runs_Above_Average),]

valid_teams <- valid_team_names()


# Extract the top 10 and bottom 10 catchers
top_10_catchers <- head(df_sorted, 10) %>%
mutate(clean_team =  case_when(
  team_name == "angels" ~ "LAA",
  team_name == "astros" ~ "HOU",
  team_name == "athletics" ~ "OAK",
  team_name == "blue_jays" ~ "TOR",
  team_name == "braves" ~ "ATL",
  team_name == "brewers" ~ "MIL",
  team_name == "cardinals" ~ "STL",
  team_name == "cubs" ~ "CHC",
  team_name == "dbacks" ~ "AZ",
  team_name == "dodgers" ~ "LAD",
  team_name == "giants" ~ "SF",
  team_name == "indians" ~ "CLE",
  team_name == "mariners" ~ "SEA",
  team_name == "mets" ~ "NYM",
  team_name == "nationals" ~ "WSH",
  team_name == "orioles" ~ "BAL",
  team_name == "padres" ~ "SD",
  team_name == "phillies" ~ "PHI",
  team_name == "pirates" ~ "PIT",
  team_name == "rangers" ~ "TEX",
  team_name == "rays" ~ "TB",
  team_name == "reds" ~ "CIN",
  team_name == "red_sox" ~ "BOS",
  team_name == "rockies" ~ "COL",
  team_name == "royals" ~ "KC",
  team_name == "tigers" ~ "DET",
  team_name == "twins" ~ "MIN",
  team_name == "white_sox" ~ "CWS",
  team_name == "yankees" ~ "NYY"
)) 

bottom_10_catchers <- tail(df_sorted, 10) %>%
mutate(clean_team =  case_when(
  team_name == "angels" ~ "LAA",
  team_name == "astros" ~ "HOU",
  team_name == "athletics" ~ "OAK",
  team_name == "blue_jays" ~ "TOR",
  team_name == "braves" ~ "ATL",
  team_name == "brewers" ~ "MIL",
  team_name == "cardinals" ~ "STL",
  team_name == "cubs" ~ "CHC",
  team_name == "dbacks" ~ "AZ",
  team_name == "dodgers" ~ "LAD",
  team_name == "giants" ~ "SF",
  team_name == "indians" ~ "CLE",
  team_name == "mariners" ~ "SEA",
  team_name == "mets" ~ "NYM",
  team_name == "nationals" ~ "WSH",
  team_name == "orioles" ~ "BAL",
  team_name == "padres" ~ "SD",
  team_name == "phillies" ~ "PHI",
  team_name == "pirates" ~ "PIT",
  team_name == "rangers" ~ "TEX",
  team_name == "rays" ~ "TB",
  team_name == "reds" ~ "CIN",
  team_name == "redsox" ~ "BOS",
  team_name == "rockies" ~ "COL",
  team_name == "royals" ~ "KC",
  team_name == "tigers" ~ "DET",
  team_name == "twins" ~ "MIN",
  team_name == "white_sox" ~ "CWS",
  team_name == "yankees" ~ "NYY"
)) 

ecdf_func <- ecdf(df_sorted$Framing_Runs_Above_Average)
top_10_catchers$Percentile <- ecdf_func(top_10_catchers$Framing_Runs_Above_Average) * 100
bottom_10_catchers$Percentile <- ecdf_func(bottom_10_catchers$Framing_Runs_Above_Average) * 100

my_plot <- top_10_catchers %>%
  ggplot2::ggplot(aes(x = mlb_name, y = Percentile)) +
  ggplot2::geom_col(aes(color = clean_team, fill = clean_team), width = 0.5) +
  geom_text(aes(label=sprintf("%.1f", Percentile), y = Percentile - 1.5), size = 4, vjust = .5) +
  geom_mlb_headshots(aes(player_id = mlb_id, y = Percentile), hjust = .1, width = 0.095) +
  mlbplotR::scale_color_mlb(type = "secondary") +
  mlbplotR::scale_fill_mlb(alpha = 0.4) +
  labs(title = "2023: Catcher Framing Percentiles",
       subtitle = "Top 10 Catchers minimum 25 borderline pitches",
       caption = "Data: Statcast via pybaseball") +
  theme_minimal() +
  theme(
    plot.title = ggplot2::element_text(face = "bold", size = 18),
    axis.title.x = ggplot2::element_text(face = "bold", size = 16, vjust = -2),
    axis.title.y =ggplot2::element_blank(),
    axis.text.y = ggplot2::element_text(face = "bold", size = 12, color = "black"),
    panel.grid.major.x = element_blank(),
    panel.background = element_rect(fill = "white", color = "white"),
    plot.backgroun = element_rect(fill = "white", color = "white"),
    aspect.ratio = 0.5
  ) +
  ggplot2::scale_x_discrete(expand = c(0.05, 0.075)) +
  ggplot2::scale_y_continuous(expand = c(0, 0, 0.05, 1.5)) +
  ggplot2::coord_flip(ylim = c(50, 100))

my_plot

my_plot2 <- bottom_10_catchers %>%
  ggplot2::ggplot(aes(x = mlb_name, y = Percentile)) +
  ggplot2::geom_col(aes(color = clean_team, fill = clean_team), width = 0.5) +
  geom_text(aes(label=sprintf("%.1f", Percentile), y = Percentile - 1.5), size = 4, vjust = .5, hjust = -.1) +
  geom_mlb_headshots(aes(player_id = mlb_id, y = Percentile), hjust = .1, width = 0.095) +
  mlbplotR::scale_color_mlb(type = "secondary") +
  mlbplotR::scale_fill_mlb(alpha = 0.4) +
  labs(title = "2023: Catcher Framing Percentiles",
       subtitle = "Bottom 10 Catchers minimum 25 borderline pitches",
       caption = "Data: Statcast via pybaseball") +
  theme_minimal() +
  theme(
    plot.title = ggplot2::element_text(face = "bold", size = 18),
    axis.title.x = ggplot2::element_text(face = "bold", size = 16, vjust = -2),
    axis.title.y =ggplot2::element_blank(),
    axis.text.y = ggplot2::element_text(face = "bold", size = 12, color = "black"),
    panel.grid.major.x = element_blank(),
    panel.background = element_rect(fill = "white", color = "white"),
    plot.backgroun = element_rect(fill = "white", color = "white"),
    aspect.ratio = 0.5
  ) +
  ggplot2::scale_x_discrete(expand = c(0.05, 0.075)) +
  ggplot2::scale_y_continuous(expand = c(0, 0, 0.05, 1.5)) +
  ggplot2::coord_flip(ylim = c(0, 30))

my_plot2

  ggsave("high_res_plot2.png", plot = my_plot2, width = 10, height = 8, dpi = 300)

