extends Control

@onready var main_text = $TextureRect/main_text
@onready var title = $TextureRect/title
@onready var button = $TextureRect/Button

func setupMessage(message,name):
	title.text = name
	main_text.text = message
	
	
	



func _on_button_pressed() -> void:
	queue_free()
	pass # Replace with function body.
