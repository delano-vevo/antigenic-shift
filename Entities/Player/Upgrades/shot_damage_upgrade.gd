extends PlayerUpgrade

func upgrade_gunshot(gunshot: Gunshot) -> void:
	gunshot.damage_amt += upgrade_amount

func get_upgrade_string() -> String:
	return "Gun damage increased by %.1f" % upgrade_amount
