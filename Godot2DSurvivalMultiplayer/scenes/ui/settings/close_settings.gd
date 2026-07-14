extends Button

@onready var settings  = $"../.."

func _on_pressed() -> void:
	settings.hide()
