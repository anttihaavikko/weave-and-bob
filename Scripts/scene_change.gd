extends Node

@export var scene: PackedScene
@export var preloaded: Array[PackedScene]

func _ready() -> void:
    for p in preloaded:
        print("prewarming ", p)
        var obj = p.instantiate()
        if obj is Node2D:
            obj.global_position = Vector2(-9999, 0)
        add_child(obj)
    await get_tree().create_timer(1).timeout
    get_tree().change_scene_to_packed(scene)
