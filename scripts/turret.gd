extends Node2D


const PROJECTILE_SCENE = preload("res://scenes/projectile.tscn")

@onready var timer = get_node("ShootTimer")
@onready var range_area: Area2D = $Range
var damage: float = 4.0
var cost = 3



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	$Range.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$RangeCircle.visible = Input.is_key_pressed(KEY_R)



func _on_timer_timeout() ->void:
	if not range_area.get_overlapping_bodies().is_empty():
		shoot()
		timer.start()

func _on_range_body_entered(_body: Node2D) -> void:
	if timer.is_stopped():
		shoot()
		timer.start()

func shoot() -> void:
	var enemies = range_area.get_overlapping_bodies()
	if enemies.is_empty():
		return

	var target: Node2D = enemies[0]
	var projectile = PROJECTILE_SCENE.instantiate()
	
	var spawn_pos = to_global(Vector2(19.0, 5.0))
	projectile.global_position = spawn_pos
	
	projectile.damage = damage
	projectile.target = spawn_pos.direction_to(target.global_position)
	
	get_tree().current_scene.add_child.call_deferred(projectile)

	
