extends Camera2D

@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.75
@export var max_zoom: float = 2

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		
		# Zoom in
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			var new_zoom = zoom - Vector2.ONE * zoom_speed
			new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
			new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)
			zoom = new_zoom
		
		# Zoom out
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			var new_zoom = zoom + Vector2.ONE * zoom_speed
			new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
			new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)
			zoom = new_zoom
