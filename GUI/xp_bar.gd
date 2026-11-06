extends Control

@export var progress_bar: TextureProgressBar ## The ProgressBar that displays the XP progress to the next level

## Sets the XP bar to indicate the current amount of XP, as a percentage of the
## XP requirement for the next level
func set_xp_amount(amount: float, next_level: float) -> void:
	progress_bar.value = (amount/next_level) * 100 # Multiply to percentage
