extends Pickup

@export var amount: float = 1.0

func get_pickup(player: Player) -> void:
	player.get_hp(amount)
