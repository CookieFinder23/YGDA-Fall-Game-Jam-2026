extends Control


func _on_start_button_pressed() -> void:
	SceneSwitcher.switch("res://level/world.tscn")



func _on_credits_button_pressed() -> void:
	var tween : Tween = get_tree().create_tween()
	tween.tween_property($Credits, "position", Vector2(0,0), 1.0)


func _on_credits_visibility_changed() -> void:
	pass # Replace with function body.


func _on_back_button_pressed() -> void:
	var tween : Tween = get_tree().create_tween()
	tween.tween_property($Credits, "position", Vector2(0,1080), 1.0)
