# Script R : meteo_horaire

 Ce script permet de récupérer les relevés de température et de précipitations horaires de Météo France publiés sur data.gouv.fr                              
 Il traite les données des champs :                                    
   * T : température sous abri instantanée (en °C et 1/10)             
   * TN : température minimale sous abri dans l’heure (en °C et 1/10)  
   * TX : température maximale sous abri dans l’heure (en °C et 1/10)  
   * RR1: quantité de précipitation tombée en 1 heure (en mm et 1/10)  

## Descriptif du contenu

* Racine : emplacement du projet R --> "METEO_HORAIRE.Rproj"
* Un dossier "data" pour stocker les données téléchargées par le script
* Un dossier doc contenant le descriptif des champs
* Un dossier "result" pour le stockage du résultat
* Un dosssier script qui contient :
  * prog_meteo.R --> script principal
  * librairie.R --> script contenant les librairies utiles au programme
  * donnees_meteo.R --> script de téléchargement et de mise en forme des données
  * suppression_gitkeep.R --> script de suppression des .gitkeep

## Fonctionnement

1. Modifier la valeur affecté à la variable "sel_dep" avec le numéro du département souhaité
2. Lancer le script intitulé "prog_meteo" qui se trouve dans le dossier "script"

## Résultat

Le dossier "result" contiendra:
  * un fichier csv nommé "temperature_horaire" avec les relevés de températures
  * un fichier csv nommé "precipitation_horaire" avec les relevés de précipitations
  * un fichier csv nommé "station_meteo" avec la liste et les coordonnées des stations
