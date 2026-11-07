extends PlayerUpgrade

@export var damage_amt: float = 1.0

func upgrade_gunshot(gunshot: Gunshot) -> void:
	gunshot.damage_amt += damage_amt
