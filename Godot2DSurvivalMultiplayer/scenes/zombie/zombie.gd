extends RigidBody2D


@export var player: CharacterBody2D


#player priority is the there to avoid cheese when a single guy just runs  a
#away wilst the other lob spears 
var player_priority = 0


func  _ready() -> void:
	pass


func _on_damage_area_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_damage_area_body_exited(body: Node2D) -> void:
	pass # Replace with function body.


func _on_detect_area_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_detect_area_body_exited(body: Node2D) -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass
