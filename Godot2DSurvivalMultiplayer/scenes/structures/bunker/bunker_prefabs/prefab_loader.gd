extends Node2D

@onready var spawn = $Marker2D
@export var spawn_place = Vector2(0,0) 


func _ready() -> void:
	spawn_place = spawn.position
