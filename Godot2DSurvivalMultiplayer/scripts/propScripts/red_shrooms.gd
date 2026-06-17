extends Node2D

var actions: Array[String] = ["Inspect","Pick Up"]
var objectname = "Red Mushrooms"

@export var pickup_loot_pool: Array[Dictionary] = [
	{
		"item_id": "red_mushroom",
		"amount": 2,
		"chance": 1
	},
	{
		"item_id": "red_mushroom",
		"amount": 1,
		"chance": 0.5
	},
	
]

@export var pickup_time: float = 0.5       # seconds to hold interact
@export var inspect_text: String = "Bright red spotted mushrooms... they look pretty appetizing"
