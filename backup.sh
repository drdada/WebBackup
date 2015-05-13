#!/bin/bash
# Script de sauvegarde FTP
# Télécharge un répertoire distant par FTP
# Dépendances: WASH, GET, GZIP, MYSQLDUMP

#Parametres
##Section FTP
USER_FTP=""
PASS_FTP=""
HOTE_FTP=""
DIR_DISTANT_FTP="" #sans le premier /
##Section SQL
SAVE_SQL=true #On active la sauvegarde SQL ? (True ou False)

USER_SQL=""
PASS_SQL=""
HOTE_SQL=$HOTE_FTP #Generalement l'hote sql est le meme que l'hote FTP
NAME_BDD_SQL=""

# Dossier de stockage des backups (chemin absolut)
BACKUP_DIR=""

#Parametres globaux
TEMP_DIR="/tmp" # Dossier temporaire
SQLDUMP_PATH="/usr/local/mysql/bin/mysqldump" # "which mysqldump" pour savoir quoi mettre

#Initialisation
NOW="$(date +"%Y-%m-%d")_$HOTE_FTP"
echo $NOW
DRM=$(date +%Y-%m-%d --date "14 days ago") #on gardera l'archive 14 jours
echo $DRM

cd $TEMP_DIR
mkdir $NOW
cd $NOW

#Téléchargement du dossier distant par FTP
wget -r -nH ftp://$USER_FTP:$PASS_FTP@$HOTE_FTP/$DIR_DISTANT_FTP -o log_ftp.txt || exit 1
# -r Pour le recursif
# -nH Pour ne pas avoir les dossiers préalable (nom d'hote etc)
# -o pour l'écriture des logs

if [ $SAVE_SQL ]
	then 
	$SQLDUMP_PATH --user=$USER_SQL --password=$PASS_SQL --host=$HOTE_SQL $NAME_BDD_SQL > $NAME_BDD_SQL.sql
fi

#On Compresse le tout (bz2 plus efficace que gzip)
cd ..
tar -cjf $NOW.tar.bz2 $NOW || exit 1

#On copie du dossier temp vers le dossier d'archivage
cp $NOW.tar.bz2 $BACKUP_DIR

#On supprime le contenu du dossier temporaire
rm -r $NOW
rm $NOW.tar.bz2

#On test si le fichier exite (si le backup est bien OK)
#Si oui, on peux supprimer le vieux backup
#Si non, on notifie et on exit 1
if [ -f $BACKUP_DIR/$NOW.tar.bz2 ]
then
	echo $BACKUP_DIR/$DRM*
	rm -f $BACKUP_DIR/$DRM*
else
	echo "ERREUR - Le fichier archive n'as pas pu etre cree" && exit 1
fi

exit 0
