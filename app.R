#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(leaflet)
library(rgdal)

# https://www.naturalearthdata.com/downloads/50m-cultural-vectors/
mp_world_cntr = readOGR(dsn = "ne_50m_admin_0_countries",
                        layer = "ne_50m_admin_0_countries",
                        encoding = "UTF-8")
# the data got from https://en.wikipedia.org/wiki/Template:Visa_requirements
# consequently it was transformed
# can be accessed here: https://1drv.ms/u/s!AsB08ZBv5_PG-yydMsqQs_ks_FXU
visa_dt = readRDS("visa_free_countries_mutual.Rds")
visa_dt = dplyr::arrange(visa_dt,nms_rep)

# function to subset mutually visa-free countries
create_2dt <- function(ctz1,ctz2) {
  if (ctz1==ctz2) {
    dt_name = visa_dt %>% filter(nms_rep==ctz1|nms_rep==ctz2) %>% 
      group_by(nms_rep,country) %>% count() %>% dplyr::select(-n) %>% 
      group_by(country) %>% count() %>% filter(n>0)
    dt_vec = dt_name$country
    dt2cntr = subset(mp_world_cntr,GEOUNIT %in% dt_vec)
  } else {
    dt_name = visa_dt %>% filter(nms_rep==ctz1|nms_rep==ctz2) %>% 
      group_by(nms_rep,country) %>% count() %>% dplyr::select(-n) %>% 
      group_by(country) %>% count() %>% filter(n>1)
    dt_vec = dt_name$country
    dt2cntr = subset(mp_world_cntr,GEOUNIT %in% dt_vec)
    
  }
}

# function to print names of mutually visa-free countries
list_cntr <- function(ctz1,ctz2) {
  if (ctz1==ctz2) {
    x = visa_dt %>% filter(nms_rep==ctz1|nms_rep==ctz2) %>% 
      group_by(nms_rep,country) %>% count() %>% dplyr::select(-n) %>% 
      group_by(country) %>% count() %>% filter(n>0)
    x = x$country %>% as.character() %>% sort(x,decreasing = F) %>% 
      paste(collapse = ", ")
  } else{
    x = visa_dt %>% filter(nms_rep==ctz1|nms_rep==ctz2) %>% 
      group_by(nms_rep,country) %>% count() %>% dplyr::select(-n) %>% 
      group_by(country) %>% count() %>% filter(n>1)
    x = x$country %>% as.character() %>% sort(x,decreasing = F) %>% 
      paste(collapse = ", ")
  }
  }

# Define UI for application that draws a leaflet map
ui <- fluidPage(
   
   # Application title
   titlePanel("Travelling Abroad without Visa with Foreigners"),
   # application explanation
   h4("This web application maps countries that do not require any kind of travel visa for citizens of two different countries."),
   
   # Sidebar with a slider input for the selection of citizenships 
   sidebarLayout(
      sidebarPanel(
        # citizenship 1
         selectInput(inputId="cit1",
                     label="Citizenship 1:",
                     choices = unique(visa_dt$nms_rep),
                     selectize = F,multiple = F,
                     width = "auto"),
         # citizenship 2
         selectInput(inputId="cit2",
                     label="Citizenship 2:",
                     choices = unique(visa_dt$nms_rep),
                     selectize = F,multiple = F,
                     width = "auto"),
         # click button to map the options for selected countries
         actionButton(inputId = "buttClick",label = "Create Map",
                      width = "auto"),
         # random stuff
         hr(),
         isolate(p("Data: 'Template: Visa requirements. (last edited 16 April 2018). In Wikipedia. Retrieved 4 April 2018, from https://en.wikipedia.org/wiki/Template:Visa_requirements'")),
         hr(),
         isolate(strong("Disclaimer:")),
         br(),
         isolate(p("Tuvalu is not mapped although might be present among the visa-free countries.")),
         isolate(p("This data is shared to inform in general. When making the decision to travel, please, consult relevant authorities.")),
         hr(),
         strong("Author:"),
         a(href="https://github.com/bobfromspace","Nina Ilchenko")
      ),
      
      # Show a map and short description
      mainPanel(
         leafletOutput("leafltMap"),
         p("Countries highlighed in blue are mutually visa-free."),
         textOutput("listCntr")
      )
   )
)

# Define server logic required to draw a map
server <- function(input, output) {
    # make map appeared after pressing the button
    dt2mp = eventReactive(input$buttClick,{
    create_2dt(input$cit1,input$cit2)
      })
    # draw the map
    output$leafltMap = renderLeaflet({
    ml = dt2mp()
    leaflet() %>% addTiles() %>% 
      addPolygons(data = ml,weight = 2,
                  smoothFactor = 0.5,label = ml$GEOUNIT)
   })
    
    # change country names after pressing the button (doesn't work properly)
    lCntr = eventReactive(input$buttClick,{
      list_cntr(input$cit1,input$cit2)
    })
    # print names of the citizenships and countries
    output$listCntr = renderText({
      ml = lCntr()
      sprintf("These countries are visa-free for %s and %s: %s.",
              input$cit1,input$cit2,ml)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

