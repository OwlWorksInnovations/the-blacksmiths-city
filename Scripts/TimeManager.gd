extends Node

signal hour_changed(hour: float)

var time: float = 0
var current_time: float
var hour_length: float = 1.0

func _process(delta: float) -> void:
	time += delta
	
	if time >= hour_length:
		if current_time >= 23:
			current_time = 0
			hour_changed.emit(current_time)
		elif current_time < 23:
			current_time += 1
			hour_changed.emit(current_time)
			
		time = 0
		
