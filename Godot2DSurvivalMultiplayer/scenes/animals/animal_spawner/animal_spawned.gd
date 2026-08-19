extends MultiplayerSpawner

@export var chiken: PackedScene 
#@export var tilemap_index: TileMapLayer
@export var animal_ammount = 20
@export var animal = 0
@export var multiplayer_spawner: MultiplayerSpawner 

@export var sort_container_for_pos : Node2D
var hog = preload("res://scenes/animals/hog/hog.tscn")

func _ready() -> void:
	if is_multiplayer_authority():
		await Utils.wait(2)
		call_deferred("spawn_animal")
func spawn_animal():
	var animal_to_spawn = hog.instantiate()
	animal_to_spawn.position = sort_container_for_pos.position
	animal_to_spawn.add_child(animal_to_spawn , true)
