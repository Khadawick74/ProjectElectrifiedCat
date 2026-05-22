extends Node2D

# Code for menu script adapted from: 
# https://youtu.be/29jCe-mjyKQ

# Detect button type
var button_type = null

func _ready():
	# Play fadeout animation 
	$fade_transition/AnimationPlayer.play("fade_in")

# Start Button Press
func _on_start_pressed() -> void:
	# Change button type to "start", then fade
	button_type = "start"
	$fade_transition.show()
	$fade_transition/fade_timer.start()
	$fade_transition/AnimationPlayer.play("fade_out")

# Options Button Press
func _on_options_pressed() -> void:
	# Change button type to "options", then fade
	button_type = "options"
	$fade_transition.show()
	$fade_transition/fade_timer.start()
	$fade_transition/AnimationPlayer.play("fade_out")
	
# Quit Button Press
func _on_quit_pressed() -> void:
	# Exit the game
	get_tree().quit()


# Fade timer start and scene transition
func _on_fade_timer_timeout() -> void:
	# If button was start
	if button_type == "start" :
		# Change scene to "main", or main game scene
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
	# If button was options	
	elif button_type == "options" :
		# Change scene to "options" scene
		get_tree().change_scene_to_file("res://Scenes/UI/options.tscn")
		
		
		
		
		
