extends Node

var recipes: Dictionary = {}


func _ready():
	_load_recipes()


# =========================================================
# RECIPE API
# =========================================================

func get_recipe(recipe_id: String) -> CraftingRecipe:
	return recipes.get(recipe_id)


func has_recipe(recipe_id: String) -> bool:
	return recipes.has(recipe_id)


func get_all_recipes() -> Dictionary:
	return recipes


func add_recipe(recipe: CraftingRecipe) -> bool:
	if recipe == null:
		push_error("Cannot add null recipe")
		return false

	if recipe.id.is_empty():
		push_error("Cannot add recipe with empty ID")
		return false

	if recipes.has(recipe.id):
		push_warning("Recipe '" + recipe.id + "' already exists. Overwriting.")

	recipes[recipe.id] = recipe
	return true


func remove_recipe(recipe_id: String) -> bool:
	return recipes.erase(recipe_id)



func _load_recipes():
	_create_sample_recipes()

func _create_sample_recipes():

	#################################################################
	var recipe = CraftingRecipe.new()
	recipe.id = "craft_plant_fibre_grass"
	recipe.name = "Create plant fibre"
	recipe.ingredients = {
		"grass_strands": 4,
		}
	
	recipe.craftableStations = [
		CraftingRecipe.CraftingStationType.HAND,
		CraftingRecipe.CraftingStationType.WORKBENCH_1,
		CraftingRecipe.CraftingStationType.WORKBENCH_2,
		CraftingRecipe.CraftingStationType.WORKBENCH_3
								]
	recipe.crafting_time = 1
	recipe.result_item = ItemDatabase.items["plant_fibre"]
	recipe.result_amount = 1
	recipes[recipe.id] = recipe
	#################################################################
	
	recipe = CraftingRecipe.new()
	recipe.id = "dry_plant_fibre_grass_"
	recipe.name = "Dry Grass"
	recipe.ingredients= {
		"grass_strands": 1,
		}
	
	recipe.craftableStations = [
		CraftingRecipe.CraftingStationType.CAMPFIRE,
		CraftingRecipe.CraftingStationType.FURNACE,
		CraftingRecipe.CraftingStationType.FORGE,
								]
	recipe.crafting_time = 2
	recipe.result_item = ItemDatabase.items["plant_fibre"]
	recipe.result_amount = 1
	recipes[recipe.id] = recipe
	
	#################################################################
	recipe = CraftingRecipe.new()
	recipe.id = "cook_red_mushrooms"
	recipe.name = "Cook Red Mushrooms"
	recipe.ingredients = {
		"red_mushrooms": 1,
		}
	recipe.craftableStations = [
		CraftingRecipe.CraftingStationType.CAMPFIRE,
		CraftingRecipe.CraftingStationType.FURNACE,
		CraftingRecipe.CraftingStationType.FORGE,
								]
	recipe.crafting_time = 2
	recipe.result_item = ItemDatabase.items["plant_fibre"]
	recipe.result_amount = 1
	recipes[recipe.id] = recipe
	
	
	#################################################################
	recipe = CraftingRecipe.new()
	recipe.id = "create_camp_fire_branches"
	recipe.name = "Create Campfire"
	recipe.ingredients = {
		"tree_branch": 7,
		"twigs": 2,
		"large_stone": 8,
		}
	recipe.craftableStations = [
		CraftingRecipe.CraftingStationType.HAND,
		CraftingRecipe.CraftingStationType.WORKBENCH_1,
		CraftingRecipe.CraftingStationType.WORKBENCH_2,
		CraftingRecipe.CraftingStationType.WORKBENCH_3,
								]
	recipe.crafting_time = 5
	recipe.result_item = ItemDatabase.items["camp_fire"]
	recipe.result_amount = 1
	recipes[recipe.id] = recipe
	
	
	#################################################################
	recipe = CraftingRecipe.new()
	recipe.id = "twist_twine_plant_fibre"
	recipe.name = "Twist Twine"
	recipe.ingredients = {
		"plant_fibre": 5,
		}
	recipe.craftableStations = [
		CraftingRecipe.CraftingStationType.HAND,
		CraftingRecipe.CraftingStationType.WORKBENCH_1,
		CraftingRecipe.CraftingStationType.WORKBENCH_2,
		CraftingRecipe.CraftingStationType.WORKBENCH_3,
								]
	recipe.crafting_time = 3
	recipe.result_item = ItemDatabase.items["twine"]
	recipe.result_amount = 1
	recipes[recipe.id] = recipe
	
	#################################################################
	recipe = CraftingRecipe.new()
	recipe.id = "branch_flint_hatchet"
	recipe.name = "Craft Branch Flint Hatchet"
	recipe.ingredients = {
		"twine": 2,
		"flint_shard": 1,
		"tree_branch": 1,
		}
	recipe.craftableStations = [
		CraftingRecipe.CraftingStationType.HAND,
		CraftingRecipe.CraftingStationType.WORKBENCH_1,
		CraftingRecipe.CraftingStationType.WORKBENCH_2,
		CraftingRecipe.CraftingStationType.WORKBENCH_3,
								]
	recipe.crafting_time = 8
	recipe.result_item = ItemDatabase.items["branch_flint_hatchet"]
	recipe.result_amount = 1
	recipes[recipe.id] = recipe
	
	
	#################################################################
	recipe = CraftingRecipe.new()
	recipe.id = "smash_large_stone"
	recipe.name = "Smash Large Stone"
	recipe.ingredients = {
		"large_stone": 1,

		}
	recipe.craftableStations = [
		CraftingRecipe.CraftingStationType.SLAB_ANVIL,
		CraftingRecipe.CraftingStationType.HAMMERING_SURFACE,
		CraftingRecipe.CraftingStationType.IRON_ANVIL,
								]
	recipe.crafting_time = 3
	recipe.result_item = ItemDatabase.items["small_stones"]
	recipe.result_amount = 1
	recipes[recipe.id] = recipe
	
	
	
	#################################################################
	recipe = CraftingRecipe.new()
	recipe.id = "branch_stone_spear"
	recipe.name = "Make Branch-Stone Spear"
	recipe.ingredients = {
		"small_stones": 1,
		"tree_branch": 2,
		"twine": 2,

		}
	recipe.craftableStations = [
		CraftingRecipe.CraftingStationType.HAND,
		CraftingRecipe.CraftingStationType.WORKBENCH_1,
		CraftingRecipe.CraftingStationType.WORKBENCH_2,
		CraftingRecipe.CraftingStationType.WORKBENCH_3,
								]
	recipe.crafting_time = 8
	recipe.result_item = ItemDatabase.items["branch_stone_spear"]
	recipe.result_amount = 1
	recipes[recipe.id] = recipe
	
	
	
	
	#################################################################
	recipe = CraftingRecipe.new()
	recipe.id = "branch_flint_spear"
	recipe.name = "Make Branch-Flint Spear"
	recipe.ingredients = {
		"flint_shard": 1,
		"tree_branch": 2,
		"twine": 2,

		}
	recipe.craftableStations = [
		CraftingRecipe.CraftingStationType.HAND,
		CraftingRecipe.CraftingStationType.WORKBENCH_1,
		CraftingRecipe.CraftingStationType.WORKBENCH_2,
		CraftingRecipe.CraftingStationType.WORKBENCH_3,
								]
	recipe.crafting_time = 8
	recipe.result_item = ItemDatabase.items["branch_flint_spear"]
	recipe.result_amount = 1
	recipes[recipe.id] = recipe
