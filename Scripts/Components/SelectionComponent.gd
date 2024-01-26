extends Area2D
class_name SelectionComponent

const OUTLINE = preload("res://Shaders/outline.gdshader")

@export var target: RigidBody2D
@export var sprite: Sprite2D
@export var show_outline: bool
@export var hide_outline_on_click: bool

var selected = false
var can_select = true

func _ready():
	sprite.material = ShaderMaterial.new()

func _process(delta):
	can_select = not InputManager.holding_mouse
	
	if selected and show_outline and can_select:
		sprite.material.shader = OUTLINE
	elif sprite.material.shader:
		sprite.material.shader = null

func _on_mouse_entered():
	if not can_select: return
	selected = true

func _on_mouse_exited():
	selected = false
