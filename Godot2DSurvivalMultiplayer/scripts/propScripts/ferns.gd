extends Node2D

var actions: Array[String] = ["Inspect","Pick Up"]
var objectname = "Fern"

@export var pickup_loot_pool: Array[Dictionary] = [
	{
		"item_id": "fern_leaf",
		"amount": 1,
		"chance": 1
	},
	{
		"item_id": "fern_leaf",
		"amount": 1,
		"chance": 0.5
	},
	{
		"item_id": "plant_fibre",
		"amount": 1,
		"chance": 0.5
	},
	{
		"item_id": "fern_leaf",
		"amount": 1,
		"chance": 0.2
	},
	
	
]
@export var pickup_time: float = 1      # seconds to hold interact
@export var inspect_text: String = "A luscious plant boasting large heavy, floppy leaves."
