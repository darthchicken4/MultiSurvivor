var actions: Array[String] = ["Inspect","Pick Up"]
var objectname = "Big obelisk"

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
@export var inspect_text: String = "WASD inscribed in the obelisk ,I think he was referecing the way you move in Garden Masacre."
