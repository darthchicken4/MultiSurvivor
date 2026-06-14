extends Control

@onready var file_dialog = $FileDialog
@onready var texture_rect = $Sprite2D
@onready var anim = $AnimationPlayer
func _ready():
	anim.play("new_animation")
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	
	file_dialog.filters = PackedStringArray([
		"*.png ; PNG Images",
		"*.jpg, *.jpeg ; JPEG Images",
		"*.webp ; WebP Images"
	])
	
	file_dialog.file_selected.connect(_on_file_selected)

func _on_button_pressed():
	file_dialog.popup_centered_ratio()

func _on_file_selected(path: String):
	var image = Image.new()
	var err = image.load(path)

	if err != OK:
		print("Failed to load image")
		return

	var texture = ImageTexture.create_from_image(image)
	texture_rect.texture = texture
	
