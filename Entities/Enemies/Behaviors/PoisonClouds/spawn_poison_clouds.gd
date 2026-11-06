extends Behavior

@export var poison_cloud_tscn: PackedScene

# Spawn another poison cloud
func _on_next_cloud_timer_timeout() -> void:
	# Don't execute on a dead zombie!
	if (!get_parent().state_machine.dead_state.is_current_state()):
		var cloud = poison_cloud_tscn.instantiate()
		cloud.global_position = global_position
		get_tree().get_current_scene().add_child(cloud)
