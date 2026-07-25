extends Node2D

var actions: Array[String] = ["Inspect"]
var objectname : String = "Pine Tree"

@export var inspect_text: String = "A sturdy pine tree, slightly twisted in some places."





func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	visible = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	visible = false
