extends Control

@onready var prorgess_bar = $ProgressBar
@onready var cancel_sprite = $Sprite2D
var x_pos = 0.0
@export var time = 1.0


func _ready() -> void:
	cancel_sprite.visible = false
	progress_reset()
	
func progress_set(time):
	while true:
		await  Utils.wait(time / prorgess_bar.max_value)
		prorgess_bar.value = prorgess_bar.value + 1
		
func progress_reset():
	prorgess_bar.value = 0.0

func progress_cancel():
	x_pos = prorgess_bar.size.x * (prorgess_bar.value / prorgess_bar.max_value)
	cancel_sprite.global_position.x = x_pos
	
