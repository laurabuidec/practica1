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
