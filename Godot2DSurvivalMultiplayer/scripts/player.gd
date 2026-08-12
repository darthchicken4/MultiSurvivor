extends CharacterBody2D
class_name Character

@export var NORMAL_SPEED : float = 100.0
const SPRINT_SPEED : float  = 150.0
const EXHAUST_SPEED : float  = 70.0
const AIM_SPEED : float  = 90.0
enum SkinColor { BLUE, YELLOW, GREEN, RED }

var mouse_icon_attack = preload("res://scenes/ui/mouse_icons/attack.png")


@onready var nickname: Label = $PlayerNick/Nickname
@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = $"."
@onready var inventory: InventoryUI = $CanvasLayer/InventoryUI
@onready var interactMenu: Control = $InteractMenu
@onready var chat: MultiplayerChatUI = $CanvasLayer/MultiplayerChatUI
@onready var pause_menu : Control = $CanvasLayer/PauseMenu
@onready var stats = $CanvasLayer/StatsUi
@onready var respawnUI = $CanvasLayer/RespawnUi
@onready var tool_pivot = $ToolPivot

@onready var foot_step_sounds := {
	"default": $audio/grass_foot_steps,
	"gravel": $audio/gravel_foot_steps,
	"rock": $audio/rock_foot_steps
}

@export var tile_map : TileMapLayer

@export var blood_particle : GPUParticles2D



@export var stamina_value : float = 10.0
@export var stamina_timer : float = 10.0 #sec
@export var stamina_tick_rate : float = 0.3

@export var recovery_delay: float = 1.0  
@export var recovery_rate: float = 1.0

@export var health : float= 20.0
@export var max_health : float = 20.0
@export var damage_reduction : float = 1.0

@export var hunger_value : float= 20.0
@export var hunger_tick : float= 0.3 #time to hunger go down
@export var hunger_max : float = 20.0

@export var progres_bar : Control 
@export var can_die = false

var player_inventory: PlayerInventory
var selected_hotbar_slot := -1

var _current_speed : float
var _respawn_point :Vector2 = Vector2(0, 0)
var chat_visible :bool = false
var inventory_visible :bool = false

var _health_tick_timer := 0.0

var max_stamina: float = 10.0
var can_sprint_again :bool = false
var _time_since_stopped_running: float = 0.0
var current_surface = "default"


func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
	$Camera2D.enabled = is_multiplayer_authority()
	


func find_tile_map():
	tile_map = get_parent().get_parent().get_child(2)
func _ready():
	update_stamina()
	update_saturation()
	find_tile_map()
	if not is_multiplayer_authority(): return
	
	
	var is_local_player = is_multiplayer_authority()
	var local_client_id = multiplayer.get_unique_id()
	
	print("Debug: Player ", name, " ready - authority: ", get_multiplayer_authority(), ", local client: ", local_client_id, ", is_local: ", is_local_player)

	if is_local_player:
		GameManager.setPlayer(self)
		player_inventory = PlayerInventory.new()
		_add_starting_items()
		inventory.visible = true
		stats.visible = true
	elif multiplayer.is_server():
		player_inventory = PlayerInventory.new()
		_add_starting_items()
	else:
		if get_multiplayer_authority() == local_client_id:
			request_inventory_sync.rpc_id(1)
	inventory.inventory_closed.connect(_on_inventory_closed)

func _physics_process(_delta):
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is CharacterBody2D:
			var push_dir = (global_position - collision.get_collider().global_position).normalized()
			global_position += push_dir * 1.0
	var current_scene = get_tree().get_current_scene()
	if current_scene:
		var should_freeze = false
		if current_scene.has_method("is_chat_visible") and current_scene.is_chat_visible():
			should_freeze = true
		elif current_scene.has_method("is_inventory_visible") and current_scene.is_inventory_visible():
			should_freeze = true

		if should_freeze:
			freeze()
			return
	_move()
	move_and_slide()
	_check_bounds_and_respawn()
	pause_menu_show()
func _process(_delta):
	_animate()
	look_at_mouse()
	update_health(_delta)
	death_check()


func freeze():
	velocity = Vector2.ZERO
	_current_speed = 0

