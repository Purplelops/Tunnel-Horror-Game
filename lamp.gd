extends Node3D


func _physics_process(delta: float) -> void:
	pass


func _on_audio_stream_player_3d_finished() -> void:
	$AudioStreamPlayer3D.play()
