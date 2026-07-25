extends StaticBody3D
class_name RowingObject

@export var total_distance: float = 100.0
@export var rowing_speed: float = 3.0 # How much distance is added per second

@export var rowing_text: Node

@export var oar_animation_player: AnimationPlayer
# Stores the dynamically detected animation name
var oar_anim: String = ""

var rowed_distance: float = 0.0
var is_rowing: bool = false
@export var world_objects: Node3D

func _ready() -> void:
	# 1. Ensure the animation machine is dead-silent on load
	oar_animation_player.stop()
	
	# 2. Grab the first animation name dynamically from the library
	var anim_list = oar_animation_player.get_animation_list()
	if anim_list.size() > 0:
		oar_anim = anim_list[0]
		var anim_resource : Animation = oar_animation_player.get_animation(oar_anim)
		if anim_resource:
			anim_resource.loop_mode = Animation.LOOP_LINEAR # 1 = Loop, 0 = None
	else:
		push_error("No animations found inside this AnimationPlayer!")
#
# Call this function once from your player script when they first press or hold 'E'
func start_rowing() -> void:
	if not is_rowing:
		is_rowing = true
		print("Started rowing")
		# Start the animation engine
		if oar_animation_player and oar_anim != "":
			oar_animation_player.play(oar_anim)

# Call this function once when the player releases 'E' or looks away
func stop_rowing() -> void:
	if is_rowing:
		is_rowing = false
		print("Stopped rowing")
		
		# 2. Freeze the animation in place [2]
		if oar_animation_player:
			oar_animation_player.pause()

func _process(delta: float) -> void:
	if not is_rowing:
		return
		
	# REMOVED: oar_animation_player.play() from here!
	
	# Increase distance smoothly based on frame rate (delta)
	rowed_distance += rowing_speed * delta
	rowed_distance = min(rowed_distance, total_distance)
	print("rowed_distance = " + str(rowed_distance))
	
	# Move environment towards player to simulate movement
	world_objects.translate(Vector3(0, 0, 1)*delta)
	
	# Check if the player reached the goal
	if rowed_distance >= total_distance:
		print("Rowing complete!")
		stop_rowing() # Safely handles the state cleanup and animation pausing

func _on_interactable_show_text(interactor: Node) -> void:
	print("_on_interactable_show_text called")
	rowing_text.visible = true

func _on_interactable_unshow_text(interactor: Node) -> void:
	print("_on_interactable_unshow_text called")
	rowing_text.visible = false
	stop_rowing()

func _on_interactable_hold_interacted(interactor: Node) -> void:
	print("_on_interactable_hold_interacted called")
	start_rowing()
