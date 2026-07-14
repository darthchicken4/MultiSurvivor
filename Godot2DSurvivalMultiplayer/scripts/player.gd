extends CharacterBody2D
class_name Character

const NORMAL_SPEED : float = 100.0
const SPRINT_SPEED : float  = 150.0
const EXHAUST_SPEED : float  = 70.0
enum SkinColor { BLUE, YELLOW, GREEN, RED }



@onready var nickname: Label = $PlayerNick/Nickname
@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = $"."
@onready var inventory: InventoryUI = $CanvasLayer/InventoryUI
@onready var interactMenu: Control = $InteractMenu
@onready var chat: MultiplayerChatUI = $CanvasLayer/MultiplayerChatUI
@onready var pause_menu : Control = $CanvasLayer/PauseMenu
@onready var stats = $CanvasLayer/StatsUi
@onready var respawnUI = $CanvasLayer/RespawnUi
@onready var foot_steps = $audio/foot_steps

@export var stamina_value : float = 10.0
@export var stamina_timer : float = 10.0 #sec
@export var stamina_tick_rate : float = 0.3

@export var health : float= 20.0
@export var max_health : float = 20.0
@export var damage_reduction : float = 0.0

@export var hunger_value : float= 20.0
@export var hunger_tick : float= 0.3 #time to hunger go down
@export var hunger_max : float = 50.0

var player_inventory: PlayerInventory

var _current_speed : float
var _respawn_point :Vector2 = Vector2(0, 0)
var chat_visible :bool = false
var inventory_visible :bool = false

var can_sprint_again :bool = false
func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
	$Camera2D.enabled = is_multiplayer_authority()
	
func is_chat_visible() -> bool:
	return chat.is_chat_visible()

func _on_chat_message_sent(message_text: String) -> void:
	var trimmed_message = message_text.strip_edges()
	if trimmed_message == "":
		return # do not send empty messages

	var nick = Network.players[multiplayer.get_unique_id()]["nick"]
	rpc("msg_rpc", nick, trimmed_message)

@rpc("any_peer", "call_local")
func msg_rpc(nick, msg):
	chat.add_message(nick, msg)
	
func _ready():
	update_stamina()
	update_saturation()
	if not is_multiplayer_authority(): return
	
	
	var is_local_player = is_multiplayer_authority()
	var local_client_id = multiplayer.get_unique_id()

	print("Debug: Player ", name, " ready - authority: ", get_multiplayer_authority(), ", local client: ", local_client_id, ", is_local: ", is_local_player)

	if is_local_player:
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
	chat.hide()
	chat.set_process_input(true)
	if chat:
		chat.message_sent.connect(_on_chat_message_sent)
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



func freeze():
	velocity = Vector2.ZERO
	_current_speed = 0
	_sprite.play("idle")

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
	if velocity.length() > 0.1:
		_sprite.play("walk")

		if not foot_steps.playing:
			foot_steps.play()

		if velocity.x != 0:
			_sprite.flip_h = velocity.x < 0
	else:
		_sprite.play("idle")

		if foot_steps.playing:
			foot_steps.stop()

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
		for i in range(inventory.slots.size()):
			var slot = inventory.get_slot(i)
			if slot and not slot.is_empty():
				print("Slot ", i, ": ", slot.item_id, " x", slot.quantity)
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
					
				
				
# ---------- MULTIPLAYER CHAT ----------
func toggle_chat():


	chat.toggle_chat()
	chat_visible = chat.is_chat_visible()
#runn
func show_respawn_ui():
	pass


func is_running() -> bool:
	if Input.is_action_pressed("shift") and can_sprint_again and stamina_value > 0.0:
		_current_speed = SPRINT_SPEED
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
			stamina_value += stamina_tick_rate / 10
			if stamina_value >= stamina_timer:
				stamina_value = stamina_timer
				can_sprint_again = true
		stamina_value = clamp(stamina_value, 0.0, stamina_timer)

func update_saturation() -> void:
	while true:
		await Utils.wait(1.0)
		hunger_value -= hunger_tick
		if hunger_value < 0.0:
			hunger_value = 0.0
			health -= 1.2

func update_health()-> void:
	while true:
		await Utils.wait(0.01)


func damage_player(amount): 
	if amount < 1.0:
		health = health - amount * damage_reduction



func pause_menu_show():
	if Input.is_action_just_pressed("quit"):
		pause_menu.visible = !pause_menu.visible

func _check_bounds_and_respawn():
	if global_position.y > 10000.0:
		_respawn()

func _respawn():
	global_position = _respawn_point
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
func request_move_item(from_slot: int, to_slot: int, quantity: int = -1):
	print("Debug: request_move_item called - from:", from_slot, " to:", to_slot, " on player ", name, " (authority: ", get_multiplayer_authority(), ") by client ", multiplayer.get_remote_sender_id())

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
		success = player_inventory.move_item(from_slot, to_slot)
		if not success:
			success = player_inventory.swap_items(from_slot, to_slot)
			print("Debug: Swapped items between slots ", from_slot, " and ", to_slot)
		else:
			print("Debug: Moved item from slot ", from_slot, " to ", to_slot)
	else:
		success = player_inventory.move_item(from_slot, to_slot, quantity)
		print("Debug: Moved ", quantity, " items from slot ", from_slot, " to ", to_slot)

	if success:
		print("Debug: Move successful, syncing inventory to owner ", get_multiplayer_authority())
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
