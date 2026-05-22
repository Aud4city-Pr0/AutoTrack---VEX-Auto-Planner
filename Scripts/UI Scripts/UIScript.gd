extends Control

# the ui script
@export var placmentScriptObject: Node
var isEnabled = false
@export var placeBtn: Button
@export var removeBtn: Button
@export var genBtn: Button
@export var path: Path3D


func _on_point_button_pressed():
	if isEnabled == false:
		placmentScriptObject.enable_placement()
		isEnabled = true
		placeBtn.show()
		removeBtn.show()
		genBtn.show()
	elif isEnabled == true:
		placmentScriptObject.disable_placement()
		isEnabled = false
		placeBtn.hide()
		removeBtn.hide()
		genBtn.hide()

func _on_place_button_pressed():
	if isEnabled == true:
		placmentScriptObject.current_mode = placmentScriptObject.placementState.BUILD

func _on_remove_button_pressed():
	if isEnabled == true:
		placmentScriptObject.current_mode = placmentScriptObject.placementState.DESTROY


func _on_gen_button_pressed():
	var created_curve = placmentScriptObject.get_current_curve()
	if created_curve:
		print("setting curve")
		path.curve = created_curve
