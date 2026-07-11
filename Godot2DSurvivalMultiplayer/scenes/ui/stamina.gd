extends Control
@export var player :CharacterBody2D
@export var stamina = 0

@onready var prog = $MarginContainer/VBoxContainer/ProgressBar

func _ready() -> void:
	if not is_multiplayer_authority():
		# This isn't "my" player, hide their UI from my screen
		self.visible = false
func _process(delta: float) -> void:
	prog.value = player.stamina_value
	
