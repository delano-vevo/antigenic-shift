extends Control
## Implements an ammo counter GUI element
## For now, just uses a very simple Label node to display for prototyping purposes

## Editor nodes
@export var amt_label: Label

## Gameplay variables
## Track the ammo amounts internally when updated via mutator methods below
@onready var ammo_clip: int = 0
@onready var ammo_total: int = 0

## Set the amount of ammo in the current clip in the GUI element
func set_ammo_clip(amount: int) -> void:
	ammo_clip = amount
	amt_label.set_text(str(ammo_clip) + "/" + str(ammo_total))

## Set the amount of TOTAL ammo owned by the player in the GUI element
func set_ammo_total(amount: int) -> void:
	ammo_total = amount
	amt_label.set_text(str(ammo_clip) + "/" + str(ammo_total))
