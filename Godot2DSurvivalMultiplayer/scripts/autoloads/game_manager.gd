extends Node
func _on_context_action(action: String, target: Node):
	match action:
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

func _inspect(target: Node):
	#if target.has_method("get") and target.get("inspect_text"):
		#chat_popup.show_message(target.inspect_text)
	pass
