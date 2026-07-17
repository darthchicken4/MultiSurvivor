extends Control

# Recipe database
@onready var recipes: Dictionary = CraftingDatabase.get_all_recipes()

# Button template
@onready var originalrbutton = $"MarginContainer/MarginContainer/HSplitContainer/selecting recepie_category_all/Label/ScrollContainer/VBoxContainer/recipebuttontemplate"
@onready var recipebuttontemplate

# Station image template
@onready var originalcraftingstationimage = $MarginContainer/MarginContainer/HSplitContainer/item_requierment/recipename/maincontainer/craftingtable_list/craftingstationtemplate
@onready var craftingstationimagetemplate

# Material template
@onready var originalmaterial = $MarginContainer/MarginContainer/HSplitContainer/item_requierment/recipename/maincontainer/material_list/materialtemplate
@onready var materialtemplate

# UI references
@onready var tabs = $MarginContainer/MarginContainer/HSplitContainer/select_group/select_tab.get_children()
@onready var recipebuttoncontainer = $"MarginContainer/MarginContainer/HSplitContainer/selecting recepie_category_all/Label/ScrollContainer/VBoxContainer"

@onready var maincontainer = $MarginContainer/MarginContainer/HSplitContainer/item_requierment/recipename/maincontainer
@onready var craftingtableimagelist = $MarginContainer/MarginContainer/HSplitContainer/item_requierment/recipename/maincontainer/craftingtable_list
@onready var materiallist = $MarginContainer/MarginContainer/HSplitContainer/item_requierment/recipename/maincontainer/material_list
@onready var recipename = $MarginContainer/MarginContainer/HSplitContainer/item_requierment/recipename
@onready var description = $MarginContainer/MarginContainer/HSplitContainer/item_requierment/recipename/maincontainer/description
@onready var crafting_station_text = $MarginContainer/MarginContainer/HSplitContainer/item_requierment/recipename/maincontainer/crafting_station2
@onready var materials_text = $MarginContainer/MarginContainer/HSplitContainer/item_requierment/recipename/maincontainer/materials


func _ready():
	
	# Save button template
	recipebuttontemplate = originalrbutton.duplicate()
	originalrbutton.queue_free()

	# Save station template
	craftingstationimagetemplate = originalcraftingstationimage.duplicate()
	originalcraftingstationimage.queue_free()

	# Save material template
	materialtemplate = originalmaterial.duplicate()
	originalmaterial.queue_free()

	# Connect tab buttons
	for tab in tabs:
		tab.pressed.connect(_on_tab_button_pressed.bind(tab))
		
		


func _on_tab_button_pressed(button: Button) -> void:

	# Remove old buttons
	for child in recipebuttoncontainer.get_children():
		child.queue_free()

	generate_recipe_buttons(button.text.strip_edges())


func generate_recipe_buttons(tag):

	# Find matching recipes
	var results = CraftingDatabase.get_recipes_by_tag(tag)

	for result in results:

		var newrecipebutton = recipebuttontemplate.duplicate()

		newrecipebutton.name = result.name
		newrecipebutton.text = result.name

		# Open recipe info
		newrecipebutton.pressed.connect(update_recipe_info.bind(result))

		recipebuttoncontainer.add_child(newrecipebutton)


func update_recipe_info(recipe: CraftingRecipe):
	
	# Update recipe text
	recipename.text = recipe.name
	description.text = recipe.description

	# Build requirements text
	var requirementsstring = "Requirements: "
	for child in craftingtableimagelist.get_children():
		child.queue_free()
	for station in recipe.craftableStations:

		# Add comma separator
		if recipe.craftableStations.find(station) != 0:
			requirementsstring += ", "

		requirementsstring += station

		var image = craftingstationimagetemplate.duplicate()
		image.texture = CraftingDatabase.craftingStations[station]
		craftingtableimagelist.add_child(image)
	crafting_station_text.text = requirementsstring



	for child in materiallist.get_children():
		child.queue_free()
	for material in recipe.ingredients:


		var materialentry = materialtemplate.duplicate()

		materialentry.get_child(0).texture = ItemDatabase.items[material].icon
		materialentry.get_child(0).get_child(0).text = str(recipe.ingredients[material])
		materialentry.get_child(0).get_child(1).text = ItemDatabase.items[material].name
		materiallist.add_child(materialentry)
		print(materialentry.get_child(0).texture)


# Toggle crafting menu
func toggle_crafting_ui():
	visible = !visible


# Listen for input
func _unhandled_input(event: InputEvent) -> void:

	if event.is_action_pressed("craftingmenu"):
		toggle_crafting_ui()
