extends Node2D

var actions: Array[String] = ["Inspect","Pick Up"]
var objectname = "Yellow Mushrooms"

@export var pickup_loot_pool: Array[Dictionary] = [
	{
		"item_id": "yellow_mushroom",
		"amount": 2,
		"chance": 1
	},
	{
		"item_id": "yellow_mushroom",
		"amount": 1,
		"chance": 0.5
	},
	
]

@export var pickup_time: float = 0.5       # seconds to hold interact
@export var inspect_text: String = "Soft, moist yellow mushrooms... you are unsure whether they can be consumed."
