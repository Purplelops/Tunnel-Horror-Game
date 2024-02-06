extends Node3D


func _on_audio_stream_player_3d_finished() -> void:
	$AudioStreamPlayer3D.play()
