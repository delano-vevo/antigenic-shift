class_name Player
extends Entity
## Defines the base-level functionality for a Player type Entity, containing
## common code for the player controllers for both the Scientist and the Gunner

## Take in some amount of damage from an outside source and apply logic
func take_damage(amount: float) -> void:
	print(str(self) + " is taking " + str(amount) + " damage")
	hp -= amount
	print(str(self) + " hp is now " + str(hp))
	if (hp <= 0):
		print("Ouchie i dead :(")
