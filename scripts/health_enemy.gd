extends ProgressBar
var parent
var max_value_amount
var min_value_amount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
	max_value_amount = parent.health_max
	min_value_amount = parent.health_min
	value = parent.health
	print(max_value_amount)
	print(min_value_amount)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = parent.health
