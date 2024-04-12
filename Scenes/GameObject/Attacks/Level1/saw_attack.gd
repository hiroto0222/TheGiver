extends Node2D


var speed := 300
var target_position := Vector2.ZERO
var spawn_margin := 200

func _ready() -> void:
	# Randomly choose a starting position outside the screen
	var screen_size := get_viewport_rect().size
	var side := randi_range(0, 3)  # 0: top, 1: right, 2: bottom, 3: left
	match side:
		0:  # Top
			position.x = randf_range(0, screen_size.x)
			position.y = -spawn_margin
		1:  # Right
			position.x = screen_size.x + spawn_margin
			position.y = randf_range(0, screen_size.y)
		2:  # Bottom
			position.x = randf_range(0, screen_size.x)
			position.y = screen_size.y + spawn_margin
		3:  # Left
			position.x = -spawn_margin
			position.y = randf_range(0, screen_size.y)

	# Calculate target position (center of the screen)
	target_position = screen_size / 2

	# Calculate direction towards the center of the screen
	var direction := (target_position - position).normalized()

	# Set the final destination for the projectile
	# This ensures that the projectile will pass through the center of the screen
	target_position += direction * screen_size.length()


func _process(delta: float) -> void:
	# Move towards the target position
	var direction := (target_position - position).normalized()
	position += direction * speed * delta

	# Check if the projectile is outside the screen boundaries
	if is_outside_screen():
		queue_free()


func is_outside_screen() -> bool:
	# Check if the projectile is outside the screen boundaries
	var margin := 300
	var screen_rect := get_viewport_rect().grow(margin)
	return !screen_rect.has_point(position)
