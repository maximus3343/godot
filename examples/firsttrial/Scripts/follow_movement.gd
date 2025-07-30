class_name FollowMovementC
extends CharacterBody2D

@export var speed: float = 20.0
@export_enum("AxisX", "AxisY", "AxisXY") var Movement_type: String = "AxisXY"
@export var gravity: float = 500.0
@export var max_fall_speed: float = 200.0

@onready var nav_agent := $NavigationAgent2D
@onready var timer := $Timer

var start_position: Vector2
var target: Player


func _ready() -> void:
	start_position = position
	$FollowArea.body_entered.connect(_on_follow_area_body_entered)
	$FollowArea.body_exited.connect(_on_follow_area_body_exited)
	timer.timeout.connect(_on_timer_timeout)
	timer.start()


func _physics_process(delta: float) -> void:
	if target and !nav_agent.is_navigation_finished():
		update_velocity(delta)
		move_and_slide()
	else:
		velocity = Vector2.ZERO


func update_velocity(delta: float) -> void:
	var direction = (nav_agent.get_next_path_position() - global_position).normalized()

	match Movement_type:
		"AxisXY":
			velocity = direction * speed

		"AxisX":
			direction.y = 0
			direction = direction.normalized()
			velocity.x = direction.x * speed

			if !is_on_floor():
				velocity.y += gravity * delta
				velocity.y = min(velocity.y, max_fall_speed)
			else:
				velocity.y = 0

		"AxisY":
			direction.x = 0
			direction = direction.normalized()
			velocity = direction * speed


func _on_timer_timeout() -> void:
	if target:
		nav_agent.target_position = target.global_position


func _on_follow_area_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body


func _on_follow_area_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
