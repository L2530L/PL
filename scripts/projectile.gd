extends Node2D

var damage
var speed: float = 400.0
var target:Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	position += target * speed * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.health -= damage
	queue_free()
