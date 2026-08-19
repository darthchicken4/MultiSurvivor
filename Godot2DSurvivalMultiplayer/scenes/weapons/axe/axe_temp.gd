extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var animated_sprite = $ParticleNode/AnimatedSprite2D
@export var weapon_damage = 4.0 
@onready var swipes_sounds = [$audio/swipe_1]

var swipe_type = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _activate():
	animation_player.play("RESET")
	animation_player.play("axe_swing")
	_play_swipe_networked(swipe_type)
	animated_sprite.play("default")
	animated_sprite.frame =0
	_stop_swipe_networked()
	pass


func _play_swipe_networked(swipe_type) -> void:
	# Only the player who owns this character triggers the RPC
	if not is_multiplayer_authority():
		return
	_play_swipe.rpc(swipe_type)


func _stop_swipe_networked() -> void:
	if not is_multiplayer_authority():
		return
	_stop_swipe.rpc(swipe_type)


@rpc("call_local", "reliable")
func _play_swipe() -> void:
	swipes_sounds[0].play()


@rpc("call_local", "reliable")
func _stop_swipe() -> void:
	swipes_sounds[0].stop()
