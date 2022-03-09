# example from http://shiny.rstudio.com/gallery/kmeans-example.html

library(shiny)
library(data.table)
library(flexdashboard)
library(shinydashboard)
library(shinythemes)
library(DT)

data_pap <- fread("data/paso_a_paso.csv", header=TRUE, stringsAsFactors=FALSE)

fluidPage(theme = shinytheme("united"),
          navbarPage("Avance Plan Paso a Paso",
            tabPanel("Cuarentenas", 
                     titlePanel("Datos Input"),

                     sidebarLayout(
                       
                       # Sidebar panel for inputs ----
                       sidebarPanel(
                       selectInput("cod_region",
                                   "Codigo región:",choices = sort(unique(data_pap$codigo_region)),
                                   selected = 13
                       )
                       ),
                       # Main panel for displaying outputs ----
                       mainPanel(
                         # Output
                         DT::dataTableOutput("cuarentena_opciones")
                       )
                     )
            ),
            tabPanel("Gráfico de cuarentenas", 
                     titlePanel("Detalle Ventas"),
                     
                     sidebarLayout(
                       
                       # Sidebar panel for inputs ----
                       sidebarPanel(
                         selectInput("cod_region2",
                                     "Codigo región:",choices = unique(data_pap$codigo_region),
                                     selected = 13
                         ),
                         selectInput("region_residencia",
                                     "Región residencia:",choices = unique(data_pap$region_residencia),
                                     selected = "Metropolitana"
                         ),
                         selectInput("codigo_comuna",
                                     "Codigo comuna:",choices = unique(data_pap$codigo_comuna),
                                     selected = 13114
                         ),
                         selectInput("comuna_residencia",
                                     "Comuna residencia:",choices = unique(data_pap$comuna_residencia),
                                     selected = "Las Condes"
                         ),
                         selectInput("zona",
                                     "Zona:",choices = unique(data_pap$zona),
                                     selected = "Total"
                         )
                       ),
                       # Main panel for displaying outputs ----
                       mainPanel(
                         # Output
                         plotOutput(outputId = "lineplot_pap",height = "500px")
                       )
                     )
            )
          )
)
        
