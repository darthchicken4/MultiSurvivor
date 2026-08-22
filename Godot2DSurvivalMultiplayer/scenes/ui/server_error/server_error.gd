extends Control

func _ready() -> void:
	self.hide()



func _process(delta: float) -> void:
	if Network.server_error == true:
		self.show()


func _on_button_pressed() -> void:
	self.queue_free()


func _on_exit_game_pressed() -> void:
	get_tree().quit()
