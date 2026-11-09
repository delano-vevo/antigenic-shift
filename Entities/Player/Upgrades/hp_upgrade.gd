extends PlayerUpgrade

func upgrade_obtained(player: Player) -> void:
	player.max_hp += upgrade_amount
	player.hp += upgrade_amount # Also apply to current HP - can change this if needed
	# Emit the player's signal to update the HP UI
	player.hp_get.emit()
	print(str(player) + " : " + str(player.hp) + "/" + str(player.max_hp))

func get_upgrade_string() -> String:
	return "HP increased by %.1f" % upgrade_amount
