class_name CraftingRecipe
extends Resource


@export var id: String = ""
@export var name: String = ""
@export var description: String = ""
@export var icon: Texture2D


@export var result_item: Item
@export var result_amount: int = 1


@export var ingredients: Dictionary = {}
@export var craftingtag = ""

@export var crafting_time: float = 0.0

@export var craftableStations = []


# -------------------------
# Helper Functions
# -------------------------

func can_craft_at(station: String) -> bool:
	# If no stations are required, can craft anywhere
	if craftableStations.is_empty():
		return true
	
	return station in craftableStations


func get_ingredient_count(item_id: String) -> int:
	return ingredients.get(item_id, 0)


func has_ingredients(inventory: PlayerInventory) -> bool:
	for item_id in ingredients.keys():
		if inventory.get_item_count(item_id) < ingredients[item_id]:
			return false

	return true

func consume_ingredients(inventory: PlayerInventory) -> void:
	for item_id in ingredients.keys():
		inventory.remove_item(item_id, ingredients[item_id])

func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"result_amount": result_amount,
		"crafting_time": crafting_time,
		"required_stations": craftableStations
	}
	
