extends Node3D
class_name Item

@export var item_name: String
@export var text : RichTextLabel

var starting_y: float # we need this to avoid clipping when items are dropped lol

func _ready():
	if text != null:
		text.visible = false
	starting_y = transform.origin.y

func _on_interactable_interacted(interactor: Node) -> void:
	interactor.hold_item(self)

func _on_interactable_show_text(interactor: Node) -> void:
	if text != null:
		text.visible = true
	pass # Replace with function body.

func _on_interactable_unshow_text(interactor: Node) -> void:
	if text != null:
		text.visible = false
	pass # Replace with function body.
