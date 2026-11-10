extends Control
## UI element that displays the number of the current day at the beginning of each day

@export var day_count_label: Label ## The Label responsible for displaying the current day count
@export var show_timer: Timer ## The Timer that determines how long this UI element is visible

## Update the day_count_label text to indicate the current day
func set_current_day(current_day: int) -> void:
	visible = true
	day_count_label.set_text("DAY " + str(current_day))
	show_timer.start()

## Fade out the graphic when the timer times out
func _on_timer_timeout() -> void:
	# TODO: use tweens or some shit to make this a cooler effect
	visible = false
