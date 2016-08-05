# Prototypes for trivia game
Regex  # Include for loading questions logic

Game := Object clone
Game players := List clone
Game questions := List clone
Game loadQuestions := method(theme,
	f := File with("questions.csv")
	f openForReading
	f foreach(i, v, 
		l := f readLine
		parsedLine := List clone
		parsedLine = l allMatchesOfRegex("([^,]+)") map (at(0))
		parsedLine println
		parsedLine size println
	)
	f close
)

Game createPlayers := method(numPlayers,
	for(num, 1, numPlayers, 
		write("What is the name for player ", num, " ?\n");
		answer := File standardInput readLine;
		Game players append(Player new(answer))
	) 
)
Game seePlayers := method(
	names := List clone;
	Game players foreach(current, player,
		names append(player name);
	)
	write("Players: ");
	names foreach(current, name,
		((current+1) == names size) ifFalse(write(name,", ")) ifTrue(write(name,".","\n"))
	) 
)
Game askQuestion := method(
	
	)


Player := Object clone
Player new := method(name, 
	p := Player clone;
	p name := name;
	p points := 0;
	p
)



# UI Prompts
introduction := method("How many players are there?" println)
showNumPlayers := method("OK we have #{answer} players" interpolate println)
pickTheme := method("What theme do you wish to play today?" println)

# Game logic

introduction
answer := File standardInput readLine
showNumPlayers
numPlayers := answer asNumber
Game createPlayers(numPlayers)
Game seePlayers()
pickTheme
theme := File standardInput readLine
Game loadQuestions(theme)
