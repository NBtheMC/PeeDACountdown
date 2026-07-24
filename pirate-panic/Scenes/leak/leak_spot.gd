extends Node3D
class_name LeakSpot

var index: int

@export var screen_text: Node

signal leak_repair

func _on_interactable_interacted(interactor: Node) -> void:
	leak_repair.emit(index)


func _on_interactable_show_text(interactor: Node) -> void:
	screen_text.visible = true


func _on_interactable_unshow_text(interactor: Node) -> void:
	screen_text.visible = false
