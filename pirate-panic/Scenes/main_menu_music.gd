extends Node

@export var music_phrases : Array[AudioStreamOggVorbis]
@export var delay_between_phrases_range : Vector2
@export var avoid_playing_last_x_clips : int

var last_played_clips : Array[AudioStreamOggVorbis]
var flip_flop : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var start_phrase : AudioStreamOggVorbis = music_phrases.pop_front()
	last_played_clips.append(start_phrase)
	$AudioPlayer2.stream = start_phrase
	$AudioPlayer2.play(0.0)
	
	$Timer.wait_time = randf_range(delay_between_phrases_range.x, delay_between_phrases_range.y)
	$Timer.timeout.connect(play_next_phrase)
	$Timer.start()

func play_next_phrase():
	if (randf_range(0.0, 1.0) < 0.15):
		$Timer.wait_time = randf_range(delay_between_phrases_range.x / 2, delay_between_phrases_range.y / 2)
		return
	
	var random_index : int = randi_range(0, music_phrases.size() - 1)
	var new_phrase : AudioStreamOggVorbis = music_phrases.pop_at(random_index)
	if (last_played_clips.size() == avoid_playing_last_x_clips):
		music_phrases.append(last_played_clips.pop_front())
	last_played_clips.append(new_phrase)
	
	if (flip_flop):
		$AudioPlayer1.stream = new_phrase
		$AudioPlayer1.play(0.0)
	else:
		$AudioPlayer2.stream = new_phrase
		$AudioPlayer2.play(0.0)
	
	flip_flop = !flip_flop
	$Timer.wait_time = randf_range(delay_between_phrases_range.x, delay_between_phrases_range.y)
	
