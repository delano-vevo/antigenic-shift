extends Control
## Handles the UI for displaying the remaining time in a given day cycle in the game

## Editor nodes
@export var time_remaining_label: Label ## The GUI Label for displaying remaining time

## Sets the text in the time_remaining_label by taking the remaining time in seconds
func update_countdown(time_left: float) -> void:
	var minutes_left: int = floor(time_left / 60)
	var seconds_left: int = int(floor(time_left)) % 60
	time_remaining_label.set_text(str(minutes_left) + ":" + str(seconds_left))
