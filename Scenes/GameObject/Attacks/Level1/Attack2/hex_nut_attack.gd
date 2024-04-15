extends CharacterBody2D

var max_speed := 250
var min_speed := 150
var target_position := Vector2.ZERO
var spawn_margin := 100
var speed := max_speed
var attack_damage: int

func _ready() -> void:
	# Randomly choose speed
	speed = randi_range(min_speed, max_speed)

	# Randomly choose a starting position outside the screen
	var screen_size := get_viewport_rect().size
	position.x = randf_range(450, screen_size.x - 450)
	position.y = -spawn_margin

	# Calculate target position
	target_position = Vector2(position.x, screen_size.y)
	var direction := (target_position - position).normalized()
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
