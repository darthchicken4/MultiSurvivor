extends Node2D

@onready var players_container: Node2D = $Map/SortContainer
@onready var main_menu: MainMenuUI = $CanvasLayer/MainMenuUI
@export var player_scene: PackedScene



@onready var tilemap = $Map/TileMapLayer  # adjust path to match your scene




func _ready():
	
	if DisplayServer.get_name() == "headless":
		print("Dedicated server starting...")
		Network.start_host("", "")

	
	main_menu.show_menu()
	

	main_menu.host_pressed.connect(_on_host_pressed)
	main_menu.join_pressed.connect(_on_join_pressed)
	main_menu.quit_pressed.connect(_on_quit_pressed)

	if not multiplayer.is_server():
		return
	
	Network.connect("player_connected", Callable(self, "_on_player_connected"))
	multiplayer.peer_disconnected.connect(_remove_player)
	

	
	
	
	
func _on_player_connected(peer_id, player_info):
	_add_player(peer_id, player_info)
	if peer_id != 1:
		tilemap.sync_map_seed.rpc_id(peer_id, tilemap.map_seed)
		
func _on_host_pressed(nickname: String, skin: String):
	
	
	Network.start_host(nickname, skin)
	tilemap._initiate(randi())  # host generates with random seed
	
	await get_tree().create_timer(1.0).timeout
	main_menu.hide_menu()
	
func _on_join_pressed(nickname: String, skin: String, address: String):
	main_menu.hide_menu()
	Network.join_game(nickname, skin, address)

func _add_player(id: int, player_info : Dictionary):
	if DisplayServer.get_name() == "headless" and id == 1:
		return

	if players_container.has_node(str(id)):
		return

	var player = player_scene.instantiate()
	player.name = str(id)
	
	
	player.position = get_spawn_point()
	players_container.add_child(player, true)

	var nick = Network.players[id]["nick"]
	player.nickname.text = nick

	var skin_enum = player_info["skin"]
	player.set_player_skin(skin_enum)
	
func get_spawn_point() -> Vector2:
	var spawn_radius = 100.0
	return Vector2.from_angle(randf() * 2 * PI) * spawn_radius

func _remove_player(id):
	if not multiplayer.is_server() or not players_container.has_node(str(id)):
		return
	var player_node = players_container.get_node(str(id))
	if player_node:
		player_node.queue_free()

func _on_quit_pressed() -> void:
	get_tree().quit()


# Additional helper for testing
func _notification(what):
	if what == NOTIFICATION_READY:
		print("Inventory System Controls:")
		print("  B - Toggle inventory")
		print("  F1 - Add random test item (debug)")
		print("  F2 - Print inventory contents (debug)")





func _get_local_player() -> Character:
	var local_player_id = multiplayer.get_unique_id()
	if players_container.has_node(str(local_player_id)):
		return players_container.get_node(str(local_player_id)) as Character
	return null
