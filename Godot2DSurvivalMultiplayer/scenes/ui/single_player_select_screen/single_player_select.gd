extends Control


var single_player = preload("res://scenes/level/dev_level/devlevel.tscn")




func _on_pressed() -> void:
	get_tree().change_scene_to_packed(single_player)


func _on_option_button_item_selected(index: int) -> void:
	pass # Replace with function body.
