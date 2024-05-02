extends Node2D
class_name Fight

signal ended(x_pos: float, y_pos: float)

@export var line_horizontal: PackedScene
@export var line_vertical: PackedScene

@onready var timer: Timer = $Timer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

var line_horizontal_instance: ColorRect
var line_vertical_instance: ColorRect

var horizontal_speed: float = 1000
var vertical_speed: float = 1000


func _ready() -> void:
	line_horizontal_instance = line_horizontal.instantiate() as ColorRect
	line_horizontal_instance.line_speed = horizontal_speed
	line_horizontal_instance.ended.connect(on_line_horizontal_ended)

	line_vertical_instance = line_vertical.instantiate() as ColorRect
	line_vertical_instance.line_speed = vertical_speed
	line_vertical_instance.ended.connect(on_line_vertical_ended)

	timer.wait_time = randf_range(2, 4)
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
	ended.emit(line_horizontal_instance.position.x, line_vertical_instance.position.y)
