extends MultiplayerSpawner


@export var chiken: PackedScene 
@export var hog :PackedScene
@export var tilemap_index = TileMapLayer
@onready var multiplayer_spawner = $"."
@export var animal_ammount  = 20

@export var animal = 0

func _ready() -> void:
	spawn_function = _spawn_animal
	spawn(hog.resource_path)
	spawn(hog.resource_path)

func _spawn_animal(scene_path: String) -> Node:
	var scene: PackedScene = load(scene_path)
	return scene.instantiate()


	#if not multiplayer_spawner.is_server():
	#	return

	#var spawn_pos = tilemap_index.grass_spawn
	#var animal = randi_range(0, 1)
	#var instance: Node

	#if animal == 0:
	#	instance = hog.instantiate()
	#else:
	#	instance = chiken.instantiate()
	#instance.name = "Animal_%d" % randi()
	#instance.set_multiplayer_authority(1) # 1 = server authority
	#instance.position = spawn_pos
	#$AnimalContainer.add_child(instance, true) # true = force readable name, helps sync
