extends Item
class_name FishingSpotItem

@export_group("Fishing Configuration")
@export var line_material: Material
@export var hook_scene: PackedScene

var active_hook: Node3D = null
var line_mesh: MeshInstance3D = null
var current_interactor: Node = null

func _ready() -> void:
	super() # Runs the parent Item _ready function to hide text and store starting_y
	
	# Set up the line drawing mesh only for this specific object
	line_mesh = MeshInstance3D.new()
	line_mesh.mesh = ImmediateMesh.new()
	if line_material:
		line_mesh.material_override = line_material
	add_child(line_mesh)

func _process(_delta: float) -> void:
	if active_hook and current_interactor and current_interactor.has_method("get_held_item"):
		var held = current_interactor.get_held_item()
		if held:
			draw_fishing_line(held)

# This overrides the base item interaction behavior completely
func _on_interactable_interacted(interactor: Node) -> void:
	if interactor.has_method("get_held_item"):
		var held = interactor.get_held_item()
		
		# Check if the held item is specifically named "Fishing Rod"
		if held and held is Item and held.item_name.to_lower() == "fishing rod":
			current_interactor = interactor
			spawn_fishing_line_and_hook()
			
			# Trigger the parent minigame node
			var minigame = get_parent()
			if minigame and minigame.has_method("start_minigame"):
				minigame.start_minigame()
			return
			
	print("You need a fishing rod to fish here!")

func spawn_fishing_line_and_hook() -> void:
	if active_hook != null: 
		return
		
	if hook_scene:
		active_hook = hook_scene.instantiate()
		get_tree().current_scene.add_child(active_hook)
		active_hook.global_transform.origin = global_transform.origin

func draw_fishing_line(held_rod: Node3D) -> void:
	var imm_mesh: ImmediateMesh = line_mesh.mesh
	imm_mesh.clear_surfaces()
	
	var rod_tip: Marker3D = held_rod.get_node_or_null("Tip")
	var start_pos: Vector3 = rod_tip.global_transform.origin if rod_tip else held_rod.global_transform.origin
	var end_pos: Vector3 = active_hook.global_transform.origin
	
	imm_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	imm_mesh.surface_add_vertex(line_mesh.to_local(start_pos))
	imm_mesh.surface_add_vertex(line_mesh.to_local(end_pos))
	imm_mesh.surface_end()

func reel_in() -> void:
	if active_hook:
		active_hook.queue_free()
		active_hook = null
	if line_mesh and line_mesh.mesh:
		line_mesh.mesh.clear_surfaces()
	current_interactor = null
