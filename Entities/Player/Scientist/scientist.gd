extends Player
## This script is responsible for the top-level Entity code for the Scientist
## half of the player's controllable entities

## Editor nodes
@export var rope_connector: Node2D ## A Node2D used as the anchor point for the sled rope on the scientist

## Editor variables
@export var move_speed: float = 200.0 ## Player's movement speed

## Internal variables
## The Playback node responsible for the Movement state machine in the animation BlendTree
@onready var move_anim_playback: AnimationNodeStateMachinePlayback

## Initialize
func _ready() -> void:
	# Grab the animation playback node
	move_anim_playback = animation_tree.get("parameters/MoveStateMachine/playback")
	# Call generic entity init
	super()
