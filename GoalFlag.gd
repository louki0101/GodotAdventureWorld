extends Area2D

export(String, FILE, "*.tscn") var scene_to_load

func _on_GoalFlag_body_entered(body):
	if body.is_in_group("player"):
		#change scene
		get_tree().change_`scene(scene_to_load)
		