func _move() -> void:
	var _input_direction: Vector2 = Vector2.ZERO
	if is_multiplayer_authority():
		_input_direction = Input.get_vector(
			"move_left", "move_right",
			"move_forward", "move_backward"
			)



	if _input_direction != Vector2.ZERO:
		velocity = _input_direction.normalized() * _current_speed
		return

	velocity = velocity.move_toward(Vector2.ZERO, _current_speed)



func _animate() -> void:
	#change_sound() pls fix 
	if velocity.length() > 0.1:
		_sprite.play("walk")
		if not foot_step_sounds[current_surface].playing:
			_play_footstep_networked(current_surface)
		if velocity.x != 0:
			_sprite.flip_h = velocity.x < 0
	else:
		_sprite.play("idle")
		if foot_step_sounds[current_surface].playing:
			_stop_footstep_networked(current_surface)



func _play_footstep_networked(surface_type: String) -> void:
	# Only the player who owns this character triggers the RPC
	if not is_multiplayer_authority():
		return
	_play_footstep.rpc(surface_type)


func _stop_footstep_networked(surface_type: String) -> void:
	if not is_multiplayer_authority():
		return
	_stop_footstep.rpc(surface_type)


@rpc("call_local", "reliable")
func _play_footstep(surface_type: String) -> void:
	if foot_step_sounds.has(surface_type):
		foot_step_sounds[surface_type].play()
	else:
		foot_step_sounds["default"].play()


@rpc("call_local", "reliable")
func _stop_footstep(surface_type: String) -> void:
	if foot_step_sounds.has(surface_type):
		foot_step_sounds[surface_type].stop()


func get_player_tile() -> Vector2i:
	var local_pos = tile_map.to_local(global_position)
	return tile_map.local_to_map(local_pos)

func change_sound():
	var cell := get_player_tile()
	var data : TileData = tile_map.get_cell_tile_data(cell)
	var int_type = data.get_custom_data("terrain_type")

	current_surface = convert_tile_data(int_type)

func convert_tile_data(terrain_type):
	match terrain_type:
		0:
			return "default"
		1:
			return "gravel"
		2:
			return "rock"

func _debug_add_item():
	var local_player = player
	if local_player:
		var test_items = [
		"camp_fire",
		"red_mushroom",
		"branch_flint_hatchet",
		"yellow_mushroom",
		"tree_branch",
		"grass_strands",
		"small_stones",
		"flint_shard",
		"waxed_leaves",
		"twigs",
		"plant_fibre",
		"sharp_slab",
		"large_stone",
		"fern_leaf",
		"raw_clay",
		"red_berries",
		"thorny_bramble",
		"twine",
		"branch_stone_spear",
		"branch_flint_spear"
		]
		var random_item = test_items[randi() % test_items.size()]
		print("Debug: Requesting to add ", random_item, " to player ", local_player.name, " (authority: ", local_player.get_multiplayer_authority(), ")")
		local_player.request_add_item.rpc_id(1, random_item, 1)
	else:
		print("Debug: No local player found!")

func _debug_print_inventory():
	var local_player = player
	if local_player and local_player.get_inventory():
		var inventory = local_player.get_inventory()
		print("=== Inventory Debug ===")

		for i in range(inventory.inventory_slots.size()):
			var slot = inventory.get_inventory_slot(i)
			if slot and not slot.is_empty():
				print("Inventory Slot ", i, ": ", slot.item_id, " x", slot.quantity)

		for i in range(inventory.hotbar_slots.size()):
			var slot = inventory.get_hotbar_slot(i)
			if slot and not slot.is_empty():
				print("Hotbar Slot ", i, ": ", slot.item_id, " x", slot.quantity)

		print("=====================")
	else:
		print("No inventory found for local player")
		
func is_inventory_visible() -> bool:
	return inventory_visible
	
func update_local_inventory_display():
	if inventory:
		inventory.refresh_display()
		print("Debug: Inventory display updated from server sync")
		
func _on_inventory_closed():
	inventory_visible = false
	
func _select_hotbar_slot(slot: int):
		if inventory:
			var inventory_ui = inventory
			if selected_hotbar_slot == slot:
				if selected_hotbar_slot!=-1: inventory_ui.slot_uis[PlayerInventory.INVENTORY_SIZE+selected_hotbar_slot].toggle_select(false)
				if tool_pivot.get_child(0): tool_pivot.get_child(0).queue_free()
				selected_hotbar_slot = -1
				print("Deselected hotbar")
			else:
				if selected_hotbar_slot!=-1: inventory_ui.slot_uis[PlayerInventory.INVENTORY_SIZE+selected_hotbar_slot].toggle_select(false)
				selected_hotbar_slot = slot
				var item_id = get_inventory().get_hotbar_slot(selected_hotbar_slot).item_id;
				if ItemDatabase.has_item(item_id):
					var template = ItemDatabase.get_item(item_id).template.instantiate()
					var icon = ItemDatabase.get_item(item_id).icon
					if tool_pivot.get_child(0): tool_pivot.get_child(0).queue_free()
					tool_pivot.add_child(template)
					var sprite = template.get_node("Weapon").get_node("Sprite")
					if sprite:
						sprite.texture = icon
				inventory_ui.slot_uis[PlayerInventory.INVENTORY_SIZE+selected_hotbar_slot].toggle_select(true)
		
func _unhandled_input(event):
	if event is InputEventMouseButton \
			and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:

		var mouse_position = get_global_mouse_position()
		var direction = (mouse_position - global_position).normalized()

		if tool_pivot.get_child_count() > 0:
			var tool = tool_pivot.get_child(0)
			if tool.has_method("_activate"):
				tool._activate()
				
func _input(event):
	if not is_multiplayer_authority():
		return
	if event.is_action_pressed("toggle_chat"):
		toggle_chat()
	elif chat_visible and chat.message.has_focus():
		if event is InputEventKey and event.keycode == KEY_ENTER and event.pressed:
			chat._on_send_pressed()
			get_viewport().set_input_as_handled()
	elif event.is_action_pressed("inventory"):
		toggle_inventory()
	elif event is InputEventKey and event.pressed and event.keycode == KEY_F1:
		_debug_add_item()
	elif event is InputEventKey and event.pressed and event.keycode == KEY_F2:
		_debug_print_inventory()

	elif event is InputEventMouseButton:
		print(get_viewport().gui_get_hovered_control())
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			# Don't open another menu if one is already open
			if interactMenu.visible:
				return
			var mouse_pos = get_global_mouse_position()
			# Check if we're hovering over something interactable
			var tilemaplayer =  get_parent().get_parent().get_node("TileMapLayer")
			
			if tilemaplayer:
				var target =  tilemaplayer.get_tile_object((mouse_pos))
				print(target)
				
				
				if target:	
					interactMenu.open(
						get_global_mouse_position(),
						target,
						target.actions
					)
	elif event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1:
				_select_hotbar_slot(0)
			KEY_2:
				_select_hotbar_slot(1)
			KEY_3:
				_select_hotbar_slot(2)
			KEY_4:
				_select_hotbar_slot(3)
func toggle_chat():
	chat.toggle_chat()
	chat_visible = chat.is_chat_visible()
#runn
func show_respawn_ui():
	pass
	
func look_at_mouse():
	var mouse_position = get_global_mouse_position()
	var direction = mouse_position - global_position
	var target_angle = direction.angle()

	if Input.is_action_pressed("look_at"):
		_sprite.flip_h = abs(target_angle) > PI / 2
		_current_speed = AIM_SPEED
		Input.set_custom_mouse_cursor(mouse_icon_attack)
	else:
		Input.set_custom_mouse_cursor(null)
func is_running() -> bool:
	if Input.is_action_pressed("shift") and can_sprint_again and stamina_value > 0.0:
		_current_speed = SPRINT_SPEED
		_time_since_stopped_running = 0.0
		return true
	else:
		_current_speed = NORMAL_SPEED if can_sprint_again else EXHAUST_SPEED
		return false

func update_stamina() -> void:
	while true:
		await Utils.wait(0.01)

		if is_running():
			stamina_value -= stamina_tick_rate / 10
			if stamina_value <= 0.0:
				stamina_value = 0.0
				can_sprint_again = false
		else:
			_time_since_stopped_running += 0.01

			# only start regenerating after the delay has passed
			if _time_since_stopped_running >= recovery_delay:
				stamina_value += recovery_rate / 10
				if stamina_value >= max_stamina:
					stamina_value = max_stamina
					can_sprint_again = true

func update_saturation() -> void:
	while true:
		await Utils.wait(1.0)
		hunger_value -= hunger_tick
		if hunger_value < 0.0:
			hunger_value = 0.0
			health -= 1.2

