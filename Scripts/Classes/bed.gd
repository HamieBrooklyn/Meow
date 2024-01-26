extends Node2D

@onready var rest_point_component = $RestPointComponent
@onready var sleep_timer = %SleepTimer

@export var wait := .8
@export var give := 1

var bodies

func _ready():
	bodies = rest_point_component.current_bodies
	sleep_timer.wait_time = wait

func start():
	await get_tree().create_timer(1).timeout
	
	for body in bodies:
		body.current_state = "sleeping"

func stop():
	for body in bodies:
		body.current_state = "idle"

func _on_sleep_timer_timeout():
	for body in bodies:
		body.stats.get("tiredness").current += give
