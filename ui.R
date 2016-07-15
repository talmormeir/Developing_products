#this is the UIscript: controls the layout and appearance of your app. 

library(shiny)
library(shinythemes)

fluidPage(
    
    h1(tags$b("Return On Investment - Telematics App"),align="center",style = "color:black;font-family:'Ariel';font-size: 36px; line-height: 32px;"),
    
    sidebarLayout(
        sidebarPanel(   #all the side panel options
            (tags$head(tags$style("body {background-color: silver; }",type='text/css', ".irs-grid-text { font-size: 14pt; }",".form-control{font-size: 18pt; }",
                                  ".irs-min{font-size: 14pt; }",".irs-max{font-size: 14pt; }",".irs-single {font-size: 14pt; }",
                                  ".irs-slider single{font-size: 4pt; }",".radio{font-size: 20pt; }"))),  #background color and changing size of bottons
            #h2("Inputs",align="center",style = "color:blue"),
            br(),br(),
            sliderInput("TotalDrivers", tags$p("Portfolio Size",style = "color:black;font-family:'Ariel';font-size: 30px; line-height: 32px;"), min = 0, max = 10000,pre = " drivers ",value = 1000),
            sliderInput("Telematics", tags$p("Telematics",style = "color:black;font-family:'Ariel';font-size: 30px; line-height: 32px;"), min = 0, max = 100,value = 10, pre = " % "),
            sliderInput("PolicyValue", tags$p("Policy Value",style = "color:black;font-family:'Ariel';font-size: 30px; line-height: 32px;"), min = 0, max = 2000,value = 1000, pre = " $ "),
            br(),br(),
            numericInput("Technology",tags$p("Technology",style = "color:black;font-family:'Ariel';font-size: 30px; line-height: 32px;"),50,min=0,max=10000,step=10),
            radioButtons("DefectionRate",tags$p("Policy Defection Rate [%]",style = "color:black;font-family:'Ariel';font-size: 30px; line-height: 32px;"),choices = c("2", "3", "4"),selected = "4"),
            br(),br(),
            sliderInput("Quotes", tags$p("Number of Quotes",style = "color:black;font-family:'Ariel';font-size: 30px; line-height: 32px;"), min = 0, max = 1000,pre = " Quotes ",value = 100),
            radioButtons("CaptureRate", tags$p("Capture Rate [%]",style = "color:black;font-family:'Ariel';font-size: 30px; line-height: 32px;"),choices = c("14","16","18"),selected = "16"),
            radioButtons("CaptureCost", tags$p("Capture Cost [$]",style = "color:black;font-family:'Ariel';font-size: 30px; line-height: 32px;"),choices = c("10","20","30"),selected = "10"),
            
            width=4),
        
        
        mainPanel(
            (tags$head(tags$style("body {background-color: gainsboro; }"))),
            br(),
            fluidRow(column(10,offset=8,
                            textOutput("ROI"),style = "color:darkgreen;font-family:'Ariel';font-size: 48px; line-height: 40px;")),
            br(),
            fluidRow(column(10,offset=8,
                            textOutput("GAINS"),style = "color:darkgreen;font-family:'Ariel';font-size: 48px; line-height: 40px;")),
            
            br(),
            fluidRow(column(10,offset=8,
                            textOutput("Gain_percent"),style = "color:darkgreen;font-family:'Ariel';font-size: 48px; line-height: 40px;")),
            
            
            fluidRow(column(10,offset=0,
                            textOutput("TotalPremium"),style = "color:black;font-family:'Ariel';font-size: 30px; line-height: 32px;")),
            br(),
            
            plotOutput("population",width="100%",height="250px"),
            br(),
            fluidRow(column(10,offset=0,
                            textOutput("TotalDiscount"),style = "color:black;font-family:'Ariel';font-size: 30px; line-height: 32px;")),
            br(),
            fluidRow(column(10,offset=0,
                            textOutput("InitialCost"),style = "color:black;font-family:'Ariel';font-size: 30px; line-height: 32px;")),
            br(),
            fluidRow(column(10,offset=0,
                            textOutput("TechnologyCost"),style = "color:black;font-family:'Ariel';font-size: 30px; line-height: 32px;")),
            
            br(),br(),br(),
            
            
            fluidRow(column(10,offset=0,
                            textOutput("DefectionRate"),style = "color:black;font-family:'Ariel';font-size: 30px; line-height: 32px;")),
            br(),
           
            fluidRow(column(10,offset=0,
                            textOutput("DefectionSavings"),style = "color:black;font-family:'Ariel';font-size: 30px; line-height: 32px;")),
            br(),br(),br(),br(),
            
            
            ###Capture calculations: 
            br(),br(),br(),br(),br(),br(),br(),
            fluidRow(column(10,offset=0,
                            textOutput("CaptureTotal"),style = "color:black;font-family:'Ariel';font-size: 30px; line-height: 32px;")), 
            br(),
            fluidRow(column(10,offset=0,
                            textOutput("CostTotal"),style = "color:black;font-family:'Ariel';font-size: 30px; line-height: 32px;")), 
            br(),
            fluidRow(column(10,offset=0,
                            textOutput("InitialCost_capture"),style = "color:black;font-family:'Ariel';font-size: 30px; line-height: 32px;")), 
            br(),
            fluidRow(column(10,offset=0,
                            textOutput("S_M"),style = "color:black;font-family:'Ariel';font-size: 30px; line-height: 32px;")), 
            
            fluidRow(column(10,offset=0,
                            textOutput("M_STotal"),style = "color:black;font-family:'Ariel';font-size: 30px; line-height: 32px;")), 
            fluidRow(column(10,offset=0,
                            textOutput("CapturePopulation"),style = "color:black;font-family:'Ariel';font-size: 30px; line-height: 32px;")), 
            fluidRow(column(10,offset=0,
                            textOutput("CTotal"),style = "color:black;font-family:'Ariel';font-size: 30px; line-height: 32px;")), 
            fluidRow(column(10,offset=0,
                            textOutput("CAverage"),style = "color:black;font-family:'Ariel';font-size: 30px; line-height: 32px;")), 
            br(),
            fluidRow(column(10,offset=0,
                            textOutput("CSummary"),style = "color:black;font-family:'Ariel';font-size: 30px; line-height: 32px;")), 
            
            br()
            ,width=8,style = "border: 1.8px solid silver;")
    )
)






