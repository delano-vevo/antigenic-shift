class_name Player
extends Entity
## Defines the base-level functionality for a Player type Entity, containing
## common code for the player controllers for both the Scientist and the Gunner

## Signals
signal hp_get
signal xp_get(amount: float)
signal game_over

## Gameplay variables
@onready var upgrades: Array[PlayerUpgrade] ## A list of PlayerUpgrade resources defining the upgrades on the player character

## Take in some amount of damage from an outside source and apply logic
func take_damage(amount: float) -> void:
	print(str(self) + " is taking " + str(amount) + " damage")
	hp -= amount
	hp_get.emit() # Just reusing the signal to also indicate HP loss
	print(str(self) + " hp is now " + str(hp))
	if (hp <= 0):
		print("Ouchie i dead :(")
		game_over.emit()

## Get a new upgrade
func get_upgrade(new_upgrade: PlayerUpgrade) -> void:
	upgrades.append(new_upgrade)
	new_upgrade.upgrade_obtained(self)

## Get an amount of extra HP
func get_hp(amount: float) -> void:
	hp += amount
	if (hp > max_hp):
		hp = max_hp
	hp_get.emit()

## Get an amount of XP
func get_xp(amount: float) -> void:
	xp_get.emit(amount)
