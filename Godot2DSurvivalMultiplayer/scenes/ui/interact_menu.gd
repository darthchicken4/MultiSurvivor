extends Control

signal action_selected(action: String, target: Node)

@onready var objectname =$Panel/Name
@onready var panel =$Panel
@onready var vbox = $Panel/MarginContainer/VBoxContainer
@onready var inspect_button = $Panel/MarginContainer/VBoxContainer/InspectButton

var target_node: Node = null

func _ready():
	hide()
	inspect_button.pressed.connect(_on_action_pressed.bind("Inspect"))
	set_as_top_level(true)

func open(pos: Vector2, target: Node, actions: Array):
	target_node = target
	objectname.text = target.objectname
	panel.size.y = 46+(30*(actions.size()-1))
	# Remove all buttons except the template
	for child in vbox.get_children():
		if child != inspect_button:
			child.queue_free()

	# Hide template, we'll duplicate it for each action
	inspect_button.hide()

	# Create a button for each action
	for action in actions:
		var btn = inspect_button.duplicate()
		btn.text = action
		btn.show()
		btn.pressed.connect(_on_action_pressed.bind(action))
		vbox.add_child(btn)

	# Position at mouse
	show()
	await get_tree().process_frame
	panel.global_position =pos
	
	

	

func _on_action_pressed(action: String):
	action_selected.emit(action, target_node)
	hide()

func _input(event):
	if not visible:
		return
	if get_viewport().get_camera_2d().global_position.distance_to(panel.global_position) > 120:
		print(get_viewport().get_camera_2d().global_position)
		print(global_position)
		visible = false
	if event is InputEventMouseButton and event.pressed:
		if not panel.get_global_rect().has_point(get_viewport().get_mouse_position()):
			hide()
