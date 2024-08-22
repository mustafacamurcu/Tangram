extends HSlider

@export var signal_name: String

func _value_changed(new_value):
	SignalBus[signal_name].emit(new_value)
