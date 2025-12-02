extends Control

class IdRange:
	var start: int
	var end: int
	
	func _init(s, e):
		start = s
		end = e

var _ranges: Array[IdRange]

@onready var button_part_1: Button = $VBoxContainer/VBoxContainerPart1/ButtonPart1
@onready var label_part_1: Label = $VBoxContainer/VBoxContainerPart1/LabelPart1
@onready var button_part_2: Button = $VBoxContainer/VBoxContainerPart2/ButtonPart2
@onready var label_part_2: Label = $VBoxContainer/VBoxContainerPart2/LabelPart2


func _parse_input():
	if !_ranges.is_empty():
		return

	var file = FileAccess.open("res://day2/input.txt", FileAccess.READ)
	var range_strs = file.get_line().split(',')
	for range_str in range_strs:
		var split_str = range_str.split("-")
		_ranges.append(IdRange.new(int(split_str[0]), int(split_str[1])))

func part_one() -> String:
	_parse_input()
	
	var invalid_id_sum = 0
	for r in _ranges:
		for i in range(r.start, r.end + 1):
			var i_str = str(i)
			var i_str_len =  i_str.length()
			if i_str_len % 2 != 0:
				continue

			@warning_ignore("integer_division")
			var front = i_str.substr(0, i_str_len / 2)
			@warning_ignore("integer_division")
			var back =  i_str.substr(i_str_len / 2, i_str_len + 1)
			if front == back:
				invalid_id_sum += i

	return(str(invalid_id_sum))

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
