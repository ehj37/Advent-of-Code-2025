extends Control


class IdRange:
	var start: int
	var end: int

	func _init(s, e):
		start = s
		end = e


var _example_ranges: Array[IdRange] = [
	IdRange.new(11, 22),
	IdRange.new(95, 115),
	IdRange.new(998, 1012),
	IdRange.new(1188511880, 1188511890),
	IdRange.new(222220, 222224),
	IdRange.new(1698522, 1698528),
	IdRange.new(446443, 446449),
	IdRange.new(38593856, 38593862),
	IdRange.new(565653, 565659),
	IdRange.new(824824821, 824824827),
	IdRange.new(2121212118, 2121212124),
]

var _ranges: Array[IdRange]

@onready var button_part_1: Button = $VBoxContainer/VBoxContainerPart1/ButtonPart1
@onready var label_part_1: Label = $VBoxContainer/VBoxContainerPart1/LabelPart1
@onready var button_part_2: Button = $VBoxContainer/VBoxContainerPart2/ButtonPart2
@onready var label_part_2: Label = $VBoxContainer/VBoxContainerPart2/LabelPart2


func _parse_input():
	if !_ranges.is_empty():
		return

	var file = FileAccess.open("res://day2/input.txt", FileAccess.READ)
	var range_strs = file.get_line().split(",")
	for range_str in range_strs:
		var split_str = range_str.split("-")
		_ranges.append(IdRange.new(int(split_str[0]), int(split_str[1])))


func part_one() -> String:
	_parse_input()

	var invalid_id_sum = 0
	for r in _ranges:
		for i in range(r.start, r.end + 1):
			var i_str = str(i)
			var i_str_len = i_str.length()
			if i_str_len % 2 != 0:
				continue

			@warning_ignore("integer_division")
			var front = i_str.substr(0, i_str_len / 2)
			@warning_ignore("integer_division")
			var back = i_str.substr(i_str_len / 2, i_str_len + 1)
			if front == back:
				invalid_id_sum += i

	return str(invalid_id_sum)


# Not 28196420717
func part_two() -> String:
	_parse_input()
	var invalid_ids: Array[int] = []
	for r in _ranges:
		for i in range(r.start, r.end + 1):
			var i_str = str(i)
			var i_str_len = i_str.length()
			@warning_ignore("integer_division")
			for j in range(1, i_str_len / 2 + 1):
				var j_str = i_str.substr(0, j)
				var j_str_len = j_str.length()
				if i_str_len % j_str_len == 0:
					var candidate: String = ""
					@warning_ignore("integer_division")
					for _k in range(i_str_len / j_str_len):
						candidate += j_str
					if candidate == i_str:
						if !invalid_ids.has(i):
							invalid_ids.append(i)

	var invalid_id_sum = invalid_ids.reduce(func(acc, n): return acc + n, 0)
	return str(invalid_id_sum)


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
