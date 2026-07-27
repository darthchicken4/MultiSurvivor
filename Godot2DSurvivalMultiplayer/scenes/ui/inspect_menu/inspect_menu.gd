extends Control


@onready var text_title = $Panel/MarginContainer/VBoxContainer/title
@onready var text_description  =$Panel/MarginContainer/VBoxContainer/description

	
func update(title,description):
		text_description.text = description
		text_title.text = title
		


func _on_button_pressed() -> void:
	queue_free()
	pass # Replace with function body.
