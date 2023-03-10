#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# check if no argument passed
if [[ -z $1 ]]
then
  # output message and exit
  echo "Please provide an element as an argument."
else
  # default where condition queries using name/symbol using a string argument
  WHERE_CONDITION="name = '$1' or symbol = '$1'"
  # if argument is a number instead
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # then query by atomic number
    WHERE_CONDITION="atomic_number = $1"
  fi
  
  # query db to see if argument matches any row for one of 3 columns
  RESULT=$($PSQL "SELECT e.atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements AS e JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE $WHERE_CONDITION LIMIT 1;")
  
  # if that element doesn't exist in the db
  if [[ -z $RESULT ]]
  then
    # output message and exit
    echo "I could not find that element in the database."
  else
    # split result into bash variables
    IFS="|" read NUMBER NAME SYMBOL MASS MELTING BOILING TYPE <<< $RESULT
    # format and output result
    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  fi
fi
