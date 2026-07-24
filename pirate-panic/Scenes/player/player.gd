extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.005

@onready var main_node = $".."
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var raycast = $Head/Camera3D/RayCast3D
@onready var hand = $Head/Camera3D/Hand

var held_item

var currentViewedInteractable: Interactable = null

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	currentViewedInteractable = null
	
func _unhandled_input(event: InputEvent) -> void:
	# 1. UI Cancel (Escape key)
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	# 2. Recapture mouse on click
	if event is InputEventMouseButton and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	# 3. Handle Camera Rotation
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		print("Moving mouse")
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

	# 4. Action inputs using the global 'Input' class, completely safe from mouse events
	if Input.is_action_just_pressed("drop"):
		drop_held_item()
		
	if Input.is_action_just_pressed("interact"):
		print("Pressed interact key")
		if currentViewedInteractable != null:
			currentViewedInteractable.interact(self)
			
	if Input.is_action_just_released("interact"):
		print("Released interact key")
		if currentViewedInteractable and currentViewedInteractable.has_method("stop_rowing"):
			currentViewedInteractable.stop_rowing()

# Add a new variable at the very top of your script to track the previous frame's target
var last_viewed_interactable: Node = null

func _process(delta: float) -> void:
	# 1. Force the raycast to update its math using the current visual frame positions
	raycast.force_raycast_update()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
	
	# 2. Now safely run your look-at and continuous-hold logic at framerate speed
	var found_interactable: Node = null

	if raycast.is_colliding():
		var hit_object = raycast.get_collider()
		if hit_object and hit_object.has_node("Interactable"):
			found_interactable = hit_object.get_node("Interactable")

	# Handle Text transitions smoothly at visual framerate
	if found_interactable != last_viewed_interactable:
		if last_viewed_interactable != null:
			clear_current_viewed_interactable()
		if found_interactable != null:
			currentViewedInteractable = found_interactable
			currentViewedInteractable.show_text(self)
		last_viewed_interactable = found_interactable

	# 3. Continuous holding checks belong in _process for perfectly smooth progress updates
	if currentViewedInteractable != null and Input.is_action_pressed("interact"):
		currentViewedInteractable.hold_interact(self)


func hold_item(item: Node):
	item.reparent(hand)
	item.transform = hand.transform
	held_item = item

func drop_held_item():
	if (held_item == null):
		return
	held_item.reparent(main_node)
	held_item.transform = transform
	held_item.transform.origin.y = held_item.starting_y
	
func clear_current_viewed_interactable():
	print("clear_current_viewed_interactable")
	# ONLY call the function if the variable actually holds an object!
	if currentViewedInteractable != null:
		currentViewedInteractable.unshow_text(self)
	# Safely clear the reference out afterward
	currentViewedInteractable = null
