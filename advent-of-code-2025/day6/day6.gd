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

		var split_line = line.split(" ")
		if split_line[0] == "+" || split_line[0] == "*":
			for c in split_line:
				match c:
					"+", "*":
						operators.append(c)
		else:
			var number_line: Array[int] = []
			for c in split_line:
				if c != "":
					number_line.append(int(c))
			number_lines.append(number_line)

	var grand_total = 0
	for i in number_lines[0].size():
		var numbers: Array[int] = []
		for number_line in number_lines:
			numbers.append(number_line[i])
		var operator = operators[i]
		match operator:
			"+":
				grand_total += numbers.reduce(func(acc, j): return acc + j, 0)
			"*":
				grand_total += numbers.reduce(func(acc, j): return acc * j, 1)

	return str(grand_total)


func part_two() -> String:
	var file = FileAccess.open("res://day6/input.txt", FileAccess.READ)
	# var file = FileAccess.open("res://day6/example_1.txt", FileAccess.READ)
	var lines: Array[String] = []
	while !file.eof_reached():
		var line = file.get_line()
		if line.is_empty():
			continue

		lines.append(line)

	var grand_total = 0

	var current_operator: String
	var numbers_to_operate_on: Array[int]

	var max_line_len: int
	for line in lines:
		if line.length() > max_line_len:
			max_line_len = line.length()

	for i in range(max_line_len):
		var number_chars: Array[String] = []
		for j in range(lines.size()):
			if i >= lines[j].length():
				continue

			var c = lines[j][i]
			if c == " ":
				continue

			if c == "+" || c == "*":
				current_operator = c
				continue

			number_chars.append(c)

		if !number_chars.is_empty():
			var number_str = number_chars.reduce(func(acc, s): return acc + s, "")
			var number = int(number_str)
			numbers_to_operate_on.append(number)
			if i != max_line_len - 1:
				continue

		match current_operator:
			"+":
				grand_total += numbers_to_operate_on.reduce(func(acc, j): return acc + j, 0)
			"*":
				grand_total += numbers_to_operate_on.reduce(func(acc, j): return acc * j, 1)

		numbers_to_operate_on = []

	return str(grand_total)


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
