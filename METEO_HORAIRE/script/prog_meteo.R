######################################################################### 
# Ce script permet de récupérer les relevés de température et de        #
# précipitations horaires de Météo France.                              #
# Il traite les données des champs :                                    #
#   - T : température sous abri instantanée (en °C et 1/10)             #
#   - TN : température minimale sous abri dans l’heure (en °C et 1/10)  #
#   - TX : température maximale sous abri dans l’heure (en °C et 1/10)  #
#   - RR1: quantité de précipitation tombée en 1 heure (en mm et 1/10)  #
#########################################################################
# Fonctionnement :                                                      #
#     1. Téléchargement des données sur data.gouv.fr                    #
#     2. Mise en forme des données méteos publiées par météo france     #
#     Les données sont téléchargées dans le dossier 'data'              #
#                                                                       #
# Le descriptif du contenu des bases chargées est disponible dans       #
# le dossier 'doc'.                                                     #
#                                                                       #
# Résultat :                                                            #
#     - un tableau nommé 'temperature_horaire' avec les relevés de      #
# température                                                           #
#     - un tableau nommé 'precipitation_horaire' avec les relevés des   #
# précipitations                                                        #
#     - un tableau nommé 'station_meteo' la liste et les coordonnées    # 
# des stations                                                          #
#########################################################################

#################### chargement des librairies

source("script/librairie.R")

#################### Suppression des fichiers gitkeep

source("script/suppression_gitkeep.R")

#################### Téléchargement et mise en forme des données météos

source("script/chargement_donnees_meteo.R")

#################### Téléchargement et mise en forme des données météos

source("script/donnees_meteo.R")
