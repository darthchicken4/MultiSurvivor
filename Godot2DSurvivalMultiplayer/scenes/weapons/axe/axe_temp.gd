extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var animated_sprite = $ParticleNode/AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _activate():
	animation_player.play("RESET")
	animation_player.play("axe_swing")
	animated_sprite.play("default")
	animated_sprite.frame =0
	pass
