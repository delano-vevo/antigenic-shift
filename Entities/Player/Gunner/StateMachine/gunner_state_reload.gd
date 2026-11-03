extends State

## Constants
const RELOAD_END_TRIGGER: float = 0.5 ## The time, in seconds, from the end of the reload timer to trigger the reload_end animation

## State links
@export var active_state: State

## Editor nodes
@export var reload_graphic: TextureProgressBar

## Internal variables
@onready var r_end: bool = false ## Used to prevent multiple triggers of reload_end animation

func state_entered(parent: Entity) -> void:
	r_end = false
	parent.laser_line.visible = false
	parent.animation_player.play("reload_start")
	# Show the reload time graphic
	reload_graphic.value = 0
	reload_graphic.visible = true
	# Start the reload timer
	parent.reload_timer.start(parent.reload_time)

func state_exited(parent: Entity) -> void:
	# Hide the reload time graphic
	reload_graphic.visible = false

func process(delta: float, parent: Entity) -> State:
	# Apply reload progress from the timer to the indicator graphic
	reload_graphic.value = ((parent.reload_time - parent.reload_timer.time_left) / parent.reload_time) * 100 # Convert to percentage
	# Poll the parent's reload timer to see if it's done
	if (parent.reload_timer.is_stopped()):
		# Reload complete - apply to the parent
		# Handled here rather than state-exited to prevent abusing the shift mechanic
		# TODO: is this full-clip-reload thing the move? It seems like it might be a cool way to
		# add tension, but people might hate it :( playtest with this some more in the future
		if (parent.bullets >= parent.clip_size):
			parent.bullets -= parent.clip_size
			parent.clip_current = parent.clip_size
		else:
			# Load all remaining bullets
			parent.clip_current = parent.bullets
			parent.bullets = 0
		# Update the GUI in the main scene
		get_tree().get_current_scene().update_ammo_counter()
		# Return to active state
		return active_state
	else:
		# Check remaining timer duration to trigger reload_end animation
		if (parent.reload_timer.time_left <= RELOAD_END_TRIGGER and !r_end):
			parent.animation_player.play("reload_end")
			r_end = true
		# Continue reloading
		return null
