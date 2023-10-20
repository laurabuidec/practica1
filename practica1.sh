#!/bin/bash

echo "Sortir (q)"
echo "Llistar països (lp)"
echo "Seleccionar país (sc)"
echo "Seleccionar estat (se)"
echo "Llista els estats d'un país (le)"
echo "Llista les poblacions del país seleccionat (lcp)"
echo "Extreure les poblacions del país seleccionat (ecp)"
echo "Llistar les poblacions de l'estat seleccionat (lce)"
echo "Extreure les poblacions de l'estat seleccionat (ece)"
echo "Obtenir dades d'una ciutat de la Wikidata (gwd)"
echo "Obtenir estadístiques (est)"

while [ "$opcio" != "q" ] ; do
       	read -p "Escull una opció: " opcio
	case $opcio in

		  #1. Sortir
		  "q") echo "Sortint de l'aplicació"
		  exit 0
		  ;;
		   #2. Llista països
		   "lp") awk -F',' '!seen[$8]++ {print $7, $8}' cities.csv
		   ;;
		    #3. Seleccionar país
		    "sc") read -p "Selecciona un país: " sc
		    codi_pais=$(grep "$sc" cities.csv | awk -F ',' -v sc="$sc" '$8 == sc {print $7; exit}')
		    if [ -n "$codi_pais" ]; then
			    codi_pais="$codi_pais"
		    else
			    codi_pais="XX"
		    fi
		    echo "$codi_pais"
		    ;;
		    #4. Seleccionar un estat                                                                                
		    "se") read -p "Selecciona un estat: " se
		    if [ -z "$sc" ]; then
			    read -p "Selecciona un país: " sc
		    fi
		    if grep -q "$sc" cities.csv; then
			    if grep -q "$se" cities.csv; then
				    grep "$se" cities.csv | awk -F ',' -v sc="$sc" '$8 == sc {print $4; exit}'
			    else
				    se="XX"
				    echo "$se"
			    fi
		    fi
		    ;;
		     #5. Llistat dels estats del país seleccionat
		     "le")   if [ -z "$sc" ]; then
			     read -p "Selecciona un país: " sc

	
			     if grep -q "$sc" cities.csv; then
				     grep "$sc" cities.csv | awk -F ',' -v sc="$sc" '$8 == sc {print $4, $5}' | sort | uniq
		    	 	fi
		     fi
		     ;;
		     #6. Llistat de les poblacions del país selecionat
		     "lcp")   if [ -z "$sc" ]; then
		     read -p "Selecciona un país: " sc
		     fi
		    	 if grep -q "$sc" cities.csv; then
			     grep "$sc" cities.csv | awk -F ',' -v sc="$sc" '$8 == sc {print $2, $11}' | sort | uniq
		    	 fi
		     ;;
		     #7. Extreure les poblacions del país seleccionat
		     "ecp")   if [ -z "$sc" ]; then
		     read -p "Selecciona un país: " sc
		     fi
		     if grep -q "$sc" cities.csv; then
			     codi_pais=$(grep "$sc" cities.csv | awk -F ',' -v sc="$sc" '$8 == sc {print $7; exit}')
			     grep "$sc" cities.csv | awk -F ',' '{print $2, $11}' > "${codi_pais}.csv"
		     fi
		     ;;
		    #8. Llistar les poblacions de l'estat seleccionat
    		    "lce") if [ -z "$sc" ]; then
   
		    read -p "Selecciona un país: " sc
		    fi                                                                                                                                                                                         
		    if [ -z "$se" ]; then
			    read -p "Selecciona un estat: " se
		    fi
		    if grep -q "$sc" cities.csv; then
			    if grep -q "$se" cities.csv; then
				    grep "$se" cities.csv | awk -F ',' -v se="$se" '$5 == se {print $2, $11}' | sort | uniq
			    fi
		    fi
		    ;;
		    #9. Extreure les poblacions de l'estat seleccionat
		    "ece") if [ -z "$sc" ]; then
		    read -p "Selecciona un país: " sc
		    fi
		    if [ -z "$se" ]; then
			    read -p "Selecciona un estat: " se
		    fi
		    if grep -q "$sc" cities.csv; then
			    if grep -q "$se" cities.csv; then
				    codi_pais=$(grep "$sc" cities.csv | awk -F ',' -v sc="$sc" '$7 == sc {print $7; exit}')
				    codi_estat=$(grep "$se" cities.csv | awk -F ',' -v se="$se" '$4 == se {print $4; exit}')
				    awk -F ','-v se="$se" sc="$sc" '$4 == se && $7 == sc {print $2, $11}' cities.csv > "${codi_pais}_${codi_estat}.csv"
			    fi
		    fi
		    ;;	
    		    #10. Obtenir dades d'una ciutat de la Wikidata
		    #el URL proporcionat no funciona
    		    "gwd")
   
		    if [ -z "$sc" ]; then
			    read -p "Selecciona un país: " sc
		    fi
		    if [ -z "$se" ]; then
			    read -p "Selecciona un estat: " se
		    fi
		    read -p "Selecciona una població: " poblacio
		    wikidataId=$(awk -F ',' -v poblacio="$poblacio" '$2 == poblacio {print $11; exit}' cities.csv)
		    if [ -z "$wikidataId" ]; then
			    echo "No s'ha trobat cap entrada a Wikidata per a $poblacio."
		    else
			    arxiudata="${wikidataId}.json"
			    url="https://www.wikidata.org/wiki/Special:EntityData/$wikidataId.json"
			    curl -o "$arxiudata" "$url"
			    cat "$arxiudata"
		    fi
		    ;;
		    #11. Obtenir estadístiques
		    "est") awk -F',' '
		    BEGIN {
		    nord=0;
		    sud=0;
		    est=0;
		    oest=0;
		    no_ubic=0;
		    no_wd_id=0;

	
		    }
      		  {
                         nom=$2;
                        latitud=$9;
                        longitud=$10;
                        wikidataId=$11;
			
   			if (latitud > 0) {
                                nord++;
                        } else
                                if (latitud < 0) {
					sud++;
                                }
                        if (longitud > 0) {
                                est++;
                        } else
                                if (longitud < 0) {
                                        oest++;
					}
                           if (latitud == 0 && longitud == 0) {
                                no_ubic++;
	                        }
                        if (wikidataId == "") {
                                         no_wd_id++;
					 }
                        }

                        END {
                                print "Nord " nord " Sud " sud " Est " est " Oest " oest " No ubic " no_ubic " No WDId " no_wd_id;                                                                                                         }' cities.csv

        esac
done
