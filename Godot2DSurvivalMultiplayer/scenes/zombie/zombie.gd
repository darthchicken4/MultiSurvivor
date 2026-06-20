extends CharacterBody2D




#player priority is the there to avoid cheese when a single guy just runs  a
#away wilst the other lob spears 

@export var speed: float = 100.0

var player: Node2D = null
var player_priority = 0
var player_pos = Vector2(0,0)

func  _ready() -> void:
	pass


func _on_damage_area_body_entered(body: Node2D) -> void:
	pass # Replace with function body.



func _on_detect_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body


func _on_detect_area_body_exited(body: Node2D) -> void:
	print('player_detected')
	if body == player:
		player = null

func _process(delta: float) -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		position += direction * speed * delta
