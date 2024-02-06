extends Node3D

@onready var player := $Player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$UI/ProgressBar.value = player.current_stamina
