@abstract
class_name Gameplay

static func hit_stop(tree: SceneTree, speed: float, duration: float):
	Engine.time_scale = speed
	await tree.create_timer(duration).timeout
	Engine.time_scale = 1