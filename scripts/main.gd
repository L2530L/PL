extends Node2D

@export var enemy_scene: PackedScene
@onready var path_follow: PathFollow2D = $EnemyPath/PathFollow2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_enemies(3)



func spawn_enemies(amount: int):
	for i in range(amount):
		var enemy = enemy_scene.instantiate()
		path_follow.add_child(enemy)
			
		#enemy.position = Vector2(1000, 250 + i * 60)
		enemy.position = Vector2.ZERO



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
