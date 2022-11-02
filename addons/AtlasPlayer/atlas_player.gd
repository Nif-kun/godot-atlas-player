tool
extends TextureRect

# Self-note:
# 	Properly customize this when possible. Refer to FlexContainer plugin for better exports.

# Note:
# 	Atlas Texture export is meant to take in direct texture. 
# 	Drag and drop the texture from the resource to the input box.

# Warning:
# 	Base Texture must be an AtlasTexture. By default, the AtlasPlayer will set it.
# 	That said, any form of modification to the Texture without knowledge can lead 
# 	to AtlasPlayer breaking.

# Signals
signal started
signal stopped

# Exports
export var atlas_texture : Texture setget set_atlas_texture, get_atlas_texture
export var hframe := 1 setget set_hframe, get_hframe
export var vframe := 1 setget set_vframe, get_vframe
export var start_frame := 1 setget set_start_frame, get_start_frame
export var end_frame := 1 setget set_end_frame, get_end_frame
export var speed := 1.0 setget set_speed, get_speed
export var loop := true setget set_loop, get_loop
export var auto_start := false setget set_auto_start, get_auto_start
export var pause_on_hide := true 

# Private
var _frame_buffer := 0
var _frame := 1
var _timer := Timer.new()


# Called on script instance.
func _init():
	texture = AtlasTexture.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	if texture == null and !(texture is AtlasTexture):
		texture = AtlasTexture.new()
	# warning-ignore:RETURN_VALUE_DISCARDED
	_timer.connect("timeout", self, "_on_timeout")
	_timer.wait_time = speed
	_timer.autostart = auto_start
	add_child(_timer)
	connect("visibility_changed", self, "on_visibility_changed")


# Returns an index vector position of the _frame (value taken from start_frame).
func _get_matrix_index() -> Vector2:
	var indexed_frame = _frame - 1
	if (indexed_frame) < hframe:
		return Vector2(indexed_frame, 0)
	return Vector2(floor(indexed_frame%hframe), floor(indexed_frame/hframe))

# Returns a pixel position vector of an index vector based on the width and height of the image.
func _get_region_pos() -> Vector2:
	var matrix_index = _get_matrix_index()
	return Vector2(texture.region.size.x * matrix_index.x, texture.region.size.y * matrix_index.y)


# Update functions to refresh the AtlasTexture properties.
func _update(check:bool=true):
	if !check or texture is AtlasTexture and texture.atlas != null:
		texture.region.size = Vector2(texture.atlas.get_size().x / hframe, texture.atlas.get_size().y / vframe)
		texture.region.position = _get_region_pos()

func _update_size():
	if texture is AtlasTexture and texture.atlas != null:
		texture.region.size = Vector2(texture.atlas.get_size().x / hframe, texture.atlas.get_size().y / vframe)

func _update_position():
	if texture is AtlasTexture and texture.atlas != null:
		texture.region.position = _get_region_pos()


# Restricts start_frame and end_frame going beyond possible frame size (hframe * vframe).
func _restrict_frame_size():
	if end_frame > hframe * vframe:
		end_frame = hframe * vframe
	if start_frame > hframe * vframe:
		start_frame = hframe * vframe
	property_list_changed_notify()


# AtlasTexture setget
func set_atlas_texture(value:Texture):
	atlas_texture = value
	if texture is AtlasTexture:
		texture.atlas = value
		_update()

func get_atlas_texture() -> Texture:
	return atlas_texture


# HFrame setget
func set_hframe(value:int):
	if value > 0:
		hframe = value
	else:
		hframe = 1
	_restrict_frame_size()
	_update()

func get_hframe() -> int:
	return hframe


# VFrame setget:
func set_vframe(value:int):
	if value > 0:
		vframe = value
	else:
		vframe = 1
	_restrict_frame_size()
	_update()

func get_vframe() -> int:
	return vframe


# StartFrame setget
func set_start_frame(value:int):
	if value > 0:
		if value <= hframe * vframe:
			start_frame = value
		else:
			start_frame = hframe * vframe
		if start_frame > end_frame:
			end_frame = start_frame
			property_list_changed_notify()
	else:
		start_frame = 1
	_frame = start_frame
	_update_position()

func get_start_frame() -> int:
	return start_frame


# EndFrame setget
func set_end_frame(value:int):
	if value > 0:
		if value < start_frame:
			end_frame = start_frame
		elif value <= hframe * vframe:
			end_frame = value
		else:
			end_frame = hframe * vframe
	else:
		end_frame = 1
	_update_position()

func get_end_frame() -> int:
	return end_frame


# Speed setget
func set_speed(value:float):
	if value >= 0.01:
		speed = value
		_timer.wait_time = value
	else:
		speed = 0.01
		_timer.wait_time = 0.01

func get_speed() -> float:
	return speed


# Loop setget
func set_loop(flag:bool):
	loop = flag

func get_loop() -> bool:
	return loop


# AutoStart setget
func set_auto_start(flag:bool):
	auto_start = flag
	_timer.autostart = flag

func get_auto_start() -> bool:
	return auto_start


# Timer [node] getter, for more complex need of timer.
# Note: understand that this directly calls on the node. 
#       If still not loaded or ready, it can cause null instances.
func get_timer() -> Timer:
	return _timer


# PauseOnHide setget
func set_pause_on_hide(flag:bool):
	pause_on_hide = flag

func get_pause_on_hide() -> bool:
	return pause_on_hide


# Occurs when visibility is changed.
func on_visibility_changed():
	_timer.paused = !visible # Pauses the animation if the AtlasPlayer is not visible.


# Start and Stop function for the animation to play or end.
func start(update:bool=true):
	if update:
		_frame = start_frame
		_update_position()
	_timer.start()
	emit_signal("started")

func stop(update:bool=true):
	_timer.stop()
	if update:
		_frame = start_frame
		_update_position()
	emit_signal("stopped")


# Called upon end of _timer:Timer node.
# Used as a form of timed process to animate.
func _on_timeout():
	if end_frame > start_frame:
		# This is to avoid out of index logical error in _get_matrix_index.
		if _frame <= (vframe * hframe): 
			_update_position()
			if _frame < end_frame:
				_frame += 1
			else:
				_frame = start_frame
				if !loop:
					_timer.stop()
					emit_signal("stopped")
		else:
			_frame = start_frame
