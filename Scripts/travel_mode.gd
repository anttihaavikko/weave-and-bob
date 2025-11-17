extends Node

@export var bodies: Array[RigidBody2D]
@export var links: Array[PlayerPart]
@export var spring: DampedSpringJoint2D
@export var sprite: Node2D
@export var nodes_to_hide: Array[Node]
@export var line: Line2D

var joint: PinJoint2D

func _ready() -> void:
	for link in bodies:
		link.body_entered.connect(func(other: Node2D):
			if not joint and other is AttachPoint:
				if not GameState.worm or not GameState.worm.friendly:
					return
				joint = PinJoint2D.new()
				# joint.global_position = other.global_position
				joint.position = Vector2(0, -250)
				joint.bias = 1
				joint.node_a = link.get_path()
				joint.node_b = other.get_path()
				joint.softness = 0
				other.add_child(joint)
				spring.stiffness = 100
				spring.length = 10
				sprite.show()
				# line.show()
				for n in nodes_to_hide:
					n.hide()
				GameState.attached = true
				GameState.worm.change_goal()
				for l in links:
					l.collision_mask = int(pow(2, 6))
					l.hide()
				for l in bodies:
					l.collision_mask = int(pow(2, 6))
		)
		
func _process(_delta: float) -> void:
	if joint and Input.is_action_just_pressed("jump"):
		GameState.worm.leave()
		GameState.worm = null
		GameState.attached = false
		GameState.request_player_fix()

# func _physics_process(_delta: float) -> void:
# 	if joint:
# 		line.points = [bodies[0].global_position, joint.global_position]
