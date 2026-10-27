extends Node2D

@onready var timer = get_node("ShootTimer")
var damage = 50.0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() ->void:
	shoot()

func _on_range_body_entered(body: Node2D) -> void:
	timer.start()

func shoot() ->void :
	pass
