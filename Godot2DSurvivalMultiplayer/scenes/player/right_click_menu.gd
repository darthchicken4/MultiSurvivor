extends Control

# Reference your existing menu container
@onready var menu_panel = $MarginContainer 
@export var option1 :bool
@export var option2 :bool
@export var option3 :bool

func _ready() -> void:
	# Ensure the menu is hidden initially
	menu_panel.visible = false

func _unhandled_input(event: InputEvent) -> void:
	# Check if the event is a mouse button click
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			# Show the menu at the current mouse global position
			menu_panel.global_position = get_global_mouse_position()
			menu_panel.visible = true
		
		# Optional: Hide menu if clicking somewhere else (left click)
		elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			menu_panel.visible = false
			
			
