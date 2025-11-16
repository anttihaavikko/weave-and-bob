class_name WormBlister
extends AnimatableBody2D

@export var flasher: Flasher

signal died

var life = 1000

func hit():
	life -= GameState.damage
	flasher.flash()
	if life <= 0:
		GameState.camera.shake(10, 0.3)
		Effects.singleton.add_many([4, 3, 10, 2, 0, 0, 0, 1], global_position)
		SoundEffects.singleton.add(2, global_position)
		SoundEffects.singleton.add(13, global_position)
		died.emit()
		get_parent().queue_free()
