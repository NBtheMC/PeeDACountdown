extends Node3D

@export var start_position : Vector3
@export var end_position : Vector3

@export var time_limit : float # in seconds
var current_time : float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_time += delta
	self.position = lerp(start_position, end_position, clamp(current_time/time_limit, 0.0, 1.0))
