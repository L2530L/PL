extends Node2D

@onready var start_button: Button = $CanvasLayer/StartButton
@onready var loading_label: Label = $CanvasLayer/LoadingLabel

var loading_scene := false
var next_scene_path := "res://scenes/level_1.tscn"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not loading_scene:
		loading_label.visible = false
		return

	var progress: Array = []
	var status := ResourceLoader.load_threaded_get_status(
		next_scene_path, progress
	)

	if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		var percentage := 0.0
		if not progress.is_empty():
			percentage = progress[0] * 100.0
		
		
		loading_label.text = "Loading... %d%%" % int(percentage)

	elif status == ResourceLoader.THREAD_LOAD_LOADED:
		var packed_scene := ResourceLoader.load_threaded_get(next_scene_path)
		loading_scene = false
		get_tree().change_scene_to_packed(packed_scene)

	elif status == ResourceLoader.THREAD_LOAD_FAILED:
		loading_scene = false
		loading_label.text = "Failed to load level."


func _on_start_button_pressed() -> void:
	if loading_scene:
		return

	var error := ResourceLoader.load_threaded_request(next_scene_path)

	if error == OK:
		loading_scene = true
		loading_label.text = "Loading... 0%"
	else:
		loading_label.text = "Could not start loading."
