extends Control
## Top-level parent for the Control nodes in the game's GUILayer

## Editor nodes
@export var ammo_counter: Control ## The Control node housing the ammo counter UI
@export var health_bars: Control ## The Control node housing the player's HP counters
@export var xp_bar: Control ## The Control node housing the XP bar
@export var day_remaining: Control ## The Control node housing the UI for the day length countdown
@export var day_counter: Control ## The UI element that counts the number of days passed

## PackedScene references
@export var day_end_countdown_tscn: PackedScene

## Internal variables
@onready var day_end_countdown: Control

## Called at the start of a new day to reset certain UI states
func start_new_day() -> void:
	day_remaining.visible = true

## Start the countdown to the end of the day
## Takes a reference to the countdown timer in order to pass this to the new UI scene
func start_countdown(countdown_timer: Timer) -> void:
	# Hide the usual daylight timer
	day_remaining.visible = false
	# Kickoff the countdown timer
	day_end_countdown = day_end_countdown_tscn.instantiate()
	day_end_countdown.countdown_timer = countdown_timer
	add_child(day_end_countdown)

## Stop the countdown to the end of the day - either due to a game over or successful bunker escape
func stop_countdown() -> void:
	day_end_countdown.queue_free()
	day_remaining.visible = true

## Called at the start of a day to show the current_day UI element
func start_day(current_day: int) -> void:
	day_remaining.set_day_label(current_day)
	day_counter.set_current_day(current_day)
