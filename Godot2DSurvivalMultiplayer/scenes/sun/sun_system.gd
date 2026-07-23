extends Control
class_name DayNightCycle

@export var time: float = 0.0

var alpha: float = 0.0
var saturation: float = 0.4

var day_direction: int = 1

var sun_tick: float = 0.008
var saturation_tick: float = 0.001

var max_light: float = 0.55
var min_saturation: float = 0.2
var max_saturation: float = 0.4

var overlay_size := Vector2(100000, 100000)

@onready var sun_color = $DirectionalLight2D
@onready var saturation_rect = $sat

func _ready():
	saturation_rect.size = overlay_size
	saturation_rect.position = -overlay_size / 2

	update_visuals()
	time_cycle()

func time_cycle():
	while is_inside_tree():
		await Utils.wait(0.5)
		update_time()

func update_time():
	time += 0.2

	alpha += sun_tick * day_direction
	saturation -= saturation_tick * day_direction

	alpha = clamp(alpha, 0.0, max_light)
	saturation = clamp(saturation, min_saturation, max_saturation)

	if alpha >= max_light:
		day_direction = -1
	elif alpha <= 0.0:
		day_direction = 1

	update_visuals()

func update_visuals():
	sun_color.color = Color(1, 1, 1, alpha)

	var smooth_saturation = lerp(
		saturation_rect.material.get_shader_parameter("saturation"),
		saturation,
		0.1
	)

	saturation_rect.material.set_shader_parameter("saturation", smooth_saturation)
