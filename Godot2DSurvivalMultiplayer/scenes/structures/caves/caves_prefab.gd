extends Node2D

@onready var label = $Label
@onready var tile = $TileMapLayer
@onready  var enter_area = $enter_area
@onready var exit_area = $exit_area

@export var map: Node2D 
@export var cave_pos = Vector2i(200,200)
@export var seed = 1902837
@export var dist = 7
@export var cave_side_offset = Vector2i(128,128)
@export var enter_timer = 2
@export var area_around_cave = 128




var player: Node2D = null
var can_enter_cave = true
var degree = 0 

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
	gen_cavev4()
	


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
	for x in range(-area_around_cave / 2, area_around_cave / 2):
		for y in range(-area_around_cave / 2, area_around_cave / 2):
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
func gen_cavev3():
	var ray
	var degree = 0.0

	# Fill area with wall tiles
	for x in range(-area_around_cave / 2, area_around_cave / 2):
		for y in range(-area_around_cave / 2, area_around_cave / 2):
			ray = Vector2i(cave_pos[0] + x, cave_pos[1] + y)
			tile.set_cell(ray, 0, Vector2(randi_range(0, 1), 1))

	# Main cave body: irregular radius per angle instead of a fixed circle
	var num_blobs = randi_range(3, 5)  # extra "lobes" off the main circle
	var blob_offsets = []
	for b in range(num_blobs):
		var a = randf_range(0, TAU)
		var d = randf_range(dist * 0.2, dist * 0.6)
		blob_offsets.append(Vector2(cos(a), sin(a)) * d)

	degree = 0.0
	for i in range(360):
		degree += 1.0
		var rad = deg_to_rad(degree)

		# base radius wobbles per-angle so the edge isn't a perfect circle
		var radius_wobble = dist * randf_range(0.75, 1.15)
		var r = 0.0

		while r <= radius_wobble:
			var px = r * cos(rad) + cave_pos[0] + randf_range(-1.5, 1.5)
			var py = r * sin(rad) + cave_pos[1] + randf_range(-1.5, 1.5)
			ray = Vector2i(round(px), round(py))
			tile.set_cell(ray, 0, Vector2(1, 0))
			r += 0.5

		# occasionally push a ray further out to bite into the wall
		if randf() < 0.08:
			var far_r = radius_wobble
			while far_r <= radius_wobble + randf_range(3.0, 8.0):
				var fx = far_r * cos(rad) + cave_pos[0]
				var fy = far_r * sin(rad) + cave_pos[1]
				ray = Vector2i(round(fx), round(fy))
				tile.set_cell(ray, 0, Vector2(1, 0))
				far_r += 0.5

	# carve extra lobes so the cave isn't perfectly radial from one center
	for offset in blob_offsets:
		var blob_center = Vector2(cave_pos[0], cave_pos[1]) + offset
		var blob_dist = dist * randf_range(0.35, 0.55)
		var d2 = 0.0
		for i in range(180):
			d2 += 2.0
			var rad2 = deg_to_rad(d2)
			var r2 = 0.0
			while r2 <= blob_dist:
				var px2 = r2 * cos(rad2) + blob_center.x + randf_range(-1.0, 1.0)
				var py2 = r2 * sin(rad2) + blob_center.y + randf_range(-1.0, 1.0)
				ray = Vector2i(round(px2), round(py2))
				tile.set_cell(ray, 0, Vector2(1, 0))
				r2 += 0.5

	exit_area.position = Vector2i(cave_pos * 32)


func gen_cavev4():
	var w = area_around_cave
	var h = area_around_cave
	var fill_prob = 0.45
	var smooth_iterations = 5
	var birth_limit = 4
	var death_limit = 3

	# 1. Random noise grid (true = wall, false = floor)
	var grid = []
	for x in range(w):
		grid.append([])
		for y in range(h):
			if x == 0 or y == 0 or x == w - 1 or y == h - 1:
				grid[x].append(true)
			else:
				grid[x].append(randf() < fill_prob)

	# 2. Smooth with cellular automata rules
	for i in range(smooth_iterations):
		grid = smooth_grid(grid, w, h, birth_limit, death_limit)

	# 3. Keep only the largest connected floor region, and get its cells back
	var largest_region = []
	grid = keep_largest_region(grid, w, h, largest_region)

	# 4. Apply to tilemap
	var origin_x = cave_pos[0] - w / 2
	var origin_y = cave_pos[1] - h / 2
	for x in range(w):
		for y in range(h):
			var ray = Vector2i(origin_x + x, origin_y + y)
			if grid[x][y]:
				tile.set_cell(ray, 0, Vector2(randi_range(0, 1), 1))
			else:
				tile.set_cell(ray, 0, Vector2(1, 0))

	# 5. Place exit on a random floor tile inside the carved region
	if largest_region.size() > 0:
		var exit_cell = largest_region[randi() % largest_region.size()]
		var exit_world = Vector2i(origin_x + exit_cell.x, origin_y + exit_cell.y)
		exit_area.position = exit_world * 32
	else:
		# fallback if something went wrong and no floor was found
		exit_area.position = Vector2i(cave_pos * 32)


func smooth_grid(grid, w, h, birth_limit, death_limit) -> Array:
	var new_grid = []
	for x in range(w):
		new_grid.append([])
		for y in range(h):
			var walls = count_wall_neighbors(grid, x, y, w, h)
			if grid[x][y]:
				new_grid[x].append(walls >= death_limit)
			else:
				new_grid[x].append(walls > birth_limit)
	return new_grid


func count_wall_neighbors(grid, x, y, w, h) -> int:
	var count = 0
	for nx in range(x - 1, x + 2):
		for ny in range(y - 1, y + 2):
			if nx == x and ny == y:
				continue
			if nx < 0 or ny < 0 or nx >= w or ny >= h:
				count += 1
			elif grid[nx][ny]:
				count += 1
	return count


# Now takes an "out_region" array to fill with the winning region's cells
func keep_largest_region(grid, w, h, out_region) -> Array:
	var visited = []
	for x in range(w):
		visited.append([])
		for y in range(h):
			visited[x].append(false)

	var regions = []

	for x in range(w):
		for y in range(h):
			if not grid[x][y] and not visited[x][y]:
				var region = flood_fill(grid, visited, x, y, w, h)
				regions.append(region)

	if regions.is_empty():
		return grid

	var biggest = regions[0]
	for r in regions:
		if r.size() > biggest.size():
			biggest = r

	var result = []
	for x in range(w):
		result.append([])
		for y in range(h):
			result[x].append(true)

	for cell in biggest:
		result[cell.x][cell.y] = false
		out_region.append(cell)

	return result


func flood_fill(grid, visited, start_x, start_y, w, h) -> Array:
	var region = []
	var stack = [Vector2i(start_x, start_y)]

	while not stack.is_empty():
		var p = stack.pop_back()
		if p.x < 0 or p.y < 0 or p.x >= w or p.y >= h:
			continue
		if visited[p.x][p.y] or grid[p.x][p.y]:
			continue

		visited[p.x][p.y] = true
		region.append(p)

		stack.append(Vector2i(p.x + 1, p.y))
		stack.append(Vector2i(p.x - 1, p.y))
		stack.append(Vector2i(p.x, p.y + 1))
		stack.append(Vector2i(p.x, p.y - 1))

	return region
