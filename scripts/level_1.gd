extends Node2D

@export var enemy_scene: PackedScene
@onready var enemy_path: Path2D = $EnemyPath
@onready var timer_label: Label = $CanvasLayer/TimerLabel
@onready var build_button: Button = $CanvasLayer/BuildButton
@onready var spawn_timer: Timer = $SpawnTimer
@onready var health_label: Label = $CanvasLayer/HealthLabel
@onready var buildable_area: TileMapLayer = $BuildableArea


const boss_scene = preload("res://scenes/boss.tscn")
const turret_scene = preload("res://scenes/turret.tscn")
const core_scene = preload("res://scenes/core.tscn")
var next_scene_path := "res://scenes/level_2.tscn"

var elapsed_time = 0
var loading_scene := false
var points = 50
var placing_turret: bool = false
var occupied_cells: Array[Vector2i] = []
var core

const SAVE_PATH = "user://savegame.save"
var spawn_increased = false

var surprise = false

func load_core():
	core = core_scene.instantiate()
	core.position = Vector2(140.0,70.0)
	core.health = 15.0
	get_tree().current_scene.add_child(core)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	build_button.pressed.connect(_on_build_button_pressed)
	load_core()
	buildable_area.visible = false
	
	


func _on_spawn_timer_timeout() -> void:
	spawn_enemies()

# OS CONCEPT: Processes and programs. Enemy scenes are instantiated at runtime.
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
	
	
	


# OS CONCEPT: CPU scheduling. Time-based game logic runs every frame using delta.
func _process(delta: float) -> void:
	health_label.text = "Health: %d" % int(core.health)
	elapsed_time += delta
	timer_label.text = "Time: %d" % int(elapsed_time)
	
	if elapsed_time >= 15 and not spawn_increased:
		spawn_increased = true
		GameManager.set_spawn_speed(spawn_timer, 1.5)
		
	if elapsed_time >= 35 and not surprise:
		spawn_timer.stop()
		
	if elapsed_time >= 40 and not surprise:
		surprise = true
		spawn_timer.stop()
		spawn_enemies(true)
		
	if elapsed_time >= 58:
		get_tree().change_scene_to_file("res://scenes/End.tscn")

func _on_turret_died(cell: Vector2i) -> void:
	occupied_cells.erase(cell)

func _on_build_button_pressed() -> void:
	if not placing_turret:
		placing_turret = true
		
	else:
		placing_turret = not placing_turret
	buildable_area.visible = placing_turret
	
func build_turret(position: Vector2,cell: Vector2i ) -> void:
	var turret := turret_scene.instantiate()
	if core.health - turret.cost <= 0:
		return
	turret.global_position = position
	core.health -= turret.cost
	add_child(turret)
	turret.turret_died.connect(_on_turret_died.bind(cell))
	
	

# OS CONCEPT: I/O management. Mouse input is handled when the event occurs.
func _unhandled_input(event: InputEvent) -> void:
	if not placing_turret:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:

			var mouse_pos = get_global_mouse_position()

			
			var cell = $BuildableArea.local_to_map(
				$BuildableArea.to_local(mouse_pos)
			)
			
			if $BuildableArea.get_cell_source_id(cell) != -1:
				# Check if a turret already exists here
				if cell in occupied_cells:
					return

			# Check if this cell has a tile
			if $BuildableArea.get_cell_source_id(cell) != -1:
				var grid_pos = $BuildableArea.map_to_local(cell)
				build_turret($BuildableArea.to_global(grid_pos),cell)
				occupied_cells.append(cell)
