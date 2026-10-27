extends Node2D

@export var enemy_scene: PackedScene
@onready var enemy_path: Path2D = $EnemyPath
@onready var timer_label: Label = $CanvasLayer/TimerLabel
@onready var build_button: Button = $CanvasLayer/BuildButton

const turret_scene = preload("res://scenes/turret.tscn")

var elapsed_time = 0
var loading_scene := false
var next_scene_path := "res://scenes/level_2.tscn"
var points = 50
var placing_turret: bool = false


const SAVE_PATH = "user://savegame.save"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	build_button.pressed.connect(_on_build_button_pressed)
	load_time()


func _on_spawn_timer_timeout() -> void:
	spawn_enemies()

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
	elapsed_time += delta
	timer_label.text = "Time: %d" % int(elapsed_time)


func _on_build_button_pressed() -> void:
	if not placing_turret:
		placing_turret = true
	else:
		placing_turret = not placing_turret
	
func build_turret(position: Vector2) -> void:
	var turret := turret_scene.instantiate()
	turret.global_position = position
	
	add_child(turret)
	

func _unhandled_input(event: InputEvent) -> void:
	if not placing_turret:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			build_turret(get_global_mouse_position())



func save_time() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_32(elapsed_time)
		file.close()
		print("Time saved: ", elapsed_time)
	else:
		print("Failed to save score.")

func load_time() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			elapsed_time = file.get_32()
			file.close()
			print("Time loaded: ", elapsed_time)
	else:
		print("No save file found. Starting with score 0.")


func _on_save_timer_timeout() -> void:
	save_time()
