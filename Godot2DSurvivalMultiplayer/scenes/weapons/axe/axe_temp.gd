extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var animated_sprite = $ParticleNode/AnimatedSprite2D

@onready var right_hand = $right_hand
@onready var left_hand = $left_hand
@export var hand_placement_left = Vector2.ZERO
@export var hand_placement_right = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hand_placement_left = left_hand.global_position 
	hand_placement_right = right_hand.global_position 
func _activate():
	animation_player.play("RESET")
	animation_player.play("axe_swing")
	animated_sprite.play("default")
	animated_sprite.frame =0
	pass
