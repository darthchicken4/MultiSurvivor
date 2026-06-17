extends Node2D

var actions: Array[String] = ["Inspect","Pick Up"]
var objectname = "Tall Grass"

@export var pickup_loot_pool: Array[Dictionary] = [
	{
		"item_id": "grass_strands",
		"amount": 1,
		"chance": 1
	},
	{
		"item_id": "grass_strands",
		"amount": 1,
		"chance": 0.3
	},
	{
		"item_id": "grass_strands",
		"amount": 1,
		"chance": 0.2
	},
	{
		"item_id": "grass_strands",
		"amount": 1,
		"chance": 0.2
	},
	
]
@export var pickup_time: float = 1.5      # seconds to hold interact
@export var inspect_text: String = "A spot of long, overgrown grass, unchecked in the wilderness."
