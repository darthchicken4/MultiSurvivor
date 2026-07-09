extends Node2D


@export var chiken: PackedScene 
@export var hog :PackedScene
@export var tilemap_index = TileMapLayer

@export var animal_ammount  = 20

@export var animal = 0
func _ready() -> void:
	spawn()
	
func spawn():
	var spawn_pos = tilemap_index.grass_spawn
	animal = randi_range(0, 1)
	if animal == 0:
		var hog_instance = hog.instantiate()
		hog_instance.position = spawn_pos
		add_child(hog_instance)
		print(hog_instance.global_position)
	elif animal == 1:
		var chicken_instance = chiken.instantiate()
		chicken_instance.position = spawn_pos
		add_child(chicken_instance)
		print(chicken_instance.global_position)
