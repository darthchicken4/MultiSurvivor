extends Node2D

@export var scale_tool: Vector2

@export var left_hand_pos = Vector2.ZERO
@export var right_hand_pos = Vector2.ZERO

func _ready() -> void:
	scale_tool = scale

func _process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	var direction = mouse_position - global_position
	var target_angle = direction.angle()

	rotation = target_angle

	if abs(target_angle) > PI / 2:
		scale = scale_tool * Vector2(1, -1)
	else:
		scale = scale_tool * Vector2(1, 1)
	if get_child(0) == null:
		pass
	else:
		right_hand_pos = get_child(0).hand_placement_right
		left_hand_pos = get_child(0).hand_placement_left
