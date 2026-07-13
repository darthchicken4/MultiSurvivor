extends Control
class_name PlayerStatsUI

@onready var health_bar: ProgressBar = $Control/Health
@onready var damage_indicator: ProgressBar = $Control/DamageIndicator
@onready var hunger_bar: ProgressBar = $Control/Hunger
@onready var stamina_bar: ProgressBar = $Control/Stamina

@export var max_health := 20.0
@export var max_hunger := 100.0
@export var max_stamina := 100.0

@export var player: CharacterBody2D

var health := 100.0
var hunger := 100.0
var stamina := 100.0

# Damage indicator settings
@export var damage_delay := 0.5
@export var damage_lerp_speed := 4.0

var _damage_timer := 0.0

func _ready():
	update_bars(true)
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
	update_bars(true)
func update_bars(force := false):
	hunger = player.hunger_value
	health = player.health
	stamina = player.stamina_value  * 10
	health_bar.max_value = max_health
	damage_indicator.max_value = max_health
	hunger_bar.max_value = max_hunger
	stamina_bar.max_value = max_stamina
	
	health_bar.value = health
	hunger_bar.value = hunger
	stamina_bar.value = stamina

	if force:
		damage_indicator.value = health

func set_health(value: float):
	var previous := health
	health = clampf(value, 0.0, max_health)

	health_bar.value = health

	# Only trigger delay when taking damage
	if health < previous:
		_damage_timer = damage_delay
	elif health > previous:
		# Healing updates both bars immediately
		damage_indicator.value = health

func damage(amount: float):
	set_health(health - amount)

func heal(amount: float):
	set_health(health + amount)

func set_hunger(value: float):
	hunger = clampf(value, 0.0, max_hunger)
	hunger_bar.value = hunger

func add_hunger(amount: float):
	set_hunger(hunger + amount)

func consume_hunger(amount: float):
	set_hunger(hunger - amount)

func set_stamina(value: float):
	stamina = clampf(value, 0.0, max_stamina)
	stamina_bar.value = stamina

func restore_stamina(amount: float):
	set_stamina(stamina + amount)

func consume_stamina(amount: float):
	set_stamina(stamina - amount)
