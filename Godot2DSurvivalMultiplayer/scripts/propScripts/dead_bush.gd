extends Node2D

var actions: Array[String] = ["Inspect","Pick Up"]
var objectname = "Dead Bush"

@export var pickup_loot_pool: Array[Dictionary] = [
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

@export var inspect_text: String = "A long dead shrivelled up bush, seemingly effected by some mysterious ailement."
