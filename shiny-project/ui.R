

header <- dashboardHeader(title = "Projeto 2")

sidebar <- dashboardSidebar(
    sidebarMenu(
      menuItem("Métricas", tabName = "m", icon = icon("chart-line")),
      menuItem('Comparar ', tabName = 'comp', icon = icon('chart-bar'))
    )
)

body <- dashboardBody(
    tabItems(
      
      ################ PRIMEIRA ABA ################ 
        tabItem(tabName = 'm',
                mainPanel(h3("Integrantes:",tags$br(),"[0] ebgr - Erbert Bernardino Gadelha Rocha", align = "start")),
                fluidRow(
                    box(
                      title = 'Selecione suas opções', width=12, solidHeader = TRUE, status='warning',
                      selectInput('model_single', 'Modelo de TV', stock_list, multiple=FALSE) ,
                      dateRangeInput("date_single", "Período de análise", end = '2016-08-30', start = '2014-01-01', min = '2014-01-01', max = '2016-08-31', format = "dd/mm/yy", startview = "decade", separator = " até ", language='pt-BR'),
                      actionButton('go_single', 'Submeter', icon = icon("chart-bar"))
                    )
                ),
                
                fluidRow(
                    box(title = "Informações sobre o modelo", width = 12, solidHeader = TRUE,
                        DTOutput('info_single')
                    )
                ),
                
                fluidRow(
                  box(title = "Gráfico de Linha", width = 12, solidHeader = TRUE,
                      plotOutput('line_single')
                  )
                ),
                
                fluidRow(
                  box(title = "BoxPlot", width = 12, solidHeader = TRUE,
                      plotOutput('box_single')
                  )
                ),
                
                fluidRow(
                  box(title = "Histograma", width = 12, solidHeader = TRUE,
                      plotOutput('hist_single')
                  )
                ),
                
        ),
      ################ PRIMEIRA ABA ################ 
      
        
        
        
        
      ################ SEGUNDA ABA ################ 
        tabItem(tabName = 'comp',
                fluidRow(
                    box(title = 'Selecione suas opções', width=12, solidHeader = TRUE, status='warning',
                        selectInput('model_couple', 'Ação', stock_list, multiple=TRUE),
                        dateRangeInput("date_couple", "Período de análise", end = '2016-08-30', start = '2014-01-01', min = '2014-01-01', max = '2016-08-31', format = "dd/mm/yy", startview = "decade", separator = " até ", language='pt-BR'),
                        actionButton('go_couple', 'Submeter', icon = icon("chart-bar"))
                    ),
                    
                    fluidRow(
                      box(title = "Informações sobre os modelos", width = 12, solidHeader = TRUE,
                          DTOutput('info_couple')
                      )
                    ),
                    
                    
                    fluidRow(
                      box(title = "Gráfico de Linhas", width = 12, solidHeader = TRUE,
                          plotOutput('line_couple')
                      )
                    ),
                    
                    fluidRow(
                      box(title = "Gráfico de Barras", width = 12, solidHeader = TRUE,
                          plotOutput('bar_couple')
                      )
                    ),
                    
                    fluidRow(
                      box(title = "Scatter Plot", width = 12, solidHeader = TRUE,
                          plotOutput('scatter')
                      )
                    ),
                    
                    
                ),            
        )
      ################ SEGUNDA ABA ################ 
    )
)

ui <- dashboardPage(
    skin = 'blue',
    header, sidebar, body)
