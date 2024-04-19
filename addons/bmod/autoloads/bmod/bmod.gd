@tool

extends Node


@onready var _internal_container = $Container
@onready var _internal_container_2d = $Container2D
@onready var _internal_container_3d = $Container3D


# Set these properties if you want BMOD to spawn audio players
# as children of a different node and not the internal containers
var default_container: Node = null
var default_container_2d: Node2D = null
var default_container_3d: Node3D = null


# Play SoundEffect
# Note: By default it spawns audio players inside the autoload
# The sound will continue to play after you switch the scene
#
# If this is not a desired behaviour:  
# - Either pass `override_container` to this function
# - Or set the `override_container` propery on BMOD autoload each time you load a scene
func play_sfx(
	sound_effect: SoundEffect,
	override_container: Node = null,
	override_bus: StringName = &"",
) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	
	if is_instance_valid(override_container):
		override_container.add_child(player)
	elif is_instance_valid(default_container):
		default_container.add_child(player)
	else:
		_internal_container.add_child(player)
	
	sound_effect.apply_to_player(player)
	player.bus = _get_sfx_bus(override_bus)
	player.finished.connect(player.queue_free)
	player.play()
	return player


# Play SoundEffect with a 2D position
# Note: By default it spawns audio players inside the autoload
# The sound will continue to play after you switch the scene
#
# If this is not a desired behaviour (For 2D usually it's not):  
# - Either pass `override_container_2d` to this function
# - Or set the `default_container_2d` propery on BMOD autoload each time you load a scene
func play_sfx_2d(
	sound_effect: SoundEffect,
	global_position: Vector2,
	override_container: Node = null,
	override_bus: StringName = &""
) -> AudioStreamPlayer2D:
	var player := AudioStreamPlayer2D.new()
	
	if is_instance_valid(override_container):
		override_container.add_child(player)
	elif is_instance_valid(default_container):
		default_container.add_child(player)
	else:
		_internal_container.add_child(player)
	
	player.global_position = global_position
	sound_effect.apply_to_player(player)
	player.bus = _get_sfx_bus(override_bus)
	player.finished.connect(player.queue_free)
	player.play()
	return player


# Play SoundEffect with a 3D position
# Note: By default it spawns audio players inside the autoload
# The sound will continue to play after you switch the scene
#
# If this is not a desired behaviour (For 3D usually it's not):  
# - Either pass `override_container_3d` to this function
# - Or set the `default_container_3d` propery on BMOD autoload each time you load a scene
func play_sfx_3d(
	sound_effect: SoundEffect,
	global_position: Vector3,
	override_container: Node = null,
	override_bus: StringName = &"",
) -> AudioStreamPlayer3D:
	var player := AudioStreamPlayer3D.new()
	
	if is_instance_valid(override_container):
		override_container.add_child(player)
	elif is_instance_valid(default_container):
		default_container.add_child(player)
	else:
		_internal_container.add_child(player)
	
	player.global_position = global_position
	sound_effect.apply_to_player(player)
	player.bus = _get_sfx_bus(override_bus)
	player.finished.connect(player.queue_free)
	player.play()
	return player


static func _get_sfx_bus(override_bus: StringName) -> StringName:
	if override_bus == &"":
		return default_sfx_bus()
	else:
		return override_bus


static func default_sfx_bus() -> StringName:
	return ProjectSettings.get_setting("audio/bmod/default_sfx_bus", &"Master")


static func get_variation(variation_amount: float) -> float:
	return randf_range(-variation_amount, variation_amount)
