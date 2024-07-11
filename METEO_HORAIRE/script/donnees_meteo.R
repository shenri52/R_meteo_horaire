#################### Mise en forme des données météos

# Création d'un dataframe avec les données téléchargées
meteo <- list.files("data", full.names = TRUE) %>%
         map(read.delim,
             sep = ";",
             colClasses = c("NUM_POSTE" = "character", "AAAAMMJJHH" = "character")) %>%
         list_rbind() %>%
         as_tibble(.name_repair = make_clean_names) %>%
         # Suppression des espaces contenus dans le champs
         mutate(num_poste = str_trim(num_poste)) %>%
         # Conversion de la date
         mutate(aaaammjjhh = as.POSIXct(aaaammjjhh, format = "%Y%m%d%H"))

# Regroupement des station météo
station_meteo <- meteo %>%
                 summarise(.by= c(num_poste, lat, lon))

# Création d'un dataframe avec les relevés de températures (toutes stations)
meteo_temp <- meteo %>%
              filter(!(is.na(t)) | !is.na(tx) | !is.na(tn)) %>%
              select(num_poste, nom_usuel, aaaammjjhh, t, tn, tx) %>%
              rename.variable("tn", "Tmin") %>%
              rename.variable("tm", "Tmoy") %>%
              rename.variable("tx", "Tmax")%>%
              left_join(station_meteo,
                        by = c("num_poste" = "num_poste"),
                        copy = FALSE)

# Création d'un dataframe avec les relevés de précipitations (toutes stations)
meteo_pluie <- meteo %>%
               # Filtre des stations météos sans précipitations
               filter(!(is.na(rr1))) %>%
               select(num_poste, nom_usuel, aaaammjjhh, rr1) %>%
               rename.variable("rr1", "Pmm") %>%
               left_join(station_meteo,
                         by = c("num_poste" = "num_poste"),
                         copy = FALSE)

remove(meteo, station_meteo)

# Export des données
write.table(meteo_temp,
            file = paste("result/temperature_horaire.csv"),
            fileEncoding = "UTF-8",
            sep =";",
            row.names = FALSE)

write.table(meteo_pluie,
            file = paste("result/precipitation_horaire.csv"),
            fileEncoding = "UTF-8",
            sep =";",
            row.names = FALSE)

rm(list = ls())
gc()
