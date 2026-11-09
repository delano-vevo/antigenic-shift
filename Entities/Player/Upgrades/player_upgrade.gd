class_name PlayerUpgrade
extends Resource
## Defines an abstract template for an upgrade that can be applied to the player as a
## reward for completing a tier of research by collecting ViralSample pickup types

## Properties
var upgrade_type: Enum.PlayerUpgradeTypes ## Tracks the type of upgrade; useful for routing in PlayerController
var upgrade_amount: float ## The amount by which the relevant stat will be augmented

## Called once when this Upgrade is added to a Player object
## Useful for flat stat upgrades like HP, max ammo, damage reduction, etc.
func upgrade_obtained(player: Player) -> void:
	pass

## Apply upgrades to a Gunshot object fired by the gunner
func upgrade_gunshot(gunshot: Gunshot) -> void:
	pass

## Gets a description of the Upgrade as a string - useful for UI elements
func get_upgrade_string() -> String:
	return "The default Upgrade description - you should not be able to see this!"
