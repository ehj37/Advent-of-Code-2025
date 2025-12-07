extends Control

var _lines: Array = []
var _line_num_and_index_to_num_worlds = {}

@onready var button_part_1: Button = $VBoxContainer/VBoxContainerPart1/ButtonPart1
@onready var label_part_1: Label = $VBoxContainer/VBoxContainerPart1/LabelPart1
@onready var button_part_2: Button = $VBoxContainer/VBoxContainerPart2/ButtonPart2
@onready var label_part_2: Label = $VBoxContainer/VBoxContainerPart2/LabelPart2


func _parse_input() -> void:
	_lines = []

	var file = FileAccess.open("res://day7/input.txt", FileAccess.READ)
	#var file = FileAccess.open("res://day7/example_1.txt", FileAccess.READ)

	while !file.eof_reached():
		var line = file.get_line()
		if line.is_empty():
			continue

		_lines.append(line.split(""))


func part_one() -> String:
	_parse_input()

	var lines = _lines.duplicate_deep()

	var num_splits = 0
	for i in range(lines.size()):
		if i == 0:
			continue

		var line = lines[i]
		for j in range(line.size()):
			var c = line[j]
			var above_c = lines[i - 1][j]
			if above_c == "." || above_c == "^":
				continue

			match c:
				".":
					line[j] = "|"
				"^":
					if j > 0 && line[j - 1] == ".":
						line[j - 1] = "|"
					if j < line.size() - 1 && line[j + 1] == ".":
						line[j + 1] = "|"

					num_splits += 1

	return str(num_splits)


func num_timelines(lines: Array) -> int:
	for i in range(lines.size()):
		var line = lines[i]
		if line.has("S") || line.has("|"):
			continue

		for j in range(line.size()):
			var c = line[j]
			var above_c = lines[i - 1][j]
			if above_c == "." || above_c == "^":
				continue

			var cached_value = _line_num_and_index_to_num_worlds.get([i - 1, j])
			if cached_value != null:
				return cached_value

			match c:
				".":
					if i == lines.size() - 1:
						_line_num_and_index_to_num_worlds[[i, j]] = 1
						return 1
					var new_lines = lines.duplicate_deep()
					new_lines[i][j] = "|"
					var num_worlds = num_timelines(new_lines)
					_line_num_and_index_to_num_worlds[[i, j]] = num_worlds
					return num_worlds
				"^":
					var num_worlds = 0
					if j > 0 && line[j - 1] == ".":
						var left_world_lines = lines.duplicate_deep()
						left_world_lines[i][j - 1] = "|"
						var num_worlds_l = num_timelines(left_world_lines)
						_line_num_and_index_to_num_worlds[[i, j - 1]] = num_worlds_l
						num_worlds += num_worlds_l
					if j < line.size() - 1 && line[j + 1] == ".":
						var right_world_lines = lines.duplicate_deep()
						right_world_lines[i][j + 1] = "|"
						var num_worlds_r = num_timelines(right_world_lines)
						_line_num_and_index_to_num_worlds[[i, j + 1]] = num_worlds_r
						num_worlds += num_worlds_r

					return num_worlds

	assert("If we've gotten here, something has gone terribly wrong.")
	return 0


func part_two() -> String:
	_parse_input()

	return str(num_timelines(_lines))


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
