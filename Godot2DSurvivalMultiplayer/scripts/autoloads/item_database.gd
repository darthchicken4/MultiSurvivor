extends Node

var items: Dictionary = {}

func _ready():
	_load_items()

func get_item(item_id: String) -> Item:
	return items.get(item_id)

func has_item(item_id: String) -> bool:
	return items.has(item_id)

func get_all_items() -> Dictionary:
	return items

func _load_items():
	_create_sample_items()

func _create_sample_items():
	

	# yellow_mushroom
	var yellow_mushroom = Item.new()
	yellow_mushroom.id = "yellow_mushroom"
	yellow_mushroom.name = "Yellow Mushroom"
	yellow_mushroom.description = "A soft mushroom with medicinal purposes... can be processed into a dangerous paralyzant"
	yellow_mushroom.item_type = Item.ItemType.CONSUMABLE
	yellow_mushroom.rarity = Item.ItemRarity.UNCOMMON
	yellow_mushroom.stackable = true
	yellow_mushroom.max_stack = 10
	yellow_mushroom.value = 5
	yellow_mushroom.icon = SpriteSheetLoader.get_texture("items1",1,1)
	items[yellow_mushroom.id] = yellow_mushroom

	# tree_branch
	
	var tree_branch = Item.new()
	tree_branch.id = "tree_branch"
	tree_branch.name = "Tree Branch"
	tree_branch.description = "A useful ingredient in primitive crafting, althought slightly fragile."
	tree_branch.item_type = Item.ItemType.RESOURCE
	tree_branch.rarity = Item.ItemRarity.COMMON
	tree_branch.stackable = true
	tree_branch.max_stack = 10
	tree_branch.value = 2
	tree_branch.icon = SpriteSheetLoader.get_texture("items1",2,1)
	items[tree_branch.id] = tree_branch
	
	# grass_strands
	var grass_strands = Item.new()
	grass_strands.id = "grass_strands"
	grass_strands.name = "Grass Strand"
	grass_strands.description = "A handful of grass strands that can be further refined into plant fibre."
	grass_strands.item_type = Item.ItemType.RESOURCE
	grass_strands.rarity = Item.ItemRarity.COMMON
	grass_strands.stackable = true
	grass_strands.max_stack = 10
	grass_strands.value = 1
	grass_strands.icon = SpriteSheetLoader.get_texture("items1",0,1)
	items[grass_strands.id] = grass_strands
	
	# grass_strands
	var small_stones = Item.new()
	small_stones.id = "small_stones"
	small_stones.name = "Small Stones"
	small_stones.description = "A collection of small, pebble sized stones."
	small_stones.item_type = Item.ItemType.RESOURCE
	small_stones.rarity = Item.ItemRarity.COMMON
	small_stones.stackable = true
	small_stones.max_stack = 10
	small_stones.value = 1
	small_stones.icon = SpriteSheetLoader.get_texture("items1",3,1)
	items[small_stones.id] = small_stones
	
	# flint_shard
	var flint_shard = Item.new()
	flint_shard.id = "flint_shard"
	flint_shard.name = "Flint Shard"
	flint_shard.description = "A sharp, brittle shard of flint that is great at sparking fire and being used to make primitive tools."
	flint_shard.item_type = Item.ItemType.RESOURCE
	flint_shard.rarity = Item.ItemRarity.UNCOMMON
	flint_shard.stackable = true
	flint_shard.max_stack = 10
	flint_shard.value = 8
	flint_shard.icon = SpriteSheetLoader.get_texture("items1",4,1)
	items[flint_shard.id] = flint_shard
	
	# waxed_leaves
	var waxed_leaves = Item.new()
	waxed_leaves.id = "waxed_leaves"
	waxed_leaves.name = "Waxed Leaves"
	waxed_leaves.description = "An assortment of small, round leaves with a slightly flamable wax coating."
	waxed_leaves.item_type = Item.ItemType.RESOURCE
	waxed_leaves.rarity = Item.ItemRarity.COMMON
	waxed_leaves.stackable = true
	waxed_leaves.max_stack = 10
	waxed_leaves.value = 1
	waxed_leaves.icon = SpriteSheetLoader.get_texture("items1",5,1)
	items[waxed_leaves.id] = waxed_leaves
	
	# twigs
	var twigs = Item.new()
	twigs.id = "twigs"
	twigs.name = "Twigs"
	twigs.description = "Small, fragile brittle pieces of wood best used as fuel."
	twigs.item_type = Item.ItemType.RESOURCE
	twigs.rarity = Item.ItemRarity.COMMON
	twigs.stackable = true
	twigs.max_stack = 10
	twigs.value = 1
	twigs.icon = SpriteSheetLoader.get_texture("items1",0,2)
	items[twigs.id] = twigs
	
	# plant_fibre
	var plant_fibre = Item.new()
	plant_fibre.id = "plant_fibre"
	plant_fibre.name = "Plant Fibre"
	plant_fibre.description = "Strong, inelastic plant fibres that can be further twisted into twine"
	plant_fibre.item_type = Item.ItemType.RESOURCE
	plant_fibre.rarity = Item.ItemRarity.COMMON
	plant_fibre.stackable = true
	plant_fibre.max_stack = 10
	plant_fibre.value = 3
	plant_fibre.icon = SpriteSheetLoader.get_texture("items1",1,2)
	items[plant_fibre.id] = plant_fibre
	
	# sharp_slab
	var sharp_slab = Item.new()
	sharp_slab.id = "sharp_slab"
	sharp_slab.name = "Sharp Slab"
	sharp_slab.description = "A large, very hard stone slab with a particularly sharp edge. This has various purposes."
	sharp_slab.item_type = Item.ItemType.RESOURCE
	sharp_slab.rarity = Item.ItemRarity.UNCOMMON
	sharp_slab.stackable = false
	sharp_slab.max_stack = 1
	sharp_slab.value = 10
	sharp_slab.icon = SpriteSheetLoader.get_texture("items1",2,2)
	items[sharp_slab.id] = sharp_slab
	
	# red_mushroom
	var red_mushroom = Item.new()
	red_mushroom.id = "red_mushroom"
	red_mushroom.name = "Red Mushroom"
	red_mushroom.description = "A tasty yet not super nutritious food source. May require to be cooked."
	red_mushroom.item_type = Item.ItemType.RESOURCE
	red_mushroom.rarity = Item.ItemRarity.COMMON
	red_mushroom.stackable = true
	red_mushroom.max_stack = 10
	red_mushroom.value = 2
	red_mushroom.icon = SpriteSheetLoader.get_texture("items1",3,2)
	items[red_mushroom.id] = red_mushroom
	
	# large_stone
	var large_stone = Item.new()
	large_stone.id = "large_stone"
	large_stone.name = "Large Stone"
	large_stone.description = "A heavy stone with mishapen sides. Can be further broken into smaller pieces."
	large_stone.item_type = Item.ItemType.RESOURCE
	large_stone.rarity = Item.ItemRarity.COMMON
	large_stone.stackable = true
	large_stone.max_stack = 10
	large_stone.value = 1
	large_stone.icon = SpriteSheetLoader.get_texture("items1",4,2)
	items[large_stone.id] = large_stone
	
	# fern_leaf
	var fern_leaf = Item.new()
	fern_leaf.id = "fern_leaf"
	fern_leaf.name = "Fern Leaf"
	fern_leaf.description = "A large, floppy fern leaf that can be used for many things."
	fern_leaf.item_type = Item.ItemType.RESOURCE
	fern_leaf.rarity = Item.ItemRarity.COMMON
	fern_leaf.stackable = true
	fern_leaf.max_stack = 10
	fern_leaf.value = 1
	fern_leaf.icon = SpriteSheetLoader.get_texture("items1",5,2)
	items[fern_leaf.id] = fern_leaf
	
	# raw_clay
	var raw_clay = Item.new()
	raw_clay.id = "raw_clay"
	raw_clay.name = "Raw Clay"
	raw_clay.description = "A clump of raw, moist, malleable clay. Can be formed to create basic pottery or meld stones together."
	raw_clay.item_type = Item.ItemType.RESOURCE
	raw_clay.rarity = Item.ItemRarity.COMMON
	raw_clay.stackable = true
	raw_clay.max_stack = 10
	raw_clay.value = 2
	raw_clay.icon = SpriteSheetLoader.get_texture("items1",3,0)
	items[raw_clay.id] = raw_clay
	
	# red_berries
	var red_berries = Item.new()
	red_berries.id = "red_berries"
	red_berries.name = "Red Berries"
	red_berries.description = "Delicious red berries with a sweet but slightly sour taste."
	red_berries.item_type = Item.ItemType.RESOURCE
	red_berries.rarity = Item.ItemRarity.COMMON
	red_berries.stackable = true
	red_berries.max_stack = 10
	red_berries.value = 2
	red_berries.icon = SpriteSheetLoader.get_texture("items1",1,0)
	items[red_berries.id] = red_berries
	
		# red_berries
	var thorny_bramble = Item.new()
	thorny_bramble.id = "thorny_bramble"
	thorny_bramble.name = "Thorny Bramble"
	thorny_bramble.description = "Small vines with large, solid thorns that can easily prick through skin."
	thorny_bramble.item_type = Item.ItemType.RESOURCE
	thorny_bramble.rarity = Item.ItemRarity.COMMON
	thorny_bramble.stackable = true
	thorny_bramble.max_stack = 10
	thorny_bramble.value = 2
	thorny_bramble.icon = SpriteSheetLoader.get_texture("items1",2,0)
	items[thorny_bramble.id] = thorny_bramble
	
		# twine
	var twine = Item.new()
	twine.id = "twine"
	twine.name = "Twine"
	twine.description = "Twisted together plant fibre to form a strong, thick string."
	twine.item_type = Item.ItemType.RESOURCE
	twine.rarity = Item.ItemRarity.COMMON
	twine.stackable = true
	twine.max_stack = 10
	twine.value = 2
	twine.icon = SpriteSheetLoader.get_texture("items1",0,3)
	items[twine.id] = twine
	
		# camp_fire
	var camp_fire = Item.new()
	camp_fire.id = "camp_fire"
	camp_fire.name = "Camp Fire"
	camp_fire.description = "A placeable campfire. Useful for early cooking and drying, but more importantly, to ward off the dangers of the night..."
	camp_fire.item_type = Item.ItemType.RESOURCE
	camp_fire.rarity = Item.ItemRarity.UNCOMMON
	camp_fire.stackable = false
	camp_fire.value = 15
	camp_fire.icon = SpriteSheetLoader.get_texture("placeables1",1,1)
	items[camp_fire.id] = camp_fire
	
		# branch_flint_hatchet
	var branch_flint_hatchet = Item.new()
	branch_flint_hatchet.id = "branch_flint_hatchet"
	branch_flint_hatchet.name = "Branch Flint Hatchet"
	branch_flint_hatchet.description = "A primitive early game survival tool, meant for hacking at wood."
	branch_flint_hatchet.item_type = Item.ItemType.TOOL
	branch_flint_hatchet.rarity = Item.ItemRarity.UNCOMMON
	branch_flint_hatchet.stackable = false
	branch_flint_hatchet.value = 15
	branch_flint_hatchet.icon = SpriteSheetLoader.get_texture("tools1",1,1)
	items[branch_flint_hatchet.id] = branch_flint_hatchet
	
		# branch_stone_spear
	var branch_stone_spear = Item.new()
	branch_stone_spear.id = "branch_stone_spear"
	branch_stone_spear.name = "Branch Stone Spear"
	branch_stone_spear.description = "An early fragile weapon. The tip isn't very sharp, but it can get the job done."
	branch_stone_spear.item_type = Item.ItemType.TOOL
	branch_stone_spear.rarity = Item.ItemRarity.COMMON
	branch_stone_spear.stackable = false
	branch_stone_spear.value = 12
	branch_stone_spear.icon = SpriteSheetLoader.get_texture("tools1",3,1)
	items[branch_stone_spear.id] = branch_stone_spear
	
		# branch_flint_hatchet
	var branch_flint_spear = Item.new()
	branch_flint_spear.id = "branch_flint_spear"
	branch_flint_spear.name = "Branch Flint Spear"
	branch_flint_spear.description = "Sharper than a stone spear and boasting a stronger flint tip."
	branch_flint_spear.item_type = Item.ItemType.TOOL
	branch_flint_spear.rarity = Item.ItemRarity.UNCOMMON
	branch_flint_spear.stackable = false
	branch_flint_spear.value = 15
	branch_flint_spear.icon = SpriteSheetLoader.get_texture("tools1",3,2)
	items[branch_flint_spear.id] = branch_flint_spear
	
	
	

func add_item_to_database(item: Item) -> bool:
	if item.id.is_empty():
		push_error("Cannot add item with empty ID to database")
		return false

	if items.has(item.id):
		push_warning("Item with ID '" + item.id + "' already exists in database. Overwriting.")

	items[item.id] = item
	return true

func remove_item_from_database(item_id: String) -> bool:
	if items.has(item_id):
		items.erase(item_id)
		return true
	return false
