extends Control


class Grid:
	var rows: Array

	func _init(rs):
		# Where rows is an array of an array of cells
		rows = rs

	func num_rows() -> int:
		return rows.size()

	func row_length() -> int:
		return rows[0].size()


class Cell:
	enum Direction { U, UR, R, DR, D, DL, L, UL }
	enum Value { PAPER, EMPTY, INVALID }

	var grid: Grid
	var x: int
	var y: int
	var value: Value

	func _init(g, new_x, new_y, v):
		grid = g
		x = new_x
		y = new_y
		value = v

	func get_value_in_dir(dir: Direction) -> Value:
		var value_x: int
		var value_y: int
		match dir:
			Direction.U:
				value_x = x
				value_y = y - 1
			Direction.UR:
				value_x = x + 1
				value_y = y - 1
			Direction.R:
				value_x = x + 1
				value_y = y
			Direction.DR:
				value_x = x + 1
				value_y = y + 1
			Direction.D:
				value_x = x
				value_y = y + 1
			Direction.DL:
				value_x = x - 1
				value_y = y + 1
			Direction.L:
				value_x = x - 1
				value_y = y
			Direction.UL:
				value_x = x - 1
				value_y = y - 1

		var invalid_x = value_x < 0 || value_x >= grid.row_length()
		var invalid_y = value_y < 0 || value_y >= grid.num_rows()
		if invalid_x || invalid_y:
			return Value.INVALID

		return grid.rows[value_y][value_x].value


var _grid: Grid

@onready var button_part_1: Button = $VBoxContainer/VBoxContainerPart1/ButtonPart1
@onready var label_part_1: Label = $VBoxContainer/VBoxContainerPart1/LabelPart1
@onready var button_part_2: Button = $VBoxContainer/VBoxContainerPart2/ButtonPart2
@onready var label_part_2: Label = $VBoxContainer/VBoxContainerPart2/LabelPart2


func _parse_input() -> void:
	if _grid != null:
		return

	_grid = Grid.new([])

	var file = FileAccess.open("res://day4/input.txt", FileAccess.READ)
	#var file = FileAccess.open("res://day4/example_1.txt", FileAccess.READ)
	var line_num = 0
	var rows = []
	while !file.eof_reached():
		var line = file.get_line()
		if line.is_empty():
			continue

		var row: Array[Cell] = []
		var split_line = line.split("")
		for i in range(split_line.size()):
			var c = split_line[i]
			match c:
				"@":
					row.append(Cell.new(_grid, i, line_num, Cell.Value.PAPER))
				".":
					row.append(Cell.new(_grid, i, line_num, Cell.Value.EMPTY))

		_grid.rows.append(row)
		line_num += 1


func part_one() -> String:
	_parse_input()

	var accessible_paper_count = 0
	for row: Array[Cell] in _grid.rows:
		for cell in row:
			if cell.value != Cell.Value.PAPER:
				continue

			var paper_count = 0
			for dir in Cell.Direction.values():
				if cell.get_value_in_dir(dir) == Cell.Value.PAPER:
					paper_count += 1
			if paper_count < 4:
				accessible_paper_count += 1

	return str(accessible_paper_count)


func part_two() -> String:
	_parse_input()

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
