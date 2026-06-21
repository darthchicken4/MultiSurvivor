extends Node2D

@onready var label = $Label
@onready var tile = $TileMapLayer
@onready  var enter_area = $enter_area
@onready var exit_area = $exit_area
var player: Node2D = null
var can_enter_cave = true

@export var map: Node2D 
@export var cave_pos = Vector2i(200,200)
@export var seed = 1902837
@export var dist = 7
@export var cave_side_offset = Vector2i(128,128)
var degree = 0 
@export var enter_timer = 2
#enter  area =>


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not can_enter_cave:
		return
	
	can_enter_cave = false
	
	body.global_position = exit_area.global_position
	
	await reset_enter_delay()


func _on_exit_area_body_entered(body: Node2D) -> void:
	if not can_enter_cave:
		return
	
	can_enter_cave = false
	
	body.global_position = enter_area.global_position
	await reset_enter_delay()


func _ready() -> void:
	cave_pos = Vector2i(map.width / 2,map.height / 2)
	cave_pos = cave_pos + cave_side_offset
	gen_cavev2()
	


func reset_enter_delay() -> void:
	await get_tree().create_timer(enter_timer).timeout
	can_enter_cave = true
	
	

	
func gen_cave():
	var ray
	#20000 area?
	#ratio  8 to 272  1 34 
	for i in range(270):
		degree = degree + 1.5
		ray = Vector2(0,0)
		ray = Vector2i(Vector2(dist * cos(degree) + cave_pos[0] + randf_range(1.0,1.5) , dist * sin(degree) + cave_pos[1] + randf_range(1.0,1.5)  ))
		tile.set_cell(ray,0,Vector2(1,1))
	exit_area.position = Vector2i(cave_pos * 32)

	#exit_area.global_position = cave_pos * 34 
func gen_cavev2():
	var ray
	
	# Fill 128x128 area with tiles
	for x in range(-64, 64):
		for y in range(-64, 64):
			ray = Vector2i(cave_pos[0] + x, cave_pos[1] + y)
			#cant be 1,0
			tile.set_cell(ray, 0, Vector2(randi_range(0,1), 1))
	
	# Carve out the inner circle (set to empty)
	for i in range(270):
		degree = degree + 1.5
		var r = 0
		while r <= dist:
			ray = Vector2i(Vector2(r * cos(degree) + cave_pos[0] +  randf_range(1.0,6.0),r * sin(degree) + cave_pos[1] +  + randf_range(1.0,6.0)))
			tile.erase_cell(ray)
			tile.set_cell(ray,0,Vector2(1,0))  # Remove tile = empty space
			r += 0.5
	
	exit_area.position = Vector2i(cave_pos * 32)
