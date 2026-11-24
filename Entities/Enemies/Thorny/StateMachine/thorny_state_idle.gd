extends State

@export var state_chase: State

func state_entered(parent: Entity) -> void:
	parent.move_anim_playback.travel("Idle")

func process(_delta: float, parent: Entity) -> State:
	# Check for player in range
	if (parent.global_position.distance_to(get_tree().get_current_scene().get_nearest_player(parent.global_position).global_position) <= parent.detect_range):
		return state_chase
	# No state change encountered
	return null
