extends CharacterBody2D

@onready var area_2d: Area2D = $EnteredBattleBoxArea2D

var max_speed := 300
var min_speed := 200
var direction := Vector2.ZERO
var spawn_margin := 200
var speed := max_speed
var attack_damage: int
var inside_box := false


func _ready() -> void:
	area_2d.area_entered.connect(on_area_entered)

	# Randomly choose speed
	speed = randi_range(min_speed, max_speed)

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
	var target_position := screen_size / 2
	# Calculate direction towards the center of the screen
	direction = (target_position - position).normalized()
	velocity = direction * speed


func on_area_entered(other_area: Area2D) -> void:
	if inside_box:
		return
	inside_box = true
	set_collision_mask_value(1, true)


func _physics_process(delta: float) -> void:
	var collision := move_and_collide(velocity * delta)

	if collision:
		var normal := collision.get_normal()
		velocity = velocity.bounce(normal)

	# Check if the projectile is outside the screen boundaries
	if is_outside_screen():
		queue_free()


func is_outside_screen() -> bool:
	# Check if the projectile is outside the screen boundaries
	var margin := 300
	var screen_rect := get_viewport_rect().grow(margin)
	return !screen_rect.has_point(position)
