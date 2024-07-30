#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

NUMBER_TO_GUESS=$(( (RANDOM % 1000) + 1))

echo "Enter your username: "
read USERNAME
