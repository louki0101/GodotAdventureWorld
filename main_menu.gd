extends Node2D


func _on_ExitTextureButton_pressed():
	get_tree().quit()


func _on_NewGameTextureButton_pressed():
	SceneLoader.load_scene("res://levels/level_1.tscn", null)
