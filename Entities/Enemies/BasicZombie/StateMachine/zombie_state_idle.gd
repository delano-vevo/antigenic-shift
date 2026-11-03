extends State

## State links
@export var chase_state: State

func state_entered(parent: Entity) -> void:
	print("Idling")
	parent.move_anim_playback.travel("Idle")

func process(delta: float, parent: Entity) -> State:
	# Check for a player in detection distance
	var nearest_player = get_tree().get_current_scene().get_nearest_player(parent.global_position)
	if (parent.global_position.distance_to(nearest_player.global_position) <= parent.detect_range):
		return chase_state # Player in range - give chase!
	# No player encountered - continue idling
	return null
