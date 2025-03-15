import sys

#check arguments
try:
    time = float(sys.argv[1])
    guesses = int(sys.argv[2])
    game_difficulty = sys.argv[3].lower()
except (ValueError, IndexError) as e:
    print("Error: ", e)
    sys.exit(1)

#make difficulty numeric
game_difficulty_numerics = {
    "e": 3,
    "m": 2,
    "a": 1
}

game_difficulty_numerics = game_difficulty_numerics[game_difficulty]


#equation based on time and number of guesses
def calculating_score(time, guesses, game_difficulty):
    score = 10 * (50-time) * (30-guesses) / game_difficulty
    return score


#score = calculating_score(time, guesses, game_difficulty_numerics)          #float score
score = int(calculating_score(time, guesses, game_difficulty_numerics))    #int score
print(score)