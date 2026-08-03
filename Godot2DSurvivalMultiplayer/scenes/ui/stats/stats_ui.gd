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

var _damage_timer := 0.0
var damage_color_value = 0.0
func _ready():
	if not is_multiplayer_authority():
		# This isn't "my" player, hide their UI from my screen
		self.visible = false

func _process(delta):
	if _damage_timer > 0:
		_damage_timer -= delta
	else:
		damage_indicator.value = lerpf(
			damage_indicator.value,
			health_bar.value,
			damage_lerp_speed * delta
		)
	var lerp_speed = 0.1  # higher = faster catch-up, lower = slower/smoother

	health_bar.max_value = max_health
	damage_indicator.max_value = max_health
	hunger_bar.max_value = max_hunger
	stamina_bar.max_value = max_stamina

	health_bar.value = lerp(health_bar.value, player.health, lerp_speed * delta)
	hunger_bar.value = lerp(hunger_bar.value, player.hunger_value, lerp_speed * delta)
	stamina_bar.value = lerp(stamina_bar.value, player.stamina_value, lerp_speed * delta)
		#damage_color_value = 1 - health_bar.value  / health_bar.max_value
		#damage_overlay.self_modulate = Color(1.0, 1.0, 1.0, damage_color_value)
