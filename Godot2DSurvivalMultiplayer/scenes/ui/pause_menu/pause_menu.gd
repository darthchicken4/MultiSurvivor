extends Control

@export var setting:Control 

@onready var menu  = $MarginContainer

func _ready() -> void: 
	self.hide()
	while true:
		await Utils.wait(0.03)
		if setting.visible == false:
			menu.show()
	if not is_multiplayer_authority():
		# This isn't "my" player, hide their UI from my screen
		self.visible = false

func _on_back_to_game_pressed() -> void:
	self.visible = false



func _on_settings_pressed() -> void:
	menu.hide()
	setting.show()


func _on_quit_pressed() -> void:
	leave_game()



func leave_game():
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null
	#@for id in players.keys():
	#	players[id].queue_free()
	#	players.clear()
	# fix later 

	get_tree().change_scene_to_file("res://scenes/start_menu/start_menu.tscn")
