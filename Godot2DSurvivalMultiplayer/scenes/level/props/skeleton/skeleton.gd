extends Node2D

var actions: Array[String] = ["Inspect","Pick Up"]
var objectname = "skeleton"

@export var pickup_loot_pool: Array[Dictionary] = []
@export var pickup_time: float = 10      # seconds to hold interact

@export var inspect_text: String = "dead guy was aight, had alot of cool stuff "
