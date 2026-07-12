extends Node2D

@export var damage = 20.0

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.health = body.health - damage


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
