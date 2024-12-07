class_name MemoryChoices
extends Node2D

var _children: Array[MemoryObject]


func _ready() -> void:
	var temp_children: Array[Node] = get_children()
	for n in temp_children:
		_children.append(n as MemoryObject)


func disable() -> void:
	for choice in _children:
		choice.hide()


func enable() -> void:
	for choice in _children:
		choice.show()
