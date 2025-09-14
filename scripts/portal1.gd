extends Area2D

@export var whereto:String

func _on_body_entered(body: Node2D) -> void:
	print("Portal entry: ", body.name)
	if body is CharacterBody2D:
		call_deferred("changeLevel")

func changeLevel():
	match whereto:
		"Variant Level One":
			$"/root/game/SubViewportContainer/SubViewport".get_child(0).queue_free()
			$"/root/game/SubViewportContainer/SubViewport".add_child(preload("res://scenes/variant___level_one.tscn").instantiate())
