extends Area2D
class_name Piece

@onready var polygon_shape: CollisionPolygon2D = $CollisionPolygon2D

var polygon

var mouse_on_me = false
var dragging = false
var dragging_spot
var picked_up_from
var rotation_pivot

var container
var level: Level
var shape_id
var pivot

func _ready() -> void:
	SignalBus.level_completed.connect(_on_level_completed)

func _on_settle_finished():
	if level.number == 6:
		if shape_id == 5 or shape_id == 6:
			get_parent().move_child(self, -1)
			position += polygon.polygon[7]
			for i in range(polygon.polygon.size()):
				polygon.polygon[i] -= polygon.polygon[7]
			
			var tween = create_tween().set_trans(Tween.TRANS_SINE)
			tween.set_loops()
			tween.tween_property(self, "scale", Vector2(.65, 1), 0.6)
			tween.tween_property(self, "scale", Vector2.ONE, 0.6)

func _on_level_completed(_l: Level):
	var new_pos = container.position + Vector2(-level.container_edge_size / 2, -level.container_edge_size / 2) + Vector2(pivot)
	var tween = create_tween()
	rotation_degrees = int(rotation_degrees) % 360
	tween.tween_property(self, "position", new_pos, 0.8).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "rotation", 0, 0.8).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "scale", Vector2.ONE, 0.8).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).finished.connect(_on_settle_finished)


func sway():
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.set_loops()
	tween.tween_property(self, "position", position + Vector2(0, -15), 0.6)
	tween.parallel().tween_property(self, "rotation", 0.07, 0.6)
	tween.tween_property(self, "position", position + Vector2(0, + 15), 0.6)
	tween.parallel().tween_property(self, "rotation", 0, 0.6)
	tween.tween_property(self, "position", position + Vector2(0, -15), 0.6)
	tween.parallel().tween_property(self, "rotation", -.07, 0.6)
	tween.tween_property(self, "position", position + Vector2(0, + 15), 0.6)
	tween.parallel().tween_property(self, "rotation", 0, 0.6)

func heartbeat():
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "scale", Vector2.ONE * 1.2, 0.2).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "scale", Vector2.ONE * 1, 0.2).set_trans(Tween.TRANS_QUINT)
	tween.tween_interval(.1)
	tween.tween_property(self, "scale", Vector2.ONE * 1.2, 0.2).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "scale", Vector2.ONE * 1, 0.2).set_trans(Tween.TRANS_QUINT)
	tween.tween_interval(.5)

func get_global_polygon():
	var points = []
	for point in polygon.polygon:
		points.append(to_global(point))
	return points

func set_polygon(points: PackedVector2Array, level_, c):
	level = level_
	polygon = Polygon2D.new()
	polygon.polygon = points
	polygon.color = c
	polygon.color.a = 0.8
	add_child(polygon)
	# Area2D polygon for mouse events
	polygon_shape.polygon = polygon.polygon

func _process(_delta: float) -> void:
	if dragging:
		position = get_global_mouse_position() - dragging_spot

func expand():
	var center_before = Vector2.ZERO
	for p in polygon.polygon:
		center_before += to_global(p)
	center_before /= polygon.polygon.size()
	scale.x += .25
	scale.y += .25
	var area = Cs.polygon_area(get_global_polygon())
	if area > (level.container_edge_size) * (level.container_edge_size) / 2:
		scale.x -= .25
		scale.y -= .25
		return
	var center_after = Vector2.ZERO
	for p in polygon.polygon:
		center_after += to_global(p)
	center_after /= polygon.polygon.size()
	position += center_before - center_after
	SignalBus.piece_put_down.emit(self)

func shrink():
	if scale.x < 0.3:
		return
	var center_before = Vector2.ZERO
	for p in polygon.polygon:
		center_before += to_global(p)
	center_before /= polygon.polygon.size()
	scale.x -= .25
	scale.y -= .25
	var center_after = Vector2.ZERO
	for p in polygon.polygon:
		center_after += to_global(p)
	center_after /= polygon.polygon.size()
	position += center_before - center_after
	SignalBus.piece_put_down.emit(self)

func rotate_in_place(deg):
	var center_before = Vector2.ZERO
	for p in polygon.polygon:
		center_before += to_global(p)
	center_before /= polygon.polygon.size()
	rotation_degrees -= deg
	var center_after = Vector2.ZERO
	for p in polygon.polygon:
		center_after += to_global(p)
	center_after /= polygon.polygon.size()
	position += center_before - center_after
	SignalBus.piece_put_down.emit(self)

func _unhandled_key_input(event: InputEvent) -> void:
	if mouse_on_me:
		if event.is_action_pressed('big'):
			expand()
			get_viewport().set_input_as_handled()
		if event.is_action_pressed('small'):
			shrink()
			get_viewport().set_input_as_handled()
		if event.is_action_pressed('left'):
			rotate_in_place(-90)
			get_viewport().set_input_as_handled()
		if event.is_action_pressed('right'):
			rotate_in_place(90)
			get_viewport().set_input_as_handled()
		if event.is_action_pressed('space'):
			var new_pos = container.position + Vector2(-level.container_edge_size / 2, -level.container_edge_size / 2) + Vector2(pivot)
			var tween = create_tween()
			rotation_degrees = int(rotation_degrees) % 360
			tween.tween_property(self, "position", new_pos, 0.8).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			tween.parallel().tween_property(self, "rotation", 0, 0.8).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			tween.parallel().tween_property(self, "scale", Vector2.ONE, 0.8).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			if mouse_on_me:
				dragging = true
				dragging_spot = get_global_mouse_position() - global_position
				picked_up_from = position
				SignalBus.piece_picked_up.emit(self)
				get_viewport().set_input_as_handled()
		elif event.is_released():
			if dragging:
				position = Cs.snap_to_grid(position, level.snap_grid_pixels)
				SignalBus.piece_put_down.emit(self)
				dragging = false
				print(", ", str(scale.x), ", Vector2i", str(position / float(level.snap_grid_pixels)), ", ", str(rotation_degrees))
				print("shape id: ", shape_id)

func _mouse_enter() -> void:
	mouse_on_me = true

func _mouse_exit() -> void:
	mouse_on_me = false
