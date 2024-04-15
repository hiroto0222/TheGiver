extends Attack

const MAX_ATTACK_DURATION = 10
const MIN_SPAWN_TIME := 0.7
const MAX_SPAWN_TIME := 0.7

@export var attack_object_scene: PackedScene

var spawn_timer := Timer.new()
# probabilities of x_positions
var x_positions := {
	510: [580, 640, 700, 770],
	580: [510, 640, 640, 700, 770],
	640: [510, 580, 700, 770],
	700: [510, 580, 640, 640, 770],
	770: [510, 580, 640, 700]
}

var attack_object_instance: CharacterBody2D


func _ready() -> void:
	# total timer for current attack sequence
	timer.wait_time = MAX_ATTACK_DURATION
	add_child(timer)
	timer.start()

	attack_object_instance = attack_object_scene.instantiate() as CharacterBody2D
	attack_object_instance.attack_damage = attack_damage

	# select position of nail gun
	attack_object_instance.position.x = 640
	add_child(attack_object_instance)

	# timer for spawning attacks
	spawn_timer.wait_time = randf_range(MIN_SPAWN_TIME, MAX_SPAWN_TIME)
	spawn_timer.one_shot = false # repeat timer
	spawn_timer.timeout.connect(on_spawn_timer_timeout)
	add_child(spawn_timer)
	spawn_timer.start()


func on_spawn_timer_timeout() -> void:
	# select position of nail gun
	var rand_x: int = x_positions[int(attack_object_instance.position.x)].pick_random()
	var tween := create_tween()
	tween.tween_property(attack_object_instance, "position", Vector2(rand_x, attack_object_instance.position.y), 0.1)
	attack_object_instance.shoot()
