extends Control
class_name MultiplayerChatUI

signal message_sent(text: String)

@onready var message: LineEdit = $Panel/MarginContainer/VBoxContainer/HBoxContainer/Message
@onready var chat: TextEdit = $Panel/MarginContainer/VBoxContainer/Chat

const MAX_MESSAGE_LENGTH := 300
const MAX_HISTORY_LINES := 100
const SERVER_ID := 1

var chat_visible := false

func _ready() -> void:
	message.text_submitted.connect(_on_send_pressed)
	clear_chat()
	hide()

func toggle_chat() -> void:
	chat_visible = !chat_visible
	if chat_visible:
		show()
		await get_tree().process_frame
		message.grab_focus()
	else:
		hide()
		message.text = ""
	get_viewport().set_input_as_handled()

func is_chat_visible() -> bool:
	return chat_visible

func _on_send_pressed(_unused = null) -> void:
	var message_text := message.text.strip_edges()
	if message_text.is_empty():
		return
	if not multiplayer.has_multiplayer_peer():
		return
	if message_text.length() > MAX_MESSAGE_LENGTH:
		message_text = message_text.substr(0, MAX_MESSAGE_LENGTH)
	message_sent.emit(message_text)
	request_chat_message.rpc_id(SERVER_ID, message_text)
	message.text = ""
	message.grab_focus()

func add_message(nick: String, msg: String) -> void:
	var time := Time.get_time_string_from_system()
	var formatted_message := "[" + time + "] " + nick + ": " + msg + "\n"
	chat.text += formatted_message
	chat.scroll_vertical = chat.get_line_count() - 1
	_limit_chat_history()

func _limit_chat_history() -> void:
	if chat.text.is_empty():
		return
	var trimmed := chat.text.rstrip("\n")
	var lines := trimmed.split("\n")
	if lines.size() > MAX_HISTORY_LINES:
		var start_index := lines.size() - MAX_HISTORY_LINES
		chat.text = "\n".join(lines.slice(start_index)) + "\n"

func clear_chat() -> void:
	chat.text = ""

@rpc("any_peer", "call_local", "reliable")
func request_chat_message(text: String) -> void:
	if not multiplayer.is_server():
		return  # Only the server processes/relays requests.
	var sender_id := multiplayer.get_remote_sender_id()
	if sender_id == 0:
		sender_id = multiplayer.get_unique_id()  # Server sent it to itself.
	if text.is_empty():
		return
	if text.length() > MAX_MESSAGE_LENGTH:
		text = text.substr(0, MAX_MESSAGE_LENGTH)
	var nick := str(sender_id)
	receive_chat_message.rpc(nick, text)

@rpc("call_local", "reliable")
func receive_chat_message(nick: String, text: String) -> void:
	add_message(nick, text)
