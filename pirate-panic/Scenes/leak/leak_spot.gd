extends Node3D
class_name LeakSpot

var index: int

signal leak_repair

func _on_interactable_interacted(interactor: Node) -> void:
	leak_repair.emit(index)
