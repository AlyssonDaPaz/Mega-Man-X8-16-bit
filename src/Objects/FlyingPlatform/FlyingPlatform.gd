extends PathFollow2D
export var speed := 60
export var use_elevator_speed := false
onready var collision_shape_2d: CollisionShape2D = $kinematicBody2D/collisionShape2D

var reached_bottom := false
onready var elevator := get_parent().get_parent()

func _ready() -> void:
	if use_elevator_speed:
		speed = 0
		elevator.connect("activated",self,"get_elevator_speed")# warning-ignore:return_value_discarded
		elevator.connect("player_reached_bottom",self,"on_player_reached_bottom")# warning-ignore:return_value_discarded
	if not visible:
		collision_shape_2d.disabled = true

func get_elevator_speed() -> void:
	speed = get_parent().get_parent().speed

func _physics_process(delta: float) -> void:
	if use_elevator_speed:
		if elevator and elevator.active:
			offset += speed * delta
		if has_player_reached_bottom() and not is_on_screen():
			destroy()
	else:
		offset += speed * delta
	
	if speed < 0 and not visible:
		if global_position.y > 2200:
			visible = true
			collision_shape_2d.disabled = false
		

func has_player_reached_bottom() -> bool:
	return reached_bottom

func is_on_screen() -> bool:
	return GameManager.is_on_camera(self)

func destroy() -> void:
	print_debug(name + ": destroying")
	queue_free()
		
func on_player_reached_bottom() -> void:
	reached_bottom = true
