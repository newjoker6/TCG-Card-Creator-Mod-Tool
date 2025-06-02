extends Control


func _ready() -> void:
	await get_tree().create_timer(2).timeout
	var _err:Error = get_tree().change_scene_to_file("res://main.tscn")
