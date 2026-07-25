extends Item
class_name FishingSpotItem

# The spot just needs to know where the hook should land
@export var hook_spawn_marker: Node3D 

var is_active_fishing_spot: bool = false

@export var min_wait_time: float = 2.0
@export var max_wait_time: float = 6.0

@onready var minigame_timer: Timer = $Timer
@export var minigame_time: float = 2.0

@onready var audio_player: AudioStreamPlayer
@export var fish_sound: AudioStream
@export var catch_sound: AudioStream

@export var player : Player

func _ready() -> void:
	minigame_timer = Timer.new()
	add_child(minigame_timer)
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	minigame_timer.timeout.connect(fail_fishing)

func _on_interactable_interacted(interactor: Node) -> void:
	print("Interacted with fishing spot")
	if interactor.is_holding_fishing_rod():
		print("Holding fishing rod")
		# Safety check to make sure you aren't casting twice at the same spot
		if not is_active_fishing_spot:
			start_fishing_at_spot(interactor.get_held_item())
			player.lock_rotation()
			player.lock_movement()
		else:
			clear_fishing_spot()
			player.unlock_rotation()
			player.unlock_movement()
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
	start_fishing()

# Call this from your FishingMinigame script when the player quits, reels in, or catches a fish
func clear_fishing_spot() -> void:
	print("Clear fishing spot")
	is_active_fishing_spot = false
	
func start_fishing() -> void:
	var random_time: float = randf_range(min_wait_time, max_wait_time)
	# Create a one-shot timer directly in code
	await get_tree().create_timer(random_time).timeout

	minigame_timer.wait_time = minigame_time
	minigame_timer.start()
	pass

func _on_interactable_show_text(interactor: Node) -> void:
	if !is_active_fishing_spot and interactor.is_holding_fishing_rod():
		print("Showing text of " + item_name)
		if text != null:
			text.visible = true
	pass # Replace with function body.

func _on_interactable_unshow_text(interactor: Node) -> void:
	print("Unshowing text of " + item_name)
	if text != null:
		text.visible = false
	pass # Replace with function body.

func success_fishing() -> void:
	minigame_timer.stop()
	print("SUCCESS: Caught fish")
	# Do fishing eating stuff here

func fail_fishing() -> void:
	clear_fishing_spot()
	player.unlock_rotation()
	player.unlock_movement()
	print("FAIL: Fish got away")
	pass
