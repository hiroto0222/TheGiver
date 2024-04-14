extends CharacterBody2D

@export var max_speed := 250
@export var immune_time := 2

@onready var hit_box_area: Area2D = $HitBoxArea2D
@onready var immune_timer: Timer = $ImmuneTimer
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

var is_immune := false


func _ready() -> void:
	hit_box_area.body_entered.connect(on_body_entered)
	immune_timer.wait_time = immune_time
	immune_timer.timeout.connect(on_immune_timer_timeout)


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


func on_body_entered(body: Node2D) -> void:
	if is_immune:
		return

	# damage player
	audio.play()
	PlayerState.decrease_health(body.attack_damage)

	# start immune timer
	is_immune = true
	immune_timer.start()
	anim.play("immune")


func on_immune_timer_timeout() -> void:
	is_immune = false
	anim.stop()
