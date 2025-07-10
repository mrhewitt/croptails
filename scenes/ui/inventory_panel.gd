extends PanelContainer

@onready var labels = {
	"log": %LogLabel,
	"stone": %StoneLabel,	
	"egg": %EggLabel,	
	"milk": %MilkLabel,	
	"corn": %CornLabel,	
	"tomato": %TomatoLabel
}

func _ready() -> void:
	InventoryManager.inventory_updated.connect(on_inventory_updated)
	

func on_inventory_updated(collectable_name: String, quantity: int) -> void:
	labels[collectable_name].text = str(quantity)
