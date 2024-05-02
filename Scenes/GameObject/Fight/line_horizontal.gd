extends ColorRect

signal ended

@onready var timer: Timer = $Timer
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

var line_speed := 500
var line_stopped := false


func _ready() -> void:
	timer.wait_time = 0.3
	timer.timeout.connect(on_timer_timeout)


func _process(delta: float) -> void:
	if not line_stopped:
		position.x += line_speed * delta

	if position.x > get_viewport_rect().size.x + 100 and not line_stopped:
		line_stopped = true
		ended.emit()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and not line_stopped:
		line_stopped = true
		audio.pitch_scale = randf_range(0.8, 0.95)
		audio.play()
		anim.play("flicker")
		timer.start()


func on_timer_timeout() -> void:
	anim.stop()
	ended.emit()
