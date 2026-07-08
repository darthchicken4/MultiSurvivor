extends Node2D


@export var chiken = PackedScene 
@export var hog  = PackedScene
@export var tilemap_index = TileMapLayer

@export var animal_ammount  = 20


func _ready() -> void:
	pass
	
func spawn():
	var spawn_pos = tilemap_index.grass_spawn 
