extends Node

# hunger + psyche signals
@export var hunger_nominal : Signal
@export var hunger_low : Signal
@export var hunger_fatal: Signal
@export var psyche_nominal : Signal
@export var psyche_low : Signal
@export var psyche_fatal : Signal

var hunger_status : int = 0
var psyche_status : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#hunger_nominal.connect(set_hunger_status.bind(0))
	#hunger_low.connect(set_hunger_status.bind(1))
	#hunger_fatal.connect(set_hunger_status.bind(2))
	#psyche_nominal.connect(set_psyche_status.bind(0))
	#psyche_low.connect(set_psyche_status.bind(1))
	#psyche_fatal.connect(set_psyche_status.bind(2))
	
func set_hunger_status(status: int):
	hunger_status = status
	print("hunger status is", status)
	set_psyche_layer_volume()
	
func set_psyche_status(status: int):
	psyche_status = status
	print("psyche status is", status)
	set_psyche_layer_volume()
	
func set_psyche_layer_volume():
	var highest_status : int = maxi(hunger_status, psyche_status)
	match highest_status:
		0:
			print("music volume 0")
			$"Music-PsycheLayer".target_volume = 0.0
		1:
			print("music volume 0.6")
			$"Music-PsycheLayer".target_volume = 0.6
		2:
			print("music volume 1.0")
			$"Music-PsycheLayer".target_volume = 1.0
