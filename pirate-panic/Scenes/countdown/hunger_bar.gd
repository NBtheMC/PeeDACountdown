extends TextureProgressBar

@export var hunger_loss_speed: float = 0.2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = max_value
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		# Calculate the flat amount that represents X% of the max value
	# Move value down toward 0 safely
	value -= hunger_loss_speed
	
	print("value= " + str(value))
	if value <= 0:
		on_hunger_empty()
	pass
	
func on_hunger_empty() -> void:
	print("HUNGRY!")
