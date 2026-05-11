extends Control

# the ui script
@export var placmentScriptObject: Node
var isEnabled = false



func _on_point_button_pressed():
	if isEnabled == false:
		placmentScriptObject.enable_placement()
		isEnabled = true
	elif isEnabled == true:
		placmentScriptObject.disable_placement()
		isEnabled = false

func _on_place_button_pressed():
	if isEnabled == true:
		placmentScriptObject.current_mode = placmentScriptObject.placementState.BUILD

func _on_remove_button_pressed():
	if isEnabled == true:
		placmentScriptObject.current_mode = placmentScriptObject.placementState.DESTROY