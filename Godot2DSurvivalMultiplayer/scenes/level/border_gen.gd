extends TileMapLayer

@onready var tile_map = $"../TileMapLayer"
@onready var border_map = $"."

func _ready() -> void:
	var w = tile_map.width
	var h = tile_map.height
	var offset_x = w/2
	var offset_y = h/2

	# Bottom + Top borders
	for x in range(w):
		# Bottom
		border_map.set_cell(Vector2i(x-offset_x, h - offset_y), 0, Vector2i(0, 0))
		# Top
		border_map.set_cell(Vector2i(x-offset_x, -w + offset_y), 0, Vector2i(0, 0))

	# Left + Right borders
	for y in range(h):
		# Left
		border_map.set_cell(Vector2i(w - offset_x, y-offset_y), 0, Vector2i(0, 0))
		# Right
		border_map.set_cell(Vector2i(-w + offset_x , y-offset_y), 0, Vector2i(0, 0))
