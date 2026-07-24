extends Sprite2D

@export var hunger_max_value: float = 100.0
@export var hunger_low_value: float = 50.0
@export var hunger_fatal_value: float = 25.0
var hunger_value
@export var hunger_loss_speed: float = 2

enum state {NOMINAL, LOW, FATAL}
var hunger_state : state = state.NOMINAL

signal hunger_nominal
signal hunger_low
signal hunger_fatal
signal hunger_zero

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hunger_value = hunger_max_value
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Calculate the flat amount that represents X% of the max value
	# Move value down toward 0 safely
	hunger_value -= hunger_loss_speed * delta
	
	#print("hunger_value= " + str(hunger_value))
	
	if (hunger_state != state.NOMINAL && hunger_value > hunger_low_value):
		hunger_state = state.NOMINAL
		hunger_nominal.emit()
	elif (hunger_state != state.LOW && hunger_value <= hunger_low_value && hunger_value > hunger_fatal_value):
		#print("oof getting kinda hungry")
		hunger_state = state.LOW
		hunger_low.emit()
	elif (hunger_state != state.FATAL && hunger_value <= hunger_fatal_value):
		#print("getting really hungry")
		hunger_state = state.FATAL
		hunger_fatal.emit()
	elif hunger_value <= 0:
		on_hunger_empty()

	pass
	
func on_hunger_empty() -> void:
	hunger_zero.emit()
	print("Dead from exhaustion! SEND DEATH EVENT HERE")
