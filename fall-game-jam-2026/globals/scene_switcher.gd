extends CanvasLayer
## how much time the fading is actively "fading"
const FADE_SECONDS = 0.35
## how much time the fading pauses after it is fully opaque
const BLACK_SECONDS = 0.1
var switching = false

func switch(scene) -> void:
	if switching:
		return
	switching = true
	get_tree().paused = true
	await fade(1.0)
	get_tree().change_scene_to_file(scene)
	GameState.reset()
	get_tree().paused = false
	await get_tree().create_timer(BLACK_SECONDS).timeout
	await fade(0.0)
	switching = false

func fade(end) -> void:
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property($ColorRect, "color:a", end, FADE_SECONDS)
	await tween.finished
	tween.kill()
