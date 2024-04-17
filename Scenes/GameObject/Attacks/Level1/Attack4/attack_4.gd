extends Attack

const MAX_ATTACK_DURATION = 12
const MIN_SPAWN_TIME := 1
const MAX_SPAWN_COUNT := 4

@export var attack_object_scene: PackedScene

var spawn_timer := Timer.new()
var spawn_count := 0


func _ready() -> void:
	# total timer for current attack sequence
	timer.wait_time = MAX_ATTACK_DURATION
	add_child(timer)
	timer.start()

	# timer for spawning attacks
	spawn_timer.wait_time = MIN_SPAWN_TIME
	spawn_timer.one_shot = false # repeat timer
	spawn_timer.timeout.connect(on_spawn_timer_timeout)
	add_child(spawn_timer)
	spawn_timer.start()


func on_spawn_timer_timeout() -> void:
	spawn_count += 1
	var attack_object_instance := attack_object_scene.instantiate()
	attack_object_instance.attack_damage = attack_damage
	add_child(attack_object_instance)

	if spawn_count >= MAX_SPAWN_COUNT:
		spawn_timer.timeout.disconnect(on_spawn_timer_timeout)
		spawn_timer.stop()
