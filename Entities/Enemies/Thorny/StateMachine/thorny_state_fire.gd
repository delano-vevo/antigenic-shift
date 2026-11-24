extends State

const thorn_tscn: PackedScene = preload("res://Entities/Enemies/Thorny/Thorn.tscn")

@onready var target_player: Player

@export var idle_state: State
@export var chase_state: State

func state_entered(parent: Entity) -> void:
	# Grab a reference to the nearest player
	target_player = get_tree().get_current_scene().get_nearest_player(parent.global_position)
	# Apply animation to the parent entity
	parent.move_anim_playback.travel("Idle") # TODO: give this its own dedicated animation eventually?

func process(_delta: float, parent: Entity) -> State:
	# Check for a missing player pointer
	if (target_player == null):
		return idle_state
	# Check if the player is out of range
	if (target_player.global_position.distance_to(parent.global_position) > parent.stop_shooting_distance):
		return chase_state
	# Poll shot cooldown timer to determine whether to shoot
	if (parent.shot_cooldown_timer.is_stopped()):
		# Fire the thorn at the player
		var thorn = thorn_tscn.instantiate()
		thorn.global_position = parent.global_position
		thorn.damage_amt = parent.attack_damage
		get_tree().get_current_scene().add_child(thorn)
		# Restart the timer
		parent.shot_cooldown_timer.start()
	# No exit condition found: proceed with this state
	return null
