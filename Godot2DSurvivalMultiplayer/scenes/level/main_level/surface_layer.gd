extends TileMapLayer

var rock_noise: FastNoiseLite
var width: int = 128
var height: int = 128

var tile_objects: Dictionary = {}
var tile_terrain: Dictionary = {}

func setup_from_main(noise: FastNoiseLite, w: int, h: int) -> void:
	rock_noise = noise
	width = w
	height = h

func map_to_global(tile: Vector2i) -> Vector2:
	return to_global(map_to_local(tile))

func get_tile_object(mouse_position: Vector2) -> Node:
	var local_pos = to_local(mouse_position)
	var tile = local_to_map(local_pos)
	if tile_objects.has(tile):
		return tile_objects[tile]
	return null

func generate_chunk(position):
	if rock_noise == null:
		return  # main layer hasn't called setup_from_main yet

	tile_objects.clear()
	tile_terrain.clear()
	clear()

	var tile_pos = local_to_map(position)

	for x in range(width):
		for y in range(height):
			var wx = tile_pos.x - width / 2 + x
			var wy = tile_pos.y - height / 2 + y
			var rock_val = rock_noise.get_noise_2d(wx, wy)
			var key = Vector2i(wx, wy)

			var col: int
			if rock_val > 0.45:
				col = 0
			else:
				continue

			tile_terrain[key] = "rock"
			set_cell(key, 0, Vector2i(col, randi_range(0,1)))  # row 0 — adjust if mountain atlas differs
