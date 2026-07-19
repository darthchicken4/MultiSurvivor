extends Control


@export var time: float = 24.0
var sun_tick = 0.1
var alpha = 0.0
var flip_color = false
@onready var sun_color = $ColorRect

func _ready() -> void:
	sun_color.color = Color(0.0, 0.0, 0.0, 0.0)
	time_cycle()


func time_cycle():
	while true:
		await Utils.wait(2)
		alpha = alpha + sun_tick
		#if alpha < 255:
		sun_color.color = Color(0.0, 0.0, 0.0, alpha)
		print(sun_color.color)
