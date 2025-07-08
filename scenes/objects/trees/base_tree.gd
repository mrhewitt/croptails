class_name BaseTree
extends Sprite2D

@onready var damage_component: DamageComponent = $DamageComponent
@onready var hurt_component: HurtComponent = $HurtComponent

const LOG = preload("res://scenes/objects/trees/log.tscn")

func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damage_reached.connect(on_max_damage_reached)
	
	
func on_hurt(hit_damage: int) -> void:
	print("hurt")
	damage_component.apply_damage(hit_damage)
	
	
func on_max_damage_reached() -> void:
	call_deferred("add_log_scene")
	print("max damage reached")
	queue_free()


func add_log_scene() -> void:
	var log_instance = LOG.instantiate() as Node2D
	log_instance.global_position = global_position
	get_parent().add_child(log_instance)
