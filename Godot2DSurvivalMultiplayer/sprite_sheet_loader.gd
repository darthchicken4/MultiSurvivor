# SpritesheetLoader.gd
extends Node

const TILE_SIZE := 16

var sheets := {
	"items1": preload("res://assets/spritesheets/itemsheet1.png"),
	"guns1": preload("res://assets/spritesheets/gunsheet1.png"),
	"tools1": preload("res://assets/spritesheets/toolsheet1.png"),
	"placeables1": preload("res://assets/spritesheets/placeablesheet1.png")
}
var texture_cache := {}

func _ready():
	# Register spritesheets here
	pass

func register_sheet(id: String, path: String) -> void:
	sheets[id] = load(path)


func get_texture(sheet_id: String, col: int, row: int, tile_size: int = TILE_SIZE) -> AtlasTexture:
	var cache_key = "%s:%s:%s:%s" % [sheet_id, col, row, tile_size]

	if texture_cache.has(cache_key):
		return texture_cache[cache_key]
	print(sheets)
	if !sheets.has(sheet_id):
		push_error("Spritesheet '%s' not found" % sheet_id)
		return null

	var tex := AtlasTexture.new()
	tex.atlas = sheets[sheet_id]
	tex.region = Rect2(
		col * tile_size,
		row * tile_size,
		tile_size,
		tile_size
	)

	texture_cache[cache_key] = tex
	return tex


func get_texture_px(
	sheet_id: String,
	x: int,
	y: int,
	width: int,
	height: int
) -> AtlasTexture:
	var cache_key = "%s:%s:%s:%s:%s" % [sheet_id, x, y, width, height]

	if texture_cache.has(cache_key):
		return texture_cache[cache_key]

	if !sheets.has(sheet_id):
		push_error("Spritesheet '%s' not found" % sheet_id)
		return null

	var tex := AtlasTexture.new()
	tex.atlas = sheets[sheet_id]
	tex.region = Rect2(x, y, width, height)

	texture_cache[cache_key] = tex
	return tex


func clear_cache() -> void:
	texture_cache.clear()
