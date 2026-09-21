@tool
@icon("res://addons/bmod/icons/SoundEffect.svg")

@abstract
class_name SoundEffect extends Resource


@export var meta: SoundEffectMeta:
	set(value):
		if meta:
			meta.changed.disconnect(_on_meta_changed)
		meta = value
		if meta:
			meta.changed.connect(_on_meta_changed)


@export_category("Play")

@export var play: bool = false:
	set(value):
		if value:
			test_play()
		
@export var play_on_change: bool = false

	
var last_changed: int = 0

const CHANGE_PLAY_DELAY_MS: int = 100

func _on_meta_changed() -> void:
	emit_changed()
	_on_changed()


func _on_changed() -> void: 
	
	if last_changed + CHANGE_PLAY_DELAY_MS > Time.get_ticks_msec():
		return
	
	last_changed = Time.get_ticks_msec()
	
	if not play_on_change:
		return
	
	test_play()
	
	
@abstract func get_audio_stream() -> AudioStream


func get_volume_db() -> float:
	if meta == null:
		return 0.0
	else:
		return meta.get_volume_db()
	
	
func get_pitch_scale() -> float:
	if meta == null:
		return 1.0
	else:
		return meta.get_pitch_scale()

 
func apply_to_player(player: Node) -> void:
	if player is AudioStreamPlayer:
		player.stream = get_audio_stream()
		player.volume_db = get_volume_db()
		player.pitch_scale = get_pitch_scale()
	elif player is AudioStreamPlayer2D:
		player.stream = get_audio_stream()
		player.volume_db = get_volume_db()
		player.pitch_scale = get_pitch_scale()
	elif player is AudioStreamPlayer3D:
		player.stream = get_audio_stream()
		player.volume_db = get_volume_db()
		player.pitch_scale = get_pitch_scale()


func test_play() -> void:
	if not Engine.is_editor_hint():
		return
		
	BMOD.play_sfx(self)
