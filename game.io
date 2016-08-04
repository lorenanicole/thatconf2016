# Prototypes for trivia game

Game := Object clone
Game players := List clone
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


# Game logic

introduction
answer := File standardInput readLine
showNumPlayers
numPlayers := answer asNumber
Game createPlayers(numPlayers)
Game seePlayers()

