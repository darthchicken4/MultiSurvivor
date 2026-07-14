extends Node2D

@export var damage : float = 2.0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("damage_player"):
		body.damage_player(damage)


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
