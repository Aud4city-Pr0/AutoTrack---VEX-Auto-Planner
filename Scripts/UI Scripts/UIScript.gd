extends Control

# the ui script
@export var placmentScriptObject: Node
var isEnabled = false
@export var placeBtn: Button
@export var removeBtn: Button



func _on_point_button_pressed():
	if isEnabled == false:
		placmentScriptObject.enable_placement()
		isEnabled = true
		placeBtn.show()
		removeBtn.show()
	elif isEnabled == true:
		placmentScriptObject.disable_placement()
		isEnabled = false
		placeBtn.hide()
		removeBtn.hide()

func _on_place_button_pressed():
	if isEnabled == true:
		placmentScriptObject.current_mode = placmentScriptObject.placementState.BUILD

func _on_remove_button_pressed():
	if isEnabled == true:
		placmentScriptObject.current_mode = placmentScriptObject.placementState.DESTROY
