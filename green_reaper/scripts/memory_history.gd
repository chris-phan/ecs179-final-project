class_name MemoryHistory
extends Node2D

var _children: Array[MemoryObject]
var _idx: int = 0

func _ready() -> void:
	var temp_children: Array[Node] = get_children()
	for n in temp_children:
		_children.append(n as MemoryObject)
	clear()


func show_next(color: MemoryObject.Colors) -> void:
	if _idx >= len(_children):
		return
	
	var cur_child: MemoryObject = _children[_idx]
	cur_child.set_color(color)
	cur_child.show()
	_idx += 1


func clear() -> void:
	for i in range(len(_children)):
		_children[i].hide()
	
	_idx = 0
