extends Node

signal interacted(interactor: Node)

func interact(interactor: Node) -> void:
	interacted.emit(interactor)
	
