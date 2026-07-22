extends Control
class_name InventorySlotUI

@onready var background: ColorRect = $Background
@onready var item_icon: TextureRect = $ItemIcon
@onready var quantity_label: Label = $QuantityLabel
@onready var rarity_border: NinePatchRect = $RarityBorder

var slot_index: int = 0
var inventory_data: InventorySlot
var parent_inventory: Control
var container_type:String

signal slot_clicked(container_type: String, slot_index: int, button: int)
signal item_hovered(container_type: String, slot_index: int, item: Item)
signal item_unhovered

const RARITY_COLORS = {
	Item.ItemRarity.COMMON: Color.WHITE,
	Item.ItemRarity.UNCOMMON: Color.GREEN,
	Item.ItemRarity.RARE: Color.BLUE,
	Item.ItemRarity.EPIC: Color.PURPLE,
	Item.ItemRarity.LEGENDARY: Color.ORANGE
}

func _ready():
	gui_input.connect(_on_gui_input)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	update_display()

func set_slot_data(slot_data: InventorySlot, index: int, container: String):
	inventory_data = slot_data
	slot_index = index
	container_type = container
	update_display()

func update_display():
	if not inventory_data or inventory_data.is_empty():
		_show_empty_slot()
	else:
		_show_item_slot()

func _show_empty_slot():
	if item_icon:
		item_icon.texture = null
	if quantity_label:
		quantity_label.visible = false
	if rarity_border:
		rarity_border.visible = false

func _show_item_slot():
	var item = ItemDatabase.get_item(inventory_data.item_id)
	if not item:
		_show_empty_slot()
		return

	item_icon.texture = item.icon

	if item.stackable and inventory_data.quantity > 1:
		quantity_label.text = str(inventory_data.quantity)
		quantity_label.visible = true
	else:
		quantity_label.visible = false

	if RARITY_COLORS.has(item.rarity):
		rarity_border.modulate = RARITY_COLORS[item.rarity]
		rarity_border.visible = true
	else:
		rarity_border.visible = false

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.pressed:
			slot_clicked.emit(container_type, slot_index, event.button_index)

func _on_mouse_entered():
	if inventory_data and not inventory_data.is_empty():
		var item = ItemDatabase.get_item(inventory_data.item_id)
		if item:
			item_hovered.emit(container_type, slot_index, item)

	background.modulate = Color(1.2, 1.2, 1.2)

func _on_mouse_exited():
	item_unhovered.emit()

	background.modulate = Color.WHITE

func _can_drop_data(_position: Vector2, data) -> bool:
	return data is Dictionary and data.has("slot_index") and data.has("container")
	
func _drop_data(_position: Vector2, data):
	print("Dropped from ", data["container"], " to ", container_type)
	if parent_inventory and parent_inventory.has_method("handle_item_drop"):
		parent_inventory.handle_item_drop(data["container"], data["slot_index"], container_type, slot_index)

func _get_drag_data(_position: Vector2):
	print("Dragging ", container_type, " slot ", slot_index)
	if not inventory_data or inventory_data.is_empty():
		return null

	var item = ItemDatabase.get_item(inventory_data.item_id)
	if not item:
		return null

	var preview = Control.new()
	var preview_icon = TextureRect.new()
	preview_icon.texture = item.icon
	preview_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview_icon.size = Vector2(32, 32)
	preview.add_child(preview_icon)

	preview.modulate = Color(1, 1, 1, 0.8)
	set_drag_preview(preview)

	item_icon.modulate = Color(0.5, 0.5, 0.5)

	return {
		"slot_index": slot_index,
		"container": container_type,
		"item_id": inventory_data.item_id,
		"quantity": inventory_data.quantity,
		"inventory_type": "player"
	}

func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		item_icon.modulate = Color.WHITE
