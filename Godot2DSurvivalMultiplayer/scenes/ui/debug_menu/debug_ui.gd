extends Control

@export var player : CharacterBody2D

@onready var fps = $MarginContainer/VBoxContainer/fps
@onready var player_pos = $"MarginContainer/VBoxContainer/player pos"


func _ready() -> void:
	if not is_multiplayer_authority():
		# This isn't "my" player, hide their UI from my screen
		self.visible = false

func _physics_process(delta: float) -> void:
	player_pos.text = str(player.global_position)
	fps.text  = str(Engine.get_frames_per_second())
