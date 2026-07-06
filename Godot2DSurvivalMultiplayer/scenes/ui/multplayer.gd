extends Button

var start_game = preload("res://scenes/level/level.tscn")




func _on_pressed() -> void:
	get_tree().change_scene_to_packed(start_game)
