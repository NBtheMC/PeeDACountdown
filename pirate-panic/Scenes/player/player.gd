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

@onready var default_world_root: Node = get_tree().current_scene
var currentViewedInteractable: Interactable = null

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	currentViewedInteractable = null
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if (event is InputEventMouseButton):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if (event is InputEventMouseMotion):
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float) -> void:
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
	
	#Raycast
	if (raycast.is_colliding()):
		var hit_object = raycast.get_collider()
		if (hit_object.has_node("Interactable")):
			print("Looking at interactable")
			currentViewedInteractable = hit_object.get_node("Interactable")
			# Show interactible text
			currentViewedInteractable.show_text(self)
			if Input.is_action_just_pressed("interact"):
				currentViewedInteractable.interact(self)
			elif Input.is_action_pressed("interact"):
				currentViewedInteractable.hold_interact(self)
		else:
			clear_current_viewed_interactable()

	# item drop input
	if (Input.is_action_just_pressed("drop")):
		drop_held_item()

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
	print("Not looking at interactable anymore")
	currentViewedInteractable.unshow_text(self)
	currentViewedInteractable = null
