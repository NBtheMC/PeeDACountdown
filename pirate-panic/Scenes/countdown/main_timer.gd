extends Node

# 1. Define the custom signals that others will listen to
signal obstacle_event_triggered(extra_data)
signal countdown_finished

@export var total_time: float = 120.0

var obstacle_timer: Timer
var countdown_timer: Timer

# Configure your time boundaries (in seconds)
@export var min_variable_time: float = 1.0
@export var max_variable_time: float = 5.0

func _ready() -> void:
	# 2. Setup and add the obstacle_timer dynamically
	obstacle_timer = Timer.new()
	countdown_timer  = Timer.new()
	
	add_child(obstacle_timer)
	obstacle_timer.one_shot = true
	
	add_child(countdown_timer)
	countdown_timer.wait_time = total_time
	countdown_timer.one_shot = true
	
	# 3. Connect the obstacle_timer's timeout to our local function
	obstacle_timer.timeout.connect(_on_obstacle_timer_timeout)
	obstacle_timer.start()
	
	countdown_timer.start()
	
	# Start the very first cycle
	_start_next_cycle()

func _start_next_cycle() -> void:
	# 4. Pick a new random time duration
	var random_wait_time = randf_range(min_variable_time, max_variable_time)
	obstacle_timer.start(random_wait_time)

func _on_obstacle_timer_timeout() -> void:
	# 5. Emit the event and pass any relevant data (like a string or number)
	obstacle_event_triggered.emit("Obstacle Event fired!")
	
	# 6. Restart the cycle with a brand new random time
	_start_next_cycle()

func _on_internal_timer_timeout() -> void:
	# 7. Emit your custom event when the internal timer hits 0
	countdown_finished.emit()
	print("Countdown Event fired!")

# PUBLIC METHOD: Other scripts call this to read the current time left
func get_time_left() -> float:
	if countdown_timer:
		return countdown_timer.time_left
	return 0.0

# PUBLIC METHOD: Returns a clean, rounded integer version of the time left
func get_time_left_seconds() -> int:
	if countdown_timer:
		return ceili(countdown_timer.time_left)
	return 0
