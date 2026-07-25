extends AudioStreamPlayer2D

@export var fadeInSpeed : float = 1.0
@export var fadeOutSpeed : float = 1.0
var target_volume : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (volume_linear != target_volume):
		if (target_volume > volume_linear):
			var volumeRemaining : float = target_volume - volume_linear
			var volumeChange : float  = delta * fadeInSpeed
			if (volumeRemaining < volumeChange):
				volumeChange = volumeRemaining
			volume_linear += volumeChange
		else:
			var volumeRemaining : float = volume_linear
			var volumeChange : float  = delta * fadeOutSpeed
			if (volumeRemaining < volumeChange):
				volumeChange = volumeRemaining
			volume_linear -= volumeChange
