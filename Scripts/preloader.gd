extends Node

@export var scene: PackedScene
@export var preloaded: Array[PackedScene]
@export var spinner: Appearer

func _ready() -> void:
	spinner.appear()
	await get_tree().create_timer(0.5).timeout
	for p in preloaded:
		var o := p.instantiate()
		if o is Node2D:
			o.global_position = Vector2(500, 500)
		if o is GPUParticles2D:
			o.restart()
		add_child(o)
		await get_tree().create_timer(0.15).timeout
	await get_tree().create_timer(1).timeout
	spinner.disappear()
	get_tree().change_scene_to_packed(scene)
