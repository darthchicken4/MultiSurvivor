extends Control


signal host_pressed(nickname: String, skin: String)
signal quit_pressed
@onready var main_container: VBoxContainer = $MainContainer
@onready var debug_container: VBoxContainer = $VBoxContainer
@onready var skin_input: OptionButton = $MainContainer/MainMenu/Option2/SkinInput
@onready var nick_input: LineEdit = $MainContainer/MainMenu/Option1/NickInput
@onready var address_input: LineEdit = $MainContainer/MainMenu/Option3/AddressInput



func _ready():
	Network.debug_message.connect(add_debug_output)
	pass

func _on_host_pressed():
	main_container.visible = false
	debug_container.visible = true
	await get_tree().create_timer(0.1).timeout
	var nickname = nick_input.text.strip_edges()
	var skin = skin_input.text.strip_edges().to_lower()
	host_pressed.emit(nickname, skin)
	

func _on_quit_pressed():
	quit_pressed.emit()

func show_menu():
	show()

func hide_menu():
	hide()
	
func add_debug_output(message):
	print(message)
	
func is_menu_visible() -> bool:
	return visible

func get_nickname() -> String:
	return nick_input.text.strip_edges()

func get_skin() -> String:
	return skin_input.text.strip_edges().to_lower()

func get_address() -> String:
	return address_input.text.strip_edges()

var single_player = preload("res://scenes/level/single_player/single_player.tscn")




func _on_option_button_item_selected(index: int) -> void:
	pass # Replace with function body.


func _on_button_pressed() -> void:
	await Network.start_singleplayer("player?", "blue")
	#host_pressed.emit("you", "blue")
	get_tree().change_scene_to_packed(single_player)
	
