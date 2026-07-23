extends StaticBody3D
class_name RowingObject

@export var total_distance: float = 100.0
@export var rowing_speed: float = 10.0 # How much distance is added per second

# 1. Drag your Text object (Label3D or CanvasLayer UI Label) into this slot in the Inspector
@export var rowing_text: Node

var rowed_distance: float = 0.0
var is_rowing: bool = false

func _ready() -> void:
	print("Created rowing spot")
	is_rowing = false
	# Make sure the text is hidden when the game starts
	if rowing_text:
		rowing_text.visible = false
#
func _process(delta: float) -> void:
	if is_rowing:
		print("Is rowing")
		# Increase distance smoothly based on frame rate (delta)
		rowed_distance += rowing_speed * delta
		
		# Cap the distance so it doesn't go over the total max distance
		rowed_distance = min(rowed_distance, total_distance)
		
		# Check if the player reached the goal
		if rowed_distance >= total_distance:
			print("Rowing complete!")

func _on_interactable_show_text(interactor: Node) -> void:
	print("_on_interactable_show_text called")
	rowing_text.visible = true
	pass # Replace with function body.

func _on_interactable_unshow_text(interactor: Node) -> void:
	print("_on_interactable_unshow_text called")
	rowing_text.visible = false
	pass # Replace with function body.

func _on_interactable_hold_interacted(interactor: Node) -> void:
	print("_on_interactable_hold_interacted called")
	is_rowing = true
	pass # Replace with function body.
