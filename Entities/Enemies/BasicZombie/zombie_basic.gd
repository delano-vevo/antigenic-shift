extends Enemy

## Internal variables
## The Playback node responsible for the Movement state machine in the animation BlendTree
@onready var move_anim_playback: AnimationNodeStateMachinePlayback

## Editor nodes
@export var bite_fx: PackedScene

## Gameplay variables
@export var charge_speed: float = 100.0 ## Speed at which the zombie charges down the player when attacking
@onready var bite_player: Entity ## Tracks the last bitten player in the Area2D signal function in the Charge state

## Initialize
func _ready() -> void:
	# Activate the animation tree
	animation_tree.active = true
	# Grab the animation playback node
	move_anim_playback = animation_tree.get("parameters/MoveStateMachine/playback")
	# Call generic entity init
	super()

## Detect player in BiteArea
func _on_bite_area_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player") and state_machine.charge_state.is_current_state()):
		bite_player = body
		state_machine.set_state(state_machine.bite_state)

## Update all BlendSpaces in the AnimationTree
func set_blend_spaces(amount: int) -> void:
	# Bind values to acceptable options
	if (amount == 1 or amount == -1):
		animation_tree.set("parameters/MoveStateMachine/Move/blend_position", amount)
		animation_tree.set("parameters/MoveStateMachine/Idle/blend_position", amount)
		animation_tree.set("parameters/Bite_BlendSpace/blend_position", amount)
