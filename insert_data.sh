#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
  do
    # THIS IS THE $WINNER is not THE HEADER.
    if [[ $WINNER != 'winner' ]]
      then
        TEST1="$($PSQL "SELECT name FROM teams WHERE name='$WINNER'" )"
        TEST2="$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'" )"

        if [[ $TEST1 == "" ]]
          then
            echo -e "\nRecord Does Not Exist, Inserting Country $WINNER"
            $PSQL "INSERT INTO teams(name) VALUES('$WINNER')"
          elif [[ $TEST2 == "" ]]
            then
               echo -e "\nRecord Does Not Exist, Inserting Country $OPPONENT"
               $PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')"
          else
            echo -e "\nCountry already exists in table, SKIPPED\n"
        fi

      fi
  done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
  do
          if [[ $WINNER != 'winner' ]]
        then
          WIN_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'" )"
          OPP_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'" )"
          echo -e "\n Inserting Line\n"
          $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WIN_ID, $OPP_ID, $WINNER_GOALS, $OPPONENT_GOALS)"
        else
          echo -e "Header Line\n"
        
      fi
  done
 