extends Area2D
class_name ItemComponent

@export var item : Node2D
@export var taker_group : String
@export var item_handler : Node2D

func _on_body_entered(body):
	if body.is_in_group(taker_group) && body.has_node("Item"):
		item_handler.taken(body)
