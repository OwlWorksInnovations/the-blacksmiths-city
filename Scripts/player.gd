extends CharacterBody2D

var speed: float = 300

func _process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	
	velocity = direction * speed
	move_and_slide()
