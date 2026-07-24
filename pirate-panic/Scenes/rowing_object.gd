extends StaticBody3D
class_name RowingObject

@export var total_distance: float = 100.0
@export var rowing_speed: float = 3.0 # How much distance is added per second

# 1. Drag your Text object (Label3D or CanvasLayer UI Label) into this slot in the Inspector
@export var rowing_text: Node

@export var oar_animation_player: AnimationPlayer
# Stores the dynamically detected animation name
var oar_anim: String = ""

var rowed_distance: float = 0.0
var is_rowing: bool = false

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
func _process(delta: float) -> void:
	if is_rowing:
		print("Is rowing")
		oar_animation_player.play(oar_anim)
		# Increase distance smoothly based on frame rate (delta)
		rowed_distance += rowing_speed * delta
		
		# Cap the distance so it doesn't go over the total max distance
		rowed_distance = min(rowed_distance, total_distance)
		print("rowed_distance = " + str(rowed_distance))
		# Check if the player reached the goal
		if rowed_distance >= total_distance:
			print("Rowing complete!")
		is_rowing = false
		oar_animation_player.pause()

func _on_interactable_show_text(interactor: Node) -> void:
	print("_on_interactable_show_text called")
	rowing_text.visible = true

func _on_interactable_unshow_text(interactor: Node) -> void:
	print("_on_interactable_unshow_text called")
	rowing_text.visible = false
	is_rowing = false

func _on_interactable_hold_interacted(interactor: Node) -> void:
	print("_on_interactable_hold_interacted called")
	is_rowing = true