func update_health(delta: float) -> void:
	_health_tick_timer += delta
	if _health_tick_timer >= 0.3:
		_health_tick_timer -= 0.3
		if hunger_value > hunger_max * 0.75:
			health += 0.2


var _is_dead = false

func death_check():
	if health <= 0 and not _is_dead:
		_is_dead = true
		_current_speed = 0

		_sprite.play("death")
		await _sprite.animation_finished

		_on_death_finished()

func _on_death_finished():
	_current_speed = 0
func damage_player(amount):
	health -= amount * damage_reduction

func pause_menu_show():
	if Input.is_action_just_pressed("quit"):
		pause_menu.visible = !pause_menu.visible

func _check_bounds_and_respawn():
	if global_position.y > 20000000.0:
		_respawn()

func _respawn():
	var respawn_area_size = 100
	var respawn_area =Vector2(randi_range(-respawn_area_size,respawn_area_size),randi_range(-respawn_area_size,respawn_area_size))
	global_position = respawn_area
	velocity = Vector2.ZERO

@rpc("any_peer", "reliable")
func change_nick(new_nick: String):
	if nickname:
		nickname.text = new_nick

@rpc("any_peer", "reliable")
func set_player_skin(skin_name: SkinColor) -> void:
	pass # implement when you have skin assets

# Inventory Network Functions - Server authoritative, client-specific
@rpc("any_peer", "call_local", "reliable")
func request_inventory_sync():
	print("Debug: request_inventory_sync called on player ", name, " (authority: ", get_multiplayer_authority(), ") by client ", multiplayer.get_remote_sender_id())

	if not multiplayer.is_server():
		return

	var requesting_client = multiplayer.get_remote_sender_id()
	if requesting_client != get_multiplayer_authority():
		push_warning("Client " + str(requesting_client) + " tried to request inventory for player " + str(get_multiplayer_authority()))
		return

	if player_inventory:
		sync_inventory_to_owner.rpc_id(requesting_client, player_inventory.to_dict())

@rpc("any_peer", "call_local", "reliable")
func sync_inventory_to_owner(inventory_data: Dictionary):
	print("Debug: sync_inventory_to_owner called on player ", name, " (authority: ", get_multiplayer_authority(), ") - local unique id: ", multiplayer.get_unique_id(), " from: ", multiplayer.get_remote_sender_id())

	if multiplayer.get_remote_sender_id() != 1:
		return

	if not is_multiplayer_authority():
		return

	if not player_inventory:
		player_inventory = PlayerInventory.new()
	player_inventory.from_dict(inventory_data)
	print("Debug: Inventory synced. Slot 0:", player_inventory.get_inventory_slot(0).item_id)
	var level_scene = get_tree().get_current_scene()
	if level_scene:
		if is_multiplayer_authority() or get_multiplayer_authority() == multiplayer.get_unique_id():
			print("Debug: This is the local player, updating UI")
			update_local_inventory_display()
			if level_scene.has_node("InventoryUI"):
				var inventory_ui = level_scene.get_node("InventoryUI")
				if inventory_ui.visible and inventory_ui.has_method("refresh_display"):
					print("Debug: Calling refresh_display directly on InventoryUI")
					inventory_ui.refresh_display()
		else:
			print("Debug: Not the local player, skipping UI update")

@rpc("any_peer", "call_local", "reliable")
func request_move_item(from_container: String, from_slot: int, to_container: String, to_slot: int, quantity: int = -1):
	print("Debug: request_move_item called - from ", from_container, ":", from_slot, " to ", to_container, ":", to_slot, " on player ", name, " (authority: ", get_multiplayer_authority(), ") by client ", multiplayer.get_remote_sender_id())

	if not multiplayer.is_server():
		return

	var requesting_client = multiplayer.get_remote_sender_id()
	if requesting_client != get_multiplayer_authority():
		push_warning("Client " + str(requesting_client) + " tried to modify inventory for player " + str(get_multiplayer_authority()))
		return

	if not player_inventory:
		return

	if from_slot < 0 or to_slot < 0:
		push_warning("Invalid slot indices: from=" + str(from_slot) + " to=" + str(to_slot))
		return

	var success = false

	if quantity == -1:
		
		success = player_inventory.move_item(from_container, from_slot, to_container, to_slot)
		print("Debug: move result = ", success)
		if not success:
			success = player_inventory.swap_items(from_container, from_slot, to_container, to_slot)
			print("Debug: Swapped ", from_container, ":", from_slot, " with ", to_container, ":", to_slot)
		else:
			print("Debug: Moved item from ", from_container, ":", from_slot, " to ", to_container, ":", to_slot)
	else:
		print("Debug: move result = ", success)
		success = player_inventory.move_item(from_container, from_slot, to_container, to_slot, quantity)
		print("Debug: Moved ", quantity, " items from ", from_container, ":", from_slot, " to ", to_container, ":", to_slot)
	if success:
		print("Debug: Move successful, refreshing inventory")
		var owner_id = get_multiplayer_authority()
		if owner_id != 1:
			sync_inventory_to_owner.rpc_id(owner_id, player_inventory.to_dict())
		else:
			update_local_inventory_display()
	else:
		print("Debug: Move/swap failed")

