extends Node

signal interacted

func interact():
	interacted.emit()
	
