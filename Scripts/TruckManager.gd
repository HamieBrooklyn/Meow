extends Node2D

const FOOD_TRUCK = preload("res://Nodes/FoodTruck.tscn")

var current_truck

var available_foods = {
	"TestItem1" : preload("res://Nodes/Items/TestFood1.tscn"),
	"TestItem2" : preload("res://Nodes/Items/TestFood2.tscn"),
	"TestItem3" : preload("res://Nodes/Items/TestFood3.tscn")
}

func new_order(order : Dictionary, truck_manager : Node2D):
	await get_tree().create_timer(randf_range(order.size(), order.size() + 5)).timeout
	
	var spawn_position = truck_manager.get_node("TruckSpawn").global_position
	var stop_position = truck_manager.get_node("TruckStop").global_position
	
	var new_food_truck = FOOD_TRUCK.instantiate()
	new_food_truck.global_position = spawn_position
	
	current_truck = new_food_truck
	truck_manager.add_child(new_food_truck)
	
	var is_driving = new_food_truck.drive_to(stop_position, 1, 5)
	await is_driving.finished
	
	var is_lowering_hatch = new_food_truck.lower_hatch(true, 3, 110)
	await is_lowering_hatch.finished
	
	await new_food_truck.drop_items(order)
	
	var is_closing_hatch = new_food_truck.lower_hatch(false, 3, 0)
	await is_closing_hatch.finished
	
	var done_driving = new_food_truck.drive_to(spawn_position, -1, 5)
	await done_driving.finished
	
	new_food_truck.queue_free()
	print("Done")
