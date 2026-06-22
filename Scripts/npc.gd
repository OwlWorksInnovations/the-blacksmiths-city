extends  CharacterBody2D

var speed: float = 300
var target: Vector2 = Vector2.ZERO
var current_time: float = 0

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@export var schedule: NPCSchedule

func set_time(time: float) -> void:
	current_time = time
	
	if schedule == null or schedule.entries.is_empty():
		return

	var active_entry: ScheduleEntry = null
	var closest_start_hour: float = -1.0 # Track the highest valid hour found so far

	for entry in schedule.entries:
		# Check if the entry has already started, and if it's a closer match than the previous find
		if entry.start_hour <= current_time and entry.start_hour > closest_start_hour:
			active_entry = entry
			closest_start_hour = entry.start_hour

	# Move to target location if an active entry was found
	if active_entry:
		var nodes = get_tree().get_nodes_in_group(active_entry.location_group)
		if nodes.size() > 0:
			target = nodes[0].global_position
			set_movement_target(target)
	
func _ready() -> void:
	TimeManager.connect("hour_changed", set_time)

func set_movement_target(movement_target: Vector2):
	navigation_agent_2d.target_position = movement_target

func actor_setup():
	await get_tree().physics_frame
	set_movement_target(target)

func _process(delta: float) -> void:
	if navigation_agent_2d.is_navigation_finished():
		return
		
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent_2d.get_next_path_position()
	
	var direction = current_agent_position.direction_to(next_path_position)
	velocity = direction * speed
	move_and_slide()
