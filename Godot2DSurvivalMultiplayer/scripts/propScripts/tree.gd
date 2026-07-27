extends Node2D

var actions: Array[String] = ["Inspect"]
@export var objectname : String = "Pine Tree"

@export var inspect_text: String = "A sturdy pine tree, slightly twisted in some places."



@onready var audio_russle = $russle



func _on_rustle_trigger_body_entered(body: Node2D) -> void:
	if not body.is_in_group("objects"):
		audio_russle.play()


func _on_rustle_trigger_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
