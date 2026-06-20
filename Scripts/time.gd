extends Control

@onready var current_time: Label = $CurrentTime

func _ready() -> void:
	TimeManager.hour_changed.connect(_on_hour_changed)

func _on_hour_changed(hour: float) -> void:
	current_time.text = "Time: " + str(hour)
