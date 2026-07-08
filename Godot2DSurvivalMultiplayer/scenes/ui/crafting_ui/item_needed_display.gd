extends Panel

@export var item_sprite_index = 0 
@export var item_ammount_display = 0 
@export var item_name = ''

@onready var item_name_label = $items/item_name
@onready var item_sprite = $items
@onready var item_amount_label = $items/amount

func _process(delta: float) -> void: 
	item_name_label.text = item_name
	item_sprite.frame = item_sprite_index
	item_amount_label = item_ammount_display
