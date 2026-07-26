extends HSlider


@export var bus_name : String
var bus_reference

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bus_reference = AudioServer.get_bus_index("Music")
	self.value = AudioServer.get_bus_volume_linear(bus_reference)

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(bus_reference, value)
