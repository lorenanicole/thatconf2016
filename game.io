# Prototypes for trivia game
# Regex  # Include for loading questions logic

Game := Object clone
Game players := List clone
Game questions := List clone
Game categories := List clone
Game currentCategory := nil
Game loadQuestions := method(
	f := File with("questions.csv")
	f openForReading
	l := f readLine;
	f foreach(i, v, 
		l := f readLine;
		# parsedLine := List clone;
		# parsedLine = l allMatchesOfRegex("([^,]+)") map (at(0));
		parsedLine := l split(",");
		q := Question new(parsedLine at(0), parsedLine at(1) asLowercase, parsedLine at(2));
		Game questions append(q);
	)
	f close
	Game categories = Game questions map(category) unique;
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
	categoryQuestions := Game questions select(question, question category == Game currentCategory);
	number := Random value * categoryQuestions size;
	number = number round;
	q := categoryQuestions at(number);
	while(q used == true,
		number = Random value * categoryQuestions size;
		number = number round;
		q = categoryQuestions at(number);
	)
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

Player := Object clone
Player new := method(name, 
	p := Player clone;
	p name := name;
	p points := 0;
	p
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

# UI Prompts

selectNumPlayers := method(
	write("How many players are there?\n");
	answer := File standardInput readLine;
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

# Game logic

Game loadQuestions
Game createPlayers(selectNumPlayers)
Game seePlayers
Game seeCategories
Game pickCategory
question := Game pickQuestion
showQuestion(question)
answers := askPlayersForAnswer
Game answerQuestion(answers, question)
showAnswer(question)




