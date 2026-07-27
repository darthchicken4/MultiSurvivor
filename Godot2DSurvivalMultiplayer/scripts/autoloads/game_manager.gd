extends Node


@export var message = preload("res://scenes/ui/inspect_menu/inspect_menu.tscn")
@export var player = null

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
	pass

	# Show a progress bar for pickup_time seconds
	#var timer = get_tree().create_timer(target.pickup_time)
	#progress_bar.show()
	#await timer.timeout
	#progress_bar.hide()
	
	# Give item to player
	#var local_player = _get_local_player()
	#local_player.request_add_item.rpc_id(1, target.item_id, target.item_amount)
	
	# Remove from world
	#var tile_pos = tilemap.local_to_map(tilemap.to_local(target.global_position))
	#tilemap.request_remove_object.rpc_id(1, tile_pos)
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
