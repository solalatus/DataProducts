library(shiny)

errors<-read.table("error_analysis_table.csv",header=T, sep=",")
areas<-sort(errors$area)
area_list<-as.list(areas)
#area_list<- vector(mode="list",length=length(areas))
#area_list<-c(1:length(areas))
names(area_list)<-areas

shinyUI(
  fluidPage(
    titlePanel(
      tags$table(
        tags$td(
          div(
            img(src='https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Hungary_budapest_district_8.jpg/120px-Hungary_budapest_district_8.jpg', align = "right")
          )
        ),
        tags$td("________________________"),
        tags$td(
          div(
            h2("Predicting advertising prices"), 
            h4("of properties in Budapest, Hungary"), align="center"
          ), align="left"
        ),
        tags$td("________________________"),
        tags$td(
          div(
            img(src='https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Hungary_budapest_district_8.jpg/120px-Hungary_budapest_district_8.jpg', align = "right")
          )
        ),
        
        align="right"),
      windowTitle="Predicting Budapest flat advertisement prices"),
    
    
    sidebarPanel(
       h3("Controls"),
       selectInput("area", choices=area_list,label="Area of Budapest"),# area
       sliderInput("size",min=10, max=200, value= 50, label="Size of the flat"),# size
       helpText("In square maters"),
       numericInput("fullrooms",value=1, label="Numer of complete rooms"),# full rooms
       helpText("'Complete' means over 15 square meters."),
       numericInput("halfrooms",value=0, label="Number of 'half rooms'"),# halfrooms
       helpText("A 'half' room is defined as one under 15 square meters"),
       actionButton("calculate","Calculate")
      # maybe a reset button?
      ),
    mainPanel(
      h3("Suggested advertising price for the flat:"),
      uiOutput("prediction"),
      h3("Possible variance in our prediction:"),
      uiOutput("variance"),
      plotOutput("hist")
      )    
     )
  )
