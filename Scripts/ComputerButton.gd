extends TextureButton
class_name ComputerButton

@onready var label: Label = $Label

@export var panel : Control
@export var label_text : String

func _ready() -> void:
	label.text = label_text

func _on_pressed() -> void:
	panel.visible = not panel.visible

