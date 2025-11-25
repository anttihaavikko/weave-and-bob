class_name AreaTextDisplay
extends Area2D

@export var text: Appearer
@export var enabled := true

func _ready() -> void:
	body_entered.connect(enter)
	body_exited.connect(exit)

func enter(_node: Node2D):
	if enabled:
		text.appear()
		SoundEffects.singleton.add(17, global_position)

func exit(_node: Node2D):
	if enabled:
		text.disappear()