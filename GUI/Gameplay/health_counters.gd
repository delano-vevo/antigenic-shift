extends Control

@export var gunner_counter: TextureProgressBar ## The progress bar used to show the gunner's current HP
@export var scientist_counter: TextureProgressBar ## The progress bar used to show the scientist's current HP

## Takes pointers to the two Player characters and updates the HP value
## in the UI based on their internal HP values
func update_counters(scientist: Player, gunner: Player) -> void:
	# Bars go from 0-100 for easy data manipulation for percentages
	gunner_counter.value = (gunner.hp/gunner.max_hp) * 100
	scientist_counter.value = (scientist.hp/scientist.max_hp) * 100
