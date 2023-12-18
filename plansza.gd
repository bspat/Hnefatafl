extends Node2D

var plansza = []

func pokazPlansze(eo:Array):
	var napis
	for i in 13:
		napis = ""
		for q in 13:
			napis = napis + str(eo[i*13+q]) + " "
		print(napis)

# Called when the node enters the scene tree for the first time.
func _ready():
	plansza.resize(13*13)
	#dla uproszczenia metod sprawdzania zbijania etc, dodam jeszcze jeden rząd "pól" dookoła planszy, który będzie miał specjalną wartość
	
	#startowo - domyślnie wszystkie elementy planszy mają wartość 0 - puste pole
	for i in (13*13):
		plansza[i]=0
	#pola krawędzi mają wartość -1
	for i in 13:
		plansza[i]=-1
		plansza[13*12+i]=-1
		plansza[i*13]=-1
		plansza[i*13+12]=-1
	#pola startowe czarnych mają wartość 1
	for i in 5:
		plansza[17+i]=1
		plansza[13*11+4+i]=1
		plansza[13*(i+4)+1]=1
		plansza[13*(i+4)+11]=1
	plansza[13*2+6]=1
	plansza[13*10+6]=1
	plansza[13*6+2]=1
	plansza[13*6+10]=1
	#na dzisiaj mi starczy
	pokazPlansze(plansza)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
