server = function(input, output, session) {
  
  observeEvent(input$more_options, {
    toggle(
      id = "hidden_div",
      anim = TRUE
    )
  })
  
  filtered = reactive({
    board_games %>% 
      filter(
        maxplayers >= input$players,
        minplayers <= input$players,
        minage <= input$age,
        category %in% input$category,
        yearpublished >= input$year[1],
        yearpublished <= input$year[2],
        playingtime >= input$playtime[1],
        playingtime <= input$playtime[2]
      ) %>% 
      arrange(name)
  }) %>% 
    bindEvent(input$search)
  
  top_game = reactive({
    filtered() %>%
      mutate(category_match = category %in% input$category) %>%
      group_by(name) %>%
      mutate(category_match = sum(category_match)) %>%
      ungroup() %>%
      arrange(desc(category_match), rank) %>%
      slice(1) %>% 
      pull(name)
  })
  
  output$recommended = renderUI({
    
    recommended = board_games %>%
      filter(name == top_game())
    
    categories = recommended %>%
      distinct(category) %>%
      pull()
    
    recommendedUI(recommended[1, ], categories)
    
  }) %>% 
    bindEvent(input$search)
  
output$list = renderUI({
  if (nrow(filtered() != 0)) {
    honourable_mentions = filtered() %>%
      filter(name != top_game()) %>% 
      distinct(name, .keep_all = TRUE) %>%
      slice_min(rank, n = 10)
    
    if (nrow(honourable_mentions) == 0) {
      div()
    } else {
      listUI(honourable_mentions)
    }
  }
}) %>% 
  bindEvent(input$search)
  
}
