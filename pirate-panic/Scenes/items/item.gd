extends Node

@export var item_name: String

func on_interact():
	print("player has interacted with item")


func _on_interactable_interacted() -> void:
	on_interact()
