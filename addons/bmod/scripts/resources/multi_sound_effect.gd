@tool
@icon("res://addons/bmod/icons/MultiSoundEffect.svg")

class_name MultiSoundEffect extends SoundEffect

enum Mode {
	SHUFFLE,
	RANDOM,
	SEQUENCE,
}

@export var effect_pool: Array[MultiSoundEffectItem] = []:
	set(value):		
		effect_pool = value
		calculate_total_weight()
		for item in effect_pool:
			if not item is MultiSoundEffectItem:
				return
			
			if not item.is_connected("changed", calculate_total_weight):
				item.changed.connect(calculate_total_weight)


@export var mode: Mode = Mode.SHUFFLE

var _total_weight: int = 0

func calculate_total_weight() -> void:
	_total_weight = 0
	for item in effect_pool:
		if not item is MultiSoundEffectItem:
			return
		_total_weight += item.weight

var _last_audio_stream_index: int = -1


func get_audio_stream() -> AudioStream:
	match mode:
		Mode.SHUFFLE:
			return get_audio_stream_weighted(true)
		Mode.RANDOM:
			return get_audio_stream_weighted(false)
		Mode.SEQUENCE:
			return get_audio_stream_sequence()
	push_error("Invalid MultiSoundEffect Mode")
	return null


func get_audio_stream_weighted(prevent_back_to_back: bool) -> AudioStream:
	var total_weight = _total_weight
	
	if prevent_back_to_back and _last_audio_stream_index != -1:
		var item := effect_pool[_last_audio_stream_index]
		if item != null:
			total_weight -= item.weight

	var random_weight = randi_range(1, total_weight)
	var current_weight = 0
	
	for item_index in effect_pool.size():
		if prevent_back_to_back and _last_audio_stream_index == item_index and effect_pool.size() > 1:
			continue
		var item := effect_pool[item_index]
		current_weight += item.weight
		if current_weight >= random_weight:
			_last_audio_stream_index = item_index
			return item.audio_stream
			
	push_error("Couldn't find a random AudioStream in MultiSoundEffect. Either the pool is empty or it's a MultiSoundEffect bug")		
			
	return null


func get_audio_stream_sequence() -> AudioStream:

	_last_audio_stream_index += 1

	if _last_audio_stream_index >= effect_pool.size():
		_last_audio_stream_index = 0

	return effect_pool[_last_audio_stream_index].audio_stream


