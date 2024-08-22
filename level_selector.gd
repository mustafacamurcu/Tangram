extends CanvasLayer

const LEVEL_BUTTON = preload("res://level_button.tscn")

@onready var grid = $VBox/GridMargin/GridContainer

var levels = Cs.LEVELS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.level_completed.connect(_on_level_completed)

	for i in range(levels.size()):
		var level = levels[i]
		var button = LEVEL_BUTTON.instantiate()
		grid.add_child(button)
		button.set_level(level)
	
	grid.get_child(0).unlock()

func _on_level_completed(level: Level):
	grid.get_child(level.number - 1).reveal()

	if level.number != levels.size():
		grid.get_child(level.number).unlock()
