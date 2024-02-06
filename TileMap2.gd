extends TileMap

var neu =[]

# Called when the node enters the scene tree for the first time.
func _ready():
	neu.resize(13*13)
	for i in 169:
		neu[i]=0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (neu!=get_parent().plansza):
		neu = get_parent().plansza
