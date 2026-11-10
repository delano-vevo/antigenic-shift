extends Control
## Handles the UI scene triggered on a game over state

## Handle button press on "Continue?" button
func _on_continue_button_pressed() -> void:
	get_tree().reload_current_scene()
