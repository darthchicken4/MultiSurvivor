extends Control


var is_on_server = false
func _ready() -> void:
	pass


func _on_option_button_item_selected(index: int) -> void:
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if index == 2:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)


func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	if toggled_on == false:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _on_line_edit_text_submitted(new_text: String) -> void:
	var fps = 0 
	new_text = fps


func _on_physics_interpolate_toggled(toggled_on: bool) -> void:
	ProjectSettings.set_setting("physics/common/physics_interpolation", toggled_on)


func _on_physics_tick_rate_item_selected(index: int) -> void:
	match index:
		0:
			Engine.physics_ticks_per_second = 60
		1:
			Engine.physics_ticks_per_second = 30
		2:
			Engine.physics_ticks_per_second = 15
		3:
			Engine.physics_ticks_per_second = 3


func _on_resolutions_item_selected(index: int) -> void:
	var resolutions = [
		Vector2i(1280, 720),
		Vector2i(1600, 900),
		Vector2i(1920, 1080),
		Vector2i(2560, 1440),
		Vector2i(3840, 2160),
	]
	var new_res = resolutions[index]
	DisplayServer.window_set_size(new_res)
	
	var screen_size = DisplayServer.screen_get_size()
	var window_pos = (screen_size - new_res) / 2
	DisplayServer.window_set_position(window_pos)
