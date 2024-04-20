extends Node2D
class_name Fight

signal ended(x_pos: float, y_pos: float)

@export var line_horizontal: PackedScene
@export var line_vertical: PackedScene

@onready var timer: Timer = $Timer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

var line_horizontal_instance: ColorRect
var line_vertical_instance: ColorRect

var speed := 1000
var speeds: Array[int] = [300, 1500, 1750, 2000]


func _ready() -> void:
	line_horizontal_instance = line_horizontal.instantiate() as ColorRect
	line_horizontal_instance.line_speed = speeds.pick_random()
	line_horizontal_instance.ended.connect(on_line_horizontal_ended)

	line_vertical_instance = line_vertical.instantiate() as ColorRect
	line_vertical_instance.line_speed = speeds.pick_random()
	line_vertical_instance.ended.connect(on_line_vertical_ended)

	timer.wait_time = randf_range(3, 5)
	timer.timeout.connect(on_horizontal_timer_timeout)


func start() -> void:
	audio.play()
	timer.start()


func on_horizontal_timer_timeout() -> void:
	timer.timeout.disconnect(on_horizontal_timer_timeout)
	add_child(line_horizontal_instance)


func on_line_horizontal_ended() -> void:
	add_child(line_vertical_instance)


func on_vertical_timer_timeout() -> void:
	timer.timeout.disconnect(on_vertical_timer_timeout)
	add_child(line_vertical_instance)


func on_line_vertical_ended() -> void:
	timer.wait_time = 2
	timer.timeout.connect(on_end_timeout)
	timer.start()


func on_end_timeout() -> void:
	audio.stop()
	ended.emit(line_horizontal_instance.position.x, line_vertical_instance.position.y)
