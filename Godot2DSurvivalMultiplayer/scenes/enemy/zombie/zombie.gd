extends CharacterBody2D



@export var speed: float = 50.0
@export  var wander_dir = 3
@export var wander_timer = 4

@export var damage = 2.0
@export var nav_update_interval: float = 0.2  

@export var health = 100.0

@onready var nav_agent = $NavigationAgent2D
@onready var bite_sound = $audio/bite
@onready var anim = $AnimatedSprite2D

var slow_down = 2.0

var _nav_update_timer: float = 0.0
var player: Node2D = null
var player_priority : int= 0
var player_pos : Vector2= Vector2(0,0)
var is_thinking : bool= false
var think_timer : float= 3.0
var wander_direction = Vector2(0,0)

var direction = Vector2(0,0)

func  _ready() -> void:
	pass


func _on_damage_area_body_entered(body: Node2D) -> void:
	anim.play("downslam")
	velocity = direction * slow_down
	if body.is_in_group("player"):
		if body.has_method("damage_player"):
			body.damage_player(damage)
			bite_sound.play()
func _on_detect_area_body_entered(body: Node2D) -> void:
	if not is_multiplayer_authority():
		return
	if body.is_in_group("player"):
		player = body
		make_path()  # get an initial path immediately instead of waiting for the timer

func _on_detect_area_body_exited(body: Node2D) -> void:
	if not is_multiplayer_authority():
		return
	if body == player:
		player = null

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		update_animation()
		return

	if player:
		_nav_update_timer -= delta
		if _nav_update_timer <= 0.0:
			make_path()
			_nav_update_timer = nav_update_interval

		if not nav_agent.is_navigation_finished():
			var next_pos: Vector2 = nav_agent.get_next_path_position()
			direction = global_position.direction_to(next_pos)
			velocity = direction * speed
			global_position += velocity * delta
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO
		wander(delta)

	if velocity.length() > 3.0:
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

func make_path() -> void:
	if player:
		nav_agent.target_position = player.global_position

func _on_damage_area_body_exited(body: Node2D) -> void:
	pass # Replace with function body.



func damage_skin():
	anim.self_modulate = Color(1.0, 0.0, 0.0, health / 100 )
