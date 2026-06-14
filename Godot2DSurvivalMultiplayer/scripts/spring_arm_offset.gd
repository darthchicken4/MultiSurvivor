extends Node3D
class_name SpringArmCharacter

const MOUSE_SENSIBILITY: float = 0.005

@export_category("Objects")
@export var _spring_arm: SpringArm3D = null

func _ready() -> void:
	if is_multiplayer_authority():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		_spring_arm.spring_length = 0.0

func _unhandled_input(_event) -> void:
	if _event is InputEventKey and _event.pressed and _event.keycode == KEY_ESCAPE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED

	if (_event is InputEventMouseMotion) and is_multiplayer_authority():
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-_event.relative.x * MOUSE_SENSIBILITY)
			_spring_arm.rotate_x(-_event.relative.y * MOUSE_SENSIBILITY)
			_spring_arm.rotation.x = clamp(_spring_arm.rotation.x, -PI/2, PI/2)
