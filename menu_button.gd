extends Button

@export var signal_name: String

func _pressed():
	SignalBus[signal_name].emit()
	SignalBus.menu_button_clicked.emit()
