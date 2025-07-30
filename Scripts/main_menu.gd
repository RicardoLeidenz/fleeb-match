extends Node2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	audio_stream_player_2d.stream = load("res://Assets/SFX/Retro Swooosh 07 copy.wav")
	audio_stream_player_2d.play()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game_mode_menu.tscn")


func _on_leaderboard_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Leaderboard.tscn")
