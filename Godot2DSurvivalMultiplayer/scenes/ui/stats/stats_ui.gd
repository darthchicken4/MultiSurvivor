extends Control
class_name PlayerStatsUI

@onready var health_bar: ProgressBar = $MarginContainer/Control/Health
@onready var damage_indicator: ProgressBar = $MarginContainer/Control/Damage_lerp_bar
@onready var hunger_bar: ProgressBar = $MarginContainer/Control/Hunger
@onready var stamina_bar: ProgressBar = $MarginContainer/Control/Stamina

@onready var damage_overlay = $MarginContainer/damage

@export var max_health := 20.0
@export var max_hunger := 20.0
@export var max_stamina := 10.0

@export var player: CharacterBody2D

var hunger := 100.0
var stamina := 100.0

# Damage indicator settings
@export var damage_delay := 0.5
@export var damage_lerp_speed := 4.0
@onready var tween: Tween
var _damage_timer := 0.0
var damage_color_value = 0.0
var lerp_speed = 1
func _ready():
	if not is_multiplayer_authority():
		# This isn't "my" player, hide their UI from my screen
		self.visible = false
	health_bar.max_value = max_health
	hunger_bar.max_value = max_hunger
	stamina_bar.max_value = max_stamina
		
func _process(delta: float) -> void:
	health_bar.value = lerpf(health_bar.value ,player.health,lerp_speed)
