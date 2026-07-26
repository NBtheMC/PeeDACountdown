extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Main Menu Page/Start Game".pressed.connect(start_game)
	$"Main Menu Page/Credits".pressed.connect(open_credits)
	
	$"Credits Page/Back To Main Menu".pressed.connect(close_credits)

func start_game():
	get_tree().change_scene_to_file("res://Scenes/player_environment_integration.tscn")
	
func open_credits():
	$"Main Menu Page".visible = false
	$"Credits Page".visible = true
	
	$"Main Menu Page/Start Game".disabled = true
	$"Main Menu Page/Credits".disabled = true
	
	$"Credits Page/Back To Main Menu".disabled = false
	
func close_credits():
	$"Main Menu Page".visible = true
	$"Credits Page".visible = false
	
	$"Main Menu Page/Start Game".disabled = false
	$"Main Menu Page/Credits".disabled = false
	
	$"Credits Page/Back To Main Menu".disabled = true
