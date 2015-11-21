library(shiny)
library(shinyBS)

errors<-read.table("error_analysis_table.csv",header=T, sep=",")
areas<-sort(errors$area)
area_list<-as.list(areas)
#area_list<- vector(mode="list",length=length(areas))
#area_list<-c(1:length(areas))
names(area_list)<-areas

helptext<-"<p><b>Description:</b></p><p align='justify'>A calculator that tries to predict the optimal advertising value of Your flat in Budapest based on 45000 prior samples of flat advertisements, and a Random Forest model trained with <b>'CARET'</b> package in <b>R</b> language.</p><p><b>Usage:</b></p><ul><li>Choose a region of Budapest</li><li>Adjust size of Your flat</li><li>Give the number of rooms and half rooms</li><li>Push 'Calculate'</li></ul><p><b>Results:</b></p><p align='justify'>The histogram represents the distribution of prices in the area based on the test dataset, the <font color='red'>red vertical</font> represents the predictions's position in the price range.</p><p align='justify'>Since advertising prices are notoriously skwed by opportunism and misinformation, model fit is NOT perfect (RSQURED of 0.84). A very rough estimation of possible noise in the target area has been added as a warning. <b>USE AT YOUR OWN RISK!</b></p>"

shinyUI(
  fluidPage(
    titlePanel(
      tags$table(
        tags$td(
          div(
            img(src='https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Hungary_budapest_district_8.jpg/120px-Hungary_budapest_district_8.jpg', align = "right")
          )
        ),
        # Next time I learn CSS, I promise! :-P
        tags$td("__________________________"),
        tags$td(
          div(
            h2("Predicting advertising prices"), 
            h4("of properties in Budapest, Hungary"), align="center"
          ), align="left"
        ),
        # Next time I learn CSS, I promise! :-P
        tags$td("__________________________"),
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
       actionButton("calculate","Calculate"),
       #tags$a("Help",href="./help.html", align="right"),
       actionButton("help","Help"),
       bsModal("helpwindow","Basics","help", HTML(helptext))
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
