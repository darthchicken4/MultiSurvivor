extends Node2D

@onready var anim_main = $AnimationPlayer

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	pick_scene()
	

func pick_scene():
	var scene_list = ["scene_1", "scene_2", "scene_3"]
	var last_scene = ""

	for i in range(10):
		var value = randi_range(0, scene_list.size() - 1)

		# Re-roll until we get something different from the last scene
		while scene_list[value] == last_scene:
			value = randi_range(0, scene_list.size() - 1)

		last_scene = scene_list[value]
		anim_main.play(last_scene)
		await anim_main.animation_finished
