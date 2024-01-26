extends Control

const ITEM_ORDER_TEMPLATE = preload("res://Nodes/UI/ItemOrderTemplate.tscn")
@onready var items_container: GridContainer = %ItemsContainer
@onready var truck_manager: Node2D = %TruckManager

var items = {}

func _ready() -> void:
	setup_panel()

func _on_order_button_pressed() -> void:
	var order = items.duplicate()
	FoodTruck.new_order(order, truck_manager)
	clear_templates()
	items.clear()

func setup_panel():
	for item_name : String in OrderingData.Items:
		var new_temp = ITEM_ORDER_TEMPLATE.instantiate()
		new_temp.name = item_name
		new_temp.get_node("Name").text = item_name
		new_temp.get_node("Add").connect("pressed", func():
			add_item(item_name)
			update_template(new_temp)
			)
		new_temp.get_node("Remove").connect("pressed", func():
			remove_item(item_name)
			update_template(new_temp)
			)
		items_container.add_child(new_temp)

func add_item(item_name : String):
	if items.get(item_name):
		items[item_name] += 1
	else:
		items[item_name] = 1

func remove_item(item_name : String):
	if not items.get(item_name): return
	
	items[item_name] -= 1
	if items[item_name] <= 0:
		items.erase(item_name)

func update_template(template : Panel):
	if not items.get(template.name):
		template.get_node("Quantity").text = "0"
		return
	template.get_node("Quantity").text = str(items[template.name]) + "x"

func _on_clear_all_button_pressed() -> void:
	clear_templates()
	items.clear()

func clear_templates():
	for temp in items_container.get_children():
		temp.get_node("Quantity").text = "0"
