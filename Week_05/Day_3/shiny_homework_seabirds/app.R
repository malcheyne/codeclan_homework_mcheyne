library(shiny)
library(tidyverse)
library(shinythemes)


seabirds_cleaned_data <- read_csv("data/seabirds_cleaned_data.csv")

birds_9 <- seabirds_cleaned_data %>% 
  group_by(common_name) %>% 
  mutate(common_name = if_else(str_detect(common_name, 
                                          "(?i)shearwater"),"Shearwater", 
                               common_name),
         common_name = if_else(str_detect(common_name, 
                                          "(?i)albatross"), "Albatross",
                               common_name),
         common_name = if_else(str_detect(common_name, 
                                          "(?i)mollymawk"), "Mollymawk",
                               common_name),
         common_name = if_else(str_detect(common_name, 
                                          "(?i)petrel"), "Petrel",
                               common_name),
         common_name = if_else(str_detect(common_name, 
                                          "(?i)prion"), "Prion",
                               common_name),
         common_name = if_else(str_detect(common_name, 
                                          "(?i)skua"), "Skua",
                               common_name),
         common_name = if_else(str_detect(common_name, 
                                          "(?i)penguin"), "Penguin",
                               common_name),
         common_name = if_else(str_detect(common_name, 
                                          "(?i)Red-tailed tropicbird"), 
                               "Red-tailed tropicbird",
                               common_name),
         common_name = if_else(str_detect(common_name, 
                                          "(?i)Brown noddy"), "Brown noddy",
                               common_name)
  ) %>% 
  filter(common_name %in% c("Shearwater", "Albatross", 
                            "Mollymawk", "Petrel", 
                            "Prion", "Skua", 
                            "Penguin", "Brown noddy", 
                            "Red-tailed tropicbird"))


sighting <-  birds_9 %>% 
  group_by(common_name) %>% 
  summarise(count = sum(total_sighting, na.rm = TRUE)) %>% 
  mutate(sighting_id = row_number())

feeding <-  birds_9 %>% 
  group_by(common_name) %>% 
  filter(str_detect(feeding, "YES")) %>% 
  summarise(count = n()) %>% 
  mutate(feeding_id = row_number())

on_ship <-  birds_9 %>% 
  group_by(common_name) %>% 
  filter(str_detect(on_ship, "YES")) %>% 
  summarise(count = n()) %>% 
  mutate(on_ship_id = row_number())

in_hand <-  birds_9 %>% 
  group_by(common_name) %>% 
  filter(str_detect(in_hand, "YES")) %>% 
  summarise(count = n()) %>% 
  mutate(in_hand_id = row_number())

fly_by <-  birds_9 %>% 
  group_by(common_name) %>% 
  filter(str_detect(fly_by, "YES")) %>% 
  summarise(count = n()) %>% 
  mutate(fly_by_id = row_number())


ui <- fluidPage(
  theme = shinytheme("superhero"),
  
    titlePanel(tags$h1("Seabirds")),
  
    fluidRow(
    
    
               
        sidebarLayout(
            sidebarPanel(
              # check box
                checkboxGroupInput("checkgroup_input", 
                                  label = h3("Seabirds"), 
                                  choices = 
                                    unique(birds_9$common_name),
                                  selected = 
                                    unique(birds_9$common_name)
                )
                # ,
              # ACTION BUTTON 
                # actionButton("update", "Generate Polts and Table"
                # )
            ),
             
            mainPanel(
                tabsetPanel(
                  # First tab  
                    tabPanel("Sighting",
                        plotOutput("sightings")
                    ),
                  # Second tab  
                    tabPanel("Seen Feeding",
                        plotOutput("feeding")
                    ),
                  # Third tab
                    tabPanel("Seen On Ship",
                        plotOutput("on_ship")
                    ),
                  # Forth tab
                    tabPanel("Handled",
                             plotOutput("in_hand")
                    ),
                  # Fifth tab
                    tabPanel("Seen flying",
                             plotOutput("fly_by")
                    )
                )
            )
        ) 
    )
)



server <- function(input, output) {
  # ACTION BUTTON
  # filtered_data <- eventReactive(input$update, {
  # 
  # filter_sighting <- sighting %>%
  #     filter(common_name %in% input$checkgroup_input)
  # 
  # filter_feeding <- feeding %>% 
  #   filter(common_name %in% input$checkgroup_input)
  # 
  # filter_on_ship <- on_ship %>% 
  #   filter(common_name %in% input$checkgroup_input)
  # 
  # filter_in_hand <- in_hand %>% 
  #   filter(common_name %in% input$checkgroup_input)
  # 
  # filter_fly_by <- fly_by %>% 
  #   filter(common_name %in% input$checkgroup_input)
  # 
  # })
  
  output$sightings <- renderPlot({
    
   sighting %>%
      filter(common_name %in% input$checkgroup_input) %>%
      ggplot() +
      aes(y = common_name,
          x = log10(count), fill = sighting_id) +
      geom_col() +
      theme(legend.position = "none")
    # log10() as 1 or more birds are less than 10 and don't show on normal graph
    
  })
  
  output$feeding <- renderPlot({
    
    feeding %>%
      filter(common_name %in% input$checkgroup_input) %>%
      ggplot() +
      aes(y = common_name, 
          x = log10(count), fill = feeding_id) +
      geom_col() +
      theme(legend.position = "none")
    # log10() as 1 or more birds are less than 10 and don't show on normal graph
  })
  
  output$on_ship <- renderPlot({
    
    on_ship %>%
      filter(common_name %in% input$checkgroup_input) %>%
      ggplot() +
      aes(y = common_name, 
          x = count, fill = on_ship_id) +
      geom_col() +
      theme(legend.position = "none")
  })
  
  output$in_hand <- renderPlot({
    
    in_hand %>%
      filter(common_name %in% input$checkgroup_input) %>%
      ggplot() +
      aes(y = common_name, 
          x = count, fill = in_hand_id) +
      geom_col() +
      theme(legend.position = "none")
  })
  
  output$fly_by <- renderPlot({
    
    fly_by %>%
      filter(common_name %in% input$checkgroup_input) %>%
      ggplot() +
      aes(y = common_name, 
          x = log10(count), fill = fly_by_id) +
      geom_col() +
      theme(legend.position = "none")
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)