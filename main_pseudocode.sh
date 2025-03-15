#!/bin/bash

##--------------------------------------------------------------------------------------------------------------------------------------------
# Menu Functions --
##--------------------------------------------------------------------------------------------------------------------------------------------
# Rules
displayRules(){
  # display a prompt for the rules
}
# Display top 5 High Scores
retrieveTopFive(){
    # retrieve top 5 from scores.txt
    #display records
}
# get High Score by Username
retrieveHighscore(){
  #get a username from first argument passed
  #check if username exists/reprompt & list usernames in sql table
}
#displayScores
displayScores(){
  #Select case statement for score display
}

##--------------------------------------------------------------------------------------------------------------------------------------------
# Game Functions -- 
##--------------------------------------------------------------------------------------------------------------------------------------------
# Choosing Difficulty
chooseDifficulty(){
  #arrays holding difficulty examples

  #display difficulty arrays

  #get user input for difficulty

}
# Display Current Hangman
displayCurrentHangman(){
  # conditional based on number of wrong guesses
}
#getGuess
getGuess(){
  # display prompt/get user input
  # error check
}
#checkGuess
checkGuess(){
  #call perl script
  #check for all occurences of the guess in the word
  #if no occurences, increment wrong guess counter
}
# Calculating Score
calculateScore(){
    #call python script
}
# Save High Score
saveHighScore(){
  #keep user's highscore updated in sql table
}
# Game
gameStart(){
  
  # call chooseDifficuly function
  
  # user input chooses array of strings

  # random num generator for array index (word)

  # store each char from word in new_array

  # while wrong guess counter is less than 7
    # call displayCurrentHangman function
    
    # call getGuess function
  
    # call checkGuess function 
  
    #increment guess count by one

  #call calculateScore function
}

##--------------------------------------------------------------------------------------------------------------------------------------------
# Start Menu Selections --
##--------------------------------------------------------------------------------------------------------------------------------------------
# Start Menu
startMenu(){
  #display inital prompt

  # ask user to play, see rules, view scores, or quit game
  #switch statement 

    #Play start game loop
      # call gameStart method

    #Display file of rules 
      # call displayRules function

    #Scores
      # call displayScores method

    #Quit from game loop
      # break

}



##--------------------------------------------------------------------------------------------------------------------------------------------
# Game Loop --
##--------------------------------------------------------------------------------------------------------------------------------------------
#run an infinite game loop until user quits
  # call startMenu function 

