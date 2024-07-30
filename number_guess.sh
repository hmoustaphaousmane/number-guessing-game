#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

NUMBER_TO_GUESS=$(( (RANDOM % 1000) + 1))

echo "Enter your username: "
read USERNAME

# get user id
USER_ID=$($PSQL "select user_id from users where username = '$USERNAME';")

# if user id does not exist
if [[ -z $USER_ID ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."

  # insert new user
  INSERT_USER_RESULT=$($PSQL "insert into users (username) values ('$USERNAME');")

  # get new user id
  USER_ID=$($PSQL "select user_id from users where username = '$USERNAME';")
else
  # get database username
  DB_USERNAME=$($PSQL "select username from users where user_id = $USER_ID;")

  # get user's games info
  GAME=$($PSQL "select count(*), min(guesses) from games where user_id = $USER_ID;")
  echo "$GAME" | while IFS='|' read GAMES_PLAYED BEST_GAME
  do
    echo "Welcome back, $DB_USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi

echo "Guess the secret number between 1 and 1000:"
GUESSES=0

while true
do
  read GUESS
  ((GUESSES++))

  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  elif (( GUESS < NUMBER_TO_GUESS ))
  then
    echo "It's higher than that, guess again:"
  elif (( GUESS > NUMBER_TO_GUESS ))
  then
    echo "It's lower than that, guess again:"
  else
    echo "You guessed it in $GUESSES tries. The secret number was $NUMBER_TO_GUESS. Nice job!"
    INSERT_GAME_RESULT=$($PSQL "insert into games(guesses, user_id) values($GUESSES, $USER_ID);")
    break
  fi
done