class_name MemoryObject
extends Area2D

enum Colors {
	RED,
	ORANGE,
	YELLOW,
	GREEN,
	BLUE,
	PURPLE,
	PINK,
}

static var _color_name: Dictionary = {
	Colors.RED: "red",
	Colors.ORANGE: "orange",
	Colors.YELLOW: "yellow",
	Colors.GREEN: "green",
	Colors.BLUE: "blue",
	Colors.PURPLE: "purple",
	Colors.PINK: "pink",
}

const path: String = "res://assets/1bitplatformerpack/Tiles/Default/tile_0042_%s.png"
@export var color: Colors
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	area_entered.connect(_handle)


func set_color(new_color: Colors) -> void:
	color = new_color
	sprite.texture = load(path % [_color_name[color]])


static func get_color_name(c: Colors) -> String:
	return _color_name[c]


func _handle(_area: Area2D) -> void:
	signal_bus.hit_memory_object.emit(color)
