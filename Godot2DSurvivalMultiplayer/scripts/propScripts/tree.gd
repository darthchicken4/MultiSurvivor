extends Node2D

var actions: Array[String] = ["Inspect"]
var objectname : String = "Pine Tree"

@export var inspect_text: String = "A sturdy pine tree, slightly twisted in some places."
<<<<<<< HEAD


@onready var audio_russle = $russle



func _on_russule_trigger_body_entered(body: Node2D) -> void:
	if not body.is_in_group("objects"):
		audio_russle.play()


func _on_russule_trigger_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
=======
>>>>>>> 93ba1800b6348e1818dda331c73c1397bec2f00c
