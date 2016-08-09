#!/usr/local/bin/io

# New - Create a new assignment operator to load questions  (meta programming!)

OperatorTable addAssignOperator(":", "createQuestion")

curlyBrackets := method(
	data := Map clone
	call message arguments foreach(arg,  
    	data doMessage(arg))  
  	data  	
)
Map createQuestion := method(
	c := call evalArgAt(0) asMutable removePrefix("\"") removeSuffix("\"") asLowercase;
	args := call evalArgAt(1) asMutable split("\n");
	q := Question new(args at(0), c, args at(1) removePrefix("\t\t\t")) 
	
	if(self hasKey(c),
		val := self at(c);
		self atPut(c, val append(q)),
		self atPut(c, list(q))
	)
)

Question := Object clone
Question new := method(text, category, answer, 
	q := Question clone;
	q text := text;
	q category := category;
	q answer := answer;
	q used := false;
	q
)

# Prototypes as before

Game := Object clone
Game players := List clone
Game questions := Map clone
Game categories := List clone
Game currentCategory := nil
Game winner := nil
Game loadQuestions := method(
	s := File with("example.txt") openForReading contents
	Game questions := doString(s)
	Game categories = Game questions keys;
)
Game createPlayers := method(numPlayers,
	for(num, 1, numPlayers, 
		write("What is the name for player ", num, " ?\n");
		answer := File standardInput readLine;
		Game players append(Player new(answer));
	) 
)
Game seePlayers := method(
	write("Players: ");
	Game players foreach(current, player,
		((current+1) == Game players size) ifFalse(write(player name,", ")) ifTrue(write(player name, ".", "\n"))
	) 
)
Game seeCategories := method(
	write("Categories:\n");
	Game categories foreach(current, name,
		write("- ", name, "\n");
	) 
)
Game pickCategory := method(
	"What category do you wish to play today?" println
	answer := File standardInput readLine
	Game currentCategory = answer;
)
Game pickQuestion := method(
	categoryQuestions := Game questions at(Game currentCategory) select(question, question used == false);
	while(categoryQuestions size < 1, 
		Game pickCategory
		categoryQuestions := Game questions at(Game currentCategory) select(question, question used == false);
	)
	number := Random value * categoryQuestions size;
	number = number round;
	q := categoryQuestions at(number);
	q used = true;
	q
)
Game answerQuestion := method(answers, question,
	counter := 1;
	Game players  foreach(number, player, 
		(question answer asLowercase == answers at(number) asLowercase) ifTrue(player points = player points + 1);
		write("Player ", player name, " has ", player points, " points.\n");
		counter = counter + 1;
	)
)
Game results := method(
	Game players = Game players sortBy(block(first, second, first points > second points));
	pretext := """


		\   \  /  \  /   / |  | |  \ |  | |  \ |  | |   ____||   _  \     _ 
		 \   \/    \/   /  |  | |   \|  | |   \|  | |  |__   |  |_)  |   (_)
		  \            /   |  | |  . `  | |  . `  | |   __|  |      /       
		   \    /\    /    |  | |  |\   | |  |\   | |  |____ |  |\  \----._ 
		    \__/  \__/     |__| |__| \__| |__| \__| |_______|| _| `._____(_)"""

    write(pretext, "\n")
	if(Game players size < 2, 
		return write("Only one player, so the winner is ", Game players at(0) name, "\n")
	)
	if(Game players at(0) points == Game players at(1) points,
		write("We have a tie! ", Game players at(0) name, " and ", Game players at(1) name, " win!\n"),
		Game winner = Game players at(0);
		write("Player ", winner name, " wins with ", winner points "!!\n");
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

selectNumPlayers := method(
	write("How many players are there?\n");
	answer := File standardInput readLine;
	if(answer size == 0, answer = "1");
	write("OK, today we'll have ", answer, " players.\n");
	answer asNumber;
)
askPlayersForAnswer := method(
	answers := List clone;
	Game players foreach(i, v, 
		write("Player ", i, " answer: ");
		answer := File standardInput readLine;
		answer println;
		answers append(answer);
	)
	answers
)
showQuestion := method(question, write(question text, "\n"))
showAnswer := method(question, write("Answer: ", question answer, "\n"))
numQuestions ::= method(
	write("How many questions should we play?\n");
	answer := File standardInput readLine;
	answer asNumber;
)

# Game logic

Game loadQuestions
Game createPlayers(selectNumPlayers)
Game seePlayers
Game seeCategories
Game pickCategory
numQuestions repeat(
	question := Game pickQuestion
	showQuestion(question)
	answers := askPlayersForAnswer
	Game answerQuestion(answers, question)
	showAnswer(question)
)
Game results





