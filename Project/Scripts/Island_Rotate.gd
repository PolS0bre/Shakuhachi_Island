extends Node3D

@onready var island = $"."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	island.rotate_y(.0025)
