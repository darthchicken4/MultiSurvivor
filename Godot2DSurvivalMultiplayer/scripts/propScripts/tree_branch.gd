extends Node2D

var actions: Array[String] = ["Inspect","Pick Up"]
var objectname = "Tree Branch"


@export var pickup_loot_pool: Array[Dictionary] = [
	{
		"item_id": "tree_branch",
		"amount": 1,
		"chance": 1
	},
]

@export var pickup_time: float = 0.5       # seconds to hold interact
@export var inspect_text: String = "A fallen tree branch, it's wood lifeless and brittle yet bearing green pine needles."
