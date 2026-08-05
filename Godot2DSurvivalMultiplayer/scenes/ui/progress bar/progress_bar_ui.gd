extends Control

@onready var prorgess_bar = $ProgressBar
@onready var cancel_sprite = $Sprite2D
var x_pos = 0.0
@export var time = 1.0
var  progress_done = false

func _ready() -> void:
	cancel_sprite.visible = false
	progress_reset()
	
func progress_set(time_to_use):
	while progress_done == false:
		await  Utils.wait(time_to_use / prorgess_bar.max_value)
		prorgess_bar.value = prorgess_bar.value + 1
		if prorgess_bar.value == prorgess_bar.max_value:
			progress_done = true
			
			

func progress_reset():
	prorgess_bar.value = 0.0
	progress_done = false

func progress_cancel():
	x_pos = prorgess_bar.size.x * (prorgess_bar.value / prorgess_bar.max_value)
	cancel_sprite.global_position.x = x_pos
	progress_done = false

func progress_hide():
	self.hide()
	
func progress_show():
	self.show()
