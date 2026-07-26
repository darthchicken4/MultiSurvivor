extends Button


var start_game = preload("res://scenes/ui/single_player_select_screen/single_player_select.tscn")




func _on_pressed() -> void:
	get_tree().change_scene_to_packed(start_game)
