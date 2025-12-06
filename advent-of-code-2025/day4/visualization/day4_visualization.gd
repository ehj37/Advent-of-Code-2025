extends Control


class Grid:
	var rows: Array

	func _init(rs):
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


const PAPER_COLOR := Color("779FA1")
const EMPTY_COLOR := Color("#88498F")
const HIGHLIGHT_COLOR := Color("FF6542")

const CELL_VALUE_TO_COLOR := {Cell.Value.PAPER: PAPER_COLOR, Cell.Value.EMPTY: EMPTY_COLOR}

var _grid: Grid
var _visualization_rows: Array
var _attempt_to_remove := false
var _paper_removed_in_current_iteration := false
var _current_cell: Cell

@onready var rows_container: VBoxContainer = $RowsContainer
@onready var button: Button = $Button


func _parse_input() -> void:
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

	var visualization_row_containers = rows_container.get_children()
	for visualization_row_container in visualization_row_containers:
		_visualization_rows.append(visualization_row_container.get_children())


func _process(_delta):
	if !_attempt_to_remove:
		return

	_single_step()


func _ready():
	_parse_input()

	for row: Array[Cell] in _grid.rows:
		var row_container = HBoxContainer.new()
		row_container.custom_minimum_size.y = 3
		row_container.add_theme_constant_override("separation", 1)
		for cell in row:
			var cell_color: Color
			match cell.value:
				Cell.Value.PAPER:
					cell_color = PAPER_COLOR
				Cell.Value.EMPTY:
					cell_color = EMPTY_COLOR
			var cell_color_rect = ColorRect.new()
			cell_color_rect.color = cell_color
			cell_color_rect.custom_minimum_size.x = 4

			row_container.add_child(cell_color_rect)
		rows_container.add_child(row_container)


func _single_step() -> void:
	if _current_cell == null:
		_current_cell = _grid.rows[0][0]

	var visualization_cell: ColorRect = _get_visualization_cell(_current_cell)
	visualization_cell.color = HIGHLIGHT_COLOR

	if _current_cell.value == Cell.Value.PAPER:
		var paper_count = 0
		for dir in Cell.Direction.values():
			if _current_cell.get_value_in_dir(dir) == Cell.Value.PAPER:
				paper_count += 1
		if paper_count < 4:
			_current_cell.value = Cell.Value.EMPTY
			visualization_cell.color = EMPTY_COLOR
			_paper_removed_in_current_iteration = true

	var updated_visualization_color = CELL_VALUE_TO_COLOR[_current_cell.value]
	get_tree().create_timer(0.05).timeout.connect(
		func(): visualization_cell.color = updated_visualization_color
	)

	var next_cell: Cell = _current_cell
	while next_cell == _current_cell || next_cell.value != Cell.Value.PAPER:
		if next_cell.x < _grid.row_length() - 1:
			next_cell = _grid.rows[next_cell.y][next_cell.x + 1]
			continue

		if next_cell.y < _grid.num_rows() - 1:
			next_cell = _grid.rows[next_cell.y + 1][0]
			continue

		if !_paper_removed_in_current_iteration:
			_attempt_to_remove = false
			return

		next_cell = _grid.rows[0][0]
		_paper_removed_in_current_iteration = false

	_current_cell = next_cell


func _get_visualization_cell(cell: Cell) -> ColorRect:
	var visualization_row_containers = rows_container.get_children()
	var relevant_row_container = visualization_row_containers[cell.y]
	return relevant_row_container.get_children()[cell.x]


func _on_button_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	_attempt_to_remove = true
	button.disabled = true
	button.visible = false
