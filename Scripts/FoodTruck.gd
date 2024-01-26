extends StaticBody2D

@onready var item_checker: Area2D = $ItemChecker
@onready var food_spawn: Marker2D = %FoodSpawn
@onready var hatch: StaticBody2D = $Hatch
@onready var wheels: Node2D = $Wheels

var wheels_direction := 0
var found_items := 0

signal no_items_in_area

func _process(delta: float) -> void:
	if item_checker.get_overlapping_bodies().size() <= 0:
		no_items_in_area.emit()
	
	if wheels_direction != 0:
		for wheel : Sprite2D in wheels.get_children():
			wheel.rotation_degrees += wheels_direction * 100 * delta

func lower_hatch(proposition: bool, speed: float, angle: float):
	var tween = create_tween()
	tween.tween_property(hatch, "rotation_degrees", angle, speed)
	tween.play()
	return tween

func drop_items(items : Dictionary):
	for item_name: String in items:
		for i in items[item_name]:
			await get_tree().create_timer(1 / items.size()).timeout
			var item = FoodTruck.available_foods.get(item_name).instantiate()
			
			item.global_position = food_spawn.global_position
			get_tree().current_scene.get_node("Items").add_child(item)
	await get_tree().create_timer(3).timeout
	await no_items_in_area
	print("None found")

func stop_wheels():
	wheels_direction = 0

func drive_to(position : Vector2, direction : float, speed : float):
	var tween = create_tween()
	tween.tween_property(self, "global_position", position, speed)
	tween.play()
	wheels_direction = direction
	
	tween.connect("finished", stop_wheels)
	return tween
