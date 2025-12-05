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
	# var file = FileAccess.open("res://day5/example_1.txt", FileAccess.READ)
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
	_parse_input()

	var ranges_to_process = _fresh_ingredient_ranges.duplicate_deep()
	var processed_ranges = []
	while !ranges_to_process.is_empty():
		var relevant_range = ranges_to_process.pop_front()
		var range_merged = false
		for merge_candidate_range in ranges_to_process:
			if merge_candidate_range[1] < relevant_range[0]:
				continue

			if merge_candidate_range[0] > relevant_range[1]:
				continue

			var new_min = [merge_candidate_range[0], relevant_range[0]].min()
			var new_max = [merge_candidate_range[1], relevant_range[1]].max()
			var new_range = [new_min, new_max]
			ranges_to_process.append(new_range)
			ranges_to_process.erase(merge_candidate_range)
			range_merged = true

		if !range_merged:
			processed_ranges.append(relevant_range)

	var num_fresh_ingredients = processed_ranges.reduce(
		func(acc, r): return acc + r[1] - r[0] + 1, 0
	)
	return str(num_fresh_ingredients)


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
