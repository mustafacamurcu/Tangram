extends Control

var level: Level

@onready var area2d = $Area2D
@onready var color_rect = $ColorRect
@onready var border = $Border
@onready var border2 = $Border2
@onready var label = $ColorRect/Label

var revealed = false
var unlocked = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	border.hide()
	border2.show()
	area2d.input_event.connect(_input_event)
	area2d.mouse_entered.connect(_mouse_enter)
	area2d.mouse_exited.connect(_mouse_exit)

func set_level(l: Level):
	level = l
	label.text = str(level.number)

func unlock():
	unlocked = true
	color_rect.color = Cs.UIGREEN1

func reveal():
	if revealed:
		return
	revealed = true
	for shape in level.shapes:
		var poly = shape.to_polygon()
		poly.position = color_rect.position
		var scale_factor = level.snap_grid_pixels * 200. / level.container_edge_size
		poly.scale.x = scale_factor
		poly.scale.y = scale_factor
		add_child(poly)
	color_rect.hide()
	border.show()
	border2.hide()

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			if unlocked:
				SignalBus.level_selected.emit(level)
				SignalBus.menu_button_clicked.emit()

func _mouse_enter() -> void:
	start_animation()

func _mouse_exit() -> void:
	stop_animation()

func start_animation():
	pass

func stop_animation():
	pass
