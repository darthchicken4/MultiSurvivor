extends Control

@export var player : CharacterBody2D

@onready var fps = $MarginContainer/VBoxContainer/fps
@onready var player_pos = $"MarginContainer/VBoxContainer/player pos"
@onready var player_health = $MarginContainer/VBoxContainer/player_hp

var teleport_enabled = false
func _ready() -> void:
	if not is_multiplayer_authority():
		# This isn't "my" player, hide their UI from my screen
		self.visible = false

func _physics_process(delta: float) -> void:
	player_pos.text = str(player.global_position)
	fps.text  = str(Engine.get_frames_per_second())
	player_health.text = str(player.health)
	if teleport_enabled and Input.is_action_just_pressed("teleport"):
		teleport()

func _on_check_box_toggled(toggled_on: bool) -> void:
	teleport_enabled = toggled_on
	
	
func teleport():
	player.global_position = get_viewport().get_camera_2d().get_global_mouse_position()


func _on_spin_box_value_changed(value: float) -> void:
	player.health = value


func _on_spin_box_2_value_changed(value: float) -> void:
	player.NORMAL_SPEED = value
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dev_menu"):
		toggle_dev_ui()
		
func toggle_dev_ui():
	visible = !visible
