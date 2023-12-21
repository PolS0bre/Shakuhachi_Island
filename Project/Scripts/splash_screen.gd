extends Node3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta):
	if Input.is_action_just_pressed("Nota_Q"):
		SceneTransition.change_scene("res://Scenes/level.tscn")
