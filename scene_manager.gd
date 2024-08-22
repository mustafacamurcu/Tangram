extends Node2D

const MENU = preload("res://menu_screen.tscn")
const LEVEL_SELECTOR = preload("res://level_selector.tscn")
const TUTORIAL = preload("res://tutorial.tscn")
const GAME = preload("res://game.tscn")

@onready var audio_stream_player = $BackgroundMusic
@onready var button_click_sfx = $MenuButtonClickSound

var menu
var level_selector
var tutorial
var game

# Called when the node enters the scene tree for the first time.
func _ready():
	menu = MENU.instantiate()
	add_child(menu)
	
	level_selector = LEVEL_SELECTOR.instantiate()
	add_child(level_selector)
	level_selector.hide()

	tutorial = TUTORIAL.instantiate()
	add_child(tutorial)
	tutorial.hide()

	audio_stream_player.play()
	# audio_stream_player.volume_db = linear_to_db(0)
	SignalBus.sfx_changed.emit(Cs.sfx_value)

	SignalBus.start_pressed.connect(_on_start_pressed)
	SignalBus.restart_pressed.connect(_on_restart_pressed)
	SignalBus.level_selection_pressed.connect(_on_level_selection_pressed)
	SignalBus.level_selected.connect(_on_level_selected)
	SignalBus.quit_pressed.connect(_on_quit_pressed)
	SignalBus.back_to_menu_pressed.connect(_on_back_to_menu_pressed)
	SignalBus.tutorial_pressed.connect(_on_tutorial_pressed)
	SignalBus.escape_pressed.connect(_on_escape_pressed)
	
	SignalBus.menu_button_clicked.connect(_on_menu_button_clicked)

func _on_menu_button_clicked():
	button_click_sfx.play()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed('escape'):
		_on_escape_pressed()

func _on_start_pressed():
	menu.hide()
	level_selector.show()

func _on_restart_pressed():
	_on_level_selected(game.level)

func _on_level_selection_pressed():
	if is_instance_valid(game):
		game.queue_free()
	menu.hide()
	level_selector.show()

func _on_level_selected(level: Level):
	level_selector.hide()
	if is_instance_valid(game):
		game.queue_free()
	game = GAME.instantiate()
	add_child(game)
	game.setup(level)

func _on_back_to_menu_pressed():
	menu.show()
	level_selector.hide()
	tutorial.hide()

func _on_quit_pressed():
	get_tree().quit()

func _on_tutorial_pressed():
	tutorial.show()
	menu.hide()

func _on_escape_pressed():
	if is_instance_valid(game):
		game.queue_free()
		level_selector.show()
	elif not menu.visible:
		level_selector.hide()
		tutorial.hide()
		menu.show()
