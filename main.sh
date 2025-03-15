#!/bin/bash

##--------------------------------------------------------------------------------------------------------------------------------------------
# Menu Functions --
##--------------------------------------------------------------------------------------------------------------------------------------------

#displayRules
displayRules(){
  # display a prompt for the rules
  clear
  echo ""
  echo "==================================="
  echo "             Rules:                 "
  echo "==================================="
  echo "1.) There is a hidden word that you must figure out."
  echo "2.) You have 7 guesses to figure out the word for a multiplier"
  echo "3.) Each incorrect guess ruins your score multiplier!"
  echo "4.) Guess one letter at a time,"
  echo "5.) The game ends when you guess the hidden word."
  echo ""
  echo ""
  echo "  Press any button to continue..." 
  read $input
}

#displayScores
displayScores(){ 

  local input=0
  local username=""
  local retrieved_score=0
  
  clear
  echo ""
  echo "+===========================================+"
  echo "             Leaderboards Menu:                  "
  echo "+===========================================+"
  echo ""
  
  #display inital prompt
  echo "1) Display top 5 scores"
  echo "2) Find highscore by username"
  echo "3) Back to main menu"
  echo ""
  read -p " Please choose an option (1-3): " input
  echo ""

  # ask user to play, see rules, view scores, or quit game
  #switch statement 
  case $input in
    #
    1)
      #display top 5 scores
      displayTopFive
    ;;
    #
    2)
      echo "+============================+"
      echo "    All Player Usernames:            "
      echo "+============================+"
      #display list of usernames
      sqlite3 "scores.db" "SELECT user_name FROM leaderboard"
      #find score by username
      echo ""
      read -p "Enter username to search: " username
      retrieved_score=$(retrieveScore "$username")

      echo ""
      
      echo "$retrieved_score"

      echo ""
      echo "  Press any button to continue..." 
      read -p ""
      echo ""
      
    ;;
    #
    3)
      #main menu
      return
    ;;
    #Invalid
    *)
      echo "Invalid menu option, please try again."
      echo""
      echo""
    ;;
  esac
  
}

#retrieveScore - for a given Username
retrieveScore(){

  user_name=$1
  
  #retreive a score from a file
  score=$(sqlite3 "scores.db" "SELECT score FROM leaderboard WHERE user_name = '$user_name'")
  #error checking
  echo "Score for $user_name: $score"
  
  return $score  
}

#User word suggestions AWK implementation
suggestion(){

  files=("words_suggestion.txt" "words_easy.txt" "words_medium.txt" "words_advanced.txt")
  
  while true; do
  read -p "Enter a word suggestion: " wordSuggest
  #to lower case
  wordSuggest=$(echo "$wordSuggest" | awk '{print tolower($0)}')
    #if suggestion is empty
    if [ -z "$wordSuggest" ]; then
      echo ""
      echo "No word entered."
      echo ""
    #if suggestion has numbers
    elif [[ "$wordSuggest" =~ [0-9] ]]; then
      echo ""
      echo "Word cannot contain numbers."
      echo ""
    #if suggestion has spaces
    elif [[ "$wordSuggest" =~ \  ]]; then
      echo ""
      echo "Word cannot contain spaces."
      echo ""
    #if suggestion already in list or game
    elif awk '$0 ~ "'$wordSuggest'" {found=1} END {if (found) exit 0; else exit 1}' "${files[@]}"; then
      echo ""
      echo "Word already up for suggestion or in the game."
      echo ""
      break
    #add word to list
    else
      echo "$wordSuggest" >> words_suggestion.txt
      echo ""
      echo "Word accepted."
      break
    fi
  done
  echo ""
  echo "  Press any button to continue..." 
  read -r
}

#displayTopFive
displayTopFive(){
  # retrieve top 5 from scores.db
  echo ""
  echo "+======================================+"
  echo "           Top 5 High Scores:                  "
  echo "+======================================+"
  echo ""
  
sqlite3 "scores.db" <<EOF
.mode column
.headers on
SELECT * FROM leaderboard ORDER BY score DESC LIMIT 5;
EOF


  echo ""
  echo ""
  echo ""
  
  echo "  Press any button to continue..." 
  read -r
  
}


##--------------------------------------------------------------------------------------------------------------------------------------------
# Game Functions -- 
##--------------------------------------------------------------------------------------------------------------------------------------------

