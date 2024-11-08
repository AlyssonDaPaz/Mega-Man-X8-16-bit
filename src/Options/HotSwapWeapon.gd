extends Sprite

export var weapon : Resource
onready var select: AnimatedSprite = $"../select"
export var selectable := false
export var already_selected := false
func _ready() -> void:
	_on_hotswap_opened()
	get_parent().connect("weapon_selected",self,"on_select")
	get_parent().connect("unselected_all",self,"unselect")

func _on_hotswap_opened() -> void:
	modulate.a = 0.5
	if weapon.collectible in GameManager.collectibles:
		make_selectable()
	else:
		deactivate()

func deactivate() -> void:
	pass

func make_selectable() -> void:
	selectable = true
	texture = weapon.faded_icon
	pass

func on_select(sweapon) -> void:
	if selectable and sweapon != self:
		texture = weapon.faded_icon
		modulate.a = 0.5
		already_selected = false
		
func unselect() -> void:
	if selectable:
		texture = weapon.faded_icon
		modulate.a = 0.5
		already_selected = false
	if select.visible:
		select.visible = false
		

# warning-ignore:function_conflicts_variable
func select() -> void:
	texture = weapon.icon
	modulate.a = 1
	Event.emit_signal("select_weapon",weapon)
	select.position = position
	select.visible = true
	select.frame = 0
	already_selected = true
