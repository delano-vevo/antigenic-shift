extends State
## A State for Zombies that makes them Charge towards the nearest player;
## implemented as a child of BasicAttack for overriding zombie state machine functionality
## with bespoke behaviors

## State links
@export var bite_state: State
@export var chase_state: State

## Editor nodes
@export var timeout: Timer

## Gameplay variables
@onready var charge_dir: Vector2

func state_entered(parent: Entity) -> void:
	# Lock in the target position for the charge once on state entered
	# to allow the player to maneuver and dodge the attack as needed
	var target = get_tree().get_current_scene().get_nearest_player(parent.global_position)
	charge_dir = parent.global_position.direction_to(target.global_position)
	# Start the state timeout timer
	timeout.start()

func physics_process(delta: float, parent: Entity) -> State:
	# Poll the timer to see if it's ended
	if (timeout.is_stopped()):
		return chase_state
	# Apply movement in the player's direction
	parent.velocity = charge_dir * parent.charge_speed
	parent.move_and_slide()
	# Continue in the state
	return null
