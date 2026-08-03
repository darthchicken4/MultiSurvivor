extends Node2D

@onready var label = $Label
@onready var tile = $TileMapLayer
@onready  var enter_area = $enter_area
@onready var exit_area = $exit_area

@export var map: Node2D 
@export var bunker_pos = Vector2(200,200)
@export var dist = 7
@export var bunker_side_offset = Vector2(128,128)
@export var enter_timer = 2
@export var area_around_bunker = 128

@export var prefab_1 :PackedScene
@export var prefab_2 :PackedScene
@export var prefab_3 :PackedScene

var rng = RandomNumberGenerator.new()

var player: Node2D = null
var can_enter_bunker = true


func _on_enter_area_body_entered(body: Node2D) -> void:
	if not can_enter_bunker:
		return
	
	can_enter_bunker = false
	
	body.global_position = exit_area.global_position
	
	await reset_enter_delay()


func _on_exit_area_body_entered(body: Node2D) -> void:
	if not can_enter_bunker:
		return
	
	can_enter_bunker = false
	
	body.global_position = enter_area.global_position
	await reset_enter_delay()


func _ready() -> void:
	bunker_pos = Vector2(map.width / 2,map.height / 2)
	bunker_pos = bunker_pos  + bunker_side_offset * 5
	gen_bunker()
	


func reset_enter_delay() -> void:
	await get_tree().create_timer(enter_timer).timeout
	can_enter_bunker = true
	
	

	
func gen_bunker():
	var bunker_list = [prefab_1,prefab_2,prefab_3]
	rng.seed = 12345
	var value = rng.randi_range(0, bunker_list.size() - 1)
	var bunker_instance = bunker_list[value].instantiate()  # use .instance() if this is Godot 3.x
	add_child(bunker_instance)
	bunker_instance.global_position = bunker_pos
	exit_area.global_position = bunker_pos + bunker_instance.spawn_place * 2
	print(exit_area.global_position )
	print(bunker_instance.spawn_place)
	
