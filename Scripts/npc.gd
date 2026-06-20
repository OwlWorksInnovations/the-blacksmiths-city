extends  CharacterBody2D

var speed: float = 150
var target: Vector2 = Vector2.ZERO
var current_time: float = 0

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@export var schedule: NPCSchedule
@export var work_location: Marker2D
@export var tavern_location: Marker2D
@export var sleep_location: Marker2D

func set_time(time):
	current_time = time
	
	if current_time >= schedule.work_start_hour and current_time < schedule.tavern_start_hour and current_time < schedule.sleep_start_hour:
		target = work_location.global_position
	elif current_time >= schedule.tavern_start_hour and current_time < schedule.sleep_start_hour:
		target = tavern_location.global_position
	elif current_time >= schedule.sleep_start_hour or current_time < schedule.work_start_hour:
		target = sleep_location.global_position
	
	navigation_agent_2d.path_desired_distance = 4.0
	navigation_agent_2d.target_desired_distance = 4.0
	actor_setup.call_deferred()

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
