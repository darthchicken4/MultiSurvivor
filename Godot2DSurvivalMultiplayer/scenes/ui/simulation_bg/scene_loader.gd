extends Node2D

@onready var anim_main = $AnimationPlayer

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	pick_scene()
	

func pick_scene():
	for i in range(3):
		var scene_list = ["scene_1","scene_2"]
		rng.seed = 12345
		var value = rng.randi_range(0, scene_list.size() - 1)
		anim_main.play(scene_list[value])
		await  anim_main.animation_finished
