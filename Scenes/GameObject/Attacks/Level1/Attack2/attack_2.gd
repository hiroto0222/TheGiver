extends Attack

const MAX_ATTACK_DURATION = 7
const MIN_SPAWN_TIME := 0.1
const MAX_SPAWN_TIME := 0.3

@export var attack_object_scenes: Array[PackedScene]

var spawn_timer := Timer.new()
var attack_cnt := 0


func _ready() -> void:
	# total timer for current attack sequence
	timer.wait_time = MAX_ATTACK_DURATION
	add_child(timer)
	timer.start()

	# timer for spawning attacks
	spawn_timer.wait_time = randf_range(MIN_SPAWN_TIME, MAX_SPAWN_TIME)
	spawn_timer.one_shot = false # repeat timer
	spawn_timer.timeout.connect(on_spawn_timer_timeout)
	add_child(spawn_timer)
	spawn_timer.start()


func on_spawn_timer_timeout() -> void:
	var i := randi_range(0, len(attack_object_scenes) - 1)
	var attack_object_instance := attack_object_scenes[i].instantiate()
	attack_object_instance.attack_damage = attack_damage
	add_child(attack_object_instance)
