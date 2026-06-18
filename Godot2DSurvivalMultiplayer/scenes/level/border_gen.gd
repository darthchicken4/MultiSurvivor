extends TileMapLayer

@onready var tile_map = $"../TileMapLayer"
@onready var border_map = $"."

func _ready() -> void:
	var w = tile_map.width
	var h = tile_map.height

	print(w)
	print(h)

	# Bottom + Top borders
	for x in range(w):
		# Bottom
		border_map.set_cell(Vector2i(x, h - 1), 0, Vector2i(0, 0))
		# Top
		border_map.set_cell(Vector2i(x, w-8), 0, Vector2i(0, 0))

	# Left + Right borders
	for y in range(h):
		# Left
		border_map.set_cell(Vector2i(w, y-8), 0, Vector2i(0, 0))
		# Right
		border_map.set_cell(Vector2i(w - 1, y-8), 0, Vector2i(0, 0))
