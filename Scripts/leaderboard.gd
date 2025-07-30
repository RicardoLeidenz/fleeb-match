extends Control
@onready var player_name_text: LineEdit = $HBoxContainer/Player_Name_Text
@onready var highscore_text: RichTextLabel = $HBoxContainer/Highscore
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var highscore = Global.highscore
var player_name: String

func _ready() -> void:
	audio_stream_player_2d.stream = load("res://Assets/SFX/Retro Swooosh 07 copy.wav")
	audio_stream_player_2d.play()
	if highscore_text:
		highscore_text.text += str(highscore)

func _on_line_edit_text_submitted(new_text: String) -> void:
	highscore_text.text = str(highscore)
	player_name = player_name_text.text.to_upper()
	$HBoxContainer/SubmitButton.show()

func _on_submit_button_pressed() -> void:
	if highscore > 0:
		if PlayerAccounts.is_logged_in():
			PlayerAccounts.log_out()
		await Leaderboards.post_guest_score("fleeb-match-main-rgkr",highscore,player_name)
		get_tree().reload_current_scene()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
