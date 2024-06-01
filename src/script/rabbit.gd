class_name Rabbit
extends Node2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var baise_cooldown: Timer = $BaiseCooldown
@onready var baise_detector: Area2D = $BaiseDetector
@onready var animated_sprite: AnimatedSprite2D = $Sprite2D

@export var target : Marker2D
@export var SPEED : int = 100
var can_fuck : bool = true:
	set(new_value):
		can_fuck = new_value
		if can_fuck == false:
			baise_cooldown.start(15)

var stopped : bool = false


func _ready():
	baise_cooldown.timeout.connect(on_baise_cooldown_ended)
	baise_detector.area_entered.connect(on_gros_baiseur_detected)
	call_deferred("set_navigation_agent", target)

func _physics_process(delta: float) -> void:
	if navigation_agent.is_navigation_finished() or stopped:
		animated_sprite.animation = "walk"
		
	var direction = global_position.direction_to(navigation_agent.get_next_path_position())
	direction = direction.normalized()
	scale.x = sign(direction.x * -1)
	translate(direction * SPEED * delta)
	
func set_navigation_agent(new_target: Marker2D):
	if not target:
		navigation_agent.target_position = Vector2(randf_range(0, 530), randf_range(0,370))		
	else:
		navigation_agent.target_position = new_target.global_position
	
func on_baise_cooldown_ended():
	can_fuck = true
	
func on_gros_baiseur_detected(baiseur: Area2D):
	if can_fuck == false: return
	
	var autre_baiseur : Rabbit = baiseur.owner
	if autre_baiseur.can_fuck == false: return
	
	can_fuck = false
	autre_baiseur.can_fuck = false
	BaiseManager.call_deferred("make_baise_happen", self, autre_baiseur)


# Lié a la crotte
func spawn_poop():
	pass

# Lié a la baise
func stop():
	visible = false
	stopped = true
	
func unstop():
	visible = true
	stopped = false


func _on_navigation_agent_2d_navigation_finished() -> void:
	navigation_agent.target_position = Vector2(randf_range(0, 530), randf_range(0,370))
