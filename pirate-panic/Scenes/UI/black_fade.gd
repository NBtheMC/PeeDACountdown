extends Panel
class_name Fade

var tween : Tween

@export var fade_time : float = 2.0
@export var endgame_handler : Node

@export var win : bool = false
var game_ending : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (win):
		fade_from_white()
		return
		
	fade_from_black()

func beat_game_routine() -> void:
	if (game_ending) : return
	game_ending = true
	start_new_tween()
	$SFX_Win_Game.play()
	tween.tween_property(self, "self_modulate", Color(1, 1, 1, 0), 0.0)
	tween.tween_property(self, "self_modulate", Color(1, 1, 1, 1), fade_time).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(EndgameHandler.end_game.bind("You made it!", "You reached land!"))
	tween.tween_property(self, "self_modulate", Color(1, 1, 1, 0), fade_time).set_trans(Tween.TRANS_LINEAR)

func lose_game_routine(condition: String, text: String) -> void:
	if (game_ending) : return
	game_ending = true
	start_new_tween()
	print("LOST GAME")
	$SFX_Lose_Game.play()
	tween.tween_property(self, "self_modulate", Color(0, 0, 0, 0), 0.0)
	tween.tween_property(self, "self_modulate", Color(0, 0, 0, 1), fade_time).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(EndgameHandler.end_game.bind(condition, text))
	tween.tween_property(self, "self_modulate", Color(0, 0, 0, 0), fade_time).set_trans(Tween.TRANS_LINEAR)

func start_new_tween() -> void:
	if tween:
		tween.kill() # abort previous animation
	tween = get_tree().create_tween().bind_node(self)

func fade_from_black() -> void:
	start_new_tween()
	tween.tween_property(self, "self_modulate", Color(0, 0, 0, 1), 0.0)
	tween.tween_property(self, "self_modulate", Color(0, 0, 0, 0), fade_time).set_trans(Tween.TRANS_LINEAR)

func fade_to_black() -> void:
	start_new_tween()
	tween.tween_property(self, "self_modulate", Color(0, 0, 0, 0), 0.0)
	tween.tween_property(self, "self_modulate", Color(0, 0, 0, 1), fade_time).set_trans(Tween.TRANS_LINEAR)

func fade_to_white() -> void:
	start_new_tween()
	tween.tween_property(self, "self_modulate", Color(1, 1, 1, 0), 0.0)
	tween.tween_property(self, "self_modulate", Color(1, 1, 1, 1), fade_time).set_trans(Tween.TRANS_LINEAR)

func fade_from_white() -> void:
	start_new_tween()
	tween.tween_property(self, "self_modulate", Color(1, 1, 1, 1), 0.0)
	tween.tween_property(self, "self_modulate", Color(1, 1, 1, 0), fade_time).set_trans(Tween.TRANS_LINEAR)
