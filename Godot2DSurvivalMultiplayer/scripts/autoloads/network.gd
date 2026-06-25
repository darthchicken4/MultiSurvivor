extends Node
 
const SERVER_ADDRESS: String = "127.0.0.1"
const SERVER_PORT: int = 8000
const MAX_PLAYERS: int = 10
 
const DEBUG_NETWORK := true
signal debug_message(msg)
 
var players = {}
var upnp: UPNP
var upnp_active: bool = false
 
var player_info = {
	"nick": "host",
	"skin": Character.SkinColor.BLUE
}
 
signal player_connected(peer_id, player_info)
signal server_disconnected
signal upnp_setup_done(success: bool, external_ip: String)
 
 
func dprint(msg):
	if DEBUG_NETWORK:
		print("[Network] ", msg)
	debug_message.emit(msg)
	
 
 
func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		dprint("Quit pressed -> exiting game")
		_teardown_upnp()
		get_tree().quit(0)
 
 
func _ready() -> void:
	dprint("Network script ready")
 
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
func step_pause():
	await get_tree().create_timer(0.1).timeout
 
func start_host(nickname: String, skin_color_str: String):
	dprint("Starting host...")
	await step_pause()
 
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(SERVER_PORT, MAX_PLAYERS)
 
	if error:
		dprint("ERROR: Failed to start server -> " + str(error))
		await step_pause()
		return error
 
	multiplayer.multiplayer_peer = peer
	dprint("Server started on port " + str(SERVER_PORT))
	await step_pause()
 
	if !nickname or nickname.strip_edges() == "":
		nickname = "Host_" + str(multiplayer.get_unique_id())
		await step_pause()
 
	player_info["nick"] = nickname
	player_info["skin"] = skin_str_to_e(skin_color_str)
 
	dprint("Host player_info set: " + str(player_info))
	await step_pause()
 
	# Try to open the port automatically so remote friends can join
	# without touching their/your router settings manually.
	_setup_upnp()
 
	if DisplayServer.get_name() == "headless":
		dprint("Headless mode: skipping host local spawn")
		await step_pause()
		return
 
	players[1] = player_info
	dprint("Emitting host player_connected (id=1)")
	await step_pause()
	player_connected.emit(1, player_info)
 
 
func _setup_upnp() -> void:
	upnp = UPNP.new()
 
	var discover_result := upnp.discover()
	if discover_result != UPNP.UPNP_RESULT_SUCCESS:
		dprint("UPnP discovery failed (code %d) - router may not support it" % discover_result)
		await step_pause()
		upnp_setup_done.emit(false, "")
		return
 
	if upnp.get_gateway() == null or !upnp.get_gateway().is_valid_gateway():
		dprint("UPnP: no valid gateway found - UPnP may be disabled on your router, or you're behind CGNAT")
		await step_pause()
		upnp_setup_done.emit(false, "")
		return
 
	# ENet uses UDP, so the mapping must be UDP, not TCP.
	var map_result := upnp.add_port_mapping(SERVER_PORT, SERVER_PORT, "GodotMultiplayer", "UDP")
	if map_result != UPNP.UPNP_RESULT_SUCCESS:
		dprint("UPnP port mapping failed (code %d)" % map_result)
		await step_pause()
		upnp_setup_done.emit(false, "")
		return
 
	upnp_active = true
	var external_ip := upnp.query_external_address()
 
	if external_ip == "":
		dprint("UPnP mapping succeeded but couldn't read external IP")
		await step_pause()
		upnp_setup_done.emit(false, "")
		return
 
	dprint("UPnP success! Share this address with friends: " + external_ip)
	await step_pause()
	upnp_setup_done.emit(true, external_ip)
 
 
func _teardown_upnp() -> void:
	if upnp_active and upnp:
		dprint("Removing UPnP port mapping")
		upnp.delete_port_mapping(SERVER_PORT, "UDP")
		upnp_active = false
 
 
func join_game(nickname: String, skin_color_str: String, address: String = SERVER_ADDRESS, port: int = SERVER_PORT):
	dprint("Joining game at " + address)
	await step_pause()
 
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, port)
 
	if error:
		dprint("ERROR: Failed to join -> " + str(error))
		await step_pause()
		return error
 
	multiplayer.multiplayer_peer = peer
	dprint("Client connecting...")
	await step_pause()
 
	if !nickname or nickname.strip_edges() == "":
		nickname = "Player_" + str(multiplayer.get_unique_id())
 
	var skin_enum = skin_str_to_e(skin_color_str)
 
	player_info["nick"] = nickname
	player_info["skin"] = skin_enum
 
	dprint("Client local player_info set: " + str(player_info))
	await step_pause()
 
 
func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
 
	dprint("Connected to server. Peer ID: " + str(peer_id))
 
	players[peer_id] = player_info
 
	dprint("Stored self in players: " + str(players))
 
	player_connected.emit(peer_id, player_info)
 
 
func _on_player_connected(id):
	dprint("peer_connected signal received: " + str(id))
 
	if DisplayServer.get_name() == "headless":
		dprint("Headless server: ignoring register send to peer " + str(id))
		return
 
	dprint("Sending _register_player RPC to " + str(id))
	_register_player.rpc_id(id, player_info)
 
 
@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
 
	dprint("RPC _register_player from peer: " + str(new_player_id))
	dprint("Received player info: " + str(new_player_info))
 
	players[new_player_id] = new_player_info
 
	dprint("Players updated: " + str(players))
 
	player_connected.emit(new_player_id, new_player_info)
 
 
func _on_player_disconnected(id):
	dprint("Player disconnected: " + str(id))
 
	players.erase(id)
 
	dprint("Players after erase: " + str(players))
 
 
func _on_connection_failed():
	dprint("Connection failed")
	multiplayer.multiplayer_peer = null
 
 
func _on_server_disconnected():
	dprint("Server disconnected")
	_teardown_upnp()
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()
 
 
func skin_str_to_e(s):
	match s.to_lower():
		"blue": return Character.SkinColor.BLUE
		"yellow": return Character.SkinColor.YELLOW
		"green": return Character.SkinColor.GREEN
		"red": return Character.SkinColor.RED
		_: return Character.SkinColor.BLUE