#output
output(){
  local guesses=$1
  score=$2
  local difficulty=$3

  case $difficulty in 
    [Aa]) 
      difficulty="Advanced!"
      ;;
    [Mm]) 
      difficulty="Medium!"
      ;;
    [Ee]) 
      difficulty="Easy!"
      ;;
  esac
  
  
  echo ""
  echo ""
  echo ""
  echo "++=======================================++"
  echo "         Playing Hangman on: $difficulty "                
  echo "++=======================================++"
  echo "    ==================================="
  echo "       Amount of Incorrect Guesses: $guesses "                
  echo "    ==================================="
  echo "                    Score: $score"
}

#displayCurrentHangman
displayCurrentHangman(){

  number_of_guesses=$1
  score=$3
  difficulty=$2
  # conditional based on number of guesses
  case $number_of_guesses in
    0) 
      echo ""
      echo ""
      echo "      +------+ "
      echo "             | "
      echo "             | "
      echo "             | "
      echo "             | "
      echo "             | "
      echo "      +---------+ "
      echo ""
      ;;
    1) 
      echo ""
      echo ""
      echo "      +------+ "
      echo "      |      | "
      echo "             | "
      echo "             | "
      echo "             | "
      echo "             | "
      echo "      +---------+ "
      echo ""
      ;;
    2) 
      echo ""
      echo ""
      echo "      +------+ "
      echo "      |      | "
      echo "      O      | "
      echo "             | "
      echo "             | "
      echo "             | "
      echo "      +---------+ "
      echo ""
      ;;
    3)   
      echo ""
      echo ""
      echo "      +------+ "
      echo "      |      | "
      echo "      O      | "
      echo "      |      | " 
      echo "             | "
      echo "             | "
      echo "      +---------+ "
      echo ""
      ;;
    4) 
      echo ""
      echo ""
      echo "      +------+ "
      echo "     |       | "
      echo "     O       | "
      echo "    /|       | "
      echo "             | "
      echo "             | "
      echo "      +---------+ "
      echo ""
      ;;
    5) 
      echo ""
      echo ""
      echo "      +------+ "
      echo "      |      | "
      echo "      O      | "
      echo "     /|\     | "
      echo "             | "
      echo "             | "
      echo "      +---------+ "
      echo ""
      ;;
    6) 
      echo ""
      echo ""
      echo "      +------+ "
      echo "      |      | "
      echo "      O      | "
      echo "     /|\     | "
      echo "     /       | "
      echo "             | "
      echo "      +---------+ "
      echo ""
      ;;
    7) 
      echo ""
      echo ""
      echo "      +------+ "
      echo "      |      | "
      echo "      O      | "
      echo "     /|\     | "
      echo "     / \     | "
      echo "             | "
      echo "      +---------+ "
      echo ""
      ;;
    *) echo "Incorrect -$score_deduction points!"
        subtractScore
    ;;
  esac
    
}

#getGuess
getGuess(){
  # display prompt/get user input
  read -p "  Enter your guess (A-Za-z): " guess
  
  #error checking
  if [[ ! "$guess" =~ ^[a-zA-Z]$ ]]; then
    echo
    echo "error, enter a valid letter"
    echo
    getGuess

  fi
   
}

#checkGuess
checkGuess(){
  local guess=$1
  local correct_answer=$2
  
  #call perl script
  result=$(perl check_guess.pl "$guess" "$correct_answer")

  echo "$result"

}

#calculateScore
calculateScore(){

  local incorrect_guess_count=$1
  local time=$2
  local game_difficulty=$3
  
  #call python function
  score=$(python calculate_score.py $incorrect_guess_count $time $game_difficulty)
  echo $score
  
}

#saveScore (SQL implementation) 2
saveScore(){

  local user_name=$1
  local completion_time=$2
  local score=$3

  #create table if it doesnt exist
  sqlite3 "scores.db" "CREATE TABLE IF NOT EXISTS leaderboard (user_name VARCHAR(20) NOT NULL, completion_time INT NOT NULL, score INT NOT NULL);"

  #get current highscore from table for comparison
  table_score=$(sqlite3 "scores.db" "SELECT score FROM leaderboard WHERE user_name = '$user_name'")

  #if username not in table, add new record
  if [[ -z "$table_score" ]]; then
    sqlite3 "scores.db" "INSERT INTO leaderboard (user_name, completion_time, score) VALUES ('$user_name',       '$completion_time', '$score');"
    echo "New user '$user_name' added with score of $score."
    echo ""
    echo "  Press any button to continue..." 
    read -r
  else
    #if score is higher than table score, update
    if(( "$score" > "$table_score" )); then
      sqlite3 "scores.db" "UPDATE leaderboard SET score = $score WHERE user_name = '$user_name';"
      echo "Score for user '$user_name' updated to $score from $table_score."
      echo ""
      echo "  Press any button to continue..." 
      read -r
    #else not new highscore
    else 
      echo "Score for '$user_name' not updated. New score: $score is not higher than the existing score: $table_score"
      echo ""
      echo "  Press any button to continue..." 
      read -r
    fi
  fi

}

