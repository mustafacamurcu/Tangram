extends AudioStreamPlayer

@export var volume_factor: float = 1

func _ready() -> void:
	volume_db = linear_to_db(Cs.sfx_value / 100. * volume_factor)
	SignalBus.sfx_changed.connect(_on_sfx_changed)

func _on_sfx_changed(value):
	volume_db = linear_to_db(value / 100. * volume_factor)
	SignalBus.menu_button_clicked.emit()