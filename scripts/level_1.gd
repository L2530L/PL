extends Node2D

@export var enemy_scene: PackedScene
@onready var enemy_path: Path2D = $EnemyPath
@onready var timer_label: Label = $CanvasLayer/TimerLabel
@onready var build_button: Button = $CanvasLayer/BuildButton
@onready var spawn_timer: Timer = $SpawnTimer
@onready var health_label: Label = $CanvasLayer/HealthLabel

const boss_scene = preload("res://scenes/boss.tscn")
const turret_scene = preload("res://scenes/turret.tscn")
const core_scene = preload("res://scenes/core.tscn")
var next_scene_path := "res://scenes/level_2.tscn"

var elapsed_time = 0
var loading_scene := false
var points = 50
var placing_turret: bool = false
var core

const SAVE_PATH = "user://savegame.save"
var spawn_increased = false

var surprise = false

func load_core():
	core = core_scene.instantiate()
	core.position = Vector2(133.0,67.0)
	core.health = 15.0
	get_tree().current_scene.add_child(core)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	build_button.pressed.connect(_on_build_button_pressed)
	load_core()


func _on_spawn_timer_timeout() -> void:
	spawn_enemies()

func spawn_enemies(strong: bool = false) -> void:
	var path_follow := PathFollow2D.new()
	path_follow.loop = false
	path_follow.rotates = false
	enemy_path.add_child(path_follow)
	var enemy
	if strong:
		enemy = boss_scene.instantiate()
		enemy.position = Vector2(0,-14)
	else:
		enemy = enemy_scene.instantiate()
		enemy.position = Vector2.ZERO
	path_follow.add_child(enemy)
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	health_label.text = "Health: %d" % int(core.health)
	elapsed_time += delta
	timer_label.text = "Time: %d" % int(elapsed_time)
	
	if elapsed_time >= 15 and elapsed_time <= 35 and not spawn_increased:
		spawn_increased = true
		GameManager.set_spawn_speed(spawn_timer, 1.45)
		
	if elapsed_time >= 35 and not surprise:
		surprise = true
		spawn_timer.stop()
		spawn_enemies(true)


func _on_build_button_pressed() -> void:
	if not placing_turret:
		placing_turret = true
	else:
		placing_turret = not placing_turret
	
func build_turret(position: Vector2) -> void:
	var turret := turret_scene.instantiate()
	if core.health - turret.cost <= 0:
		return
	turret.global_position = position
	core.health -= turret.cost
	add_child(turret)
	

func _unhandled_input(event: InputEvent) -> void:
	if not placing_turret:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			build_turret(get_global_mouse_position())
