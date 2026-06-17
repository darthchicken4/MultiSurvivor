extends Node2D

var actions: Array[String] = ["Inspect","Pick Up"]
var objectname = "Shrub"

@export var pickup_loot_pool: Array[Dictionary] = [
	{
		"item_id": "waxed_leaves",
		"amount": 3,
		"chance": 1
	},
	{
		"item_id": "waxed_leaves",
		"amount": 1,
		"chance": 0.5
	},
	{
		"item_id": "twigs",
		"amount": 1,
		"chance": 1
	},
	
	{
		"item_id": "plant_fibre",
		"amount": 1,
		"chance": 0.2
	},

	
]
@export var pickup_time: float = 2      # seconds to hold interact

@export var inspect_text: String = "A small shrub, it's leaves bearing a slightly waxy surface"
