extends Node3D
class_name LeakSystem

class Leak:
	var index: int
	var node_ref: Node3D
	var active: bool

# The minimum amount of time it takes for a leak to start
@export var LEAK_TIMER_MIN = 10
#the maximum amount of time it takes for a leak to start
@export var LEAK_TIMER_MAX = 30
# how fast the water fills up. Multipled by number of active leaks
@export var LEAK_SPEED = 0.5

var leaks: Array[Leak]
var active_leaks: int
var max_leaks: int # equal to leaks.size()
var leak_meter: float
@onready var timer: Timer = $Timer
	
func _ready() -> void:
	for n in get_children():
		if (n is LeakSpot):
			var new_leak_spot = Leak.new()
			new_leak_spot.index = leaks.size()
			new_leak_spot.node_ref = n
			new_leak_spot.active = false
			new_leak_spot.node_ref.index = new_leak_spot.index
			leaks.insert(leaks.size(), new_leak_spot)
	# print("Inserted %d leak spots" % leaks.size())
	active_leaks = 0
	max_leaks = leaks.size()

	timer.one_shot = true
	_start_timer()

func _process(delta: float) -> void:
	leak_meter += (LEAK_SPEED * active_leaks * delta)

func _start_timer():
	timer.wait_time = randi_range(LEAK_TIMER_MIN, LEAK_TIMER_MAX)
	timer.start()
	print("next leak in ", timer.wait_time, " seconds")

func _on_timer_timeout():
	print("timer timeout")
	if (active_leaks == max_leaks):
		_start_timer()
		return
		
	var index = get_random_leak_spot()
	print(index)
	start_leak(index)
	_start_timer()
	
func get_random_leak_spot():
	var random_index = randi_range(0, max_leaks-1)
	if (leaks[random_index].active):
		return get_random_leak_spot()
	else:
		return random_index
		
func start_leak(index: int):
	print("Starting leak on leak spot, ", index)
	leaks[index].active = true
	enable_damage_mesh(index)
	active_leaks+=1
	
func enable_damage_mesh(index: int):
	var leak_node = leaks[index].node_ref
	leak_node.get_node("Damaged").visible = true
	leak_node.get_node("Undamaged").visible = false

func disable_damage_mesh(index: int):
	var leak_node = leaks[index].node_ref
	leak_node.get_node("Damaged").visible = false
	leak_node.get_node("Undamaged").visible = true

func _on_leak_spot_leak_repair(index: int) -> void:
	if (!leaks[index].active):
		return
	leaks[index].active = false
	active_leaks-=1
	disable_damage_mesh(index)
