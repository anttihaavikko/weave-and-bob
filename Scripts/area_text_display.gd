extends Area2D

@export var text: Appearer

func _ready() -> void:
    body_entered.connect(enter)
    body_exited.connect(exit)

func enter(_node: Node2D):
    text.appear()
    SoundEffects.singleton.add(17, global_position)

func exit(_node: Node2D):
    text.disappear()