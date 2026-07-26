extends Node

@export var ending_scene : PackedScene

var lose_text = "LOSE"
var win_text = "WIN"

var hunger_death_text = "Died by hunger"
var psyche_death_text = "Died by going crazy"
var sink_death_text = "Died by sinking"
var countdown_death_text = "Died by monster"
var lighthouse_victory_text = "Reached the lighthouse"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func end_game(condition: String, text: String) -> void:
	var end_scene_instance = ending_scene.instantiate()
	end_scene_instance.target_condition = condition
	end_scene_instance.target_message = text
	get_tree().root.add_child(end_scene_instance)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = end_scene_instance
	pass

# LOSE CONDITIONS
func _on_hunger_handler_countdown_zero() -> void:
	end_game("You Died", hunger_death_text)
	pass # Replace with function body.

func _on_psyche_handler_countdown_zero() -> void:
	end_game("You Died", psyche_death_text)
	pass # Replace with function body.

func _on_main_timer_countdown_finished() -> void:
	end_game("You Died", countdown_death_text)
	pass # Replace with function body.

func _on_leak_system_leak_max() -> void:
	end_game("You Died", sink_death_text)
	pass # Replace with function body.

# WIN CONDITIONS
func _on_lighthouse_reached(area: Area3D) -> void:
	end_game("You Won", sink_death_text)
	pass # Replace with function body.
