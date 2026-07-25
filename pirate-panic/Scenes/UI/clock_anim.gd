extends Node

# progress of clock to completion (range: 0 - 1)
var progress : float = 0
# how often the clock hand ticks (in seconds)
var tick_frequency : float = 1.0
var tick_tween : Tween

# rotations (in Degrees)
@export var starting_rotation : float
@export var final_rotation : float

@export var time_until_completion : float = 10.0
var time_elapsed : float = 0.0
var last_tick : float = 0.0

@export var clock_hand : TextureRect
var sfx_clock_tick

@export var tick_sfx_min_volume : float
@export var tick_sfx_max_volume : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sfx_clock_tick = $SFX_ClockTick


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress += (1 / time_until_completion) * delta
	time_elapsed += delta
	if (progress >= 1.0): 
		progress = 1.0
		return
	
	if (time_elapsed > last_tick + tick_frequency):
		last_tick = time_elapsed
		animate_hand()
	
	sfx_clock_tick.volume_db = ((1 - progress) * tick_sfx_min_volume) + (progress * tick_sfx_max_volume)

func animate_hand() -> void:
	tick_tween = get_tree().create_tween().bind_node(self)
	var new_rotation = deg_to_rad(((1 - progress) * starting_rotation) + (progress * final_rotation))
	tick_tween.tween_property(clock_hand, "offset_transform_rotation", new_rotation, 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	sfx_clock_tick.play()
