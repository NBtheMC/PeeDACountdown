extends Sprite2D

@export var hunger_max_value: float = 100.0
var hunger_value
@export var hunger_loss_speed: float = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hunger_value = hunger_max_value
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Calculate the flat amount that represents X% of the max value
	# Move value down toward 0 safely
	hunger_value -= hunger_loss_speed
	
	print("hunger_value= " + str(hunger_value))
	
	if hunger_value <= 50:
		print("oof getting kinda hungry")
	elif hunger_value <= 25:
		print("getting really hungry")
	elif hunger_value <= 0:
		on_hunger_empty()

	pass
	
func on_hunger_empty() -> void:
	print("Dead from exhaustion! SEND DEATH EVENT HERE")
