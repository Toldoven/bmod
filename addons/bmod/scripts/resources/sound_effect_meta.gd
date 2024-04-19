@tool
@icon("res://addons/bmod/icons/SoundEffectMeta.svg")

class_name SoundEffectMeta extends Resource

@export_category("Volume")

@export_range(-80.0, 24.0, 0.1) var volume_db: float = 0.0:
	set(value):
		if volume_db == value:
			return
		volume_db = value
		emit_changed()

@export_range(0.0, 24.0, 0.1) var volume_variation_db: float = 0.0:
	set(value):
		if volume_variation_db == value:
			return
		volume_variation_db = value
		emit_changed()

@export_category("Pitch")

@export_range(0.1, 4.0, 0.1) var pitch_scale: float = 1.0:
	set(value):
		if pitch_scale == value:
			return
		pitch_scale = value
		emit_changed()


@export_range(0.0, 1.0, 0.1) var pitch_variation: float:
	set(value):
		if pitch_variation == value:
			return
		pitch_variation = value
		emit_changed()
		
func get_volume_db() -> float:
	return volume_db + BMOD.get_variation(volume_variation_db)
	
func get_pitch_scale() -> float:
	return pitch_scale + BMOD.get_variation(pitch_variation)
