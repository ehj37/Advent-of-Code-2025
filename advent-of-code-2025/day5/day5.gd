extends Control

var _fresh_ingredient_ranges: Array = []
var _available_ingredients: Array[int] = []

@onready var button_part_1: Button = $VBoxContainer/VBoxContainerPart1/ButtonPart1
@onready var label_part_1: Label = $VBoxContainer/VBoxContainerPart1/LabelPart1
@onready var button_part_2: Button = $VBoxContainer/VBoxContainerPart2/ButtonPart2
@onready var label_part_2: Label = $VBoxContainer/VBoxContainerPart2/LabelPart2


func _parse_input() -> void:
	if !_fresh_ingredient_ranges.is_empty():
		return
	
	var file = FileAccess.open("res://day5/input.txt", FileAccess.READ)
	#var file = FileAccess.open("res://day5/example_1.txt", FileAccess.READ)
	var on_ranges = true
	while !file.eof_reached():
		var line = file.get_line()
		if line.is_empty():
			on_ranges = false
			continue
			
		if on_ranges:
			var ingredient_range_strs = line.split("-")
			var ingredient_range: Array[int] = []
			for ingredient_range_str in ingredient_range_strs:
				ingredient_range.append(int(ingredient_range_str))
			_fresh_ingredient_ranges.append(ingredient_range)
		else:
			_available_ingredients.append(int(line))

func part_one() -> String:
	_parse_input()
	
	var fresh_ingredient_count = 0
	for ingredient_id in _available_ingredients:
		for ingredient_range in _fresh_ingredient_ranges:
			if ingredient_id >= ingredient_range[0] && ingredient_id <= ingredient_range[1]:
				fresh_ingredient_count += 1
				break

	return str(fresh_ingredient_count)

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
