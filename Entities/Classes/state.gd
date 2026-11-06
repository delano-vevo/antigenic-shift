class_name State
extends Node

## Game loop - internal non-engine methods, called instead
## by the StateMachine that controls these States
func process(delta: float, parent: Entity) -> State:
	return null
func physics_process(delta: float, parent: Entity) -> State:
	return null

## State transition functions
func state_entered(parent: Entity) -> void:
	pass
func state_exited(parent: Entity) -> void:
	pass

## Checks whether this state is the current state in the StateMachine
func is_current_state() -> bool:
	if (get_parent().current_state == self):
		return true
	else:
		return false
