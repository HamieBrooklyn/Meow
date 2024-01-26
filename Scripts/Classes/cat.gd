extends RigidBody2D
class_name CatClass

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var selection_component = $SelectionComponent
@onready var stats_container = %StatsContainer
@onready var carry_component = $CarryComponent
@onready var stats_timers = %StatsTimers
@onready var origin = $Origin
@onready var sprite_2d = $Sprite2D

@export var current_state = "idle"

@export var stats = {
	'hunger' : {'current' : 100, 'min' : 50, 'amount' : 1, 'wait' : 12},
	'tiredness' : {'current' : 100, 'min' : 50, 'amount' : 1, 'wait' : 20},
}

@export var mood = "happy"
var prev_mood := ""

var last_state = current_state
func _process(delta):
	var lowest_stat
	
	for stat in stats.keys():
		var lowest_values = stats.get(lowest_stat)
		var values = stats.get(stat)
		var found = false
		
		if not lowest_stat:
			lowest_stat = stat
			continue
		if values.get("current") < lowest_values.get("current") and values.get("current") > values.get("min"):
			lowest_stat = stat
			found = true
		if not found: mood = "happy"
	
	if lowest_stat: manage_mood(lowest_stat, stats.get(lowest_stat))
	
	if current_state != last_state:
		print("state changed to " + current_state)
		last_state = current_state
	
	manage_stat_ui()
	manage_state()
	
	origin.global_rotation = 0
	
	manage_selection()
	manage_carrying()

func _ready():
	stats_container.get_node("Name").text = self.name
	manage_stats()

func manage_mood(stat_name, stat_data : Dictionary):
	if stat_data.get("current") >= stat_data.get("min"): return
	if mood == prev_mood: return
	
	if stat_name == "hunger":
		mood = "hungry"
	elif stat_name == "tiredness":
		mood = "tired"

func manage_state():
	var tiredness = stats.get("tiredness")
	var hunger = stats.get("hunger")
	
	if current_state == "sleeping":
		animation_player.play("cat_sleep")
		tiredness.current += 1
		tiredness.current = clamp(tiredness.current, 0, 100)

func manage_stat_ui():
	for stat_bar in stats_container.get_children():
		var stat_name = stat_bar.name.to_lower()
		if stats.get(stat_name):
			stat_bar.value = stats.get(stat_name).get("current")

func manage_stats():
	for stat_name in stats.keys():
		var stat_data = stats.get(stat_name)
		var new_timer = Timer.new()
		stats_timers.add_child(new_timer)
		new_timer.wait_time = stat_data.get("wait")
		
		new_timer.timeout.connect(func():
			stats.get(stat_name).current -= stat_data.get("amount")
			)
		
		new_timer.start()

func manage_selection():
	stats_container.visible = selection_component.selected
	if carry_component.is_carrying:
		stats_container.visible = false

func manage_carrying():
	var current_anim = animation_player.current_animation
	if carry_component.is_carrying:
		animation_player.play("cat_carry")
	elif current_anim == "cat_carry":
		animation_player.play("cat_idle")
