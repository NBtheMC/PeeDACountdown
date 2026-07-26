extends Node

var hunger_death_text = "Died by hunger"
var psyche_death_text = "Died by going crazy"
var sink_death_text = "Died by sinking"
var countdown_death_text = "Died by monster"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# LOSE CONDITIONS

func _on_hunger_handler_countdown_zero() -> void:
	pass # Replace with function body.

func _on_psyche_handler_countdown_zero() -> void:
	pass # Replace with function body.

func _on_main_timer_countdown_finished() -> void:
	pass # Replace with function body.

func _on_leak_system_leak_max() -> void:
	pass # Replace with function body.

# WIN CONDITIONS

func _on_lighthouse_reached(area: Area3D) -> void:
	pass # Replace with function body.
