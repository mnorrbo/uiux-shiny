library("shiny")
library("shinyjs")
library("shinyWidgets")
library("dplyr")
library("shinyhelper")

board_games = readr::read_csv("data/board_games.csv",
                              show_col_types = FALSE)

defaults = list(
  category = sort(unique(board_games$category)),
  players = list(
    min = min(board_games$minplayers),
    max = max(board_games$maxplayers),
    mid = median(c(
      max(board_games$maxplayers), min(board_games$minplayers)
    ))
  ),
  playtime = list(
    min = min(board_games$playingtime),
    max = max(board_games$playingtime),
    q1 = quantile(board_games$playingtime)[["25%"]],
    q3 = quantile(board_games$playingtime)[["75%"]]
  ),
  age = list(
    min = min(board_games$minage),
    max = max(board_games$minage),
    mid = median(board_games$minage)
  ),
  year = list(
    min = min(board_games$yearpublished),
    max = max(board_games$yearpublished)
  )
)


dynamicLabels = function() {
  tags$script(HTML(
    "document.getElementById('more_options').onclick = () => {
      currentText = document.getElementById('more_options').textContent
      
      let newText
      if (currentText == '+ More options') newText = '- Fewer options'
      if (currentText == '- Fewer options') newText = '+ More options'
    
    document.getElementById('more_options').textContent = newText
    }"
  ))
}

recommendedUI = function(data, categories) {
  div(
    id = "rec",
    h3("We recommend"),
    hr(),
    div(
      id = "rec-title",
      tags$img(src = data$thumbnail),
      h2(data$name)
    ),
    br(),
    p(HTML(paste0(
      "Rated <b>", data$average, 
      "</b>/10 (by ", 
      format(data$users_rated, big.mark = ","), 
      " users)"
    ))),
    p(HTML(
      paste0("Categories: <b>", paste0(categories, collapse = ", "), "</b>")
    )),
    div(
      class = "auto-fit main-detail",
      p(paste0(data$playingtime, " mins")),
      p(paste0(data$minage, "+ years")),
      p(paste0(
        data$minplayers, 
        "-", data$maxplayers,
        " players"
      )),
      p(data$yearpublished),
    ),
    br(),
    tags$b("Description"),
    div(
      id = "game-description", 
      p(HTML(data$description))
    )
  )
}

listUI = function(data) {
  
  rows = data %>% 
    rowwise() %>% 
    group_split()
  
  div(
    h3("You might also like"),
    hr(),
    purrr::map(
      rows, ~listItem(.x)
    )
  )
  
}

listItem = function(data) {
  div(
    tags$b(data$name),
    div(
      class = "auto-fit secondary-detail",
      p(paste0(data$average, "/10")),
      p(paste0(data$playingtime, " mins")),
      p(paste0(data$minage, "+"))
    )
  )
}
