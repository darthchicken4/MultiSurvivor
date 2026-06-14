extends TileMapLayer

var pebble_noise = FastNoiseLite.new()
var rock_noise = FastNoiseLite.new()
var dry_noise = FastNoiseLite.new()
var variant_noise = FastNoiseLite.new()

var width = 128
var height = 128
var last_tile_pos = Vector2i(INF, INF)

func _ready():
	pebble_noise.seed = randi()
	pebble_noise.frequency = 0.08

	rock_noise.seed = randi()
	rock_noise.frequency = 0.010   # lower = bigger blobs

	dry_noise.seed = randi()
	dry_noise.frequency = 0.02

	variant_noise.seed = randi()
	variant_noise.frequency = 2.0

	generate_chunk(Vector2(0, 0))

func _process(delta):
	var tile_pos = local_to_map(Vector2(0, 0))
	if tile_pos != last_tile_pos:
		last_tile_pos = tile_pos
		generate_chunk(Vector2(0, 0))

func generate_chunk(position):
	var tile_pos = local_to_map(position)
	for x in range(width):
		for y in range(height):
			var wx = tile_pos.x - width / 2 + x
			var wy = tile_pos.y - height / 2 + y

			var pebble_val  = pebble_noise.get_noise_2d(wx, wy)
			var rock_val    = rock_noise.get_noise_2d(wx, wy)
			var dry_val     = dry_noise.get_noise_2d(wx, wy)
			var variant_val = variant_noise.get_noise_2d(wx, wy)

			var col: int
			if rock_val > 0.45:           # large core of col 6, hits much more often
				col = 6
			elif rock_val > 0.35:         # wide col 5 band around core
				col = 5
			elif rock_val > 0.28:         # thin col 4 fringe
				col = 4
			elif rock_val > 0.22:         # thin col 3 fringe
				col = 3
			elif pebble_val > 0.55:
				col = 2
			else:
				col = 0

			var is_dry = dry_val > 0.0
			var base_row = 0 if variant_val > 0.0 else 1
			var row = base_row + (2 if is_dry else 0)

			set_cell(Vector2i(wx, wy), 0, Vector2i(col, row))
