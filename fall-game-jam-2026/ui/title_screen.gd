extends Control


func _on_start_button_pressed() -> void:
	SceneSwitcher.switch("res://level/world.tscn")
	print("what")
