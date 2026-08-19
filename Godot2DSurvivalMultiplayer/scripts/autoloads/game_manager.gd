extends Node


@export var message = preload("res://scenes/ui/inspect_menu/inspect_menu.tscn")
@export var player = null
@export var progress_bar = null
@export var tilemap = null
signal action_selected(action: String, target: Node)

func _ready():
	action_selected.connect(_on_context_action)
	
func _on_context_action(action: String, target: Node):
	print("yes")
	match action:
		"Inspect":
			_inspect(target)
			
		"Pick Up":
			_start_pickup(target)
		#"Chop":
			#_start_chop(target)
		#"Mine":
			#_start_mine(target)
		#"Harvest":
			#_start_pickup(target)  # same as pickup
		"Inspect":
			_inspect(target)
	
func _start_pickup(target: Node):

	
	var timer = target.pickup_time
	player.has_method("progres_bar_call")
	print("showing")
	player.progres_bar_call(4,timer)
	await player.progres_bar_call(0,timer)
	player.progres_bar_call(2,timer)
	var local_player = player
	local_player.request_add_item.rpc_id(1, target.pickup_loot_pool[0].item_id, #->
		target.pickup_loot_pool[randi_range(0,len(target.pickup_loot_pool)-1)].amount)
	var tile_pos = tilemap.local_to_map(tilemap.to_local(target.global_position))
	tilemap.remove_object.rpc_id(1,tile_pos)

func set_tile_map(target):
	tilemap = target
func setPlayer(target):
	player = target
	

func _inspect(target: Node):
	#if target.has_method("get") and target.get("inspect_text"):
		#chat_popup.show_message(target.inspect_text)
	if "inspect_text" in target:
		
		var message = message.instantiate()
		player.get_node("CanvasLayer").add_child(message)
		message.update(target.objectname,target.inspect_text)
	pass
