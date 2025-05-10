extends Node

#enters game
func _on_temp_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn"); #gets other scene from project and open it's node tree

#exits game
func _on_temp_quit_pressed() -> void:
	get_tree().quit();
