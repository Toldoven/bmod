@tool
@icon("res://addons/bmod/icons/MultiSoundEffectItem.svg")

class_name MultiSoundEffectItem extends Resource
	
@export var audio_stream: AudioStream

@export_range(1, 100) var weight: int = 1:
	set(value):
		if weight == value:
			return
		
		weight = value
		emit_changed()
