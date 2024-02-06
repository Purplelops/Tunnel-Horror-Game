extends CharacterBody3D

signal died

@onready var head: Node3D = $Head
@onready var walk_audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var ray: RayCast3D = $RayCast3D

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
	if Input.is_action_pressed("sprint") and current_stamina > 0 and not ray.is_colliding():
		current_speed = sprint_speed
		current_stamina -= stamina_depletion_speed * delta
		walk_audio_player.pitch_scale = 1.3
	else:
		current_speed = walking_speed
		if current_stamina <= 100: current_stamina += stamina_regen_speed * delta
		walk_audio_player.pitch_scale = 0.9
	
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
	
	# Walking sound
	if direction.length() > 0.8 and is_on_floor() and not ray.is_colliding():
		if !walk_audio_player.playing:
			walk_audio_player.play()
	
	move_and_slide()
