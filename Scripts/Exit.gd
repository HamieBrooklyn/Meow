extends Button

@export var panel : Control

func _on_button_down() -> void:
	panel.visible = false
