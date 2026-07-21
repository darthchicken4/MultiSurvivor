extends Control


@export var time: float = 24.0
var sun_tick = 0.05
var alpha = 0.0
var flip_color = false
var saturation_tick = 0.1
var saturation = 1.0
var overlay_size = Vector2(100000,100000)
@onready var sun_color = $DirectionalLight2D
@onready var saturaition_rect = $sat
func _ready() -> void:
	saturaition_rect.size =overlay_size
	saturaition_rect.position = -overlay_size/2
	sun_color.color = Color(1.0, 1.0, 1.0, 0.0)
	time = 0.0
	#time_cycle()




func time_cycle():
	while true:
		await Utils.wait(5)
		if flip_color == true:
			alpha = alpha - sun_tick
			time = time + 0.2
			saturation = saturation + saturation_tick
		if flip_color == false:
			alpha = alpha + sun_tick
			saturation = saturation - saturation_tick
		alpha = clamp(alpha, 0.0, 0.7)
		saturation =clamp(saturation, 0.0, 1.0)
		if alpha >= 1.0:
			flip_color = true
		elif alpha <= 0.0:
			flip_color = false
		saturaition_rect.material.set_shader_parameter("saturation", saturation)
		sun_color.color = Color(1.0, 1.0, 1.0, alpha)
		print("sat",saturation)
		print("a",alpha)
		print(sun_color.color)
		print(time)
