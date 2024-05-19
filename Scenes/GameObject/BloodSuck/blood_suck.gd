extends Node2D
class_name BloodSuck

signal ended(success: bool, x_pos: float, y_pos: float)

const MAX_PHASES = 2
const TARGET_MARGIN = 100

# stage phase
var current_phase: int = 1

@export var line_horizontal: PackedScene
@export var line_vertical: PackedScene

@onready var target: Sprite2D = $Target
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

var max_sucks: int = 5
var curr_successful_sucks: int = 0

var curr_line: ColorRect

# min/max speeds for each phase
var line_speeds := [
	[1000, 2000],
	[750, 1000],
	[250, 500],
]


func _ready() -> void:
	current_phase = mini(current_phase, MAX_PHASES)

	insantiate_new_line()

	var wait_timer: Timer = Timer.new()
	wait_timer.one_shot = true
	wait_timer.wait_time = 1
	wait_timer.timeout.connect(on_wait_timer_timeout)
	add_child(wait_timer)
	wait_timer.start()


func on_wait_timer_timeout() -> void:
	add_child(curr_line)


func on_line_ended() -> void:
	# check exit condition
	if curr_successful_sucks >= max_sucks:
		ended.emit(true, curr_line.position.x, curr_line.position.y)
		return

	# check if success
	if is_line_within_target():
		PlayerState.increase_blood(5)
		curr_successful_sucks += 1
		insantiate_new_line()
		add_child(curr_line)
	else:
		ended.emit(false, curr_line.position.x, curr_line.position.y)
		return


func insantiate_new_line() -> void:
	if curr_line != null:
		curr_line.queue_free()

	var min_speed: float = line_speeds[current_phase][0]
	var max_speed: float = line_speeds[current_phase][1]
	# randomly pick between horizontal/vertical
	if randi_range(0, 1):
		# horizontal line
		curr_line = line_horizontal.instantiate() as ColorRect
		curr_line.line_speed = randf_range(min_speed, max_speed)
		curr_line.ended.connect(on_line_ended)
	else:
		# vertical line
		curr_line = line_vertical.instantiate() as ColorRect
		curr_line.line_speed = randf_range(min_speed, max_speed)
		curr_line.ended.connect(on_line_ended)


func is_line_within_target() -> bool:
	var target_width := (target.texture.get_width() - TARGET_MARGIN) * target.scale / 2
	var res := (curr_line.position.x >= target.position.x - target_width.x &&
				curr_line.position.x <= target.position.x + target_width.x) || \
			   (curr_line.position.y >= target.position.y - target_width.y &&
				curr_line.position.y <= target.position.y + target_width.y)
	return res
