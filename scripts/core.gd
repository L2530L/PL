extends Node2D

var health: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func damaged(damage: float) -> void:
	health -= damage
	death()

func death() -> void:
	if health <= 0:
		get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_area_2d_body_entered(body: Node2D) -> void:
	damaged(body.damage) 
