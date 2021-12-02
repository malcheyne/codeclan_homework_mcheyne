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
  
  tabsetPanel(
      tabPanel("Bird numbers seen",
             
            sidebarLayout(
                sidebarPanel(
                  checkboxGroupInput("checkGroup", label = h3("Checkbox group"), 
                                    choices = list("Shearwater" = 1, 
                                                   "Albatross" = 2, 
                                                   "Mollymawk" = 3),
                                    selected = 4),
                   
                   
                                    hr(),
                                    fluidRow(column(3, 
                                          verbatimTextOutput("value")))
                 
                ),
                 
                 
                 # selectInput("bird_2", 
                 #             
                 #             "Pick Bird 2",
                 #             choices = c("Shearwater", "Albatross", 
                 #                         "Mollymawk", "Petrel", 
                 #                         "Prion", "Skua", 
                 #                         "Penguin", "Brown noddy", 
                 #                         "Red-tailed tropicbird")
                 # ),
                 # 
                 # 
                 # selectInput("bird_3", 
                 #             
                 #             "Pick Bird 3",
                 #             choices = c("Shearwater", "Albatross", 
                 #                         "Mollymawk", "Petrel", 
                 #                         "Prion", "Skua", 
                 #                         "Penguin", "Brown noddy", 
                 #                         "Red-tailed tropicbird")
                 # ),
                 # 
                 # 
                 # selectInput("bird_4", 
                 #             
                 #             "Pick Bird 4",
                 #             choices = c("Shearwater", "Albatross", 
                 #                         "Mollymawk", "Petrel", 
                 #                         "Prion", "Skua", 
                 #                         "Penguin", "Brown noddy", 
                 #                         "Red-tailed tropicbird")
                 # )
            ),
               
              mainPanel(
                plotOutput("bird_plot")
              )
      )
  ),
    
    tabPanel("Total Sighting",
             
             #mainPanel(
             plotOutput("sightings")
             
             #)
             
             
             
    )
    # 
    # tabPanel("Seen Feeding",
    #          
    #          #mainPanel(
    #              plot(feeding %>% 
    #                       ggplot() +
    #                       aes(y = common_name, 
    #                           x = log10(count), fill = feeding_id) +
    #                       geom_col() +
    #                       theme(legend.position = "none")
    #                   # log10() as 1 or more birds are less than 10 and don't show on normal graph
    #              )
    #          #)
    #          
    #          
    #          
    # ),
    # 
    # tabPanel("Seen On Ship",
    #          
    #          #mainPanel(
    #              plot(on_ship %>% 
    #                       ggplot() +
    #                       aes(y = common_name, 
    #                           x = count, fill = on_ship_id) +
    #                       geom_col() +
    #                       theme(legend.position = "none")
    #              )
    #          #)
    #          
    #          
    #          
    # ),
    # 
    # tabPanel("Seen In Hand",
    #          
    #          #mainPanel(
    #              plot(in_hand %>% 
    #                       ggplot() +
    #                       aes(y = common_name, 
    #                           x = count, fill = in_hand_id) +
    #                       geom_col() +
    #                       theme(legend.position = "none")
    #              )
    #          #)
    #          
    #          
    #          
    # ),
    # 
    # tabPanel("Seen Flying By",
    #          
    #          #mainPanel(
    #              plot(fly_by %>% 
    #                       ggplot() +
    #                       aes(y = common_name, 
    #                           x = log10(count), fill = fly_by_id) +
    #                       geom_col() +
    #                       theme(legend.position = "none")
    #                   # log10() as 1 or more birds are less than 10 and don't show on normal graph
    #              )
    #          #)
    #          
    #          
    #          
    # )
  )    
)



server <- function(input, output) {
  
  output$bird_plot <- renderPlot ({
    birds_9 %>%
      group_by(common_name) %>% 
      filter(common_name %in% c(input$bird_1, 
                                input$bird_2, 
                                input$bird_3, 
                                input$bird_4)) %>%
      summarise(count = sum(total_sighting, na.rm = TRUE)) %>% 
      ggplot() +
      aes(x = common_name, 
          y = count, fill = common_name) +
      geom_col() 
    
  })
  
  output$sightings <- renderPlot({
    
    sighting %>%
      ggplot() +
      aes(y = common_name,
          x = log10(count), fill = sighting_id) +
      geom_col() +
      theme(legend.position = "none")
    # log10() as 1 or more birds are less than 10 and don't show on normal graph
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)