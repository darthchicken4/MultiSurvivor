extends Control

@onready var sprite = $items
@onready var item_dis = $item_name



func _ready() -> void:
	item_dis.visible = false 

func _on_interactrect_mouse_entered() -> void:
	item_dis.visible = true


func _on_interactrect_mouse_exited() -> void:
	item_dis.visible = false 
