extends Node2D

@onready var label = $Label
@onready var tile = $TileMapLayer
@onready var exit_area = $exit_area
var player: Node2D = null
@export var cave_pos = Vector2(16,16)
@export var seed = 1902837
@export var dist = 7
@export var degree = 0 
var center  =Vector2(200,200) 

func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.


func _ready() -> void:
	gen_cave()
	

func gen_cave():
	var ray
	#20000 area?
	#ratio  8 to 272  1 34 
	
	for i in range(359):
		degree = degree + 1
		ray = Vector2(0,0)
		ray = Vector2i(Vector2(dist * cos(degree) + cave_pos[0], dist * sin(degree) + cave_pos[1] ))
		exit_area.global_position = cave_pos * 34
		 
		tile.set_cell(ray,0,Vector2(1,1))
	

	#exit_area.global_position = cave_pos * 34 
