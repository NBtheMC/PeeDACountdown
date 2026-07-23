extends Node

var tween
var rotate_tween

# tween durations (in Seconds)
@export var spawn_time : float
@export var rotate_cycle_time : float
@export var despawn_time : float

# rotation amount (in Degrees on either side of default)
@export var rotation_amount : float

@export var icon : Texture


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureRect.scale = Vector2(0.0, 0.0)
	$TextureRect.texture = icon
	spawn()
	animate()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		despawn()

func interrupt_current_tween() -> void:
	if tween:
		tween.kill() # abort previous animation
	tween = get_tree().create_tween().bind_node(self)
	
func spawn() -> void:
	interrupt_current_tween()
	tween.tween_property($TextureRect, "scale", Vector2(1.0, 1.0), spawn_time).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
func despawn() -> void:
	interrupt_current_tween()
	tween.tween_property($TextureRect, "scale", Vector2(0.0, 0.0), despawn_time).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN)

func animate() -> void:
	rotate_tween = get_tree().create_tween().bind_node(self)
	self.rotation_degrees = -rotation_amount
	rotate_tween.set_loops() # loop infinitely
	rotate_tween.tween_property($TextureRect, "rotation_degrees", rotation_amount, rotate_cycle_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT) 
	rotate_tween.tween_property($TextureRect, "rotation_degrees", -rotation_amount, rotate_cycle_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT) 
