extends Node2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	audio_stream_player_2d.stream = load("res://Assets/SFX/Retro Swooosh 07 copy.wav")
	audio_stream_player_2d.play()

func _on_timed_pressed() -> void:
	Global.game_mode = "timed"
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_endless_pressed() -> void:
	Global.game_mode = "endless"
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
