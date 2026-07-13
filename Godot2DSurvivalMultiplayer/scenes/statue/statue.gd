extends Node2D

@export var respawn_timer = 120.0
@export var can_trugger  = false

@onready var text_label = $Label

func _ready() -> void: 
	text_label.hide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	text_label.show()



func _on_area_2d_body_exited(body: Node2D) -> void:
	text_label.hide()
