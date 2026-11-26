extends CharacterBody2D

@export var speed: float = 60.0
@export var health: float = 10.0
@export var damage: float = 2.0





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# OS CONCEPT: CPU scheduling. Fixed-rate movement runs in _physics_process().
func _physics_process(delta: float) -> void:
	var path_follow := get_parent() as PathFollow2D

	if path_follow:
		path_follow.progress += speed * delta
	
	if path_follow.progress_ratio >= 1.0:
		path_follow.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if health <= 0:
		# OS CONCEPT: Memory management. Free the enemy when it is destroyed.
		get_parent().queue_free()
	
