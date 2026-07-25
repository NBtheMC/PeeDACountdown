extends Item
class_name FishingSpotItem

# The spot just needs to know where the hook should land
@export var hook_spawn_marker: Node3D 

var is_active_fishing_spot: bool = false

func _on_interactable_interacted(interactor: Node) -> void:
	print("Interacted with fishing spot")
	if interactor.is_holding_fishing_rod():
		print("Holding fishing rod")
		# Safety check to make sure you aren't casting twice at the same spot
		if not is_active_fishing_spot:
			start_fishing_at_spot(interactor.get_held_item())
		return
			
	print("You need a fishing rod to fish here!")

func start_fishing_at_spot(rod: Node) -> void:
	print("Start fishing")
	is_active_fishing_spot = true
	
	# 2. Determine exactly where the hook should appear in the water
	# Falls back to the fishing spot center if no marker node is assigned
	var target_position: Transform3D = global_transform
	if hook_spawn_marker != null:
		target_position = hook_spawn_marker.global_transform
	# 3. Tell the fishing rod to deploy the hook and start drawing the line
	rod.cast_line(target_position)
	
	# 4. Trigger the parent minigame manager node
	var minigame = get_parent()
	if minigame and minigame.has_method("start_minigame"):
		minigame.start_minigame()

# Call this from your FishingMinigame script when the player quits, reels in, or catches a fish
func clear_fishing_spot() -> void:
	print("Clear fishing spot")
	is_active_fishing_spot = false
