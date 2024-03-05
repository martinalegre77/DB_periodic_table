#!/bin/bash

# comprobar si tiene argumento
if [[ $1 ]]
then
  PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
  # comprobar si es un numero
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    CONSULTA=$($PSQL "SELECT atomic_number FROM elements 
    WHERE atomic_number=$1")
  else
    CONSULTA=$($PSQL "SELECT atomic_number FROM elements 
    WHERE symbol='$1' OR name='$1'")
  fi
  # si la consulta es vacia
  if [[ -z $CONSULTA ]]
  then
    echo "I could not find that element in the database."
  else
    DATOS=$($PSQL "SELECT ele.atomic_number, ele.name, ele.symbol, ty.type, pro.atomic_mass, pro.melting_point_celsius, pro.boiling_point_celsius 
    FROM elements AS ele INNER JOIN properties AS pro USING(atomic_number) 
    INNER JOIN types AS ty USING(type_id) 
    WHERE atomic_number=$CONSULTA")
    echo "$DATOS" | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELTING BAR BOILING
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
else
# si no tiene
echo "Please provide an element as an argument."
fi
