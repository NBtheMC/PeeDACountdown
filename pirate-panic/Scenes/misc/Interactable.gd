extends Node

class_name Interactable
signal interacted(interactor: Node)
signal hold_interacted(interactor: Node)
signal showText(interactor: Node)
signal unshowText(interactor: Node)

func interact(interactor: Node) -> void:
	print("interact signal called")
	interacted.emit(interactor)
	
func hold_interact(interactor: Node) -> void:
	print("hold_interact signal called")
	hold_interacted.emit(interactor)
	
func show_text(interactor: Node) -> void:
	print("show_text signal called")
	showText.emit(interactor)

func unshow_text(interactor: Node) -> void:
	print("unshow_text signal called")
	unshowText.emit(interactor)
