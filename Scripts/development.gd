extends Node2D

@onready var modify_schedule: Control = $ModifySchedule

var modify_schedule_visible: bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("modify_schedule"):
		if modify_schedule_visible:
			modify_schedule.visible = false
			modify_schedule_visible = false
		else:
			modify_schedule.visible = true
			modify_schedule_visible = true
