extends Control

@onready var button_part_1: Button = $VBoxContainer/VBoxContainerPart1/ButtonPart1
@onready var label_part_1: Label = $VBoxContainer/VBoxContainerPart1/LabelPart1
@onready var button_part_2: Button = $VBoxContainer/VBoxContainerPart2/ButtonPart2
@onready var label_part_2: Label = $VBoxContainer/VBoxContainerPart2/LabelPart2


func part_one() -> String:
	var file = FileAccess.open("res://day6/input.txt", FileAccess.READ)
	#var file = FileAccess.open("res://day6/example_1.txt", FileAccess.READ)
	var number_lines: Array = []
	var operators: Array[String] = []
	
	while !file.eof_reached():
		var line = file.get_line()
		if line.is_empty():
			continue
			
		var split_line = line.split(' ')
		if split_line[0] == '+' || split_line[0] == '*':
			for c in split_line:
				match c: 
					'+', '*':
						operators.append(c)
		else:
			var number_line: Array[int] = []
			for c in split_line:
				if c != '':
					number_line.append(int(c))
			number_lines.append(number_line)
			
	var grand_total = 0
	for i in number_lines[0].size():
		var numbers: Array[int] = []
		for number_line in number_lines:
			numbers.append(number_line[i])
		var operator = operators[i]
		match operator:
			'+':
				grand_total += numbers.reduce(func(acc, j): return acc + j, 0)
			'*':
				grand_total += numbers.reduce(func(acc, j): return acc * j, 1)
				
	return(str(grand_total))


func part_two() -> String:
	return "Implement me!"


func _on_button_part_1_pressed():
	button_part_1.disabled = true
	label_part_1.text = "Calculating…"
	label_part_1.text = part_one()
	button_part_1.disabled = false


func _on_button_part_2_pressed():
	button_part_2.disabled = true
	label_part_2.text = "Calculating…"
	label_part_2.text = part_two()
	button_part_2.disabled = false
