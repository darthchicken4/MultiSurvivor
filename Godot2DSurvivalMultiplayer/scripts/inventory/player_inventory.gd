class_name PlayerInventory
extends RefCounted

const INVENTORY_SIZE = 20  # 4x5 grid
var inventory_slots: Array[InventorySlot] = []
var hotbar_slots: Array[InventorySlot] = []

func _init():
	_initialize_slots()

func _initialize_slots():
	inventory_slots.clear()
	hotbar_slots.clear()
	for i in INVENTORY_SIZE:
		inventory_slots.append(InventorySlot.new())
	for i in 4:
		hotbar_slots.append(InventorySlot.new())
		
func get_inventory_slot(index:int) -> InventorySlot:

	if index >= 0 and index < inventory_slots.size():
		return inventory_slots[index]

	return null

func get_hotbar_slot(index:int) -> InventorySlot:

	if index >= 0 and index < hotbar_slots.size():
		return hotbar_slots[index]

	return null
	
func get_container_slot(container:String,index:int):

	match container:

		"inventory":
			return get_inventory_slot(index)

		"hotbar":
			return get_hotbar_slot(index)

	return null

func add_item(item: Item, quantity: int = 1) -> int:
	var remaining = quantity

	# First, try to add to existing stacks
	if item.stackable:
		for slot in inventory_slots:
			if slot.item_id == item.id:
				remaining = slot.add_item(item, remaining)
				if remaining <= 0:
					break

	# Then, try to add to empty inventory_slots
	if remaining > 0:
		for slot in inventory_slots:
			if slot.is_empty():
				remaining = slot.add_item(item, remaining)
				if remaining <= 0:
					break

	return remaining  # Returns what couldn't be added

func remove_item(item_id: String, quantity: int = 1) -> int:
	var removed = 0
	for slot in inventory_slots:
		if slot.item_id == item_id:
			var slot_removed = slot.remove_item(quantity - removed)
			removed += slot_removed
			if removed >= quantity:
				break
	return removed

func move_item(from_container:String,from_index:int,to_container:String,to_index:int,quantity:int=-1) -> bool:

	var from_slot = get_container_slot(from_container,from_index)
	var to_slot = get_container_slot(to_container,to_index)

	if not from_slot or not to_slot or from_slot.is_empty():
		return false

	# If quantity is -1, move entire stack
	var move_amount = quantity if quantity > 0 else from_slot.quantity
	move_amount = min(move_amount, from_slot.quantity)

	# Get item reference for validation
	var item = ItemDatabase.get_item(from_slot.item_id)
	if not item:
		
		return false

	# Check if we can add to destination
	if to_slot.can_add_item(item, move_amount):
		from_slot.remove_item(move_amount)
		to_slot.add_item(item, move_amount)
		return true

	# If can't stack in destination, try to stack in other available inventory_slots
	if to_slot.is_empty():
		from_slot.remove_item(move_amount)
		to_slot.add_item(item, move_amount)
		return true
	else:
		
		# Destination slot is occupied, try to stack in other available inventory_slots
		var remaining_after_stack = try_stack_item(item, move_amount, from_index)
		if remaining_after_stack < move_amount:
			# Successfully stacked at least part of the item
			var moved_amount = move_amount - remaining_after_stack
			from_slot.remove_item(moved_amount)

			# If something remains, move to destination slot
			if remaining_after_stack > 0:
				to_slot.add_item(item, remaining_after_stack)
			return true

	return false

func swap_items(from_container: String, from_index: int, to_container: String, to_index: int) -> bool:
	var from_slot = get_container_slot(from_container, from_index)
	var to_slot = get_container_slot(to_container, to_index)

	if not from_slot or not to_slot:
		return false

	if from_slot.item_id == to_slot.item_id and not from_slot.is_empty() and not to_slot.is_empty():
		var item = ItemDatabase.get_item(from_slot.item_id)

		if item and item.stackable:
			var total_quantity = from_slot.quantity + to_slot.quantity

			if total_quantity <= item.max_stack:
				to_slot.quantity = total_quantity
				from_slot.clear()
				return true
			else:
				var space_available = item.max_stack - to_slot.quantity
				var amount_to_move = min(space_available, from_slot.quantity)

				to_slot.quantity += amount_to_move
				from_slot.quantity -= amount_to_move

				if from_slot.quantity <= 0:
					from_slot.clear()

				return true

	var temp_item_id = from_slot.item_id
	var temp_quantity = from_slot.quantity

	from_slot.item_id = to_slot.item_id
	from_slot.quantity = to_slot.quantity

	to_slot.item_id = temp_item_id
	to_slot.quantity = temp_quantity

	return true

func get_item_count(item_id: String) -> int:
	var total = 0
	for slot in inventory_slots:
		if slot.item_id == item_id:
			total += slot.quantity
	return total

func has_item(item_id: String, quantity: int = 1) -> bool:
	return get_item_count(item_id) >= quantity

func get_first_empty_slot() -> int:
	for i in range(inventory_slots.size()):
		if inventory_slots[i].is_empty():
			return i
	return -1

func get_free_space_for_item(item: Item) -> int:
	var free_space = 0

	# Count space in existing stacks
	if item.stackable:
		for slot in inventory_slots:
			if slot.item_id == item.id:
				free_space += item.max_stack - slot.quantity

	# Count empty inventory_slots
	for slot in inventory_slots:
		if slot.is_empty():
			free_space += item.max_stack

	return free_space

func try_stack_item(item: Item, quantity: int, exclude_slot: int = -1) -> int:
	if not item.stackable:
		return quantity

	var remaining = quantity

	# First try to stack in existing inventory_slots (except origin slot)
	for i in range(inventory_slots.size()):
		if i == exclude_slot:
			continue

		var slot = inventory_slots[i]
		if slot.item_id == item.id and not slot.is_empty():
			var space_available = item.max_stack - slot.quantity
			if space_available > 0:
				var amount_to_stack = min(remaining, space_available)
				slot.quantity += amount_to_stack
				remaining -= amount_to_stack
				if remaining <= 0:
					break

	return remaining

func to_dict():

	var inventory_data=[]
	var hotbar_data=[]
	for slot in inventory_slots:
		inventory_data.append(slot.to_dict())
	for slot in hotbar_slots:
		hotbar_data.append(slot.to_dict())
	return {
		"inventory": inventory_data,
		"hotbar": hotbar_data
	}

func from_dict(data: Dictionary) -> void:
	var slots_data = data.get("inventory_slots", [])
	for i in range(min(slots_data.size(), inventory_slots.size())):
		inventory_slots[i].from_dict(slots_data[i])
