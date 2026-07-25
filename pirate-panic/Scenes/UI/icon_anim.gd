extends Node

var tween : Tween
var rotate_tween : Tween
var afterimage_tween : Tween

# tween durations (in Seconds)
@export var spawn_time : float
@export var rotate_cycle_time : float
@export var despawn_time : float
@export var afterimage_time : float

# rotation amount (in Degrees on either side of default)
@export var rotation_amount : float

# afterimage vars for fatal warning
@export var afterimage_init_scale : float = 1.0
@export var afterimage_final_scale : float
@export var afterimage_init_modulate : Color = Color(1, 1, 1, 1)
@export var afterimage_final_modulate : Color = Color(1, 1, 1, 0)

# texture field that is passed to child TextureRect
@export var icon : Texture
@export var fatal_icon : Texture

@export var nominal_warning_signal : Signal
@export var low_warning_signal : Signal
@export var fatal_warning_signal : Signal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Icon.scale = Vector2(0.0, 0.0) # vanish on start
	
	#nominal_warning_signal.connect(stop_warning)
	#low_warning_signal.connect(start_warning)
	#low_warning_signal.connect(stop_fatal_warning)
	#fatal_warning_signal.connect(start_fatal_warning)

### PUBLIC CALL FUNCTIONS ###
func start_warning() -> void:
	$SFX_Warning.play()
	update_texture(icon)
	spawn()
	anim_wiggle()

func stop_warning() -> void:
	stop_wiggle()
	despawn()

func start_fatal_warning() -> void:
	$SFX_Fatal.play()
	update_texture(fatal_icon)
	anim_afterimage()

func stop_fatal_warning() -> void:
	update_texture(icon)
	stop_afterimage()

### TWEEN STUFF ###
func update_texture(texture : Texture):
	$Icon.texture = texture
	$AfterImage.texture = texture

func interrupt_current_tween() -> void:
	if tween:
		tween.kill() # abort previous animation
	tween = get_tree().create_tween().bind_node(self)
	
func spawn() -> void:
	interrupt_current_tween()
	tween.tween_property($Icon, "scale", Vector2(1.0, 1.0), spawn_time).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
func despawn() -> void:
	interrupt_current_tween()
	tween.tween_property($Icon, "scale", Vector2(0.0, 0.0), despawn_time).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN)

func anim_afterimage() -> void:
	$AfterImage.visible = true
	afterimage_tween = get_tree().create_tween().bind_node(self)
	afterimage_tween.set_loops() # loop infinitely
	# Reset cycle
	afterimage_tween.tween_property($AfterImage, "modulate", afterimage_init_modulate, 0.0).set_trans(Tween.TRANS_LINEAR)
	afterimage_tween.parallel().tween_property($AfterImage, "scale", Vector2(afterimage_init_scale, afterimage_init_scale), 0.0).set_trans(Tween.TRANS_LINEAR)
	# Afterimage tweens
	afterimage_tween.tween_property($AfterImage, "modulate", afterimage_final_modulate, afterimage_time).set_trans(Tween.TRANS_LINEAR)
	afterimage_tween.parallel().tween_property($AfterImage, "scale", Vector2(afterimage_final_scale, afterimage_final_scale), afterimage_time).set_trans(Tween.TRANS_LINEAR)

	
func stop_afterimage() -> void:
	$AfterImage.visible = false
	if (afterimage_tween): afterimage_tween.kill()

func anim_wiggle() -> void:
	rotate_tween = get_tree().create_tween().bind_node(self)
	rotate_tween.set_loops() # loop infinitely
	rotate_tween.tween_property($Icon, "rotation_degrees", rotation_amount, rotate_cycle_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT) 
	rotate_tween.tween_property($Icon, "rotation_degrees", -rotation_amount, rotate_cycle_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func stop_wiggle() -> void:
	if (rotate_tween): rotate_tween.kill()
