extends Control

@export var title :String  = "title"
@export var descrition :String  = "description"

@onready var text_title = $Panel/MarginContainer/VBoxContainer/title
@onready var text_description  =$Panel/MarginContainer/VBoxContainer/description

func _ready() -> void:
	update() 
	
func update():
	while true:
		await Utils.wait(0.1)
		text_description.text = descrition
		text_title.text = title
		
