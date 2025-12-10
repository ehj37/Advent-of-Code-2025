extends Control


class Machine:
	var indicator_light_diagram: String
	var buttons: Array[LightButton]
	var joltage_requirements: Array[int]

	func _init(ild: String, bs: Array[LightButton], jrs: Array[int]):
		indicator_light_diagram = ild
		buttons = bs
		joltage_requirements = jrs


class LightButton:
	var machine: Machine
	var lights: Array[int]

	func _init(ls: Array[int]):
		lights = ls


var _machines: Array[Machine]

@onready var button_part_1: Button = $VBoxContainer/VBoxContainerPart1/ButtonPart1
@onready var label_part_1: Label = $VBoxContainer/VBoxContainerPart1/LabelPart1
@onready var button_part_2: Button = $VBoxContainer/VBoxContainerPart2/ButtonPart2
@onready var label_part_2: Label = $VBoxContainer/VBoxContainerPart2/LabelPart2


func _parse_input() -> void:
	_machines = []

	var file = FileAccess.open("res://day10/input.txt", FileAccess.READ)
	#var file = FileAccess.open("res://day10/example_1.txt", FileAccess.READ)

	while !file.eof_reached():
		var line = file.get_line()
		if line.is_empty():
			continue

		var ild: String
		var bs: Array[LightButton] = []
		var jrs: Array[int] = []
		var split_line = line.split(" ")
		for substr in split_line:
			var trimmed_substr = substr.substr(1, substr.length() - 2)
			match substr[0]:
				"[":
					ild = substr.substr(1, substr.length() - 2)
				"(":
					var light_nums: Array[int] = []
					for c in trimmed_substr.split(","):
						light_nums.append(int(c))
					bs.append(LightButton.new(light_nums))
				"{":
					var joltage_amounts: Array[int] = []
					for c in trimmed_substr.split(","):
						joltage_amounts.append(int(c))
					jrs = joltage_amounts
		var machine = Machine.new(ild, bs, jrs)
		_machines.append(machine)


func part_one() -> String:
	_parse_input()

	var press_sum = 0
	for machine in _machines:
		var empty_lights = ""
		for i in range(machine.indicator_light_diagram.length()):
			empty_lights = empty_lights + "."

		var min_presses: int = -99999
		var lights_and_presses_queue = [[empty_lights, 0]]
		while min_presses < 0:
			var lights_and_presses = lights_and_presses_queue.pop_front()
			var lights = lights_and_presses[0]
			var presses = lights_and_presses[1]

			if lights == machine.indicator_light_diagram:
				min_presses = presses
				continue

			for button in machine.buttons:
				var new_lights = lights
				for light_num in button.lights:
					match lights[light_num]:
						".":
							new_lights[light_num] = "#"
						"#":
							new_lights[light_num] = "."
				var new_lights_and_presses = [new_lights, presses + 1]
				if !lights_and_presses_queue.has(new_lights_and_presses):
					lights_and_presses_queue.append(new_lights_and_presses)
		press_sum += min_presses

	return str(press_sum)


func part_two() -> String:
	_parse_input()

	return str(int("Implement me!"))


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
