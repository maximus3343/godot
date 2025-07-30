extends CharacterBody2D

@onready var agent := $NavigationAgent2D
@export var speed := 100.0

func _physics_process(delta):
	print("is_navigation_finished: ", agent.is_navigation_finished())
	print("path_empty: ", agent.get_current_navigation_path().is_empty())
	print("path length: ", agent.get_current_navigation_path().size())

	if agent.is_navigation_finished() or agent.get_current_navigation_path().is_empty():
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var next_point = agent.get_next_path_position()
	var direction = (next_point - global_position).normalized()

	velocity = direction * speed
	move_and_slide()
