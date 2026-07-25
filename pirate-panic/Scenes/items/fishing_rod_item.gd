extends Item
class_name FishingRodItem

@export var pole_tip: Node3D
@export var fishing_pole_hook: Node3D
@export var line_material: Material # Assign a basic StandardMaterial3D in the Inspector

var line_mesh: MeshInstance3D
var imm_mesh: ImmediateMesh
var is_fishing: bool = false

func _ready() -> void:
	super._ready()
	# 1. Allocate a single mesh instance container into memory once
	line_mesh = MeshInstance3D.new()
	imm_mesh = ImmediateMesh.new()
	line_mesh.mesh = imm_mesh
	
	if line_material:
		line_mesh.material_override = line_material
	add_child(line_mesh)

func _process(_delta: float) -> void:
	draw_straight_line()

func cast_line(hook_spot: Transform3D) -> void:
	# print("Cast line")
	is_fishing = true
	line_mesh.visible = true
	fishing_pole_hook.transform = hook_spot

func reel_in() -> void:
	# print("Reeled in")
	is_fishing = false
	line_mesh.visible = false
	imm_mesh.clear_surfaces()

func draw_straight_line() -> void:
	# print("Draw straight line")
	# 3. Wipe the previous frame's line data instantly
	imm_mesh.clear_surfaces()
	
	# 4. Fetch the absolute world spaces and translate them into local space
	# This completely avoids visual jitter when the player moves or rotates
	var start_pos = line_mesh.to_local(pole_tip.global_transform.origin)
	var end_pos = line_mesh.to_local(fishing_pole_hook.global_transform.origin)
	
	# 5. Hand the raw vertices directly to the GPU in a single pass
	imm_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	imm_mesh.surface_add_vertex(start_pos)
	imm_mesh.surface_add_vertex(end_pos)
	imm_mesh.surface_end()


func _on_interactable_interacted(interactor: Node) -> void:
	super._on_interactable_interacted(interactor)
	pass # Replace with function body.
