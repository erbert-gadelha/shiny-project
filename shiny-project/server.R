getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

tabAux <- NULL

# Define server logic required to draw a histogram
server <- function(input, output) {
    ################### INPUT ####################
      select_single <- eventReactive (input$go_single, {
          model_name <- input$model_single
          
          inicial <- input$date_single[1]
          final   <- input$date_single[2]
          
          df_model <- master_df %>% 
                filter(Model == model_name, between(Date, inicial, final))
          
          return(df_model)
      })
      
      
      select_couple <- eventReactive (input$go_couple, {
        model_names <- input$model_couple
        
        inicial <- input$date_single[1]
        final   <- input$date_single[2]
        
        df_model <- master_df %>% 
                      filter(Model %in% model_names, between(Date, inicial, final))
        
        return(df_model)
      })
    

      
      
      
    ################ OUTPUT SINGLE ################ 
      Info_Single <- eventReactive(input$go_single,{
        df <- select_single()
        
        Modelo <- input$model_single
        Media <- mean (df $ Count)
        Mediana <- median (df $ Count)
        Moda <- getmode (df$Count)
        DesvioPadrao <- sd (df$Count)
        Max <- max ( df$Count )
        Min <- min ( df$Count )
        
        df_tb <-  data.frame(Modelo, Media, Mediana, Moda, DesvioPadrao, Max, Min)
        df_tb <- as.data.frame(t(df_tb))
        
        return(df_tb)
      })
    
      output$info_single <- renderDT({
        Info_Single() %>%
          as.data.frame() %>% 
          DT::datatable(options=list(
            language=list(
              url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Portuguese-Brasil.json'
            )
          ),
          colnames = c('Legenda', 'Valores'),
          rownames = c("Modelo de TV", "Média prevista", "Mediana", "Moda", "Desvio Padrão", "Valor máx", "Valor min"))
      })
      
      output$line_single <- renderPlot({
        
        df <- select_single()

        aux <- df$Count %>% na.omit() %>% as.numeric()
        aux1 <- min(aux)
        aux2 <- max(aux)
        
        print(aux1)
        print(aux2)

        df$Date <- ymd(df$Date)
        a <- df %>%
          ggplot(aes(Date, Count, color=Model)) +
          geom_path() +
          geom_area( aes(x = Date, y = Count, fill = Model) )+
          ylab('Valores Diarios') +
          xlab('') +
          coord_cartesian(ylim = c(aux1, aux2)) +
          theme_bw() +
          scale_x_date(date_labels = "%Y-%m-%d")

        a
      })
      
      output$hist_single <- renderPlot({
        df <- select_single()
        
        hist( df$Count,
             xlab = "Maiores Ocorencias",
             ylab = "",
             main = "")
        
      })
      
      output$box_single <- renderPlot({
        
        df <- select_single()
        
        df %>%
          ggplot()+
          geom_boxplot(aes(x = Count, y = Model, fill = Model))+
          ggtitle("")+
          theme(legend.position = 'none') +
          scale_fill_brewer(palette = 'Dark2')
      })
      
    ################ OUTPUT SINGLE ################ 
      
      
    ################ OUTPUT COUPLE ################ 
      
      Info_Couple <- eventReactive(input$go_couple,{
        df <- select_couple()
        Modelo <- sort(unique(df$Model) )
        
        Media   <- numeric( length = length(Modelo) )
        Mediana <- numeric( length = length(Modelo) )
        Moda    <- numeric( length = length(Modelo) )
        DesvioPadrao <- numeric( length = length(Modelo) )
        Max     <- numeric( length = length(Modelo) )
        Min     <- numeric( length = length(Modelo) )
            
        for (i in 1:length(Modelo) ) {
          sub <- subset(df, Model == Modelo[i])
          
          Media[i] <- mean(sub$Count)
          Mediana[i] <- median(sub$Count)
          Moda[i] <- getmode(sub$Count)
          DesvioPadrao[i] <- sd(sub$Count)
          Max[i] <- max(sub$Count)
          Min[i] <- min(sub$Count)
        }
        
        
        df_tb <-  data.frame(Modelo, Media, Mediana, Moda, DesvioPadrao, Max, Min)
        #df_tb <-  data.frame(modelos)
        df_tb <- as.data.frame(t(df_tb))
        
        return(df_tb)
      })
      
      output$info_couple <- renderDT({
        
        aux = Info_Couple()
        
        #temp2 <- c("wasd", aux[1])
        #print(temp2)
        #print(aux[1,])
        
        temp = c( "", as.vector(unlist(aux[1,]) ))
        print(c(class(temp), temp) )
        
        aux %>%
          as.data.frame() %>% 
          DT::datatable(options=list(
            language=list(
              url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Portuguese-Brasil.json'
            )
          )
          , colnames = temp
          #rownames = c("Modelo de TV", "Média prevista", "Mediana", "Moda", "Desvio Padrão", "Valor máx", "Valor min")
          )
      })
      
      output$line_couple <- renderPlot({
        
        df <- select_couple()
        aux <- df$Count %>% na.omit() %>% as.numeric()
        
        df %>%
          ggplot(aes(y = Count, x = Date, group = Model, color = Model)) +
              geom_line() +
              coord_cartesian(xlim = c(input$date_couple[1], input$date_couple[2]), ylim = c(min(aux), max(aux)))+
              geom_area( aes(x = Date, y = Count, fill = Model) ) +
              theme(text = element_text(size=14),
                    axis.title = element_text(size=14),
                    axis.text = element_text(size=14)) + 
              ylab ("Valores diarios") +
              xlab("Espaco Temporal") 
          
        
      })
      
      output$bar_couple <- renderPlot({
        df <- select_couple()
        
        modelos <- unique(df$Model)
        medias = numeric ( length = length(modelos) )
        
        for (i in 1:length(modelos) ) {
          temp <- subset(df, Model == modelos[i])
          medias[i] = mean( temp$Count )
        }
        
        data.frame(modelos, medias ) %>%
          ggplot( aes (x=modelos, y=medias, fill = modelos)) +
          geom_bar(stat="identity") +
          coord_cartesian(ylim = c(0, max(medias)) ) +
          theme(text = element_text(size=14),
                axis.title = element_text(size=14),
                axis.text = element_text(size=14))
          
        
      })
      
      output$scatter <- renderPlot({
        
        df <- select_couple()
        
        aux <- df$Count %>% na.omit() %>% as.numeric()
        aux1 <- min(aux)
        aux2 <- max(aux)

        ggplot(data = data.frame(df$Date, df$Count), aes(x = df$Date, y = df$Count, group=df$Model, color = df$Model)) +
            coord_cartesian(xlim = c(input$date_couple[1], input$date_couple[2]), ylim = c(aux1, aux2)) +
            geom_point()  +
            theme(text = element_text(size=14),
                axis.title = element_text(size=14),
                axis.text = element_text(size=14)) + 
            ylab ("") +
            xlab("") 
        
        
      })
    

    ################ OUTPUT COUPLE ################ 
      
    
    }
