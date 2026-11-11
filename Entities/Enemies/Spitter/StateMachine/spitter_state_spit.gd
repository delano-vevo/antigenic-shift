extends State

@export var timeout: Timer
@export var chase_state: State

func state_entered(parent: Entity) -> void:
	# Play the spit animation
	parent.animation_tree.set("parameters/Spit_OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	# Spawn the projectile
	parent.spit_projectile()
	# Set the timeout interval
	timeout.start()

func process(delta: float, parent: Entity) -> State:
	if (timeout.is_stopped()):
		return chase_state
	else:
		return null
