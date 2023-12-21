extends Node3D

var players_song : Array[int]
var song_lists = {
	0 : [4, 5, 3, 4, 5, 3],
	1 : [1, 5, 4, 3, 4, 3],
	2 : [5, 4, 3, 5, 4, 3],
	3 : [2, 1, 2, 1, 3, 2, 3, 2],
	4 : [2, 3, 4, 2, 3, 4],
	5 : [1, 2, 3, 3, 4],
	6 : [3, 2, 5, 3, 2, 5],
	7 : [1, 2, 1, 3, 2, 1],
	8 : [3, 1, 2, 3, 1, 2],
	9 : [4, 3, 3, 1, 4, 3, 2],
	10 : [1, 2, 5, 1, 2, 5],
	11 : [5, 3, 5, 3, 4, 5]
}

var songs_UIs = [
	load("res://Objects/Songs UI/zelda_lullaby.tscn"),
	load("res://Objects/Songs UI/minuet_of_forest.tscn"),
	load("res://Objects/Songs UI/eponas_song.tscn"),
	load("res://Objects/Songs UI/bolero_of_fire.tscn"),
	load("res://Objects/Songs UI/sarias_song.tscn"),
	load("res://Objects/Songs UI/serenade_of_water.tscn"),
	load("res://Objects/Songs UI/suns_song.tscn"),
	load("res://Objects/Songs UI/requiem_of_spirit.tscn"),
	load("res://Objects/Songs UI/song_of_time.tscn"),
	load("res://Objects/Songs UI/nocturne_of_shadow.tscn"),
	load("res://Objects/Songs UI/song_of_storms.tscn"),
	load("res://Objects/Songs UI/prelude_of_light.tscn")
]

var songs_mp3 = [
	load("res://Audio/Songs/Zelda's Lullaby.mp3"),
	load("res://Audio/Songs/Minuet of Forest.mp3"),
	load("res://Audio/Songs/Epona's Song.mp3"),
	load("res://Audio/Songs/Bolero of Fire.mp3"),
	load("res://Audio/Songs/Saria's Song.mp3"),
	load("res://Audio/Songs/Serenade of Water.mp3"),
	load("res://Audio/Songs/Sun's Song.mp3"),
	load("res://Audio/Songs/Requiem of Spirit.mp3"),
	load("res://Audio/Songs/Song of Time.mp3"),
	load("res://Audio/Songs/Nocturne of Shadow.mp3"),
	load("res://Audio/Songs/Song of Storms.mp3"),
	load("res://Audio/Songs/Prelude of Light.mp3")
]

var song_duration = [41.5, 15.5, 7.0, 19.5, 6.5, 18.5, 5.5, 22.5, 10.0, 21.5, 27.5, 18.0]

var notas_sound = [
	load("res://Audio/SFX/Notas/Nota_Q.mp3"),
	load("res://Audio/SFX/Notas/Nota_W.mp3"),
	load("res://Audio/SFX/Notas/Nota_E.mp3"),
	load("res://Audio/SFX/Notas/Nota_R.mp3"),
	load("res://Audio/SFX/Notas/Nota_T.mp3")
]


var zoom_audio = load("res://Audio/SFX/Camera Change.wav")
var song_match = load("res://Audio/SFX/Song Match.wav")

var goingToPlay : bool = false
var isPlaying : bool = false
var started : bool = false
var song_index : int = 0

@onready var cameras = [$Player/CameraOrigin/SpringArm3D/CameraBehind, $Player/CameraFront]
@onready var audioSource = $Player/Audio
@onready var GUI = $Interface/Idle
@onready var animation_player = $Player/Dralako/AnimationPlayer



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(isPlaying == false):
		if Input.is_action_just_pressed("Play"):
			audioSource.stream = zoom_audio
			audioSource.play()
			goingToPlay = !goingToPlay
			started = false
			players_song.clear()
			animation_player.stop()
	
		if(goingToPlay == false):
			if(started == false):
				cameras[0].current = true
				GUI.visible = true
				started = true
				animation_player.play("Idle Moving")
		else:
			if(started == false):
				cameras[1].current = true
				GUI.visible = false
				started = true
				animation_player.play("Playing")
			
			if Input.is_action_just_pressed("Nota_Q"):
				players_song.push_back(1)
				audioSource.stream = notas_sound[0]
				audioSource.play()
				check_songs()
			elif Input.is_action_just_pressed("Nota_W"):
				players_song.push_back(2)
				audioSource.stream = notas_sound[1]
				audioSource.play()
				check_songs()
			elif Input.is_action_just_pressed("Nota_E"):
				players_song.push_back(3)
				audioSource.stream = notas_sound[2]
				audioSource.play()
				check_songs()
			elif Input.is_action_just_pressed("Nota_R"):
				players_song.push_back(4)
				audioSource.stream = notas_sound[3]
				audioSource.play()
				check_songs()
			elif Input.is_action_just_pressed("Nota_T"):
				players_song.push_back(5)
				audioSource.stream = notas_sound[4]
				audioSource.play()
				check_songs()
			
			if players_song.size() > 8:
				players_song.clear()
				goingToPlay = false
				started = false
				animation_player.stop()

func check_songs():
	for song in song_lists:
		if players_song.size() == song_lists[song].size():
			if players_song == song_lists[song]:
				song_index = song
				isPlaying = true
				await get_tree().create_timer(1.5).timeout
				play_song()

func play_song():
	audioSource.stream = song_match
	audioSource.play()
	await get_tree().create_timer(1.0).timeout
	var object = songs_UIs[song_index].instantiate()
	add_child(object)
	audioSource.stream = songs_mp3[song_index]
	audioSource.play()
	await get_tree().create_timer(song_duration[song_index]).timeout
	object.queue_free()
	isPlaying = false
	players_song.clear()
	goingToPlay = false
	started = false
	animation_player.stop()
