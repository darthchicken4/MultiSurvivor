extends Control
@export var player : PackedScene
@export var stamina = 0

@onready var  prog = $ProgressBar

func _process(delta: float) -> void:
	
