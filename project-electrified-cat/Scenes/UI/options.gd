extends Node2D

var button_type = null

func _ready():
	# Play fadeout animation 
	$fade_transition/AnimationPlayer.play("fade_in")


# Return to main menu press
func _on_main_menu_pressed() -> void:
	# Change button type to "start", then fade
	button_type = "main menu"
	$fade_transition.show()
	$fade_transition/fade_timer.start()
	$fade_transition/AnimationPlayer.play("fade_out")
	
	
	# Fade timer start and scene transition
func _on_fade_timer_timeout() -> void:
	# If button was start
	if button_type == "main menu" :
		# Change scene to "main menu" scene
		get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
	# If button was options	
	elif button_type == "options" :
		# Change scene to "options" scene
		get_tree().change_scene_to_file("res://Scenes/UI/options.tscn")
