# example from http://shiny.rstudio.com/gallery/kmeans-example.html

library(shiny)
library(ggplot2)
library(dplyr)
library(data.table)
library(scales)
library(DT)



data_pap <- fread("data/paso_a_paso.csv", header=TRUE, stringsAsFactors=FALSE)

theme_clean <- function() {
  theme_minimal(base_family = "Barlow Semi Condensed") +
    theme(panel.grid.minor = element_blank(),
          plot.background = element_rect(fill = "white", color = NA),
          plot.title = element_text(face = "bold", size=24),
          axis.title = element_text(face = "bold", size=20),
          text = element_text(size=20),
          strip.text = element_text(face = "bold", size = rel(0.8), hjust = 0),
          strip.background = element_rect(fill = "grey80", color = NA),
          legend.title = element_text(face = "bold"))
}

# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {
  
  output$cuarentena_opciones = DT::renderDataTable({
    data_pap[codigo_region==input$cod_region,c(1:5)]
  })
  
  output$lineplot_pap <- renderPlot({
    
    aux <-  data_pap[codigo_region==as.integer(input$cod_region2)& 
                       region_residencia==as.character(input$region_residencia) &
                       codigo_comuna==as.integer(input$codigo_comuna) &
                       comuna_residencia==as.character(input$comuna_residencia) &
                       zona==as.character(input$zona),c(6:584)]
    
    x <- as.Date(colnames(data_pap[codigo_region==input$cod_region2,c(6:584)]))
    y <- t(aux[1,])[,1]
    
    df = data.frame(x,y)
    p <- ggplot(df, aes(x = x, group = 1))
    p <- p+scale_x_date(date_labels = "%Y %b %d")
    p <- p + geom_line(aes(y = y, colour = "Etapa"))
    

    # modifying colours and theme options
    p <- p + scale_colour_manual(values = c("blue", "red"))
    p <- p + labs(y = "Etapa",
                  x = " Fecha",
                  colour = "Curva")
    str <- paste('Variación de plan paso a paso por Fecha para comuna de',input$comuna_residencia,sep = " ")
    p <- p + ggtitle(str)
    p <- p + theme_clean()
    p <- p + theme(legend.position = c(0.85, 0.2))
    p
  })
  
})


