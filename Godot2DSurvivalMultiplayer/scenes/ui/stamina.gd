extends Control
@export var player :CharacterBody2D
@export var stamina = 0

@onready var prog = $MarginContainer/VBoxContainer/ProgressBar


func _process(delta: float) -> void:
	prog.value = player.stamina_player 
	
