library(shiny)
library(caret)
library(randomForest)

load("model.RData_filteredover2Msqm_ntree120")

errors<-read.table("error_analysis_table.csv",header=T, sep=",")
areas<-sort(errors$area)

test<-read.table("test_data.csv",header=T, sep=",")

set.seed(1234321)

shinyServer(
  function(input, output){
  observe({
      if (input$calculate == 0)
        return()
  isolate({

  in_area<-reactive({
    in_area<-input$area
  })
  in_size<-reactive({
    in_size<-input$size
  })
  in_halfrooms<-reactive({
    in_halfrooms<-input$halfrooms
  })
  in_fullrooms<-reactive({
    in_fullrooms<-input$fullrooms
  })
  pred<-reactive({

    mock<-data.frame(number_of_half_rooms=in_halfrooms(), number_of_whole_rooms=in_fullrooms(), area_name=in_area(), size=in_size())
    
    pred<-predict(mod_all, mock)
  })
  variance_in_neighborhood<-reactive({
    error<-errors[errors$area==input$area,"mean"]
    
    if(is.na(error)){
      variance_in_neighborhood<-"We have too few data in this area! please be warned, that prediction can be erratic!"
    } else {
      variance_in_neighborhood<-paste("The median error of prediction in Your neighborhood is: <b>",as.character(trunc(error*1000000))," </b>Hungarian Forints")
    }
    #output$latitude<-100.00 # !!!!!!
    #output$longitude<-100.00 # !!!!!!
    #print("predic")
    #print(prediction)
  })
  plo<-reactive({
    hist(test[test$area_name==in_area(),"price"], xlab="Price (Mill. HUF)", ylab="Number of advertisements in test sample", main=paste("Histogram of prices in",in_area()))
    abline(v=pred(), col="red", lwd=10, lty=2)
  })
    output$prediction<-renderUI({
      out<-paste0("<div>","Approximately ","<b>","<font color='red'>",as.character(trunc(pred()*1000000)),"</font>","</b>"," Hungarian Forints","</div>") 
      HTML( out ) })
    output$variance<-renderUI({HTML(variance_in_neighborhood())})
    output$hist<-renderPlot(plo())
  })
  })
  }
)