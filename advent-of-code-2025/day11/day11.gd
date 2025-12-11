extends Control


class Device:
	var name: String
	var outputs: Array[Device] = []
	var is_out: bool = false

	func _init(n: String):
		name = n


var _devices: Array[Device]

@onready var button_part_1: Button = $VBoxContainer/VBoxContainerPart1/ButtonPart1
@onready var label_part_1: Label = $VBoxContainer/VBoxContainerPart1/LabelPart1
@onready var button_part_2: Button = $VBoxContainer/VBoxContainerPart2/ButtonPart2
@onready var label_part_2: Label = $VBoxContainer/VBoxContainerPart2/LabelPart2


func _fetch_or_create_device(device_name: String) -> Device:
	var device: Device
	var device_i = _devices.find_custom(func(d): return d.name == device_name)
	if device_i != -1:
		device = _devices[device_i]
	else:
		device = Device.new(device_name)
		_devices.append(device)
	return device


func _parse_input() -> void:
	_devices = []

	var file = FileAccess.open("res://day11/input.txt", FileAccess.READ)
	#var file = FileAccess.open("res://day11/example_1.txt", FileAccess.READ)

	while !file.eof_reached():
		var line = file.get_line()
		if line.is_empty():
			continue

		var split_line = line.split(":")
		var device_name = split_line[0]
		var device = _fetch_or_create_device(device_name)

		var output_names = split_line[1].trim_prefix(" ").split(" ")
		for output_name in output_names:
			match output_name:
				"out":
					device.is_out = true
				_:
					var output_device = _fetch_or_create_device(output_name)
					device.outputs.append(output_device)


func part_one() -> String:
	_parse_input()

	var you_device_i = _devices.find_custom(func(d): return d.name == "you")
	var you_device = _devices[you_device_i]

	var path_count = 0
	var device_visited_queue = [[you_device, []]]
	while !device_visited_queue.is_empty():
		var device_and_visited_devices = device_visited_queue.pop_front()

		var device = device_and_visited_devices[0] as Device
		var visited_devices = device_and_visited_devices[1]
		var new_visited_devices = visited_devices.duplicate()
		new_visited_devices.append(device)

		if device.is_out:
			path_count += 1

			continue

		var visitable_devices = device.outputs.filter(func(d): return !new_visited_devices.has(d))
		for visitable_device in visitable_devices:
			device_visited_queue.append([visitable_device, new_visited_devices])

	return str(path_count)


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
