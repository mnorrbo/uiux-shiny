source("global.R")

ui = div(
  h1("Board Game Search 🔎"),
  fluidPage(
  title = "Board Game Finder",
  useShinyjs(),
  theme = "styles.css",
  sidebarLayout(
    sidebarPanel(
      id = "inputs",
      width = 3,
      sliderInput(
        "players",
        "Number of players",
        min = defaults$players$min,
        max = defaults$players$max, 
        value = defaults$players$mid
      ),
      sliderInput(
        "playtime",
        "Playing time (minutes)",
        min = defaults$playtime$min,
        max = defaults$playtime$max,
        value = c(
          defaults$playtime$q1, 
          defaults$playtime$q3
        ),
        step = 5
      ),
      pickerInput(
        "category",
        "Genre",
        choices = defaults$category,
        multiple = TRUE,
        options = list(
          `actions-box` = TRUE,
          `live-search` = TRUE
        ),
        selected = c("Fantasy", "Horror")
      ),
      sliderInput(
        "age",
        "Min. age",
        min = defaults$age$min,
        max = defaults$age$max,
        value = defaults$age$max
      ),
      actionButton(
        "more_options",
        "+ More options"
      ),
      hidden(
        div(
          id = "hidden_div",
          br(),
          sliderInput(
            "year",
            "Year",
            min = defaults$year$min,
            max = defaults$year$max,
            value = c(
              defaults$year$min, 
              defaults$year$max
            ),
            step = 1,
            sep = ""
          )
        )
      ),
      actionButton(
        "search",
        "Find board game"
      )
    ),
    mainPanel(
      fluidRow(
        column(6,
               uiOutput("recommended")
        ),
        column(6, 
               uiOutput("list") 
        )
      )
    )
  ),
  dynamicLabels()
)
)