extends Camera3D

@export var cast_range := 1000.0

func _input(event):

	if event.is_action_pressed("PlacePoint"):

		var mouse_pos = get_viewport().get_mouse_position()

		var origin = project_ray_origin(mouse_pos)
		var end = origin + project_ray_normal(mouse_pos) * cast_range

		print("Casting ray...")

		var query = PhysicsRayQueryParameters3D.create(origin, end)

		var result = get_world_3d().direct_space_state.intersect_ray(query)

		if result:

			var collider = result.collider

			# Check group
			if collider.is_in_group("field"):
				print("Hit a field object!")
			else:
				print("Hit something else:", collider.name)