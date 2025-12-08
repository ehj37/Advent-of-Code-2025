extends Control


class JunctionBox:
	var position: Vector3
	var circuit: Circuit

	func _init(x, y, z):
		position = Vector3(x, y, z)


class Circuit:
	var junction_boxes: Array[JunctionBox] = []

	func _init(jbs: Array[JunctionBox]):
		for jb in jbs:
			jb.circuit = self
		junction_boxes = jbs

	func con(c: Circuit) -> void:
		for jb in c.junction_boxes:
			if !junction_boxes.has(jb):
				jb.circuit = self
				junction_boxes.append(jb)


var _circuits: Array[Circuit] = []
var _junction_boxes: Array[JunctionBox] = []

@onready var button_part_1: Button = $VBoxContainer/VBoxContainerPart1/ButtonPart1
@onready var label_part_1: Label = $VBoxContainer/VBoxContainerPart1/LabelPart1
@onready var button_part_2: Button = $VBoxContainer/VBoxContainerPart2/ButtonPart2
@onready var label_part_2: Label = $VBoxContainer/VBoxContainerPart2/LabelPart2


func _parse_input() -> void:
	_circuits = []

	var file = FileAccess.open("res://day8/input.txt", FileAccess.READ)
	#var file = FileAccess.open("res://day8/example_1.txt", FileAccess.READ)

	while !file.eof_reached():
		var line = file.get_line()
		if line.is_empty():
			continue

		var coord_number_strs = line.split(",")
		var numbers: Array[int] = []
		for number_str in coord_number_strs:
			numbers.append(int(number_str))

		var junction_box = JunctionBox.new(numbers[0], numbers[1], numbers[2])
		_junction_boxes.append(junction_box)

		var circuit = Circuit.new([junction_box])
		_circuits.append(circuit)


func part_one() -> String:
	_parse_input()

	var junction_box_pairs_and_distances = []
	for jb_i in range(_junction_boxes.size()):
		var jb = _junction_boxes[jb_i]
		for other_jb_i in range(jb_i + 1, _junction_boxes.size()):
			var other_jb = _junction_boxes[other_jb_i]
			if jb == other_jb:
				continue

			var distance = jb.position.distance_to(other_jb.position)
			junction_box_pairs_and_distances.append([jb, other_jb, distance])

	junction_box_pairs_and_distances.sort_custom(func(a, b): return a[2] < b[2])

	for i in range(1000):
		#for i in range(10):
		var pair_to_connect = junction_box_pairs_and_distances[i]
		var jb_1 = pair_to_connect[0] as JunctionBox
		var jb_2 = pair_to_connect[1] as JunctionBox
		if jb_1.circuit == jb_2.circuit:
			continue

		_circuits.erase(jb_2.circuit)
		jb_1.circuit.con(jb_2.circuit)

	_circuits.sort_custom(
		func(a: Circuit, b: Circuit): return a.junction_boxes.size() > b.junction_boxes.size()
	)
	var largest_circuit_product = 1
	for i in range(3):
		largest_circuit_product *= _circuits[i].junction_boxes.size()

	return str(largest_circuit_product)


func part_two() -> String:
	_parse_input()

	return str("Implement me!")


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
