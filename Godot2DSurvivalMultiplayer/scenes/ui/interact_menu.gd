extends Control



@onready var objectname =$Panel/Name
@onready var panel =$Panel
@onready var vbox = $Panel/MarginContainer/VBoxContainer
@onready var inspect_button = $Panel/MarginContainer/VBoxContainer/InspectButton

var target_node: Node = null

func _ready():
	hide()
	set_as_top_level(true)
	inspect_button.hide()

func open(pos: Vector2, target: Node, actions: Array):
	target_node = target
	objectname.text = target.objectname

	panel.size.y = 46 + (30 * (actions.size() - 1))

	for child in vbox.get_children():
		if child != inspect_button:
			child.queue_free()

	for action in actions:
		var btn = inspect_button.duplicate()
		btn.text = action
		btn.show()
		btn.pressed.connect(_on_action_pressed.bind(action))
		print("Connected:", action)
		vbox.add_child(btn)

	show()
	await get_tree().process_frame
	panel.global_position = pos
	

func _on_action_pressed(action: String):
	GameManager.action_selected.emit(action, target_node)
	print("YEAH")
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
