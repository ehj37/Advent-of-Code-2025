extends Control

var _red_tile_positions: Array[Vector2] = []
var _polygon: Polygon2D

@onready var button_part_1: Button = $VBoxContainer/VBoxContainerPart1/ButtonPart1
@onready var label_part_1: Label = $VBoxContainer/VBoxContainerPart1/LabelPart1
@onready var button_part_2: Button = $VBoxContainer/VBoxContainerPart2/ButtonPart2
@onready var label_part_2: Label = $VBoxContainer/VBoxContainerPart2/LabelPart2


func _parse_input() -> void:
	var file = FileAccess.open("res://day9/input.txt", FileAccess.READ)
	# var file = FileAccess.open("res://day9/example_1.txt", FileAccess.READ)

	while !file.eof_reached():
		var line = file.get_line()
		if line.is_empty():
			continue

		var coord_strs = line.split(",")
		var coords = Vector2(int(coord_strs[0]), int(coord_strs[1]))
		_red_tile_positions.append(coords)

	_polygon = Polygon2D.new()
	_polygon.set_polygon(PackedVector2Array(_red_tile_positions))


func part_one() -> String:
	_parse_input()

	var largest_area = -INF
	for i in range(_red_tile_positions.size()):
		var red_tile_position = _red_tile_positions[i]
		var candidate_red_tile_positions = _red_tile_positions.slice(
			i + 1, _red_tile_positions.size()
		)
		for j in range(candidate_red_tile_positions.size()):
			var candidate_red_tile_position = candidate_red_tile_positions[j]

			var rect = Rect2(Vector2.ZERO, candidate_red_tile_position - red_tile_position)
			rect.position = candidate_red_tile_position
			var area = (abs(rect.size.x) + 1) * (abs(rect.size.y) + 1)
			if area > largest_area:
				largest_area = area

	return str(int(largest_area))


func part_two() -> String:
	_parse_input()

	var largest_area = -INF
	for i in range(_red_tile_positions.size()):
		var red_tile_position = _red_tile_positions[i]
		var candidate_red_tile_positions = _red_tile_positions.slice(
			i + 1, _red_tile_positions.size()
		)
		for j in range(candidate_red_tile_positions.size()):
			var candidate_red_tile_position = candidate_red_tile_positions[j]

			var min_x = min(red_tile_position.x, candidate_red_tile_position.x)
			var max_x = max(red_tile_position.x, candidate_red_tile_position.x)
			var min_y = min(red_tile_position.y, candidate_red_tile_position.y)
			var max_y = max(red_tile_position.y, candidate_red_tile_position.y)

			var upper_left_point = Vector2(min_x, min_y)
			var upper_right_point = Vector2(max_x, min_y)
			var bottom_left_point = Vector2(min_x, max_y)
			var bottom_right_point = Vector2(max_x, max_y)
			var rect_points = PackedVector2Array(
				[upper_left_point, upper_right_point, bottom_left_point, bottom_right_point]
			)

			if !Geometry2D.clip_polygons(rect_points, _polygon.polygon).is_empty():
				continue

			var area = (max_x - min_x + 1) * (max_y - min_y + 1)
			if area > largest_area:
				largest_area = area

	return str(int(largest_area))


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
