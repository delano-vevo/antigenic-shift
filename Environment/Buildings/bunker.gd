extends EnvironmentObject
## Defines the game logic for the Bunker, the player's base of operations where they
## spawn in each morning and must return to each night to analyze the day's samples

## Editor nodes
@export var animation_player: AnimationPlayer ## The AnimationPlayer node responsible for animating the door

## Gameplay variables
@onready var open: bool = false ## Whether the door is open

## Detect player entering the bunker by determining whether a body_entered is of type Player
func _on_enter_area_body_entered(body: Node2D) -> void:
	# TODO: make it so only the Scientist can walk in so that the sled doesn't accidentally
	# trigger the Area2D collision and make the transition animation play weird?
	# TODO: whatever animation controller is moving the players should just wait to give control
	# back to the player input until the door close animation is finished playing to be safe
	# Play can only re-enter the bunker if the day is over; usually the closed state will handle
	# this but we don't want the player instantly going back inside before the door closes
	if (body is Player and open and get_tree().get_current_scene().is_day_over()):
		print("Entering the bunker!")
		# TODO: play an animation here before calling the end_day() method to abruptly pull up the UI
		get_tree().get_current_scene().end_day()

## Toggle whether the bunker is opened or closed
func toggle_open() -> void:
	# TODO: defer bool toggle to animation end to avoid weirdness?
	if (open):
		open = false
		animation_player.play("close_door")
	else:
		open = true
		animation_player.play("open_door")
