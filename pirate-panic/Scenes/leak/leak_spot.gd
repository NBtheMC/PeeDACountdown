extends Node3D
class_name LeakSpot

var index: int
var active : bool = false

@export var screen_text: Node
@export var sfx_leak_spew : AudioStreamPlayer3D
@export var sfx_leak_fix : AudioStreamPlayer

signal leak_repair

func on_activate() -> void:
	active = true
	sfx_leak_spew.play()

func on_deactivate() -> void:
	active = false
	sfx_leak_spew.stop()

func _on_interactable_interacted(interactor: Node) -> void:
	if (active && interactor.held_item != null && interactor.held_item.item_name == "mallet"):
		leak_repair.emit(index)
		sfx_leak_fix.play()


func _on_interactable_show_text(interactor: Node) -> void:
	if (not active or interactor.held_item == null): return
	screen_text.visible = true


func _on_interactable_unshow_text(interactor: Node) -> void:
	screen_text.visible = false
