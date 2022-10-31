tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("AtlasPlayer", "TextureRect", preload("atlas_player.gd"), preload("res/icon.svg"))


func _exit_tree():
	remove_custom_type("AtlasPlayer")
