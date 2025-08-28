extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print("Portal entry: ", body.name)
	if body.name == "Player":
		call_deferred("changeLevel")

func changeLevel():
	get_tree().change_scene_to_file("res://scenes/level_one___tutorial.tscn")
