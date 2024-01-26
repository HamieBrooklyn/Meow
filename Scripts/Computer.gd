extends Area2D

@onready var computer_interface: Control = %ComputerInterface

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("interact"):
		computer_interface.visible = not computer_interface.visible
