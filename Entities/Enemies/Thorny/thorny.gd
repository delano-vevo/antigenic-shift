extends Enemy
## Implements an enemy type that pursues the player to within a fixed distance
## and then bombards them with homing thorns as an attack

## Editor nodes
@export var shot_cooldown_timer: Timer

## Gameplay variables
@export var start_shooting_distance: float # The distance at which the zombie will stop pursuing the player and begin shooting
@export var stop_shooting_distance: float # The distance at which the zombie will revert to pursuing the player

## Internal variables
@onready var move_anim_playback: AnimationNodeStateMachinePlayback

## Initialize
func _ready() -> void:
	# Activate the animation tree
	set_blend_spaces(1)
	animation_tree.active = true
	# Grab the animation playback node
	move_anim_playback = animation_tree.get("parameters/MoveStateMachine/playback")
	# Bind more specifically named start_shooting_distance to attack_range so this entity can reuse the basic state chase
	attack_range = start_shooting_distance
	# Call generic entity init
	super()

## Set the animation blend spaces based on provided axis
func set_blend_spaces(amount: int) -> void:
	# Bind values to acceptable options
	if (amount == 1 or amount == -1):
		animation_tree.set("parameters/MoveStateMachine/Move/blend_position", amount)
		animation_tree.set("parameters/MoveStateMachine/Idle/blend_position", amount)
		animation_tree.set("parameters/Death_BlendSpace/blend_position", amount)

## Called when attack state is triggered
func do_attack() -> void:
	print("Thorny attack!")
