@tool
@icon("res://addons/bmod/icons/SoundEffectPlayer.svg")

class_name SoundEffectPlayer extends Node

signal finished

@export var sound_effect: SoundEffect

@export var autoplay: bool = false

@export var bus: StringName = BMOD.default_sfx_bus():
	set(value):
		bus = value
		sync_values()
		
@export var max_polyphony: int = 1:
	set(value):
		max_polyphony = value
		sync_values()
		
@export var mix_target: AudioStreamPlayer.MixTarget:
	set(value):
		mix_target = value
		sync_values()

var _player: AudioStreamPlayer


func sync_values() -> void:
	if _player == null:
		return
	_player.bus = bus
	_player.max_polyphony = max_polyphony
	_player.mix_target = mix_target


func _ready() -> void:
	_player = AudioStreamPlayer.new()
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
