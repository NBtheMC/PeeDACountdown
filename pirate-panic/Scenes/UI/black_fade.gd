extends Panel

var tween : Tween

@export var fade_time : float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fade_from_black()

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
