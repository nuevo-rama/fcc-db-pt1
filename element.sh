#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ ! $1 ]]; then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]; then
    ATOMIC_NUMBER=$1
    QUERY=$($PSQL "SELECT elements.atomic_number, elements.symbol, elements.name, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements JOIN properties ON elements.atomic_number = properties.atomic_number JOIN types ON properties.type_id = types.type_id WHERE properties.atomic_number = $ATOMIC_NUMBER;")
  elif [[ $1 =~ ^[a-zA-Z]{1,2}$ ]]; then
    SYMBOL=$1
    QUERY=$($PSQL "SELECT elements.atomic_number, elements.symbol, elements.name, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements JOIN properties ON elements.atomic_number = properties.atomic_number JOIN types ON properties.type_id = types.type_id WHERE elements.symbol = '$SYMBOL';")
  else
    NAME=$1
    QUERY=$($PSQL "SELECT elements.atomic_number, elements.symbol, elements.name, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements JOIN properties ON elements.atomic_number = properties.atomic_number JOIN types ON properties.type_id = types.type_id WHERE elements.name = '$NAME';")
  fi
  if [[ -z $QUERY ]]; then
    echo "I could not find that element in the database."
  else
  IFS="|" read -r ATOMIC_NUMBER SYMBOL NAME TYPE MASS MELT BOIL <<< "$QUERY"
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  fi
fi
