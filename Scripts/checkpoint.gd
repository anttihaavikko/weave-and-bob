class_name Checkpoint
extends Area2D

@export var pole: Node2D

func _activate(other: Node2D):
	if other is Gun:
		var tween := get_tree().create_tween()
		tween.tween_property(pole, "scale", Vector2.ONE, 0.4).set_trans(Tween.TRANS_BOUNCE)
		tween.parallel().tween_property(pole, "rotation_degrees", 0, 0.4).set_trans(Tween.TRANS_BOUNCE)
		if GameState.checkpoint != self:
			Musics.intensify(false, false)
			SoundEffects.singleton.add(14, global_position, 0.75)
			SoundEffects.singleton.add(15, global_position, 1.5)
		GameState.change_spawn(self)

func deactivate():
	var tween := get_tree().create_tween()
	tween.tween_property(pole, "scale", Vector2.ZERO, 0.3).set_trans(Tween.TRANS_BOUNCE)
	tween.parallel().tween_property(pole, "rotation_degrees", 180, 0.3).set_trans(Tween.TRANS_BOUNCE)
