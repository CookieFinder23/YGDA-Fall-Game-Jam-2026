extends Control

var title_out: bool = false

func _on_start_button_pressed() -> void:
	SceneSwitcher.switch("res://level/world.tscn")
	SFX.play(SFX.Id.CLICK)


func _on_credits_button_pressed() -> void:
	if title_out:
		var tween : Tween = get_tree().create_tween()
		tween.tween_property($Credits, "position", Vector2(768,1080), 1.0)
	else:
		var tween : Tween = get_tree().create_tween()
		tween.tween_property($Credits, "position", Vector2(768,0), 1.0)
	title_out = not title_out
	SFX.play(SFX.Id.CLICK)
