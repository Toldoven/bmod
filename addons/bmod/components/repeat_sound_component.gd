@tool
@icon("res://addons/bmod/icons/RepeatSoundComponent.svg")

class_name RepeatSoundComponent extends Node

signal played

@export var player: Node

@export var playing: bool = false:
	set(value):
		if value == playing:
			return
		playing = value
		_start_if_playing_enabled()
		
@export var autoplay: bool = false;
		
@export var wait_time: float = 0.15
@export var wait_time_variation: float = 0.0

@export var stop_on_timeout: bool = true

var _timer: Timer

func _start_if_playing_enabled() -> void:
	if playing and _timer.is_stopped():
		_play()
		_start_timer()

func _start_timer() -> void:
	_timer.wait_time = wait_time + BMOD.get_variation(wait_time_variation)
	_timer.start()


func _ready() -> void:
	_timer = Timer.new()
	add_child(_timer)
	_timer.one_shot = true
	_timer.timeout.connect(_on_timeout)
	
	if autoplay and not Engine.is_editor_hint():
		playing = true
	
	_start_if_playing_enabled()


func _play() -> void:
	if player.has_method("play"):
		player.call("play")
		played.emit()
	else:
		push_error("Can't play a sound on a Node because it doesn't have a 'play' method")
		
		
func _stop() -> void:
	if player.has_method("stop"):
		player.call("stop")
	else:
		push_error("Can't stop a sound on a Node because it doesn't have a 'stop' method")


func force_play() -> void:
	playing = true
	_start_timer()	
	_play()


func force_stop() -> void:
	playing = false
	_stop()

func _on_timeout() -> void:
	
	if playing:
		_start_timer()
	else:
		if stop_on_timeout:
			_stop()
		return
	
	_play()
	