# Choosing Difficulty
chooseDifficulty(){
  #difficulties=("Easy", "Medium", "Advanced")
  
  #get user input for difficulty
  read -p "Enter your choice of difficulty: " difficulty_choice
  
  #error checking for E M or A
  while [[ ! $difficulty_choice =~ ^[EMAema]$ ]]; do
    echo "Invalid option!" >&2
    read -p "Enter your choice of difficulty correctly! (e,m,a): " difficulty_choice
  done
  
  echo $difficulty_choice
}

stringsort() {
  input="$1"
  echo "$input" | grep -o . | sort | tr -d '\n'
}

gameWin(){

  local user_name=$1
  local time=$2
  local score=$3

  local input=""
  
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "+++==========================================+++"
  echo "         You guessed the word: $curr_word "
  echo "           in $SECONDS seconds, amazing!!"
  echo ""
  echo "             Your score is: $score"
  echo "+++==========================================+++"
  echo ""
  echo ""
  echo "  Press any button to continue..." 
  read $input
  echo ""
  echo ""
  echo ""
  echo ""

  saveScore "$user_name" "$time" "$score"
}

gameLose(){

  local user_name=$1
  local time=$2
  local score=$3
  

  local input=""

  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "+++==========================================+++"
  echo "      You failed to guess the word: $curr_word "
  echo "     in $SECONDS seconds, better luck next time!"
  echo "+++==========================================+++"
  echo ""
  echo ""
  echo "  Press any button to continue..." 
  read $input
  echo ""
  echo ""
  echo ""
  echo ""

  #saveScore "$user_name" "$time" "$score" no saving score for fails
}

##--------------------------------------------------------------------------------------------------------------------------------------------
# Game Start -- 
##--------------------------------------------------------------------------------------------------------------------------------------------

