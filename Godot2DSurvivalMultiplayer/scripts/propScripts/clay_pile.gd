extends Node2D

var actions: Array[String] = ["Inspect","Pick Up"]
var objectname = "Clay Mound"

@export var pickup_loot_pool: Array[Dictionary] = [
	{
		"item_id": "raw_clay",
		"amount": 1,
		"chance": 1
	},
	{
		"item_id": "raw_clay",
		"amount": 1,
		"chance": 0.2
	},
	{
		"item_id": "raw_clay",
		"amount": 1,
		"chance": 0.2
	},
	{
		"item_id": "raw_clay",
		"amount": 1,
		"chance": 0.2
	},
	

	
]
@export var pickup_time: float = 2      # seconds to hold interact

@export var inspect_text: String = "A clump wet mud mixed with amounts of clay."
