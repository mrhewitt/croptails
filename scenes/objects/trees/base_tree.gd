class_name BaseTree
extends Sprite2D

@onready var damage_component: DamageComponent = $DamageComponent
@onready var hurt_component: HurtComponent = $HurtComponent

const LOG = preload("res://scenes/objects/trees/log.tscn")

func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damage_reached.connect(on_max_damage_reached)
	
	
func on_hurt(hit_damage: int) -> void:
	damage_component.apply_damage(hit_damage)
	material.set_shader_parameter("shake_intensity", 0.5)
	await get_tree().create_timer(1.0).timeout
	material.set_shader_parameter("shake_intensity", 0)
	
func on_max_damage_reached() -> void:
	call_deferred("add_log_scene")
	queue_free()


func add_log_scene() -> void:
	var log_instance = LOG.instantiate() as Node2D
	log_instance.global_position = global_position
	get_parent().add_child(log_instance)
