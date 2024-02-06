extends Node3D

@onready var player := $Player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$UI/ProgressBar.value = player.current_stamina
	
	# Exit
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("fullscreen"):
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		body.position += Vector3(53, 0, -7)
