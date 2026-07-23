extends Sprite2D

@export var psyche_max_value: float = 100.0
var psyche_value
@export var psyche_loss_speed: float = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	psyche_value = psyche_max_value
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Calculate the flat amount that represents X% of the max value
	# Move value down toward 0 safely
	psyche_value -= psyche_loss_speed * delta
	
	print("psyche_value= " + str(psyche_value))
	
	if psyche_value <= 50:
		print("what the freak im scared")
	elif psyche_value <= 25:
		print("HOLY MOLY IM REALLY SCARED")
	elif psyche_value <= 0:
		on_psyche_empty()

	pass
	
func on_psyche_empty() -> void:
	print("You got possessed! SEND DEATH EVENT HERE")
