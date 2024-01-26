extends Area2D
class_name RestPointComponent

@export var rest_point_manager : Node2D
@export var rest_marker : Marker2D
@export var rest_group : String
@export var max_distance := 100
@export var max_bodies := 1
@export var min_bodies := 1

var current_bodies = []

func _process(delta):
	for body in get_overlapping_bodies():
		if not body is RigidBody2D or not validate_body(body): continue
		var carryComponent = body.get_node("CarryComponent")
		
		if body is RigidBody2D and carryComponent.is_carrying == false:
			body.rotation = 0
			current_bodies.append(body)
			if current_bodies.size() >= min_bodies:
				rest_point_manager.start()
	
	for body in current_bodies:
		if body:
			var carry_comp = body.get_node("CarryComponent")
			if not carry_comp.is_carrying:
				body.global_position = global_position
			else:
				rest_point_manager.stop()
				current_bodies.remove_at(current_bodies.find(body))

func validate_body(body : RigidBody2D):
	if not body.is_in_group(rest_group): return
	if current_bodies.find(body) != -1: return
	if not body.has_node("CarryComponent"): return
	if current_bodies.size() >= max_bodies: return
	if body.get_node("CarryComponent").is_carrying: return
	return true
