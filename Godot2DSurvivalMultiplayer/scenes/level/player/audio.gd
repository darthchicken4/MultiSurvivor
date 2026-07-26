extends Node2D

@onready var nature_track = $nature
var rng = RandomNumberGenerator.new()

func _ready():
	pick_random_ambience()

func pick_random_ambience():
	var ambience = [nature_track]
	rng.seed = 12345
	var value = rng.randi_range(0, ambience.size() - 1)
	ambience[value].play()
