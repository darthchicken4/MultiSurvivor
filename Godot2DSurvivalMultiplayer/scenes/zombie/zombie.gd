extends CharacterBody2D




#player priority is the there to avoid cheese when a single guy just runs  a
#away wilst the other lob spears 

@export var speed: float = 50.0
@export  var wander_dir = 3
@export var wander_timer = 4




var player: Node2D = null
var player_priority = 0
var player_pos = Vector2(0,0)
var is_thinking = false
var think_timer = 3.0
var wander_direction = Vector2(0,0)
func  _ready() -> void:
	pass


func _on_damage_area_body_entered(body: Node2D) -> void:
	pass # Replace with function body.



func _on_detect_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body



func _on_detect_area_body_exited(body: Node2D) -> void:
	if body == player:
		player = null

func _process(delta: float) -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		position += direction * speed * delta
	if player == null:
		wander(delta)


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
	position += wander_direction * speed * delta

	wander_timer -= delta

	if wander_timer <= 0:
		is_thinking = true
		think_timer = randf_range(0.5, 2.0)
		
