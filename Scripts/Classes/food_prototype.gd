extends RigidBody2D

@export var give := 10

func taken(taker):
	var hunger = taker.stats.get("hunger").get("current")
	
	if hunger < 90:
		taker.stats.get("hunger").current += give
		queue_free()
