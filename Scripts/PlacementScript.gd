extends Camera3D

# propertys
@export var point_scene: PackedScene
@export var phantom_scene: PackedScene
@export var point_parent: Node
@export var place_material: Material
@export var notplace_material: Material
@export var snap_to_grid = false
@export var rotation_amount = 45.0

# vars
enum placementState {BUILD = 0, DESTROY = 1}
var phantom = null
var can_place = false
var ray_collider = null
var snapped_pos = Vector3(0, 0, 0)
var current_mode = placementState.BUILD
var curve_path: Curve3D
var current_rotation = 0.0

func _ready() -> void:
	curve_path = Curve3D.new()
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

	if Input.is_action_just_pressed("Rotate"):
		current_rotation += rotation_amount
		phantom.rotate(Vector3.UP, current_rotation)

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
				point.global_rotation = phantom.global_rotation
				curve_path.add_point(Vector3(point.global_position.x, 0, point.global_position.z))
		elif current_mode == placementState.DESTROY:
			if Input.is_action_pressed("PlacePoint"):
				var target = ray_collider.get_parent()
				if target and target.is_in_group("point"):
					# 1. Map target position to flat Y to match how it was saved
					var target_curve_pos = Vector3(target.global_position.x, 0, target.global_position.z)
					
					# 2. Find index in Curve3D matching this position
					var index_to_remove = -1
					for i in range(curve_path.get_point_count()):
						if curve_path.get_point_position(i).is_equal_approx(target_curve_pos):
							index_to_remove = i
							break
					
					# 3. Remove from curve and delete node
					if index_to_remove != -1:
						curve_path.remove_point(index_to_remove)
						print("removing point at index: ", index_to_remove)
					
					target.queue_free() # Fixed spelling error 'qeue_free'



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

func generate_ez_template_code() -> String:
	var code := ""
	var nodes = point_parent.get_children()
	
	for i in range(1, curve_path.get_point_count()):
		var previous_point = curve_path.get_point_position(i - 1)
		var current_point = curve_path.get_point_position(i)

		var dx = current_point.x - previous_point.x
		var dy = current_point.z - previous_point.z

		var distance = sqrt(dx * dx + dy * dy)

		var point_rotation = nodes[i].global_rotation_degrees

		# Convert radians to degrees
		var angle = rad_to_deg(atan2(dy, dx))

		if !point_rotation.is_zero_approx():
			code += "chassis.pid_turn_set(" + str(snappedf(angle, 0.01)) + "_deg" + ", 90);\n"
			code += "chassis.pid_wait();\n\n"

		code += "chassis.pid_drive_set(" + str(snappedf(distance, 0.01)) + "_in" + ", 110);\n"
		code += "chassis.pid_wait();\n\n"
	print(code)

	return code


func get_current_curve() -> Curve3D:
	return curve_path
