extends Node2D

@onready var anim_main = $AnimationPlayer

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	pick_scene()
	

func pick_scene():
	rng.seed = 12345
	var value = rng.randi_range(0,2)
	print(value)
	anim_main.play("scene_1")
	
