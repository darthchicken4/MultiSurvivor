extends Control



func _ready() -> void:
	visible = false

func toggle_crafting_ui():
	visible = !visible


# Listen for input
func _unhandled_input(event: InputEvent) -> void:

	if event.is_action_pressed("armor"):
		toggle_crafting_ui()
