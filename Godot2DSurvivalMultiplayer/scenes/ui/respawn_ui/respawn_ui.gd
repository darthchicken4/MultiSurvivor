extends Control


func _ready() -> void:
	if not is_multiplayer_authority():
		# This isn't "my" player, hide their UI from my screen
		self.visible = false
