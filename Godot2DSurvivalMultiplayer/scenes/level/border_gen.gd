extends TileMapLayer

@onready var tile_map = $"../TileMapLayer"
@onready var border_map = $"."

func _ready() -> void:
	var w = tile_map.width
	var h = tile_map.height
	var offset_x = w/2
	var offset_y = h/2

	# Bottom + Top borders
	for x in range(-1, w + 1):
		border_map.set_cell(
			Vector2i(x - offset_x, h - offset_y),
			0,
			Vector2i(0, 0)
		)

		border_map.set_cell(
			Vector2i(x - offset_x, -h + offset_y - 1),
			0,
			Vector2i(0, 0)
		)

	# Left + Right borders
	for y in range(h):
		border_map.set_cell(
			Vector2i(w - offset_x, y - offset_y),
			0,
			Vector2i(0, 0)
		)

		border_map.set_cell(
			Vector2i(-w + offset_x - 1, y - offset_y),
			0,
			Vector2i(0, 0)
	)
