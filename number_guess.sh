#!/bin/bash

NUMBER_TO_GUESS=$(( (RANDOM % 1000) + 1))

GET_USERNAME(){
  echo "Enter your username: "
  read USERNAME
}

GET_USERNAME