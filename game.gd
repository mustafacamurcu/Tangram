extends Node2D

const PIECE = preload("res://piece.tscn")

@onready var pieces = $Pieces
@onready var put_down_sfx = $PutDownBoard
@onready var win_sfx = $WinSound
@onready var you_won = $YouWon
@onready var particles = $Particles
@onready var flavor = $YouWon/PanelContainer/VBoxContainer/MarginContainer3/Flavor

@onready var smoke = $Smoke
@onready var snow = $Snow
@onready var camels = $Camels

var won = false

var container: Polygon2D
var piece_box: Polygon2D
var points: Array[Vector2i]
var edges: Array[Array]
var bads: Array[Vector2i]
var adjacency: Dictionary

var level: Level

func _on_piece_picked_up(piece: Piece):
	pieces.move_child(piece, -1)

func _on_piece_put_down(_piece: Piece):
	put_down_sfx.play()
	if check_for_win():
		win()

func win():
	if won:
		return
	won = true
	you_won.show()
	flavor.visible_ratio = 0
	create_tween().tween_property(flavor, "visible_ratio", 1., flavor.text.length() / 25)
	win_sfx.play()
	for particle: CPUParticles2D in particles.get_children():
		particle.emitting = true
	SignalBus.level_completed.emit(level)

	if level.number == 1:
		smoke.emitting = true
	if level.number == 2:
		for piece in pieces.get_children():
			if piece.shape_id == 0:
				pieces.move_child(piece, -1)
				piece.heartbeat()
				break
	if level.number == 3:
		for piece in pieces.get_children():
			if piece.shape_id == 5 or piece.shape_id == 4:
				pieces.move_child(piece, -1)
				piece.sway()
	if level.number == 4:
		camels.show()
		var cs = camels.get_children()
		var tween = create_tween().set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN)
		tween.set_loops()
		tween.tween_property(cs[0], "rotation", 0.07, 1)
		tween.parallel().tween_property(cs[1], "rotation", 0.07, 1)
		tween.parallel().tween_property(cs[2], "rotation", 0.07, 1)
		tween.tween_property(cs[0], "rotation", -0.07, 1)
		tween.parallel().tween_property(cs[1], "rotation", -0.07, 1)
		tween.parallel().tween_property(cs[2], "rotation", -0.07, 1)
	if level.number == 5:
		snow.emitting = true

func check_for_win():
	var overlap = false
	for piece1 in pieces.get_children():
		for piece2 in pieces.get_children():
			if piece1 != piece2:
				var intersect = Geometry2D.intersect_polygons(piece1.get_global_polygon(), piece2.get_global_polygon())
				if intersect.size() != 0:
					var a = 0
					for poly in intersect:
						a += Cs.polygon_area(poly)
					if a > 1:
						overlap = true
	if overlap:
		return false
	
	# Globalize container
	var container_polygon = []
	for point in container.polygon:
		container_polygon.append(container.to_global(point))

	# Win if (Total Piece Area) == (Total Piece Area within Square) == (Square Area)
	var square_area = level.container_edge_size * level.container_edge_size

	var total_area = 0
	for piece in pieces.get_children():
		total_area += Cs.polygon_area(piece.get_global_polygon())

	var total_area_within_square = 0
	for piece in pieces.get_children():
		var intersect = Geometry2D.intersect_polygons(piece.get_global_polygon(), container_polygon)
		for poly in intersect:
			total_area_within_square += Cs.polygon_area(poly)
		
	# approx equality to prevent floating point errors
	return abs(square_area - total_area) < 1 and abs(total_area - total_area_within_square) < 1

func setup(level_: Level):
	level = level_
	flavor.text = level.flavor_text
	create_container()
	create_frame()
	create_pieces()
	# create_piece_box()

func create_container():
	var half = level.container_edge_size / 2
	container = Polygon2D.new()
	container.polygon = PackedVector2Array([
		Vector2i(-half, half),
		Vector2i(-half, -half),
		Vector2i(half, -half),
		Vector2i(half, half)
	])
	var offset = Vector2i(-Cs.SCREEN_WIDTH / 4 + 40, -20)
	container.position = Cs.snap_to_grid(offset, level.snap_grid_pixels)
	container.color = Cs.WHITE1
	add_child(container)
	container.z_index = -2

