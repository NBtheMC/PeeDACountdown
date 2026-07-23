extends Node3D

@export var item_name: String
var starting_y: float # we need this to avoid clipping when items are dropped lol

func _ready():
	starting_y = transform.origin.y		

func _on_interactable_interacted(interactor: Node) -> void:
	interactor.hold_item(self)
