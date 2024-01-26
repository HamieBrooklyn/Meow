extends Node

var last_mouse_position := Vector2.ZERO
var holding_mouse := false
var holding

func _process(delta):
	check_mouse_position()

func _input(event):
	if event is InputEventMouseMotion:
		Global.MouseMoveDirection = event.relative
	
	if Input.is_action_just_pressed("interact"):
		holding_mouse = true
	
	if Input.is_action_just_released("interact"):
		holding_mouse = false
		for body in Global.InHand:
			if not body: break
			if not body.has_node("CarryComponent"): continue
			body.get_node("CarryComponent").is_carrying = false

func check_mouse_position():
	if Global.MouseMoveDirection == last_mouse_position:
		Global.MouseMoveDirection = Vector2.ZERO
	last_mouse_position = Global.MouseMoveDirection
