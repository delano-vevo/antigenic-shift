extends PlayerUpgrade

@export var amount: float = 1.0 ## The amount of extra Max HP to grant the Player

func upgrade_obtained(player: Player) -> void:
	player.max_hp += amount
	player.hp += amount # Also apply to current HP - can change this if needed
	# Emit the player's signal to update the HP UI
	player.hp_get.emit()
	print(str(player) + " : " + str(player.hp) + "/" + str(player.max_hp))
