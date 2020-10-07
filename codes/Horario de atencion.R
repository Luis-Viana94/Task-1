
#### Limpiar cosola y entorno
cat("\f")
rm(list=ls())

#### Directorio 
setwd("~/Dropbox/teaching/Taller de R/uniandes_2020_2/Task/task-1") # Eduard
# setwd("~/Dropbox/teaching/Taller de R/uniandes_2020_2/Task/task-1") # Otro usuario

#### Paquetes 
packages = c('tidyverse','data.table')
sapply(packages, require,character.only=T)

# Importar una base de datos y crear variable categorica
caracte_2020 = readRDS(file ='data/orignal/Junio 2020/Cabecera - Caracteristicas generales (Personas).rds') 
                
ocupados_2020 = readRDS(file ='data/orignal/Junio 2020/Cabecera - Ocupados.rds')  %>%
                mutate(ocupado = 1)
 
data = merge(caracte_2020,ocupados_2020,c('directorio','orden','secuencia_p'),all.x=T)
data = mutate(data, ocupado = ifelse(is.na(ocupado)==T,0,ocupado))

# Importar archivos desde una lista
files_2019 = list.files('data/orignal/Junio 2019/') %>% paste0('data/orignal/Junio 2019/',.)
df_2019 = lapply(files_2019,function(x) read.csv(file = x,header = T,sep = ';'))

files_2020 = list.files('data/orignal/Junio 2020/') %>% paste0('data/orignal/Junio 2020/',.)
df_2020 = lapply(files_2020,function(x) readRDS(file = x))

## Renombrando dentro de una lista
for (i in 1:length(df_2019)){
     colnames(df_2019[[i]]) = tolower(colnames(df_2019[[i]]))  
     colnames(df_2020[[i]]) = tolower(colnames(df_2020[[i]]))  
     colnames(df_2019[[i]])[1] = 'directorio'
}
colnames(df_2019[[3]])[1] = 'directorio'

## Generando variables categoricas y seleccionando variables de interes
v_c = c('secuencia_p','orden','directorio','p6020','p6040','p6050','fex_c_2011','mes','dpto','esc') # Caracteristicas generales
v_o = c('secuencia_p','orden','directorio','inglabo') # Ocupados
v_d = c('secuencia_p','orden','directorio') # Desocupados
v_i = c('secuencia_p','orden','directorio') # Inactivos
v_f = c('secuencia_p','orden','directorio') # F de trabajo

#### Cabeceras 
df_2020[[1]] = df_2020[[1]][,v_c] 
df_2020[[6]] = df_2020[[6]][,v_c] 

#### Desocupados
df_2020[[2]] = df_2020[[2]][v_d] %>% mutate(desocupado = 1)
df_2020[[7]] = df_2020[[7]][,v_d] %>% mutate(desocupado = 1)

#### Fuerza de trabajo
df_2020[[3]] = df_2020[[3]][v_f] %>% mutate(f_trabajo = 1)
df_2020[[8]] = df_2020[[8]][,v_f] %>% mutate(f_trabajo = 1)

#### Inactivos
df_2020[[4]] = df_2020[[4]][v_i] %>% mutate(inactivo = 1)
df_2020[[9]] = df_2020[[9]][v_i] %>% mutate(inactivo = 1)

#### Ocupados
df_2020[[5]] = df_2020[[5]][v_o] %>% mutate(ocupado = 1)
df_2020[[10]] = df_2020[[10]][,v_o] %>% mutate(ocupado = 1)

# Punto 1.2.
cabecera_2020 = merge(df_2020[[1]],df_2020[[2]],c('secuencia_p','orden','directorio'),all.x=T) %>%
                merge(.,df_2020[[3]],c('secuencia_p','orden','directorio'),all.x=T) %>%
                merge(.,df_2020[[4]],c('secuencia_p','orden','directorio'),all.x=T) %>%
                merge(.,df_2020[[5]],c('secuencia_p','orden','directorio'),all.x=T) %>%
                mutate(urbano = 1)

resto_2020 = merge(df_2020[[6]],df_2020[[7]],c('secuencia_p','orden','directorio'),all.x=T) %>%
             merge(.,df_2020[[8]],c('secuencia_p','orden','directorio'),all.x=T) %>%
             merge(.,df_2020[[9]],c('secuencia_p','orden','directorio'),all.x=T) %>%
             merge(.,df_2020[[10]],c('secuencia_p','orden','directorio'),all.x=T) %>%
             mutate(rural = 1)

# Punto 1.3 
 nacional_2020 = plyr::rbind.fill(cabecera_2020,resto_2020) %>% mutate(year = 2020)



