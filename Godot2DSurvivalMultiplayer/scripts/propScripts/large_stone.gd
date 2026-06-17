extends Node2D

var actions: Array[String] = ["Inspect","Pick Up"]
var objectname = "Large Stones"

@export var pickup_loot_pool: Array[Dictionary] = [
	{
		"item_id": "large_stone",
		"amount": 2,
		"chance": 1
	},
	{
		"item_id": "large_stone",
		"amount": 1,
		"chance": 0.3
	},
	
]
@export var pickup_time: float = 2       # seconds to hold interact
@export var inspect_text: String = "Some large, rough stones of varying shapes and sizes."
