extends Node2D

@onready var label = $Label
@onready var tile = $TileMapLayer
@onready  var enter_area = $enter_area
@onready var exit_area = $exit_area

@export var map: Node2D 
@export var bunker_pos = Vector2i(200,200)
@export var dist = 7
@export var bunker_side_offset = Vector2i(128,128)
@export var enter_timer = 2
@export var area_around_bunker = 128


var tile_set_prefabs = [1,1,1,1,1,1,1,
						1,0,0,0,0,0,1,
						1,0,0,0,0,0,1,
						1,0,0,0,0,0,1,]

var player: Node2D = null
var can_enter_bunker = true
var degree = 0 

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
	bunker_pos = Vector2i(map.width / 2,map.height / 2)
	bunker_pos = bunker_pos + bunker_side_offset
	gen_bunker()
	


func reset_enter_delay() -> void:
	await get_tree().create_timer(enter_timer).timeout
	can_enter_bunker = true
	
	

	
func gen_bunker():
	var ray
	#20000 area?
	#ratio  8 to 272  1 34 
	for i in range(270):
		degree = degree + 1.5
		ray = Vector2(0,0)
		ray = Vector2i(Vector2(dist * cos(degree) + bunker_pos[0] + randf_range(1.0,1.5) , dist * sin(degree) + bunker_pos[1] + randf_range(1.0,1.5)  ))
		tile.set_cell(ray,0,Vector2(1,1))
	exit_area.position = Vector2i(bunker_pos * 32)
