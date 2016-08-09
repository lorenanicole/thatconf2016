import csv
with open("questions.csv", "r") as mycsvfile:
	reader = csv.DictReader(mycsvfile)

	with open("dsl/output.txt", "w") as outputfile:	
		outputfile.write("{\n")
		reader = list(reader)
		size = len(reader) - 1
		for i, row in enumerate(reader):
			row_content = '"{0}": "{1}\n{2}",\n'.format(row.get('Category'), row.get('Question').strip(" "), row.get('Answer').strip(" "))
			if i == size:
				row_content = row_content[0:-2]

			outputfile.write(row_content)
		
		outputfile.write("}")