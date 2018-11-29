extends Node

var spawn_group_name = null


func load_scene(scene_path, spawn_group_name):
	self.spawn_group_name = spawn_group_name
	
	get_tree().change_scene(scene_path)
	
