extends Control

# the ui script
@export var placmentScriptObject: Node
var isEnabled = false
@export var placeBtn: Button
@export var removeBtn: Button
@export var genBtn: Button
@export var path: Path3D
@export var robot_model: Node3D
@export var robot_path: PathFollow3D
@export var build_container: VBoxContainer
@export var code_display: CodeEdit
@export var position_list: Array[Node3D]
var current_position = 0

var finished_code: String = ""

func _on_point_button_pressed():
	if isEnabled == false:
		placmentScriptObject.enable_placement()
		isEnabled = true
		_set_child_visiblity(true)
	elif isEnabled == true:
		placmentScriptObject.disable_placement()
		isEnabled = false
		_set_child_visiblity(false)

func _on_place_button_pressed():
	if isEnabled == true:
		placmentScriptObject.current_mode = placmentScriptObject.placementState.BUILD

func _on_remove_button_pressed():
	if isEnabled == true:
		placmentScriptObject.current_mode = placmentScriptObject.placementState.DESTROY


func _on_gen_button_pressed():
	var created_curve = placmentScriptObject.get_current_curve()
	if created_curve and created_curve.get_baked_length() >= 1.0:
		print("setting curve")
		path.curve = created_curve
		robot_model.visible = true
		robot_path.process_mode = Node.PROCESS_MODE_INHERIT
		finished_code = placmentScriptObject.generate_ez_template_code()
		code_display.text = finished_code
	else:
		print("You need at least one point to create a route!")

func _on_snap_enabled(snap_status):
	print(snap_status)
	placmentScriptObject.snap_to_grid = snap_status



func _set_child_visiblity(status: bool):
	for child in build_container.get_children():
		if status == true and child.is_in_group("build controlls"):
			child.show()
		elif status == false and child.is_in_group("build controlls"):
			child.hide()


func _on_cam_position_button_pressed() -> void:
	# the camera button code
	current_position += 1
	# checking if postion is greater than the size of the array
	if current_position >= position_list.size():
		print("reseting back to zero")
		current_position = 0
	print("Current position is: " + str(current_position))
	placmentScriptObject.global_position = position_list[current_position].global_position
	placmentScriptObject.global_rotation = position_list[current_position].global_rotation
