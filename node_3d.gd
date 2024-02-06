extends Node3D

@onready var player := $Player

func _ready() -> void:
	$Environment/TunnelBlock.visible = false
	$Environment/TunnelBlock.use_collision = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	$Environment/Triggers/FirstRightCorner/TunnelBlockade.visible = false
	$Environment/Triggers/FirstRightCorner/TunnelBlockade.use_collision = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$UI/ProgressBar.value = player.current_stamina
	
	# Exit
	if Input.is_action_just_pressed("quit"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.is_action_just_pressed("fullscreen") and get_window().mode != Window.MODE_EXCLUSIVE_FULLSCREEN:
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN
	elif Input.is_action_just_pressed("fullscreen"):
		get_window().mode = Window.MODE_WINDOWED
	
	if Input.is_action_just_pressed("mouse_left_debug"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_area_3d_body_entered(body: Node3D) -> void:
	$Environment/TunnelBlock.visible = true
	$Environment/TunnelBlock.use_collision = true
	$Environment/Light/Lamp/AudioStreamPlayer3D.playing = false


func _on_starter_room_table_area_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		$UI/StartRoomLetter.visible = true


func _on_starter_room_table_area_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		$UI/StartRoomLetter.visible = false


func _on_first_right_corner_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		$Environment/Triggers/FirstRightCorner/TunnelBlockade.visible = true
		$Environment/Triggers/FirstRightCorner/TunnelBlockade.use_collision = true
		$Environment/Triggers/FirstRightCorner/TunnelBlockade2.visible = false
		$Environment/Triggers/FirstRightCorner/TunnelBlockade2.use_collision = false
