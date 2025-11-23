extends Node2D

@export var enemy: Enemy
@export var face: Node2D
@export var line: Line2D
@export var bubble: Node2D
@export var mouth: Node2D
@export var cast: RayCast2D
@export var killbox: Killbox

var shooting := false
var cooldown := 1.0

func _process(delta):
	if not GameState.player:
		return

	var pp := GameState.player.live_gun.global_position
	var dir := global_position.angle_to_point(pp)
	var distance := global_position.distance_to(pp)

	line.points = [line.points[0], Vector2(0, -2000 / scale.x)]
	
	cooldown -= delta

	if distance > enemy.vision_range:
		return

	if not shooting:
		rotation = dir + PI * 0.5
		face.position = Vector2.from_angle(dir) * 50
		
	cast.target_position = cast.to_local(pp)
	if cooldown <= 0 and not cast.is_colliding():
		shoot()
		
func shoot():
	cooldown = 5
	get_tree().create_tween().tween_property(mouth, "scale", Vector2.ONE, 0.6).set_trans(Tween.TRANS_BOUNCE)
	await get_tree().create_timer(0.6).timeout
	get_tree().create_tween().tween_property(bubble, "scale", Vector2.ONE, 0.8).set_trans(Tween.TRANS_BOUNCE)
	get_tree().create_tween().tween_property(line, "width", 50, 0.3).set_trans(Tween.TRANS_BOUNCE)
	await get_tree().create_timer(0.5).timeout
	shooting = true
	get_tree().create_tween().tween_property(line, "width", 600, 0.3).set_trans(Tween.TRANS_BOUNCE)
	await get_tree().create_timer(0.3).timeout
	killbox.enabled = true
	await get_tree().create_timer(1).timeout
	killbox.enabled = false
	shooting = false
	line.width = 0
	bubble.scale = Vector2.ZERO
	get_tree().create_tween().tween_property(mouth, "scale", Vector2.ZERO, 0.3).set_trans(Tween.TRANS_BOUNCE)
