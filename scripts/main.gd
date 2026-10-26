extends Node2D

@export var enemy_scene: PackedScene
@onready var enemy_path: Path2D = $EnemyPath
@onready var timer_label: Label = $CanvasLayer/TimerLabel

var elapsed_time = 0
var loading_scene := false
var next_scene_path := "res://scenes/level_2.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_spawn_timer_timeout() -> void:
	spawn_enemies()# Replace with function body.

func spawn_enemies() -> void:
	var path_follow := PathFollow2D.new()
	path_follow.loop = false
	path_follow.rotates = false
	enemy_path.add_child(path_follow)

	var enemy = enemy_scene.instantiate()
	path_follow.add_child(enemy)
	enemy.position = Vector2.ZERO


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not loading_scene:
		elapsed_time += delta
		timer_label.text = "Time: %d" % int(elapsed_time)
		return

	var progress: Array = []
	var status := ResourceLoader.load_threaded_get_status(
		next_scene_path, progress
	)

	if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		var percentage := 0.0
		if not progress.is_empty():
			percentage = progress[0] * 100.0

		timer_label.text = "Loading... %d%%" % int(percentage)

	elif status == ResourceLoader.THREAD_LOAD_LOADED:
		var packed_scene := ResourceLoader.load_threaded_get(next_scene_path)
		loading_scene = false
		get_tree().change_scene_to_packed(packed_scene)

	elif status == ResourceLoader.THREAD_LOAD_FAILED:
		loading_scene = false
		timer_label.text = "Failed to load level."
		
func _on_next_level_button_pressed() -> void:
	if loading_scene:
		return

	var error := ResourceLoader.load_threaded_request(next_scene_path)

	if error == OK:
		loading_scene = true
		timer_label.text = "Loading... 0%"
	else:
		timer_label.text = "Could not start loading."
