extends CharacterBody3D

@onready var head: Node3D = $Head

var current_speed: float
const walking_speed: float = 3.0
const sprint_speed: float = 5.0

var current_stamina: float = 100.0
var max_stamina: float = 100.0
var stamina_depletion_speed: float = 27.0
var stamina_regen_speed: float = 8.0

var lerp_speed: float = 100.0

const mouse_sens: float = 0.25

var direction: Vector3 = Vector3.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))


func _physics_process(delta: float) -> void:
	# Sprinting
	if Input.is_action_pressed("sprint") and current_stamina > 0:
		current_speed = sprint_speed
		current_stamina -= stamina_depletion_speed * delta
		$AudioStreamPlayer3D.pitch_scale = 1.3
	else:
		current_speed = walking_speed
		current_stamina += stamina_regen_speed * delta
		$AudioStreamPlayer3D.pitch_scale = 1
	
	# Exit
	if Input.is_action_pressed("quit"):
		get_tree().quit()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "foward", "backward")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * lerp_speed)
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	if direction.length() > 0.8 and is_on_floor():
		if !$AudioStreamPlayer3D.playing:
			$AudioStreamPlayer3D.play()
	
	move_and_slide()
