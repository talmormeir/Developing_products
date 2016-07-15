library(data.table)
library(ggplot2)
library(shiny)
library(rsconnect)


shinyServer(function(input, output) {
    
    output$TotalPremium <- renderText({paste("    Total Expected Premiums:    ","   $",prettyNum(input$TotalDrivers*input$PolicyValue,big.mark=","))})#total Premium calculations
    
    
    output$TechnologyCost<-renderText({paste("    Technology Cost:    ","  -$",
                                             prettyNum(input$Technology*35,big.mark=","))})  #the cost of Dongles
    
    output$DefectionRate<-renderText({paste("    Defection Rate:    ",
                                            floor((((10/100)*(input$TotalDrivers-(input$TotalDrivers*input$Telematics/100)))+
                                                       ((as.numeric(input$DefectionRate)/100)*(input$TotalDrivers*input$Telematics/100)))),"    Drivers/year")}) #Drivers lost per year
    
   
    output$DefectionSavings<-renderText({paste("    Savings due to telematics' reduced defection rates:    ","  +$",
                                               prettyNum(round((((10/100)*(input$TotalDrivers))*2*input$PolicyValue)- #2 is because it costs 2 policies to replace 1 policy
                                                                   ((((10/100)*(input$TotalDrivers-(input$TotalDrivers*input$Telematics/100)))+
                                                                         ((as.numeric(input$DefectionRate)/100)*(input$TotalDrivers*input$Telematics/100)))*2*input$PolicyValue),digits=2),big.mark=","))}) #$ Savings due to alternative defection rate
    
    
    
    
    output$population<-reactivePlot(function(){
        disscount<-c(20,15,10,5,0)
        pop<-c(0.0351,0.228,0.251,0.139,0.3469)
        DT<-cbind(disscount,pop)
        DT<-as.data.table(DT)
        for (i in 1:nrow(DT)){
            DT$popcount[i]<-(DT$pop[i])*((input$Telematics/100)*input$TotalDrivers)}  
        for (i in 1:nrow(DT)){
            DT$TotalDiscount[i]<-DT$popcount[i]*((DT$disscount[i]/100)*input$PolicyValue)}
        
        output$TotalDiscount<-renderText({
            paste("    Total discount given:    -$",prettyNum(round(sum(DT$TotalDiscount),digits=1),big.mark=","))})#Total discount given per portfolio
        
        p<-ggplot(DT, aes(x = disscount,y=popcount)) + geom_bar(stat="identity",fill="#0066CC",colour="black")+theme_bw()+
            
            theme(axis.title = element_text(face="bold", size=14),axis.text= element_text(face="bold", size=14))+ 
            theme(plot.title = element_text(family = "Ariel", color="black", face="bold", size=14))+
            scale_fill_brewer(palette="Set1")+
            ggtitle("Distribution of Discounts")+labs(x="% Discount",  y = "population count")
        print(p)},width=500)
    
    #capture Rate analysis: 
    t<-reactive({round(
        (as.numeric(input$CaptureRate)/100)*as.numeric(input$Quotes)*as.numeric(input$PolicyValue),digits=0)}) #capture gain due to telematics, we are charging 150 to sign in
  
    s<-reactive({round((as.numeric(input$Quotes)*as.numeric(input$CaptureRate)/100)*as.numeric(input$CaptureCost),digits=0)}) #cost due to telematic capture
    
    w<-reactive({round((14/100)*as.numeric(input$Quotes)*as.numeric(input$PolicyValue),digits=0)})  #average capture gain  
    
    x<-reactive({round((14/100)*as.numeric(input$Quotes)*as.numeric(input$CaptureCost),digits=0)}) #cost for average capture
    v<-reactive({as.numeric(input$Quotes)*as.numeric(input$CaptureCost)}) #cost to quote in income requests
   
    
    X<-reactive({  #disscounts
        diss<-c(25,18,12,7,0)
        popu<-c(0.0351,0.228,0.251,0.139,0.3469) #this is a tentative break down to population in each risk group based on Jared's pricing analysis
        DX<-cbind(diss,popu)
        DX<-as.data.table(DX)
        
        for (i in 1:nrow(DX)){
            DX$popcount[i]<-(DX$popu[i])*(as.numeric(input$CaptureRate)/100)*as.numeric(input$Quotes)} 
        for (i in 1:nrow(DX)){
            DX$TotalDiscount[i]<-DX$popcount[i]*((DX$disscount[i]/100)*input$PolicyValue)}
        round(sum(DX$TotalDiscount),digits=0)})
    
    
    Y<-reactive({prettyNum(as.numeric(round(t()-v()-X()-w(),digits=0)))})   #the difference between 14% average capture to 18% telematics capture
    
    output$CSummary<-renderText({if(input$Telematics>0&input$Quotes>0){paste("    Capture Summary:    $",
                                                                             prettyNum(Y(),big.mark=","))}})
    
    
    # to caluclate the FINAL ROI value:
    
    d<-reactive({abs((((10/100)*(input$TotalDrivers))*2*input$PolicyValue)- #2 is because it costs 2 policies to replace 1 policy
                         ((((10/100)*(input$TotalDrivers-(input$TotalDrivers*input$Telematics/100)))+
                               ((as.numeric(input$DefectionRate)/100)*(input$TotalDrivers*input$Telematics/100)))*2*input$PolicyValue))}) #defection rate
    
    
    e<-reactive({input$Technology*40})  #technology
    f<-reactive({  #disscounts
        diss<-c(20,15,10,5,0)
        popu<-c(0.0351,0.228,0.251,0.139,0.3469) #this is a tentative break down to population in each risk group based on Jared's pricing analysis
        DF<-cbind(diss,popu)
        DF<-as.data.table(DF)
        
        for (i in 1:nrow(DF)){
            DF$popcount[i]<-(DF$popu[i])*((input$Telematics/100)*input$TotalDrivers)}  
        for (i in 1:nrow(DF)){
            DF$TotalDiscount[i]<-DF$popcount[i]*((DF$diss[i]/100)*input$PolicyValue)}
        round(sum(DF$TotalDiscount),digits=1)})
    h<-reactive({input$TotalDrivers*input$PolicyValue})
    
    y<-reactive({t()-v()-X()-w()})   #capture rate
    
    
    output$GAINS<-renderText({paste("   Gain= $",prettyNum(round(as.numeric(y()+d()-e()-f()),digits=0),big.mark=","))})  #includes capture rates
    output$ROI<-renderText({paste("   ROI=",prettyNum(round(as.numeric((y()+d()-e()-f())/(e()+f())),digits=3),big.mark=","))})
    output$Gain_percent<- renderText({paste("[",round(as.numeric((y()+d()-e()-f())/(h()+y())),digits=3)*100,"%] added value")})
    
    
})

