extends Node2D

@export var speed: float = 300.0
@export var max_distance: float = 2000.0
@export var damage = 5.0
var velocity: Vector2 = Vector2.ZERO
var distance_traveled: float = 0.0

@export var audio :AudioStreamPlayer2D 

@onready var colid  = $damage_area/CollisionShape2D

func _ready() -> void:
	# fires in the direction the arrow is facing
	velocity = Vector2.RIGHT.rotated(rotation) * speed

func _physics_process(delta: float) -> void:
	var step: Vector2 = velocity * delta
	global_position += step
	distance_traveled += step.length()

	if distance_traveled >= max_distance:
		queue_free()


func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.has_method("damage_player"):
		audio.play()
		body.damage_player(damage)
		set_physics_process(false)
		set_process(false)
		while true:
			await Utils.wait(0.01)
			self.global_position = body.global_position
			colid.disabled = true
		queue_free()

func _on_damage_area_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
