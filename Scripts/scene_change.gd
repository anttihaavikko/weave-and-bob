extends Node

@export var scene: PackedScene
@export var preloaded: Array[PackedScene]

func _ready() -> void:
    await get_tree().create_timer(1).timeout
    get_tree().change_scene_to_packed(scene)
