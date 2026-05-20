extends Camera3D

# propertys
@export var point_scene: PackedScene
@export var phantom_scene: PackedScene
@export var point_parent: Node
@export var place_material: Material
@export var notplace_material: Material
@export var snap_to_grid = false

# vars
enum placementState {BUILD = 0, DESTROY = 1}
var phantom = null
var can_place = false
var ray_collider = null
var snapped_pos = Vector3(0, 0, 0)
var current_mode = placementState.BUILD

func _ready() -> void:
	disable_placement()

func _process(_delta: float) -> void:
	if phantom == null or !phantom.is_inside_tree():
		print("no phantom")
		return
	var mouse_position = get_viewport().get_mouse_position()
	var from = project_ray_origin(mouse_position)
	var to = from + project_ray_normal(mouse_position) * 1000

	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)

	if result:
		ray_collider = result.collider
		if snap_to_grid:
			snapped_pos = result.position.snapped(Vector3(0.3, 0.3, 0.3))
			phantom.global_position = snapped_pos
		else:
			phantom.global_position = result.position
	else:
		ray_collider = null
	
	if ray_collider and ray_collider.is_in_group("field"):
		phantom.material_override = place_material
		can_place = true
	else:
		phantom.material_override = notplace_material
		can_place = false
	
	if ray_collider:
		if current_mode == placementState.BUILD:
			if Input.is_action_just_pressed("PlacePoint") and can_place:
				var point = point_scene.instantiate()
				point_parent.add_child(point)
				point.global_position = phantom.global_position
		elif current_mode == placementState.DESTROY:
			if Input.is_action_pressed("PlacePoint"):
				var target = ray_collider.get_parent()
				if target and target.is_in_group("point"):
					target.queue_free()



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
