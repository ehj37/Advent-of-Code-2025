extends Control


class Bank:
	var batteries: Array[int]

	func _init(bs):
		batteries = bs


var _banks: Array[Bank]

@onready var button_part_1: Button = $VBoxContainer/VBoxContainerPart1/ButtonPart1
@onready var label_part_1: Label = $VBoxContainer/VBoxContainerPart1/LabelPart1
@onready var button_part_2: Button = $VBoxContainer/VBoxContainerPart2/ButtonPart2
@onready var label_part_2: Label = $VBoxContainer/VBoxContainerPart2/LabelPart2


func _parse_input() -> void:
	if !_banks.is_empty():
		return

	var file = FileAccess.open("res://day3/input.txt", FileAccess.READ)
	while !file.eof_reached():
		var line = file.get_line()
		if line.is_empty():
			continue

		var batteries: Array[int] = []
		for c in line.split(""):
			batteries.append(int(c))

		_banks.append(Bank.new(batteries))


func part_one() -> String:
	_parse_input()

	var joltage_sum: int = 0
	for bank in _banks:
		var sorted_batteries = bank.batteries.duplicate()
		sorted_batteries.sort()
		sorted_batteries.reverse()
		var highest_joltage = sorted_batteries[0]
		var highest_joltage_i = bank.batteries.find(highest_joltage)
		if highest_joltage_i < bank.batteries.size() - 1:
			joltage_sum += highest_joltage * 10 + bank.batteries.slice(highest_joltage_i + 1).max()
		else:
			var second_highest_joltage = sorted_batteries[1]
			joltage_sum += second_highest_joltage * 10 + highest_joltage

	return str(joltage_sum)


func part_two() -> String:
	_parse_input()

	var joltage_sum: int = 0
	for bank in _banks:
		var remaining_bank_options = bank.batteries.duplicate()
		var chosen_joltages: Array[int] = []
		for i in range(12):
			var options = remaining_bank_options.slice(0, remaining_bank_options.size() - (11 - i))
			var chosen_joltage = options.max()
			chosen_joltages.append(chosen_joltage)

			var chosen_joltage_i = remaining_bank_options.find(chosen_joltage)
			remaining_bank_options = remaining_bank_options.slice(chosen_joltage_i + 1)

		var chosen_joltage_str = chosen_joltages.reduce(func(acc, i): return acc + str(i), "")
		joltage_sum += int(chosen_joltage_str)

	return str(joltage_sum)


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
