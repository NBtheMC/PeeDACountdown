extends Node

# progress of clock to completion (range: 0 - 1)
var progress : float = 0

# rotations (in Degrees)
@export var starting_rotation : float
@export var final_rotation : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ClockHand.offset_transform_rotation = deg_to_rad(((1 - progress) * starting_rotation) + (progress * final_rotation))
	progress += 0.1 * delta
	if (progress >= 1.0): progress = 1.0