func create_frame():
	var cross = Polygon2D.new()
	var width = 10
	var half = level.container_edge_size / 2
	cross.polygon = PackedVector2Array([
		Vector2i(-width, -half),
		Vector2i(+ width, -half),
		Vector2i(+ width, -width),
		Vector2i(half, -width),
		Vector2i(half, + width),
		Vector2i(+ width, + width),
		Vector2i(+ width, + half),
		Vector2i(-width, + half),
		Vector2i(-width, + width),
		Vector2i(-half, + width),
		Vector2i(-half, -width),
		Vector2i(-width, -width),
	])
	cross.color = Color.hex(0x664433FF)
	cross.position = container.position
	add_child(cross)
	cross.z_index = -1
	
	var frame = Polygon2D.new()
	frame.polygon = container.polygon.duplicate()
	frame.position = container.position
	frame.scale = Vector2(1.08, 1.08)
	frame.color = Color.hex(0x664433FF)
	add_child(frame)
	frame.z_index = -3

	var frame2 = Polygon2D.new()
	frame2.polygon = container.polygon.duplicate()
	frame2.position = container.position
	frame2.scale = Vector2(1.2, 1.2)
	frame2.color = Color.hex(0x8a5a42FF)
	add_child(frame2)
	frame2.z_index = -4

	var frame_half_height = frame2.to_global(frame2.polygon[0]).distance_to(frame2.to_global(frame2.polygon[1])) / 2

	var sill = Polygon2D.new()
	var w = level.container_edge_size * 0.68
	var h = 35
	sill.polygon = PackedVector2Array([
		Vector2i(-w, -h),
		Vector2i(+ w, -h),
		Vector2i(+ w, + h),
		Vector2i(-w, + h),
	])
	sill.color = Color.hex(0x664433FF)
	sill.position = container.position + Vector2(0, frame_half_height + h)
	sill.z_index = -5
	add_child(sill)


func create_piece_box():
	var scale = 0.9
	var width = int(Cs.SCREEN_WIDTH / 2 * scale) / level.snap_grid_pixels * level.snap_grid_pixels
	var height = int(Cs.SCREEN_HEIGHT * scale) / level.snap_grid_pixels * level.snap_grid_pixels
	piece_box = Polygon2D.new()
	piece_box.polygon = PackedVector2Array([
		Vector2i(0, height),
		Vector2i(0, 0),
		Vector2i(width, 0),
		Vector2i(width, height)
	])
	var offset = Vector2(Cs.SCREEN_WIDTH / 4, 0)
	piece_box.position = Cs.snap_to_grid(Vector2(-width / 2, -height / 2) + offset, level.snap_grid_pixels)
	piece_box.color = Cs.GRAY
	add_child(piece_box)
	piece_box.z_index = -2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.piece_picked_up.connect(_on_piece_picked_up)
	SignalBus.piece_put_down.connect(_on_piece_put_down)
	SignalBus.next_level_pressed.connect(_on_next_level_pressed)

func _on_next_level_pressed():
	SignalBus.level_selected.emit(Cs.LEVELS[level.number % 10])

func create_pieces():
	for shape_id in range(level.shapes.size()):
		var shape = level.shapes[shape_id]
		var poly = shape.polygon.duplicate()
		# translate grid points to pixel points
		for i in range(poly.size()):
			poly[i] *= level.snap_grid_pixels

		var center = Vector2i(0, 0)
		for p in poly:
			center += p
		center /= poly.size()

		var pivot = poly[0]
		for p in poly:
			if p.distance_to(center) < pivot.distance_to(center):
				pivot = p
		
		for i in range(poly.size()):
			poly[i] -= pivot
		
		var piece = PIECE.instantiate()
		pieces.add_child(piece)
		piece.position = shape.position * level.snap_grid_pixels
		piece.rotation_degrees = shape.rotation
		piece.scale.x = shape.scale
		piece.scale.y = shape.scale
		piece.shape_id = shape_id
		piece.set_polygon(PackedVector2Array(poly), level, shape.color)
		piece.container = container
		piece.pivot = pivot


func get_global_container_polygon():
	var ps = PackedVector2Array()
	for p in container.polygon:
		ps.append(container.to_global(p))
	return ps

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed('restart'):
		SignalBus.restart_pressed.emit()

func _draw() -> void:
	# for i in range(1, level.grid_size):
	# 	for j in range(1, level.grid_size):
	# 		draw_circle(Vector2(i * level.snap_grid_pixels, j * level.snap_grid_pixels) -
	# 								Vector2(level.container_edge_size / 2, level.container_edge_size / 2), 3, Cs.BLUE)
	# for poly in polygons:
	# 	var c = Cs.COLORS.pick_random()
	# 	for edge in poly:
	# 		draw_line(edge[0], edge[1], Cs.BLUE, 3)
	# for p in points:
	# 	draw_circle(to_global(p), 3, Cs.RED)
	pass
