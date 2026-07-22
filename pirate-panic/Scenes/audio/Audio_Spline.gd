extends Path3D

@export var player : Node3D
@export var follow : PathFollow3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var progress = curve.get_closest_offset(to_local(player.position))
	follow.progress = progress
