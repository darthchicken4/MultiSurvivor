extends Node2D

var rotation_speed = 10
@onready var head = $head
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position = get_global_mouse_position()
	var direction = mouse_position - global_position
	var target_angle = direction.angle()
	
	# Interpolate current rotation towards target_angle smoothly
	head.rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
