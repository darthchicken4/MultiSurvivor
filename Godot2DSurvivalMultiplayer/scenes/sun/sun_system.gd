extends Control
class_name DayNightCycle

@export var time: float = 7.0

@export var sun_curve :CurveTexture
var alpha: float = 0.0
var saturation: float = 0.4

var sun_tick: float = 0.008
var saturation_tick: float = 0.001

var max_light: float = 0.70
var min_saturation: float = 0.2
var max_saturation: float = 0.4

var overlay_size := Vector2(100000, 100000)

@onready var sun_color = $DirectionalLight2D
@onready var saturation_rect = $sat

#24 hours cycle 12 hours of night 12 hours of day 
func _ready():
	saturation_rect.size = overlay_size
	saturation_rect.position = -overlay_size / 2

	update_visuals()
	time_cycle()

func time_cycle():
	while is_inside_tree():
		await Utils.wait(1)
		update_time()
		print("time" ,time)

func update_time():
	time += 0.25
	var curve: Curve = sun_curve.curve
	var value: float = curve.sample(time) #inside sample is x value  #x is time and y is the strenghs of color # offset 0.0–1.0 → returns the curve's y value
	print("curve_time",value)
	
	if time >= 24.0:
		time = 0.0
	
	alpha = clamp(value, 0.0, max_light)
	saturation = clamp(saturation, min_saturation, max_saturation)

	update_visuals()

func update_visuals():
	sun_color.color = Color(1, 1, 1, alpha) 


	var smooth_saturation = lerp(
		saturation_rect.material.get_shader_parameter("saturation"),
		saturation,
		0.1)

	saturation_rect.material.set_shader_parameter("saturation", smooth_saturation)
