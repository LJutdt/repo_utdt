library(tidyverse)
library(readr)
library(janitor)
library(dplyr)

link <- "https://cdn.buenosaires.gob.ar/datosabiertos/datasets/sbase/subte-viajes-molinetes/molinetes-2022.zip"

#create a couple temp files

temp <- tempfile()

temp2 <- tempfile()

#download the zip folder from the internet save to 'temp' 
download.file(link,temp)
#unzip the contents in 'temp' and save unzipped content in 'temp2'
unzip(zipfile = temp, exdir = temp2)

ruta <- list.files(temp2, full.names = TRUE)

(datos <- read_csv2(ruta))

print(datos)
str(datos)
datos_a <- datos %>% 
  select('FECHA':'pax_TOTAL,"ï»¿""FECHA' ) %>% 
  mutate( Linea = LINEA...4 )%>% 
  filter(Linea=='LineaD') %>%
  mutate(PAX_TOTAL = `pax_TOTAL,"ï»¿""FECHA` )
head(datos_a)

datos_b <- datos %>%
  group_by(LINEA...4) %>%
  summarise(total_pax = sum(`pax_TOTAL,"ï»¿""FECHA`))%>%
  rename(Lineas=LINEA...4)%>%
  arrange(desc(total_pax))
head(datos_b)

datos_b2 <- pivot_wider(datos_b, 
                        names_from = Lineas , 
                        values_from = total_pax)

datos_c <- datos_a %>%
  group_by(ESTACION...6) %>%
  summarise(total_pax = sum(`pax_TOTAL,"ï»¿""FECHA`))%>% 
  arrange(desc(total_pax))%>% 
  rename(Estaciones_Linea_D=ESTACION...6)
head(datos_c) 


  
