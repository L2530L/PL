extends Node

func set_spawn_speed(timer: Timer, speed: float) -> void:
	timer.stop()
	timer.wait_time = speed
	timer.start()
