extends CharacterBody3D

const SPEED = 5.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var camera_origin = $CameraOrigin
@onready var back_camera = $CameraOrigin/SpringArm3D/CameraBehind
var sens = 0.5

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if back_camera.current == true:
		if event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x * sens))

func _physics_process(delta):
	if back_camera.current == true:
		var input_dir = Input.get_vector("left", "right", "front", "back")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.z = direction.x * SPEED
			velocity.x = -direction.z * SPEED
		else:
			velocity.z = move_toward(velocity.x, 0, SPEED)
			velocity.x = move_toward(-velocity.z, 0, SPEED)
		
		move_and_slide()
