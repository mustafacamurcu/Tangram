extends CanvasLayer

@onready var pages = $Pages

var current_index = 0

func _ready() -> void:
	SignalBus.tutorial_pressed.connect(_on_tutorial_pressed)
	pages.get_children()[0].show()

func _on_tutorial_pressed():
	current_index = 0
	for page in pages.get_children():
		page.hide()
		page.get_child(0).speed_scale = 0
		page.get_child(0).frame = 0
	pages.get_children()[0].show()
	pages.get_children()[0].get_child(0).speed_scale = 1


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed('space') and visible:
		next_page()

func next_page():
	current_index += 1
	if current_index == pages.get_children().size():
		SignalBus.back_to_menu_pressed.emit()
		return
	pages.get_children()[current_index - 1].hide()
	pages.get_children()[current_index - 1].get_child(0).speed_scale = 0
	pages.get_children()[current_index - 1].get_child(0).frame = 0
	pages.get_children()[current_index].show()
	pages.get_children()[current_index].get_child(0).speed_scale = 1
	pages.get_children()[current_index].get_child(0).frame = 0
