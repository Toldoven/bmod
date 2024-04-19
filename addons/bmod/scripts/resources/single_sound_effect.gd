@tool
@icon("res://addons/bmod/icons/SingleSoundEffect.svg")

class_name SingleSoundEffect extends SoundEffect

@export var audio_stream: AudioStream

func get_audio_stream() -> AudioStream:
	return audio_stream
