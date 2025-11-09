extends Sprite2D

var dir := 1 if randf() < 0.5 else -1
var speed := randf_range(10, 100)

func _ready() -> void:
	flip_h = randf() < 0.5
	_reposition(randf_range(-1, 1) * 2500)

func _process(delta: float) -> void:
	global_position += Vector2.LEFT * dir * speed * delta
	var distance := (global_position - GameState.camera.global_position).length()
	if distance > 6000:
		_reposition(dir * 3500)
		
func _reposition(off: float):
	global_position = GameState.camera.global_position + Vector2.RIGHT * off + Vector2.UP * randf_range(-1, 1) * 2500
