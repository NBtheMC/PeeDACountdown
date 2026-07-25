extends CharacterBody3D
class_name Player

@export var SPEED = 0.5
@export var SENSITIVITY = 0.005

@onready var main_node = $"../Environment"
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var raycast = $Head/Camera3D/RayCast3D
@onready var hand = $Head/Camera3D/Hand

var held_item

var currentViewedInteractable: Interactable = null

var isLockedMovement: bool = false
var isLockedRotation: bool = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	currentViewedInteractable = null
	
func _input(event: InputEvent) -> void:
	# 1. UI Cancel (Escape key)
	if event.is_action_pressed("ui_cancel"):
		print("Input mode set to visible")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# 2. Recapture mouse on click
	if event is InputEventMouseButton and event.pressed:
		print("Input mode set to captured")
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# 3. Handle Camera Rotation
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and !isLockedRotation:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))

	# 4. Action inputs using the global 'Input' class, completely safe from mouse events
	if Input.is_action_just_pressed("drop"):
		drop_held_item()
		
	if Input.is_action_just_pressed("interact"):
		# print("Pressed interact key")
		if currentViewedInteractable != null:
			currentViewedInteractable.interact(self)
			
	if Input.is_action_just_released("interact"):
		# print("Released interact key on " + str(currentViewedInteractable))
		if currentViewedInteractable and currentViewedInteractable.get_parent() is RowingObject:
			print("Stop rowing on " + str(currentViewedInteractable))
			currentViewedInteractable.get_parent().stop_rowing()

# Add a new variable at the very top of your script to track the previous frame's target
var last_viewed_interactable: Node = null

func _physics_process(delta: float) -> void:
	# --- ALL MOVEMENT & PHYSICS GO HERE ---
	if not is_on_floor():
		velocity += get_gravity() * delta

	if !isLockedMovement:
		var input_dir := Input.get_vector("left", "right", "up", "down")
		var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		
		move_and_slide() # Safe to run here!

func _process(delta: float) -> void:
	# --- ONLY RAYCASTS, TEXT, AND CONTINUOUS INPUTS GO HERE ---
	raycast.force_raycast_update()
	
	var found_interactable: Node = null

	if raycast.is_colliding():
		var hit_object = raycast.get_collider()
		if hit_object and hit_object.has_node("Interactable"):
			# Use 'as Interactable' to safely convert the node type
			found_interactable = hit_object.get_node("Interactable") as Interactable
			currentViewedInteractable = found_interactable
			currentViewedInteractable.show_text(self)
	else:
		clear_current_viewed_interactable()

	# Continuous holding checks
	if currentViewedInteractable != null and Input.is_action_pressed("interact"):
		currentViewedInteractable.hold_interact(self)

func hold_item(item: Node):
	item.reparent(hand)
	item.transform = Transform3D.IDENTITY
	held_item = item

func drop_held_item():
	if (held_item == null):
		return
	held_item.reparent(main_node)
	held_item.transform = held_item.starting_transform
	# held_item.transform.origin.y = held_item.starting_y
	
func clear_current_viewed_interactable():
	# print("clear_current_viewed_interactable")
	# ONLY call the function if the variable actually holds an object!
	if currentViewedInteractable != null:
		currentViewedInteractable.unshow_text(self)
	# Safely clear the reference out afterward
	currentViewedInteractable = null

func get_held_item() -> Node:
	return held_item

func is_holding_fishing_rod() -> bool:
	return held_item != null and held_item.item_name.to_lower() == "fishing_rod"

func _on_leak_spot_leak_repair() -> void:
	pass # Replace with function body.

func lock_movement() -> void:
	isLockedMovement = true
	pass

func unlock_movement() -> void:
	isLockedMovement = false
	pass

func lock_rotation() -> void:
	isLockedRotation = true
	pass

func unlock_rotation() -> void:
	isLockedRotation = false
	pass
