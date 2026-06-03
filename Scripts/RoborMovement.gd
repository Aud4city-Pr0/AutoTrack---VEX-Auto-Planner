extends PathFollow3D

# speed that the robot moves
@export var speed = 1.0
# disablaing script by default
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# this will move the robot from each point
	progress += speed * delta
	if progress >= get_parent().curve.get_baked_length():
		progress = 0.0
		process_mode = Node.PROCESS_MODE_DISABLED
		get_child(0).visible = false
