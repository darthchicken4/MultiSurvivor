extends Node2D

var actions: Array[String] = ["Inspect","Pick Up"]
var objectname = "Sharp Slab"

@export var pickup_loot_pool: Array[Dictionary] = [
	{
		"item_id": "sharp_slab",
		"amount": 1,
		"chance": 1
	},

	
]
@export var pickup_time: float = 3      # seconds to hold interact

@export var inspect_text: String = "A hard, flat slab with a particularly sharp edge."
