extends Control
class_name MainMenuUI

signal host_pressed(nickname: String, skin: String)
signal join_pressed(nickname: String, skin: String, address: String)
signal quit_pressed

var ip: String = "127.0.0.1"

@onready var main_container: VBoxContainer = $MainContainer
@onready var debug_container: VBoxContainer = $VBoxContainer
@onready var skin_input: OptionButton = $MainContainer/MainMenu/Option2/SkinInput
@onready var nick_input: LineEdit = $MainContainer/MainMenu/Option1/NickInput
@onready var address_input: LineEdit = $MainContainer/MainMenu/Option3/AddressInput
@onready var hash_input: LineEdit = $MainContainer/MainMenu/hash_input/AddressInput

func _ready():
	Network.debug_message.connect(add_debug_output)

func _on_host_pressed():
	main_container.visible = false
	debug_container.visible = true
	await get_tree().create_timer(0.1).timeout
	var nickname = nick_input.text.strip_edges()
	var skin = skin_input.text.strip_edges().to_lower()
	host_pressed.emit(nickname, skin)

# Returns the decoded string, or "" if it wasn't valid base64
func un_hash(hash_str: String) -> String:
	var decoded = Marshalls.base64_to_utf8(hash_str)
	if decoded == null or decoded == "":
		push_warning("Failed to decode hash: %s" % hash_str)
		return ""
	return decoded

func _on_join_pressed():
	main_container.visible = false
	debug_container.visible = true
	await get_tree().create_timer(0.1).timeout

	var nickname = nick_input.text.strip_edges()
	var skin = skin_input.text.strip_edges().to_lower()

	var hash_text = hash_input.text.strip_edges()
	var address_text = address_input.text.strip_edges()

	var address: String

	if hash_text != "":
		# Prefer the hash if the user typed one in
		var decoded = un_hash(hash_text)
		address = decoded if decoded != "" else address_text
	elif address_text != "":
		address = address_text
	else:
		address = ip # fallback default

	join_pressed.emit(nickname, skin, address)

func _on_quit_pressed():
	quit_pressed.emit()

func show_menu():
	show()

func hide_menu():
	hide()

func add_debug_output(message):
	var template: Label = $VBoxContainer/Title
	var new_label: Label = template.duplicate() as Label
	new_label.text = message
	$VBoxContainer.add_child(new_label)

func is_menu_visible() -> bool:
	return visible

func get_nickname() -> String:
	return nick_input.text.strip_edges()

func get_skin() -> String:
	return skin_input.text.strip_edges().to_lower()

func get_address() -> String:
	return address_input.text.strip_edges()
