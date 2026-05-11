extends Camera3D

# propertys
@export var point_scene: PackedScene
@export var phantom_scene: PackedScene
@export var point_parent: Node

# vars
var phantom = null
var can_place = false
var ray_collider = null
var snapped_pos = Vector3(0, 0, 0)

func _ready() -> void:
	disable_placement()

func _process(_delta: float) -> void:
	if phantom == null or !phantom.is_inside_tree():
		return
	var mouse_position = get_viewport().get_mouse_position()
	var from = project_ray_origin(mouse_position)
	var to = from + project_ray_normal(mouse_position) * 1000

	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)

	if result:
		ray_collider = result.collider
		snapped_pos = result.position.snapped(Vector3(0.1, 0.1, 0.1))
		phantom.global_position = snapped_pos
		can_place = true
	else:
		ray_collider = null
		can_place = false
	
	if ray_collider and ray_collider.is_in_group("field"):
		if Input.is_action_pressed("PlacePoint") and can_place:
			var point = point_scene.instantiate()
			point_parent.add_child(point)
			point.global_position = snapped_pos


# helpers
func enable_placement():
	print("started placement")
	phantom = phantom_scene.instantiate()
	get_parent().add_child.call_deferred(phantom)
	process_mode = Node.PROCESS_MODE_INHERIT

func disable_placement():
	if phantom != null:
		print("ended placement")
		get_parent().remove_child.call_deferred(phantom)
	process_mode = Node.PROCESS_MODE_DISABLED