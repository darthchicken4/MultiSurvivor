extends Node2D


@onready var hand1  = $hand_1
@onready var hand2  = $hand_2

@export var left_sholder : Node2D
@export var right_sholder : Node2D

@export var tool_pivot: Node2D

@export var player : CharacterBody2D
func _ready() -> void:
	print(hand1.get_point_position(1))
	hand1.set_point_position(0, left_sholder.position)   # change point at index 0
	hand2.set_point_position(0, right_sholder.position)
	
func _process(delta: float) -> void:
	hand1.set_point_position(0, left_sholder.position)   # change point at index 0
	hand2.set_point_position(0, right_sholder.position)
	hand1.set_point_position(1, player.global_position - tool_pivot.left_hand_pos)   # change point at index 0
	hand2.set_point_position(1, player.global_position - tool_pivot.right_hand_pos)
