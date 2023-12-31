extends Node2D

var plansza = []

func pole(x:int,y:int):
	#funkcja zwraca indeks tablicy 169-elementowej, odpowiadajacy indeksowi w tablicy dwuwymiarowej 13x13; gdy podane zostaną wartości spoza zakresu, zwraca false
	if (x>=0)&&(x<=13)&&(y>=0)&&(y<=13): return y*13+x
	else: return false

func initPlansza(eo:Array):
	eo.resize(13*13)
	#dla uproszczenia metod sprawdzania zbijania etc, dodam jeszcze jeden rząd "pól" dookoła planszy, który będzie miał specjalną wartość -1
	#startowo - domyślnie wszystkie elementy planszy mają wartość 0 - puste pole
	for i in (169):
		eo[i]=0
	#pola krawędzi mają wartość -1
	for i in 13:
		eo[i]=-1
		eo[pole(12,i)]=-1
		eo[pole(0,i)]=-1
		eo[pole(i,12)]=-1
	#pola startowe czarnych mają wartość 1
	for i in 5:
		eo[pole(4+i,1)]=1
		eo[13*11+4+i]=1
		eo[13*(i+4)+1]=1
		eo[13*(i+4)+11]=1
	eo[13*2+6]=1
	eo[13*10+6]=1
	eo[13*6+2]=1
	eo[13*6+10]=1
	#pola startowe białych pionów mają wartość 2
	eo[13*6+4]=2
	eo[13*6+5]=2
	eo[13*6+7]=2
	eo[13*6+8]=2
	eo[13*4+6]=2
	eo[13*8+6]=2
	for i in 3:
		eo[13*5+5+i]=2
		eo[13*7+5+i]=2
	#tron z królem ma wartość 7, potem sam król wartość 3, a tron i inne pola zastrzeżone 4
	eo[13*6+6]=8
	eo[13+1]=4
	eo[13+11]=4
	eo[13*11+1]=4
	eo[13*11+11]=4

func pokazPlansze(_eo:Array):
	var napis
	for i in 13:
		napis = ""
		for q in 13:
			napis = napis + str(_eo[i*13+q]) + " "
		print(napis)

func wolnePole(eo:Array, x:int,y:int):
	if (eo[y*13+x]==0):
		return 1
	elif (eo[y*13+x]==4):
		return 2
	else:
		return 0	

func czyRuchLegalny(eo:Array, x1:int,y1:int,x2:int,y2:int):
	#funkcja ta sprawdza, czy jest legalny ruch z pola (x1,y1) na (x2,y2). Jeśli tak, zwraca TRUE, jeżeli nie, FALSE
	#nie sprawdzam, czy wartości należą do zakresu od 1 do 11, bo zakładam, że tylko takie będą podawane
	if (x1==x2):
		if y1<y2:
			for i in range(y2,y1,-1):
				if (wolnePole(eo,x1,i)==0)||(wolnePole(eo,x1,i)==2)&&((eo[13*y1+x1]==3)||(eo[13*y1+x1]==8)):
					return false
		elif(y1>y2):
			for i in range(y2,y1,1):
				if (wolnePole(eo,x1,i)==0)||(wolnePole(eo,x1,i)==2)&&((eo[13*y1+x1]==3)||(eo[13*y1+x1]==8)):
					return false
		else: return false	
	elif (y1==y2):
		if x1<x2:
			for i in range(x2,x1,-1):
				if (wolnePole(eo,i,y1)==0)||(wolnePole(eo,i,y1)==2)&&((eo[13*y1+x1]==3)||(eo[13*y1+x1]==8)):
					return false
		elif(x1>x2):
			for i in range(x2,x1,1):
				if (wolnePole(eo,i,y1)==0)||(wolnePole(eo,i,y1)==2)&&((eo[13*y1+x1]==3)||(eo[13*y1+x1]==8)):
					return false
	else: return false
	return true

#func zbijanie(eo:Array,x:int,y:int)
	#if 

func ruch(eo:Array, x1:int,y1:int,x2:int,y2:int):
	if czyRuchLegalny(eo, x1,y1,x2,y2):
		if eo[y1*13+x1]==8:
			#ruch królem z tronu
			eo[y1*13+x1]=4
			eo[y2*13+x2]=3
		elif (eo[y2*13+x2]==4):
			#powrót królem na tron
			eo[y1*13+x1]=0
			eo[y2*13+x2]=7
		else:
			#każdy inny ruch - zakładam, że żadna bierka (poza królem) nie może startować ani kończyć na polu zastrzeżonym
			eo[y2*13+x2]=eo[y1*13+x1]
			eo[y1*13+x1]=0
	else: return false
	return true

# Called when the node enters the scene tree for the first time.
func _ready():
	initPlansza(plansza)
	pokazPlansze(plansza)
	ruch(plansza,4,6,4,8)
	ruch(plansza,5,6,3,6)
	ruch(plansza,6,6,4,6)
	pokazPlansze(plansza)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
