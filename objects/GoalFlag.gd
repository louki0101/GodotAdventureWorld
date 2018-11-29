extends Area2D

export(String, FILE, "*.tscn") var scene_to_load
export(String) var target_spawn_group

func _on_GoalFlag_body_entered(body):
	if body.is_in_group("player"):
		#change scene
		#get_tree().change_scene(scene_to_load)
		SceneLoader.load_scene(scene_to_load, target_spawn_group)
		
