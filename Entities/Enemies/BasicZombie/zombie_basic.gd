extends Enemy

## Internal variables
## The Playback node responsible for the Movement state machine in the animation BlendTree
@onready var move_anim_playback: AnimationNodeStateMachinePlayback

## Initialize
func _ready() -> void:
	# Grab the animation playback node
	move_anim_playback = animation_tree.get("parameters/MoveStateMachine/playback")
	# Call generic entity init
	super()
