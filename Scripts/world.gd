extends Node2D
var icons := [preload("res://Assets/Icons/Alien_80.png"), preload("res://Assets/Icons/Alien_black_80-export.png"), preload("res://Assets/Icons/Cactus_80.png"), preload("res://Assets/Icons/Fleeb_80.png"), preload("res://Assets/Icons/Fleeb_blue_80-export.png"), preload("res://Assets/Icons/Fleeb_red_80-export.png"), preload("res://Assets/Icons/Fleeb_white_80.png"), preload("res://Assets/Icons/Saw_80.png")]
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var points: Label = $Points
@onready var time: Label = $Time
@onready var exit: Button = $Exit
@onready var game_over_ui: Control = $GameOverUI
@onready var game_over_points: Label = $GameOverUI/GameOverPoints

var flip_counter := 0
var flipped_cards := []
var matches := 0
var points_counter := 0
var can_flip := true
var first_click = false
var cards := []

func _ready() -> void:
	audio_stream_player_2d.stream = load("res://Assets/SFX/Retro Swooosh 07 copy.wav")
	audio_stream_player_2d.play()
	cards = get_tree().get_nodes_in_group("Card")
	shuffle_cards()
	set_game_mode()

func _process(delta: float) -> void:
	update_labels()
	handle_flips()
	#When we get all matches we restart the game
	if ((matches > 1) and (matches % 8 == 0)):
		reshufle()

func handle_flips():
	if flipped_cards.size() == 2:
		can_flip = false
		if flipped_cards[0].icon == flipped_cards[1].icon:
			matching(flipped_cards)
		else:
			reset_cards(flipped_cards)
		flip_counter = 1
		flipped_cards = []

func _on_button_pressed(button: BaseButton):
	if first_click: 
		first_click = false
		time.get_node("Timer").start()
	if can_flip:
		flip_counter += 1
		#On the third card we flip we check if the previous match, if not whe reset them along with our tracking variables
		#Prevents from pressing the same button twice
		if !flipped_cards.has(button):
			show_icon(button)
		else:
			flip_counter -= 1

func reset_cards(cards_to_reset):
	await get_tree().create_timer(0.5).timeout
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(cards_to_reset[0].get_node("Sprite2D"),"scale", Vector2(3.5,3.5),0.2)
	tween.tween_property(cards_to_reset[1].get_node("Sprite2D"),"scale", Vector2(3.5,3.5),0.2)
	can_flip = true
	audio_stream_player_2d.stream = load("res://Assets/SFX/Retro Jump Classic 08 copy.wav")
	audio_stream_player_2d.play()

func show_icon(pressed_button):
	flipped_cards.append(pressed_button)
	var tween = create_tween()
	tween.tween_property(pressed_button.get_node("Sprite2D"),"scale", Vector2(0,0),0.2)
	audio_stream_player_2d.stream = load("res://Assets/SFX/Retro Jump Simple C2 02.wav")
	audio_stream_player_2d.play()

func matching(cards_matching):
	matches += 1
	points_counter += 1
	cards_matching[0].disabled= true
	cards_matching[1].disabled= true
	can_flip = true
	audio_stream_player_2d.stream = load("res://Assets/SFX/Retro Event Acute 11 copy.wav")
	audio_stream_player_2d.play()

func shuffle_cards():
	#We get all cards, shuffle them and assign a random icon
	cards.shuffle()
	#We use these to keep track of which item to assign since we assign only 2 of each
	var pair_tracker := 0
	var icon_index := 0
	for card in cards:
		if pair_tracker == 2:
			pair_tracker = 0
			icon_index += 1
		pair_tracker += 1
		if icons[icon_index]:
			card.icon = icons[icon_index]
		card.pressed.connect(_on_button_pressed.bind(card))

func set_game_mode():
	if Global.game_mode == "endless":
		time.queue_free()
	else:
		first_click = true
		exit.queue_free()

func update_labels():
	if (time and !first_click):
		time.text = "TIME: " + str(int(time.get_node("Timer").time_left))
	points.text = "POINTS: " + str(points_counter)

func reshufle():
	matches = 0
	for card in cards:
		card.disabled= false
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(card.get_node("Sprite2D"),"scale", Vector2(3.5,3.5),0.2)
	await get_tree().create_timer(0.2).timeout
	audio_stream_player_2d.stream = load("res://Assets/SFX/Retro Swooosh 07 copy.wav")
	audio_stream_player_2d.play()
	shuffle_cards()

func _on_timer_timeout() -> void:
	for card in cards:
		card.disabled= true
	if points_counter > Global.highscore:
		Global.highscore = points_counter
		game_over_points.text = "NEW HIGHSCORE: " + str(points_counter)
	else:
		game_over_points.text = "SCORE: " + str(points_counter)
	print(Global.highscore)
	game_over_ui.show()
#Definately adding sounds, leaderboard

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_play_again_pressed() -> void:
	get_tree().reload_current_scene()
