extends Node2D

var actions: Array[String] = ["Inspect","Pick Up","Harvest"]
var objectname = "Berry Bush"

@export var pickup_loot_pool: Array[Dictionary] = [
	{
		"item_id": "waxed_leaves",
		"amount": 1,
		"chance": 0.5
	},
	{
		"item_id": "red_berries",
		"amount": 2,
		"chance": 1
	},
	{
		"item_id": "red_berries",
		"amount": 1,
		"chance": 0.5
	},
	{
		"item_id": "thorny_bramble",
		"amount": 1,
		"chance": 0.5
	},
	
	{
		"item_id": "plant_fibre",
		"amount": 1,
		"chance": 0.2
	},

	
]
@export var harvest_loot_pool: Array[Dictionary] = [
{
		"item_id": "red berries",
		"amount": 2,
		"chance": 1
	},
]
@export var pickup_time: float = 2      # seconds to hold interact

@export var inspect_text: String = "A thorny version of the typical shrub, displaying large, bright, enticing berries."
