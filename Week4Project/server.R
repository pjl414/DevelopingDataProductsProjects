#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(boot)
library(gridExtra)





# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Initial stuff
  # Set up stuff
  # New approach:
  # initialize a huge list of important information.
  pop1<-data.frame(plant_heights = round(rnorm(1000,12,3.7),2))
  PM<-mean(pop1$plant_heights)
  
  
  get_index_and_bars<-function(n){
    index_list<-list()
    ms<-numeric(2000)
    ymins<-numeric(2000)
    ymaxes<-numeric(2000)
    flag<-character(2000)
    for (j in 1:2000){
      samp_index<-sample(1:1000,n)
      ms[j]<-mean(pop1[samp_index,1])
      se<-sd(pop1[samp_index,1])/sqrt(n)
      ymins[j]<-ms[j]-qt(.975,df=n-1)*se
      ymaxes[j]<-ms[j]+qt(.975,df=n-1)*se
      if (ymins[j]>PM | ymaxes[j]<PM) {
        flag[j]<-"red"
      } else {flag[j]<-"blue"}
      index_list[[j]]<-samp_index
    }
    df_errorbars<-data.frame(m=ms,
                             x=1:2000,
                             ymin=ymins,
                             ymax=ymaxes,
                             flag=flag)
    
    return(list(index_list,df_errorbars))
  }
  
  
  
  truth<-ggplot()+geom_point(aes(x=1:1000,
                                 y=pop1$plant_heights),
                             col='green',
                             alpha=.4)+
    coord_cartesian(ylim=c(0,25))+
    geom_hline(yintercept=PM,col='green4',size=1.25)+
    labs(x="Plant ID Number",
         y="Plant Height (inches)",
         title="Population of Plant Heights One Month After Germination")
  
  plot_with_sample<-function(plot,record_num,
                             index_list, 
                             df_errorbars){
    
    plot +
      geom_point(aes(x=index_list[[record_num]],
                     y=pop1[index_list[[record_num]],1]),
                 col='blue',alpha=.6)+
      geom_hline(yintercept=df_errorbars$m[record_num],
                 col='blue',size=1,lty=2)+
      geom_hline(yintercept=PM,col='green4',size=1.25,
                 alpha=.75)+
      labs(x="Plant ID Number",
           y="Plant Height (inches)",
           title="Population of Plant Heights One Month\nAfter Germination")+
      coord_cartesian(ylim=c(0,25))
  }
  
  #create CI tracker
  ci_record<-ggplot()+geom_hline(yintercept=PM,col='green4',size=1.25,
                                 alpha=.75)+
    labs(y="",
         title="Record of Confidence Intervals")+
    coord_cartesian(xlim=c(0,10),
                    ylim=c(0,25))+
    geom_hline(yintercept=0)+geom_vline(xintercept=0)
  
  
  add_ci<-function(record_num,df_errorbars,show_eb){
    if (show_eb){
      ci_record+ geom_errorbar(data=df_errorbars[1:record_num,],
                               aes(x =x, 
                                   ymin = ymin,
                                   ymax = ymax,
                                   col=flag),
                               size=1,
                               width=.1+.2*(record_num/(record_num+10)))+
        geom_point(data=df_errorbars[1:record_num,],
                   aes(x = x,
                       y = m,
                       col=flag))+
        scale_color_manual("",values=c("blue","red"),guide=F)+
        coord_cartesian(xlim=c(0,max(10,record_num+3)),
                        ylim=c(0,25))
    } else {
      ci_record+
        geom_point(data=df_errorbars[1:record_num,],
                   aes(x = x,
                       y = m,
                       col=flag))+
        scale_color_manual("",values=c("blue","red"),guide=F)+
        coord_cartesian(xlim=c(0,max(10,record_num+3)),
                        ylim=c(0,25))
    }
    
  }
  
    output$sampling<-renderPlot({
      plot_samples$data
    })
    
    output$conf_int<-renderPlot({
        plot_cis$data+
          labs(x="",
               y="")+
        geom_hline(yintercept=rlist$data[[2]][record_num$data,'m'],
                   col='blue',
                   lty=2, size=.7)
    })
    
    output$success_rate<-renderText({
      sr<-100*(sum(rlist$data[[2]]$flag[1:record_num$data]=='blue')/record_num$data)
      paste("Success Rate: ",sr,"%")
      })
    

    record_num<-reactiveValues(data=0)
    rlist<-reactiveValues(data=get_index_and_bars(5))
    plot_samples<-reactiveValues(data= truth)
    plot_cis<-reactiveValues(data= ci_record)
    
    observeEvent(input$sample_size,{
      rlist$data= get_index_and_bars(input$sample_size)
      plot_samples$data<-truth
      plot_cis$data<-ci_record
      record_num$data<-0
    })

    observeEvent(input$get_samp,{
      record_num$data<-record_num$data+1
      plot_samples$data<-plot_with_sample(truth,record_num$data,
                                          rlist$data[[1]],
                                          rlist$data[[2]])
      
      plot_cis$data<-add_ci(record_num$data,
                            rlist$data[[2]],input$show_interval)
      
    })
    
    observeEvent(input$show_interval,{
      if (record_num$data==0) {
        plot_cis$data<-ci_record
      } else {
        plot_cis$data<-add_ci(record_num$data,
                            rlist$data[[2]],input$show_interval)}
    })
    
    observeEvent(input$get_50,{
      record_num$data<-record_num$data+50
      plot_samples$data<-plot_with_sample(truth,record_num$data,
                                          rlist$data[[1]],
                                          rlist$data[[2]])
      
      plot_cis$data<-add_ci(record_num$data,
                            rlist$data[[2]],input$show_interval)
      
    })
    
    observeEvent(input$reset, {
      plot_samples$data<-truth
      plot_cis$data<-ci_record
      record_num$data<-0
    })
  
    
    #workflow: 
    # sample_index as reactive value that updates
    # success_rate as reactive value that updates
    # record_num as reactive value that updates
    # get sample: updates sample_index, show the sample and sample mean
    # in pane 1, adds mean and CI in pain 2, update 
    # success_rate.
    # render the current success rate of the CI
    # get 100 sample: repeats process above 100 times.
})

