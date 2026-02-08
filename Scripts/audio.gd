extends Node

func play_sfx(stream: AudioStream, pitch: float = 1.0):
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = stream
	player.pitch_scale = pitch
	player.play()
	player.finished.connect(player.queue_free)
	
func play_music(stream: AudioStream, pitch: float = 1.0):
	var music_player = get_node_or_null("MusicPlayer")
	if not music_player:
		music_player = AudioStreamPlayer.new()
		music_player.name = "MusicPlayer"
		add_child(music_player)
	music_player.stream = stream
	music_player.play()

func play_ambience(stream: AudioStream, pitch: float = 1.0):
	var music_player = get_node_or_null("MusicAmbiencePlayer")
	if not music_player:
		music_player = AudioStreamPlayer.new()
		music_player.name = "MusicAmbiencePlayer"
		add_child(music_player)
	music_player.stream = stream
	music_player.play()
