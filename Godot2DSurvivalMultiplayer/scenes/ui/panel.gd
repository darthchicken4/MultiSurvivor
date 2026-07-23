extends Panel

var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				drag_offset = get_global_mouse_position() - global_position
			else:
				dragging = false

	elif event is InputEventMouseMotion:
		if dragging:
			global_position = get_global_mouse_position() - drag_offset


func _on_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_MOVE)


func _on_mouse_exited() -> void:
	if not dragging:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
