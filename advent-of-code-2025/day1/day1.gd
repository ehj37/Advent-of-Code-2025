extends Control


class Rotation:
	enum Direction { LEFT, RIGHT }

	var dir: Direction
	var amount: int

	func _init(dir, amount) -> void:
		self.dir = dir
		self.amount = amount


const INITIAL_POSITION := 50
const MIN_POSITION := 0
const MAX_POSITION := 99

var _rotations: Array[Rotation] = []

@onready var button_part_1: Button = $VBoxContainer/VBoxContainerPart1/ButtonPart1
@onready var label_part_1: Label = $VBoxContainer/VBoxContainerPart1/LabelPart1
@onready var button_part_2: Button = $VBoxContainer/VBoxContainerPart2/ButtonPart2
@onready var label_part_2: Label = $VBoxContainer/VBoxContainerPart2/LabelPart2


func part_one() -> String:
	_parse_input()

	var zero_count := 0
	var current_position := INITIAL_POSITION
	for rotation in _rotations:
		var unwrapped_new_position: int
		match rotation.dir:
			Rotation.Direction.LEFT:
				unwrapped_new_position = current_position - rotation.amount
			Rotation.Direction.RIGHT:
				unwrapped_new_position = current_position + rotation.amount
		current_position = wrap(unwrapped_new_position, MIN_POSITION, MAX_POSITION + 1)
		if current_position == 0:
			zero_count += 1

	return str(zero_count)


func part_two() -> String:
	return "Implement me!"


func _on_button_part_1_pressed():
	button_part_1.disabled = true
	label_part_1.text = "Calculating…"
	label_part_1.text = part_one()


func _on_button_part_2_pressed():
	button_part_2.disabled = true
	label_part_2.text = "Calculating…"
	label_part_2.text = part_one()


func _parse_input() -> void:
	if !_rotations.is_empty():
		return

	var file = FileAccess.open("res://day1/input.txt", FileAccess.READ)
	while !file.eof_reached():
		var line = file.get_line()
		if line.is_empty():
			continue

		var dir: Rotation.Direction
		match line[0]:
			"L":
				dir = Rotation.Direction.LEFT
			"R":
				dir = Rotation.Direction.RIGHT
		var amount = int(line.substr(1))
		_rotations.append(Rotation.new(dir, amount))
