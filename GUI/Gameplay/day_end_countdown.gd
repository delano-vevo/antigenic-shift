extends Control
## Handles the UI for the final countdown to get back to the bunker at the end of a day

## Editor nodes
@export var countdown_label: Label ## The Label that displays the remaining time
@export var bg_texture: TextureRect ## The background texture behind the countdown
@export var animate_texture: AnimationPlayer ## The animator for the background texture

## Internal variables
@onready var countdown_timer: Timer ## A reference to the Timer elsewhere in the scene tree controlling the countdown

## Initialize
func _ready() -> void:
	animate_texture.play("animate_bar")

## Game loop
func _process(delta: float) -> void:
	# Set the time remaining UI manually by polling the provided timer reference every frame
	if (countdown_timer != null):
		set_time_remaining(countdown_timer.time_left)
	else:
		print("Critical error! Timer reference missing in instantiated Countdown UI!")

## Set the text UI for the remaining time countdown
func set_time_remaining(time: float) -> void:
	# Format to 4 decimal points
	countdown_label.set_text(str("%.4f" % time))
