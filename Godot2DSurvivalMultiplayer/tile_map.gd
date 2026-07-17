extends TileMapLayer

var pebble_noise = FastNoiseLite.new()
var rock_noise = FastNoiseLite.new()
var dry_noise = FastNoiseLite.new()
var variant_noise = FastNoiseLite.new()
var tree_noise = FastNoiseLite.new()
var tree_density_noise = FastNoiseLite.new()
var spawn_noise = FastNoiseLite.new()

@export var width :int =128
@export var height :int = 128
var last_tile_pos :Vector2i = Vector2i(INF, INF)

var tile_objects: Dictionary = {}
var tile_terrain: Dictionary = {}

@export var tree_scene: PackedScene
@export var shrub_scene: PackedScene
@export var dead_bush_scene: PackedScene
@export var slab_scene: PackedScene
@export var berryshrub_scene: PackedScene
@export var gold_scene: PackedScene
@export var iron_scene: PackedScene
@export var copper_scene: PackedScene
@export var rocks_scene: PackedScene
@export var pebbles_scene: PackedScene
@export var tree_branches_scene: PackedScene
@export var clay_scene: PackedScene
@export var tallgrass_scene: PackedScene
@export var fern_scene: PackedScene
@export var redmushrooms_scene: PackedScene
@export var yellowmushrooms_scene: PackedScene

@export var grass_spawn = Vector2(0,0) #grass tile surrounded by + shape
@export var can_spawn_again = true
var tree_container: Node2D

var map_seed: int = 0

func _ready():
	tree_container = $"../SortContainer"
func _initiate(seed: int):
	map_seed = seed
	_apply_seed_and_generate()
	animal_spawn_tile()
func _apply_seed_and_generate():
	var rng = RandomNumberGenerator.new()
	rng.seed = map_seed

	pebble_noise.seed = rng.randi()
	pebble_noise.frequency = 0.08
	rock_noise.seed = rng.randi()
	rock_noise.frequency = 0.010
	dry_noise.seed = rng.randi()
	dry_noise.frequency = 0.02
	variant_noise.seed = rng.randi()
	variant_noise.frequency = 2.0
	tree_noise.seed = rng.randi()
	tree_noise.frequency = 0.03
	tree_density_noise.seed = rng.randi()
	tree_density_noise.frequency = 0.8
	spawn_noise.seed = rng.randi()
	spawn_noise.frequency = 3.0

	generate_chunk(Vector2(0, 0))

@rpc("authority", "reliable")
func sync_map_seed(seed: int):
	map_seed = seed
	_apply_seed_and_generate()

func _process(_delta):
	var tile_pos = local_to_map(Vector2(0, 0))
	if tile_pos != last_tile_pos:
		last_tile_pos = tile_pos
		generate_chunk(Vector2(0, 0))


func map_to_global(tile: Vector2i) -> Vector2:
	return to_global(map_to_local(tile))
	
func get_tile_object(mouse_position: Vector2) -> Node:
	var local_pos = to_local(mouse_position)
	var tile = local_to_map(local_pos)

	if tile_objects.has(tile):
		return tile_objects[tile]
	return null
	