gameStart(){

  #constants
  MAX_GUESSES=7
  #variables
  local difficulty=""
  local amt_of_words=""
  local rand_word_index=""
  
  local curr_word=""
  local curr_word_letter_count=""

  guess=""
  local incorrect_guess_count=0
  local guessed_letters=""
  local correct_guessed_letters=()
  
  game_array=()

  local correct_guessed_letters_as_string=""
  local curr_word_nodup=""
  local temp=""

  SECONDS=0
  score=0

  #get username
  clear
  echo ""
  echo "+===================================+"
  echo -n " Enter your username: "
  read user_name

  clear
  echo ""
  # choose difficulty prompt
  echo "+===================================+"
  echo "  $user_name, choose a game difficulty"
  echo "+===================================+"
  echo "E)asy"
  echo "M)edium"
  echo "A)dvanced"
  echo ""
  # call chooseDifficuly function
  difficulty=$(chooseDifficulty)
  #select word_list based on difficulty 
  case $difficulty in 
    [Aa]) 
      word_list="words_advanced.txt"
      ;;
    [Mm]) 
      word_list="words_medium.txt"
      ;;
    [Ee]) 
      word_list="words_easy.txt"
      ;;
    *)
      echo "Error!"
    ;;
  esac

  # Generating random word.
  #get total number of lines from selected word list
  amt_of_words=$(wc -l < "$word_list")
  #generate random index from amt_of_words
  rand_word_index=$((RANDOM % amt_of_words))
  #get current word based on random index
  curr_word=($(sed -n "${rand_word_index}p" "$word_list"))
  
  # get letter count
  curr_word_letter_count=${#curr_word}

  # fill game array with underscores
  for ((i=0; i<curr_word_letter_count; i++)); do
    game_array+=("_")
  done
  
  clear
  echo""
  echo "=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+="
  echo "        READY TO BEGIN?     "
  echo "=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+="
  echo ""
  
  read -p " Press any button to continue..."
  
  
  SECONDS=0
  # while incorrect guess counter is less than 7 ---
  while [ $incorrect_guess_count -lt $MAX_GUESSES ] ; do
  
    #call calculateScore function
    score=$(calculateScore "$incorrect_guess_count"  "$SECONDS" "$difficulty")
    
    # if incorrect guess,
    if [[ "$curr_guess_result" == "-1" ]] ; then
      echo "Incorrect!"
      #increment guess count by one
      incorrect_guess_count=$((incorrect_guess_count + 1))
      
    # otherwise
    else
      if [[ "$curr_guess_result" -ge 1 ]]; then 
        echo "Correct!"
      fi

      #for all the letters in current word,
      for ((i=0; i<curr_word_letter_count; i++)) do
      
        #if guess is in current word,
        if [[ "${curr_word:i:1}" == "$guess" ]] ; then
          #add guess to game array
          game_array[$i]="$guess"
          #add guess to seperate string, removing duplicates
          if [[ ! "${correct_guessed_letters[@]}" =~ "$guess" ]] ; then
            correct_guessed_letters+=("$guess")   
          fi
        #guess is not in current word
        else
          #for all the letters in current word,
          for((w=0; w<curr_word_letter_count; w++)) do 
            #not including correct answer 
            if [[ ! "${curr_word:w:1}" == "$guess" && "${curr_word:w:1}" == "_" ]] ; then
              #add underscores
              game_array[$w]="_"
            fi
          done
        fi
          
      done
    fi

    # display output and call displayCurrentHangman function
    clear
    output "$incorrect_guess_count" "$score" "$difficulty"
    displayCurrentHangman $incorrect_guess_count $difficulty $score
    echo ""
    echo -n "Word:  "
    echo -n "${game_array[@]}"

    #checking win condition
    
    #put correct guesses into a string
    for letter in "${correct_guessed_letters[@]}"; do
        if [[ ! "$correct_guessed_letters_as_string" =~ "$letter" ]] ; then
          correct_guessed_letters_as_string+="$letter"
        fi
    done
    
    #remove duplicate letters
    for (( i=0; i<${#curr_word}; i++)); do  
    
        temp="${curr_word:i:1}"
        
        if [[ ! "$curr_word_nodup" =~ "$temp" ]]; then
            curr_word_nodup+="$temp"
        fi
    done

    curr_word_nodup=$(stringsort "$curr_word_nodup")
    correct_guessed_letters_as_string=$(stringsort "$correct_guessed_letters_as_string")
    #echo "$correct_guessed_letters_as_string"
    
    if [[ "$correct_guessed_letters_as_string" == "$curr_word_nodup" ]] ; then 

      gameWin "$user_name" "$SECONDS" "$score"

      return 0
    fi
    
    #display it all (for testing)
    echo ""
    echo ""
    #echo "Testing:"
    #echo "Current word letter Count: $curr_word_letter_count"
    #echo "Current Word: $curr_word"
    #echo "Current word, no dup, sorted: $curr_word_nodup"
    #echo ""
    #echo "Guessed letters: ${guessed_letters[@]}"
    #echo "Correct guessed letters: ${correct_guessed_letters[@]}"
    #echo "Correct guessed letters as string, sorted: ${correct_guessed_letters_as_string[@]}"
    
    # call getGuess function
    echo ""
    getGuess
    # prevent letter reguessing
    while [[ " ${guessed_letters[@]} " =~ " $guess " ]]; do
      echo
      echo "You already guessed that letter, try again"
      echo
      getGuess    
    done

    # call checkGuess function (returns -1 if incorrect guess.)
    curr_guess_result=$(checkGuess "$guess" "$curr_word")

    guessed_letters+=("$guess")
    
  done

  

  #echo "$score"

  gameLose "$user_name" "$SECONDS" "$score"
  


  
}

##--------------------------------------------------------------------------------------------------------------------------------------------
# Start Menu Selections --
##--------------------------------------------------------------------------------------------------------------------------------------------

# Start Menu
startMenu(){
  #display inital prompt
  while true ; do
    clear
    echo ""
    echo ""
    echo "   -------------------------------------------------"
    echo "--------------    Welcome to Hangman!    --------------"
    echo "   -------------------------------------------------"
    echo ""
    echo "1) Start a Game"
    echo "2) Read the Rules"
    echo "3) View High Scores"
    echo "4) Make Word Suggestion"
    echo "5) Quit"
    echo ""
    read -p " Choose an option (1-5): " option
    echo ""
    echo ""

    # ask user to play, see rules, view scores, or quit game
    #switch statement 
    case $option in
      #Play start game loop
      1)
        # call gameStart method
        gameStart
      ;;
      #Display file of rules 
      2)
        # call displayRules function
        displayRules
      ;;
      #Scores
      3)
        # call displayScores method
        displayScores
      ;;
      4)
        # call displayScores method
        suggestion
      ;;
      #Quit from game loop
      5)
        clear
        echo ""
        echo ""
        echo ""
        echo "   Exiting Hangman, leave a review!"
        exit
      ;;
      *)
        echo "Invalid menu option, please try again."
        echo""
        echo""
      ;;
    esac
  done
}





##--------------------------------------------------------------------------------------------------------------------------------------------
# Game Loop --
##--------------------------------------------------------------------------------------------------------------------------------------------

#run an infinite game loop until user quits
while true; do
  # call startMenu function 
  startMenu
  
done

