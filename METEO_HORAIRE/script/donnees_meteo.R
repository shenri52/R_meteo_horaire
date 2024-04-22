#################### Téléchargement et mise en forme des données météos

# Compter le nombre de fichiers météo france disponible sur data.gouv.fr
n_files <- GET("https://www.data.gouv.fr/api/2/datasets/6569b4473bedf2e7abad3b72/") %>%
           content() %>%
           pluck("resources", "total")

# Lire les informations des fichiers disponible
files_available <- GET(paste("https://www.data.gouv.fr/api/2/datasets/6569b4473bedf2e7abad3b72/resources/?page=1&page_size=",
                            paste(n_files, "&type=main", sep =""),
                            sep = "")) %>% 
                   content(as = "text", encoding = "UTF-8") %>%
                   fromJSON(flatten = TRUE) %>%
                   pluck("data") %>%
                   as_tibble(.name_repair = make_clean_names) %>%
                   # Ajout du code département et du type d'observations
                   mutate(dep = str_sub(title, 17,18)) %>%
                   mutate(annee_fin = str_sub(title, nchar(title)-3,nchar(title))) %>%
                   # Filtre département et du type d'observation (RR = RR-T-Vent)
                   filter(dep == sel_dep,
                          annee_fin == as.character(year(Sys.Date())))

# Téléchargement des fichiers
for (i in 1:nrow(files_available))
    {
      
      # Initialisation d'une variable avec l'URL de téléchargement
      url <- as.character(files_available[i, 7]) 
      
      # Téléchargement du fichier
      GET(url,
          write_disk(paste("data/",
                     paste(files_available[i, 2], files_available[i, 6], sep = "."),
                     sep = ""),
                     overwrite = TRUE))
    }

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

# Création d'un dataframe avec les relevés de températures (toutes stations)
meteo_temp <- meteo %>%
              filter(!(is.na(t)) | !is.na(tx) | !is.na(tn)) %>%
              select(num_poste, nom_usuel, aaaammjjhh, t, tn, tx)

# Création d'un dataframe avec les relevés de précipitations (toutes stations)
meteo_pluie <- meteo %>%
               # Filtre des stations météos sans précipitations
               filter(!(is.na(rr1))) %>%
               select(num_poste, nom_usuel, aaaammjjhh, rr1)

# Regroupement des station météo
station_meteo <- meteo %>%
                 summarise(.by= c(nom_usuel, num_poste, lat, lon))
            
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

write.table(station_meteo,
            file = paste("result/station_meteo.csv"),
            fileEncoding = "UTF-8",
            sep =";",
            row.names = FALSE)
