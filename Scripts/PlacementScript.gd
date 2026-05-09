extends Camera3D

# propertys
@export var point_scene: PackedScene
@export var phantom_scene: PackedScene
@export var point_parent: Node

# vars
var phantom = null
var can_place = false

func _ready() -> void:
	disable_placement()

func _process(_delta: float) -> void:
	if phantom == null or !phantom.is_inside_tree():
		return
	update_phantom_obj()

func update_phantom_obj():
	var mouse_position = get_viewport().get_mouse_position()
	var from = project_ray_origin(mouse_position)
	var to = from + project_ray_normal(mouse_position) * 1000

	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)

	if result:
		phantom.global_position = result.position
		can_place = true
	else:
		can_place = false


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = event.position
		var from = project_ray_origin(mouse_pos)
		var to = from + project_ray_normal(mouse_pos) * 1000

		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to)
		var result = space_state.intersect_ray(query)

		if result:
			var collider = result.collider
			if collider.is_in_group("field") and can_place:
				var point = point_scene.instantiate()
				point_parent.add_child(point)
				point.global_position = result.position


# helpers
func enable_placement():
	print("started placement")
	phantom = phantom_scene.instantiate()
	get_parent().add_child.call_deferred(phantom)
	process_mode = Node.PROCESS_MODE_INHERIT

func disable_placement():
	print("ended placement")
	get_parent().remove_child.call_deferred(phantom)
	process_mode = Node.PROCESS_MODE_DISABLED
