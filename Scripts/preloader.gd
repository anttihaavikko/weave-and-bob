extends Node

@export var scene: PackedScene
@export var preloaded: Array[PackedScene]
@export var spinner: Appearer
@export var shader_info: Node

func _ready() -> void:
	var ua = JavaScriptBridge.eval("navigator.userAgent")
	if ua and ua.contains("Windows"):
		shader_info.show()
	
	if OS.is_debug_build():
		await get_tree().create_timer(0.1).timeout
		get_tree().change_scene_to_packed(scene)
		return
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
