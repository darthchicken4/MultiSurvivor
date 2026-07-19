extends Node2D

@export var scale_tool: Vector2

func _ready() -> void:
	scale_tool = scale

func _physics_process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	var direction = mouse_position - global_position
	var target_angle = direction.angle()

	rotation = target_angle

	if abs(target_angle) > PI / 2:
		scale = scale_tool * Vector2(1, -1)
	else:
		scale = scale_tool * Vector2(1, 1)
