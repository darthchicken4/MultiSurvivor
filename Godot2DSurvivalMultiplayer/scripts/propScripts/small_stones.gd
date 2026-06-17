extends Node2D

var actions: Array[String] = ["Inspect","Pick Up"]
var objectname = "Small stones"

@export var pickup_loot_pool: Array[Dictionary] = [
	{
		"item_id": "small_stones",
		"amount": 1,
		"chance": 1
	},
	{
		"item_id": "small_stones",
		"amount": 1,
		"chance": 0.3
	},
	{
		"item_id": "flint_shard",
		"amount": 1,
		"chance": 0.5
	},
	
]
@export var pickup_time: float = 1.5      # seconds to hold interact

@export var inspect_text: String = "A scattered assortment of pebbles, some different types than others."
