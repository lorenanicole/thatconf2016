#!/usr/local/bin/io

OperatorTable addAssignOperator(":", "createQuestion")

curlyBrackets := method(
	data := List clone
	call sender println
	call message arguments foreach(arg,  
    	data doMessage(arg))  
  	data  	
)

List createQuestion := method(
	args := call evalArgAt(1) asMutable split("\n");
	q := (Question new(args at(0), args at(1), args at(2))) 
	self append(q)
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


s := File with("example.tsv") openForReading contents
allQuestions := doString(s)
# s close
write(allQuestions)







