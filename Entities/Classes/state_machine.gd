class_name StateMachine
extends Node
## Implements a state machine for controlling entities with discrete states

## Tracks the current state 
@export var current_state: State
## Tracks the entity that owns this StateMachine
## MUST be assigned in the editor, or a runtime error will occur!
@export var parent: Entity

## Initialize the current state with a state_entered call
func init() -> void:
	current_state.state_entered(parent)

## Game loop - _process and _physics_process propagate down to the current state
## by calling non-engine process and physics_process functions. These functions return
## a State object, which if not null will alert the state machine to transition states
func _process(delta: float) -> void:
	var new_state = current_state.process(delta, parent)
	if (new_state != null):
		set_state(new_state)
func _physics_process(delta: float) -> void:
	var new_state = current_state.physics_process(delta, parent)
	if (new_state != null):
		set_state(new_state)

## Setter for the FSM's current state - handles state_entered and state_exited
## signaling for the previous and new current state
func set_state(new_state: State) -> void:
	current_state.state_exited(parent)
	current_state = new_state
	current_state.state_entered(parent)
