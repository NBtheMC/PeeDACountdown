extends Sprite2D

@export var countdown_max_value: float = 100.0
@export var countdown_low_value: float = 50.0
@export var countdown_fatal_value: float = 25.0
var countdown_value
@export var countdown_loss_speed: float = 2

enum state {NOMINAL, LOW, FATAL}
var countdown_state : state = state.NOMINAL

signal countdown_nominal
signal countdown_low
signal countdown_fatal
signal countdown_zero

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	countdown_value = countdown_max_value
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Calculate the flat amount that represents X% of the max value
	# Move value down toward 0 safely
	countdown_value -= countdown_loss_speed * delta
	
	#print("countdown_value= " + str(countdown_value))
	
	if (countdown_state != state.NOMINAL && countdown_value > countdown_low_value):
		countdown_state = state.NOMINAL
		countdown_nominal.emit()
	elif (countdown_state != state.LOW && countdown_value <= countdown_low_value && countdown_value > countdown_fatal_value):
		#print("oof getting kinda hungry")
		countdown_state = state.LOW
		countdown_low.emit()
	elif (countdown_state != state.FATAL && countdown_value <= countdown_fatal_value):
		#print("getting really hungry")
		countdown_state = state.FATAL
		countdown_fatal.emit()
	elif countdown_value <= 0:
		on_countdown_empty()

	pass
	
func on_countdown_empty() -> void:
	countdown_zero.emit()
	print("Dead from exhaustion! SEND DEATH EVENT HERE")
