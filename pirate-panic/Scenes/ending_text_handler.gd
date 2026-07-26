extends Control

# 1. Create variables to temporarily store incoming data
var target_condition: String = ""
var target_message: String = ""

# 2. Get normal or unique-name references to your UI elements
@onready var ending_header = $EndingHeader # Adjust path if needed
@onready var text_label = $Text            # Adjust path if needed

func _ready() -> void:
	# 3. Safely update your UI elements now that they are ready in the tree!
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	ending_header.text = target_condition
	text_label.text = target_message
	$"Replay".pressed.connect(retry_game)

func retry_game():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
