#!/usr/bin/env bash

if [[ $# -ne 1 ]];
then
	echo "On veut exactement un argument au script."
	exit
fi

URLS=$1

if [ ! -f $URLS ]
then
	echo "On attend un fichier, pas un dossier"
	exit
fi

CIBLE="robots?"
lineno=1
while read -r URL
do
  lang=$(basename $URLS .txt)
	response=$(curl -s -L -w "%{http_code}" -o "./aspirations/${lang}-${lineno}.html" $URL)
  encoding=$(curl -s -I -L -w "%{content_type}" -o /dev/null $URL | grep -P -o "charset=\S+" | cut -d"=" -f2 | tail -n 1 | tr "[:lower:]" "[:upper:]")

  COUNT=0
  TEXTFILE="NA"
  if [ $response -eq 200 ]
  then
    if [ ! $encoding == "UTF-8" ]  
    then
      iconv -f "$encoding" -t "UTF-8" -o "/tmp/recode_${lineno}.html" "./aspirations/${lang}-${lineno}.html"
      mv "/tmp/recode_${lineno}.html" "./aspirations/${lang}-${lineno}.html"
    fi
    # création du dump text
    lynx -assume_charset UTF-8 -dump -nolist ./aspirations/${lang}-${lineno}.html > ./dumps-text/${lang}-${lineno}.txt
    TEXTFILE="../dumps-text/${lang}-${lineno}.txt"
    COUNT=$(grep -P -i -o "$CIBLE" ./dumps-text/${lang}-${lineno}.txt | wc -l)
    grep -i -C 3 "$CIBLE"  ./dumps-text/${lang}-${lineno}.txt > ./contextes/${lang}-${lineno}.txt  
  fi

	echo -e "$lineno\t$URL\t$response\t$encoding\t$TEXTFILE\t$COUNT" 
	lineno=$(expr $lineno + 1)

done < "$URLS"