func generate_chunk(position):
	for child in tree_container.get_children():
		if child.is_in_group("map_objects"):
			child.queue_free()
	tile_objects.clear()
	tile_terrain.clear()

	var tile_pos = local_to_map(position)
	
	# First pass: tiles and terrain
	for x in range(width):
		for y in range(height):
			var wx = tile_pos.x - width / 2 + x
			var wy = tile_pos.y - height / 2 + y

			var pebble_val  = pebble_noise.get_noise_2d(wx, wy)
			var rock_val    = rock_noise.get_noise_2d(wx, wy)
			var dry_val     = dry_noise.get_noise_2d(wx, wy)
			var variant_val = variant_noise.get_noise_2d(wx, wy)

			var col: int
			if rock_val > 0.45:
				col = 6
			elif rock_val > 0.35:
				col = 5
			elif rock_val > 0.28:
				col = 4
			elif rock_val > 0.22:
				col = 3
			elif pebble_val > 0.55:
				col = 2
			else:
				col = 0

			var is_dry = dry_val > 0.0
			var base_row = 0 if variant_val > 0.0 else 1
			var row = base_row + (2 if is_dry else 0)

			set_cell(Vector2i(wx, wy), 0, Vector2i(col, row))

			var key = Vector2i(wx, wy)
			if col > 5:
				continue
			if col >= 4:
				tile_terrain[key] = "rock"
			elif col >= 2:
				tile_terrain[key] = "rock_edge"
			elif col == 1:
				tile_terrain[key] = "pebble"
			elif is_dry:
				tile_terrain[key] = "dry_grass"
			else:
				tile_terrain[key] = "lush_grass"

	# Second pass: spawn objects
	
	for x in range(width):
		for y in range(height):
			var wx = tile_pos.x - width / 2 + x
			var wy = tile_pos.y - height / 2 + y
			var key = Vector2i(wx, wy)
			var terrain = tile_terrain.get(key, "")

			var tree_val         = tree_noise.get_noise_2d(wx, wy)
			var tree_density_val = tree_density_noise.get_noise_2d(wx, wy)
			var s                = (spawn_noise.get_noise_2d(wx, wy) + 1.0) / 2.0


			if tile_objects.has(key):
				continue

			match terrain:
				"lush_grass":
					if tree_val > 0.01 and tree_density_val > 0.15:
						spawn_object(key, tree_scene, ["lush_grass"])
					elif s < 0.25:
						spawn_object(key, berryshrub_scene, ["lush_grass"])
					elif s < 0.3:
						spawn_object(key, shrub_scene, ["lush_grass"])
					elif s < 0.39:
						spawn_object(key, tallgrass_scene, ["lush_grass"])
					elif s < 0.4:
						spawn_object(key, fern_scene, ["lush_grass"])
					elif s < 0.42:
						spawn_object(key, redmushrooms_scene, ["lush_grass"])
					elif s < 0.44:
						spawn_object(key, rocks_scene, ["lush_grass"])
					elif s < 0.45:
						spawn_object(key, tree_branches_scene, ["lush_grass"])
					elif s < 0.452:
						spawn_object(key, slab_scene, ["lush_grass"])

				"dry_grass":
					if tree_val > 0.01 and tree_density_val > 0.3:
						spawn_object(key, tree_scene, ["dry_grass"])
					if s < 0.08:
						spawn_object(key, shrub_scene, ["dry_grass"])
					elif s < 0.3:
						spawn_object(key, tallgrass_scene, ["dry_grass"])
					elif s < 0.33:
						spawn_object(key, fern_scene, ["dry_grass"])
					elif s < 0.335:
						spawn_object(key, yellowmushrooms_scene, ["dry_grass"])
					elif s < 0.34:
						spawn_object(key, redmushrooms_scene, ["dry_grass"])
					elif s < 0.35:
						spawn_object(key, pebbles_scene, ["dry_grass"])
					elif s < 0.36:
						spawn_object(key, rocks_scene, ["dry_grass"])
					elif s < 0.37:
						spawn_object(key, tree_branches_scene, ["dry_grass"])
					elif s < 0.38:
						spawn_object(key, dead_bush_scene, ["dry_grass"])
					elif s < 0.382:
						spawn_object(key, slab_scene, ["lush_grass"])

				"rock_edge":
					if s < 0.1:
						spawn_object(key, pebbles_scene, ["rock_edge"])
					elif s < 0.13:
						spawn_object(key, rocks_scene, ["rock_edge"])
					elif s < 0.132:
						spawn_object(key, slab_scene, ["rock_edge"])
					elif s < 0.32:
						spawn_object(key, clay_scene, ["rock_edge"])

				"rock":
					if s < 0.26:
						spawn_object(key, gold_scene, ["rock"])
					elif s < 0.28:
						spawn_object(key, iron_scene, ["rock"])
					elif s < 0.3:
						spawn_object(key, copper_scene, ["rock"])
					elif s < 0.31:
						spawn_object(key, slab_scene, ["rock"])

				"pebble":
					if s < 0.04:
						spawn_object(key, pebbles_scene, ["pebble"])
					elif s < 0.07:
						spawn_object(key, rocks_scene, ["pebble"])
					elif s < 0.09:
						spawn_object(key, slab_scene, ["pebble"])
					elif s < 0.4:
						spawn_object(key, clay_scene, ["pebble"])

func spawn_object(key: Vector2i, scene: PackedScene, allowed_terrains: Array):
	
	if tile_objects.has(key):
		return
	if scene == null:
		return
	if not tile_terrain.get(key, "") in allowed_terrains:
		return
	var obj = scene.instantiate()
	obj.add_to_group("map_objects")
	
	tree_container.add_child(obj)
	if obj.has_meta("flipX"):
		if randi() % 2 == 0:
			obj.get_child(0).flip_h = true
	if obj.has_meta("flipY"):
		if randi() % 2 == 0:
			obj.get_child(0).flip_v = true
	obj.global_position = map_to_global(key)
	tile_objects[key] = obj

func remove_object(tile: Vector2i):
	if tile_objects.has(tile):
		tile_objects[tile].queue_free()
		tile_objects.erase(tile)





func _is_grass(terrain: String) -> bool:
	return terrain == "lush_grass" or terrain == "dry_grass"


func animal_spawn_tile():
	# Cross offsets: center + up, down, left, right
	var cross_offsets = [
		Vector2i(0, 0),
		Vector2i(0, -1),
		Vector2i(0, 1),
		Vector2i(-1, 0),
		Vector2i(1, 0),
	]

	# Collect all grass tiles that form a full + shape
	var valid_tiles: Array = []
	for key in tile_terrain.keys():
		if not _is_grass(tile_terrain[key]):
			continue
		var all_grass = true
		for offset in cross_offsets:
			var neighbor = key + offset
			if not _is_grass(tile_terrain.get(neighbor, "")):
				all_grass = false
				break
		if all_grass:
			valid_tiles.append(key)

	if valid_tiles.is_empty():
		print("animal_spawn_tile: no valid cross-shaped grass tile found")
		return

	# Pick a random valid tile
	var chosen: Vector2i = valid_tiles[randi() % valid_tiles.size()]
	grass_spawn = Vector2(chosen.x, chosen.y)
	print("animal_spawn_tile: grass_spawn set to ", grass_spawn)
