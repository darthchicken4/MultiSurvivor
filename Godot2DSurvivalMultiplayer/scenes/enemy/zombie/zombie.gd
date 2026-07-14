extends CharacterBody2D



@export var speed: float = 50.0
@export  var wander_dir = 3
@export var wander_timer = 4

@onready var anim = $AnimatedSprite2D



var player: Node2D = null
var player_priority = 0
var player_pos = Vector2(0,0)
var is_thinking = false
var think_timer = 3.0
var wander_direction = Vector2(0,0)


func  _ready() -> void:
	set_multiplayer_authority(1)


func _on_damage_area_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_detect_area_body_entered(body: Node2D) -> void:
	if not is_multiplayer_authority():
		return
	if body.is_in_group("player"):
		player = body

func _on_detect_area_body_exited(body: Node2D) -> void:
	if not is_multiplayer_authority():
		return
	if body == player:
		player = null

func _process(delta: float) -> void:
	if not is_multiplayer_authority():
		update_animation()
		return
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		global_position += velocity * delta
	else:
		velocity = Vector2.ZERO
		wander(delta)

	if velocity.length() > 0.1:
		anim.play("run")
	else:
		anim.play("idle")
	if velocity.x != 0:
		anim.flip_h = velocity.x < 0


func wander(delta: float) -> void:
	if is_thinking:
		think_timer -= delta

		if think_timer <= 0:
			wander_direction = Vector2(
				randf_range(-1.0, 1.0),
				randf_range(-1.0, 1.0)
			).normalized()

			wander_timer = randf_range(1.0, 3.0)
			is_thinking = false

		return
	# Moving
	velocity = wander_direction * speed
	global_position += velocity * delta
	wander_timer -= delta

	if wander_timer <= 0:
		is_thinking = true
		think_timer = randf_range(0.5, 2.0)
		
		
func update_animation() -> void:
	if velocity.length() > 0.1:
		anim.play("run")
	else:
		anim.play("idle")
