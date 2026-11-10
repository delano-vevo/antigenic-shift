extends Node2D
## Controls the day/night system that dictates the flow of the game

## Signals
signal game_over
signal countdown_begin

## Editor nodes
@export var day_length_timer: Timer ## The timer that defines the length of a standard day period in the game
@export var day_countdown_timer: Timer ## The timer that defines the countdown period for the player to get TF home to the bunker

## Gameplay variables
@export var day_length: float = 180.0 ## The length of the regular Day period in game
@export var countdown_length: float = 60.0 ## The length of the countdown period at the end of the day

## Called to start a day cycle in the game
func start_day() -> void:
	day_countdown_timer.stop()
	day_length_timer.stop()
	day_length_timer.start(day_length)

## When the day_length_timer times out, trigger the frantic "get-the-fuck-home" period of gameplay
func _on_day_length_timer_timeout() -> void:
	day_countdown_timer.start(countdown_length)
	countdown_begin.emit()

## If this node is still active when the day ends, trigger a game over state
func _on_day_end_countdown_timeout() -> void:
	game_over.emit()
