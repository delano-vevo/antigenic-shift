class_name ViralStrain
extends Node2D
## This class implements a strain of the zombie virus, built as an aggregate
## of Traits and Behaviors. A ViralStrain will be assigned to a Zombie on spawn,
## and will dictate its stats and programming based on the contained components.
##
## Additionally, these ViralStrains can be combined in order to perform Antigenic
## Shift, which will create a new ViralStrain containing randomized elements of the
## two Strains which were combined
