@tool
@icon("res://addons/bmod/icons/SoundEffectPlayer3D.svg")

class_name SoundEffectPlayer3D extends Node3D

signal finished

@export var sound_effect: SoundEffect

@export var autoplay: bool = false

@export var attenuation_model: AudioStreamPlayer3D.AttenuationModel = AudioStreamPlayer3D.ATTENUATION_INVERSE_DISTANCE:
	set(value):
		attenuation_model = value
		sync_values()
		
@export_range(0.01, 100.0, 0.01) var unit_size: float = 10:
	set(value):
		unit_size = value
		sync_values()

@export var max_distance_m: int = 0:
	set(value):
		max_distance_m = value
		sync_values()
		
@export var max_polyphony: int = 1:
	set(value):
		max_polyphony = value
		sync_values()
		
@export_range(0.0, 3.0) var panning_strength: float = 1.0:
	set(value):
		panning_strength = value
		sync_values()

@export var bus: StringName = BMOD.default_sfx_bus():
	set(value):
		bus = value
		sync_values()

@export_flags_3d_physics var area_mask: int = 0:
	set(value):
		area_mask = value
		sync_values()

var _player: AudioStreamPlayer3D


func sync_values() -> void:
	if _player == null:
		return
	_player.bus = bus
	_player.max_polyphony = max_polyphony
	_player.max_distance = max_distance_m
	_player.area_mask = area_mask
	_player.panning_strength = panning_strength
	_player.attenuation_model = attenuation_model
	_player.unit_size = unit_size


func _ready() -> void:
	_player = AudioStreamPlayer3D.new()
	_player.finished.connect(func() -> void: finished.emit())
	add_child(_player)
	sync_values()
	
	if autoplay and not Engine.is_editor_hint():
		play()


func play(from_position: float = 0.0) -> void:
	sound_effect.apply_to_player(_player)
	_player.play(from_position)


func stop() -> void:
	_player.stop()
