extends Control

# the ui script
@export var placmentScriptObject: Node
var isEnabled = false


func _on_point_button_pressed():
	if isEnabled == false:
		placmentScriptObject.process_mode = Node.PROCESS_MODE_INHERIT
		print("started placement")
		isEnabled = true;
	elif isEnabled == true:
		placmentScriptObject.process_mode = Node.PROCESS_MODE_DISABLED
		print("ended placement")
		isEnabled = false
