extends Node
class_name CarryComponent

@export var body : RigidBody2D
@export var state_machine : Node2D
@export var keep_momentum := false
@export var max_force := 500.0
@export var offset_point : Marker2D
@export var reset_rotation := true

var was_carrying = false
var is_carrying = false
var has_state = false

func _process(delta):
	if is_carrying:
		if not was_carrying:
			Global.InHand.insert(0, body)
		was_carrying = true
		update_pos(delta)
		update_momentum(delta)
	else:
		if was_carrying:
			change_state("idle")
			InputManager.holding = null
			was_carrying = false
			if reset_rotation:
				body.global_rotation = lerp(body.global_rotation, 0.0, 1)

		InputManager.holding = body
		change_state("carrying")
		is_carrying = true

func update_pos(delta):
	var offset : Vector2
	if not offset_point:
		offset = Vector2.ZERO
	else:
		offset = offset_point.position
	
	var mouse_pos = get_viewport().get_mouse_position()
	body.global_position = lerp(body.global_position - offset, mouse_pos, 25 * delta)
	body.rotation = (mouse_pos.x - body.global_position.x) * delta

func update_momentum(delta):
	body.linear_velocity = Vector2.ZERO
	if not keep_momentum or Global.MouseMoveDirection == Vector2.ZERO: return
	body.linear_velocity += (Global.MouseMoveDirection * 1500.0 * delta)
	body.linear_velocity = body.linear_velocity.limit_length(max_force)

func change_state(state_name):
	if state_machine:
		state_machine.current_state = state_name
