extends Control
## Handles the UI elements on the end-of-day screen, including level-up choices,
## text elements, the cure progress bar, notifications for the titular Shift, etc.

## On tree entered
func _ready() -> void:
	# TODO: update the cursor for interfacing with the levelup UI
	pass

## Custom initializer - takes input from Main.tscn to set up the UI correctly on day end
func init(level_up: bool) -> void:
	if (level_up):
		print("Leveling up! Woo, alright!")
	else:
		print("Bummer! no level up tonight :(")
