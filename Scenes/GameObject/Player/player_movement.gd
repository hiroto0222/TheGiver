extends CharacterBody2D

@export var max_speed := 250


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	process_movement_input()


# process movement input and change velocity
func process_movement_input() -> void:
	var movement_vector := get_movement_vector()
	var direction := movement_vector.normalized()
	velocity = direction * max_speed
	move_and_slide()


# return current input state as Vector2
func get_movement_vector() -> Vector2:
	var x_movement := Input.get_action_strength("move_right") - Input.get_action_strength("move_left") # returns 0 or 1
	var y_movement := Input.get_action_strength("move_down") - Input.get_action_strength("move_up") # returns 0 or 1

	return Vector2(x_movement, y_movement)