@rpc("any_peer", "call_local", "reliable")
func request_add_item(item_id: String, quantity: int = 1):
	print("Debug: request_add_item called on player ", name, " (authority: ", get_multiplayer_authority(), ") by client ", multiplayer.get_remote_sender_id())

	if not multiplayer.is_server():
		return

	var requesting_client = multiplayer.get_remote_sender_id()
	if requesting_client != get_multiplayer_authority() and requesting_client != 1:
		push_warning("Client " + str(requesting_client) + " tried to add items to player " + str(get_multiplayer_authority()))
		return

	if not player_inventory:
		return

	if quantity <= 0:
		push_warning("Invalid quantity: " + str(quantity))
		return

	var item = ItemDatabase.get_item(item_id)
	if not item:
		push_warning("Item not found: " + item_id)
		return

	var remaining = player_inventory.add_item(item, quantity)
	var added = quantity - remaining
	print("Debug: Added ", added, " ", item_id, " to inventory (", remaining, " remaining)")

	if added > 0:
		var owner_id = get_multiplayer_authority()
		print("Debug: Syncing inventory to owner ", owner_id)
		if owner_id != 1:
			sync_inventory_to_owner.rpc_id(owner_id, player_inventory.to_dict())
		else:
			update_local_inventory_display()

@rpc("any_peer", "call_local", "reliable")
func request_remove_item(item_id: String, quantity: int = 1):
	print("Debug: request_remove_item called on player ", name, " (authority: ", get_multiplayer_authority(), ") by client ", multiplayer.get_remote_sender_id())

	if not multiplayer.is_server():
		return

	var requesting_client = multiplayer.get_remote_sender_id()
	if requesting_client != get_multiplayer_authority():
		push_warning("Client " + str(requesting_client) + " tried to remove items from player " + str(get_multiplayer_authority()))
		return

	if not player_inventory:
		return

	if quantity <= 0:
		push_warning("Invalid quantity: " + str(quantity))
		return

	var removed = player_inventory.remove_item(item_id, quantity)

	if removed > 0:
		var owner_id = get_multiplayer_authority()
		if owner_id != 1:
			sync_inventory_to_owner.rpc_id(owner_id, player_inventory.to_dict())

func get_inventory() -> PlayerInventory:
	return player_inventory

func toggle_inventory():

	inventory_visible = !inventory_visible
	if inventory_visible:
		inventory.open_inventory(player)
	else:
		inventory.close_inventory()

func _add_starting_items():
	if not player_inventory:
		return

	var sword = ItemDatabase.get_item("iron_sword")
	var potion = ItemDatabase.get_item("health_potion")

	if sword:
		player_inventory.add_item(sword, 1)
	if potion:
		player_inventory.add_item(potion, 3)

func progres_bar_call(method_select,time_use):
	progres_bar.has_method("progress_set")
	progres_bar.has_method("progress_reset")
	progres_bar.has_method("progress_cancel")
	progres_bar.has_method("progress_hide")
	progres_bar.has_method("progress_show")
	if method_select == 0:
		progres_bar.progress_set(time_use)	
	if method_select == 1:
		progres_bar.progress_reset()
	if method_select == 2:
		progres_bar.progress_cancel()	
	if method_select == 3:
		progres_bar.progress_hide()	
	if method_select == 4:
		progres_bar.progress_show()	
	
