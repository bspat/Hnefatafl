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
		eo[pole(4+i,11)]=1
		eo[pole(1,(i+4))]=1
		eo[pole(11,(i+4))]=1
	eo[pole(6,2)]=1
	eo[pole(6,10)]=1
	eo[pole(2,6)]=1
	eo[pole(10,6)]=1
	#pola startowe białych pionów mają wartość 2
	eo[pole(4,6)]=2
	eo[pole(5,6)]=2
	eo[pole(7,6)]=2
	eo[pole(8,6)]=2
	eo[pole(6,4)]=2
	eo[pole(6,8)]=2
	for i in 3:
		eo[pole(5+i,5)]=2
		eo[pole(5+i,7)]=2
	#tron z królem ma wartość 7, potem sam król wartość 3, a tron i inne pola zastrzeżone 4
	eo[pole(6,6)]=8
	eo[pole(1,11)]=4
	eo[pole(11,11)]=4
	eo[pole(1,1)]=4
	eo[pole(11,1)]=4

func pokazPlansze(_eo:Array):
	var napis
	for i in 13:
		napis = ""
		for q in 13:
			napis = napis + str(_eo[pole(q,i)]) + " "
		print(napis)

func wolnePole(eo:Array, x:int,y:int):
	if (eo[pole(x,y)]==0):
		return 1
	elif (eo[pole(x,y)]==4):
		return 2
	else:
		return 0	

func czyRuchLegalny(eo:Array, x1:int,y1:int,x2:int,y2:int):
	#funkcja ta sprawdza, czy jest legalny ruch z pola (x1,y1) na (x2,y2). Jeśli tak, zwraca TRUE, jeżeli nie, FALSE
	#nie sprawdzam, czy wartości należą do zakresu od 1 do 11, bo zakładam, że tylko takie będą podawane
	if (x1==x2):
		if y1<y2:
			for i in range(y2,y1,-1):
				if (wolnePole(eo,x1,i)==0)||(wolnePole(eo,x1,i)==2)&&((eo[pole(x1,y1)]==3)||(eo[pole(x1,y1)]==8)):
					return false
		elif(y1>y2):
			for i in range(y2,y1,1):
				if (wolnePole(eo,x1,i)==0)||(wolnePole(eo,x1,i)==2)&&((eo[pole(x1,y1)]==3)||(eo[pole(x1,y1)]==8)):
					return false
		else: return false	
	elif (y1==y2):
		if x1<x2:
			for i in range(x2,x1,-1):
				if (wolnePole(eo,i,y1)==0)||(wolnePole(eo,i,y1)==2)&&((eo[pole(x1,y1)]==3)||(eo[pole(x1,y1)]==8)):
					return false
		elif(x1>x2):
			for i in range(x2,x1,1):
				if (wolnePole(eo,i,y1)==0)||(wolnePole(eo,i,y1)==2)&&((eo[pole(x1,y1)]==3)||(eo[pole(x1,y1)]==8)):
					return false
	else: return false
	return true

#funckja sprawdza zbijanie na planszy (każdą możliwą metodą) dla bierki przestawionej w podane miejsce z podanego kierunku (strzalka) - wartość zwracana przez ruch()
#białe 2, czarne 1, król 3, tron/rogi 4, król na tronie 7, krawędź -1;
func zbijanie(eo:Array, x:int, y: int, strzalka:int):
	var kierunek
	#zbijanie przez "wzięcie w kleszcze" - klasyczne
	for i in 4:
		match i:
			0:kierunek=-1
			1:kierunek=1
			2:kierunek=13
			3:kierunek=-13
		if eo[pole(x,y)+kierunek]>0:#sprawdzenie czy nie stoi przy krawędzi lub pustym
			if eo[pole(x,y)]==1:#sprawdzenie koloru - jeżeli 1 to czarny, jeżeli coś innego to biały lub król w rozmaitych konfiguracjach
				if(eo[pole(x,y)+kierunek]==2)&&((eo[pole(x,y)+kierunek*2]==1)||(eo[pole(x,y)+kierunek*2]==4)):
					#powyższy warunek sprawdza, czy pole sąsiadujace jest zajęte przez białego piona, a następne przez czarnego lub tron/róg
					eo[pole(x,y)+kierunek]==0
			else:#jeżeli przesunięty był król lub biały pion
				if(eo[pole(x,y)+kierunek]==1)&&(eo[pole(x,y)+kierunek*2]>1):
					#powyższy warunek sprawdza, czy pole sąsiadujące jest czarne, a następne nie puste, nie jest krawędzią ani czarnym
					eo[pole(x,y)+kierunek]==0
	#zbijanie przez mur tarcz
	kierunek=strzalka
	if(eo[pole(x,y)+kierunek]==-1):
		if eo[pole(x,y)]==1:#czarne
			if abs(kierunek)==1:#sprawdzanie dla pionowych krawędzi
				for i in range((y+1),12,1):#sprawdzanie w dół
					if (eo[pole(x,i)]==2):
						if(eo[pole(x,i)-kierunek]!=1):
							break
					elif((eo[pole(x,i)]==1)||(eo[pole(x,i)]==4)):
						for q in range(y+1,i-1):
							eo[pole(x,q)]=0
						break
				for i in range((y-1),0,-1):#sprawdzanie w górę
					if (eo[pole(x,i)]==2):
						if(eo[pole(x,i)-kierunek]!=1):
							break
					elif((eo[pole(x,i)]==1)||(eo[pole(x,i)]==4)):
						for q in range(y-1,i+1,-1):
							eo[pole(x,q)]=0
						break
			else:#sprawdzanie dla poziomych krawędzi
				for i in range((x+1),12,1):#sprawdzanie w prawo
					if (eo[pole(i,y)]==2):
						if(eo[pole(i,y)-kierunek]!=1):
							break
					elif((eo[pole(i,y)]==1)||(eo[pole(i,y)]==4)):
						for q in range(x+1,i-1):
							eo[pole(q,y)]=0
						break
				for i in range((x-1),0,-1):#sprawdzanie w lewo
					if (eo[pole(i,y)]==2):
						if(eo[pole(i,y)-kierunek]!=1):
							break
					elif((eo[pole(i,y)]==1)||(eo[pole(i,y)]==4)):
						for q in range(x-1,i+1,-1):
							eo[pole(q,y)]=0
						break
		else:#białe i król
			if abs(kierunek)==1:#sprawdzanie dla pionowych krawędzi
				for i in range((y+1),12,1):#sprawdzanie w dół
					if (eo[pole(x,i)]==1):
						if(eo[pole(x,i)-kierunek]!=2)&&(eo[pole(x,i)-kierunek]!=3):
							break
					elif((eo[pole(x,i)]==1)||(eo[pole(x,i)]==4))||(eo[pole(x,i)-kierunek]==3):
						for q in range(y+1,i-1):
							eo[pole(x,q)]=0
						break
				for i in range((y-1),0,-1):#sprawdzanie w górę
					if (eo[pole(x,i)]==1):
						if(eo[pole(x,i)-kierunek]!=2)&&(eo[pole(x,i)-kierunek]!=3):
							break
					elif((eo[pole(x,i)]==1)||(eo[pole(x,i)]==4))||(eo[pole(x,i)-kierunek]==3):
						for q in range(y-1,i+1,-1):
							eo[pole(x,q)]=0
						break
			else:#sprawdzanie dla poziomych krawędzi
				for i in range((x+1),12,1):#sprawdzanie w prawo
					if (eo[pole(i,y)]==1):
						if(eo[pole(i,y)-kierunek]!=2)&&(eo[pole(i,y)-kierunek]!=3):
							break
					elif((eo[pole(i,y)]==1)||(eo[pole(i,y)]==4))||(eo[pole(i,y)-kierunek]==3):
						for q in range(x+1,i-1):
							eo[pole(q,y)]=0
						break
				for i in range((x-1),0,-1):#sprawdzanie w lewo
					if (eo[pole(i,y)]==1):
						if(eo[pole(i,y)-kierunek]!=2)&&(eo[pole(i,y)-kierunek]!=3):
							break
					elif((eo[pole(i,y)]==1)||(eo[pole(i,y)]==4))||(eo[pole(i,y)-kierunek]==3):
						for q in range(x-1,i+1,-1):
							eo[pole(q,y)]=0
						break

#funkcja ruch zwraca kierunek w jakim przemieściła się bierka: GÓRA - -13, DÓŁ - 13, PRAWO - 1, LEWO - -1, lub 0 gdy ruch był nielegalny
func ruch(eo:Array, x1:int,y1:int,x2:int,y2:int):
	if czyRuchLegalny(eo, x1,y1,x2,y2):
		if eo[pole(x1,y1)]==8:
			#ruch królem z tronu
			eo[pole(x1,y1)]=4
			eo[pole(x2,y2)]=3
		elif (eo[pole(x2,y2)]==4):
			#powrót królem na tron
			eo[pole(x1,y1)]=0
			eo[pole(x2,y2)]=7
		else:
			#każdy inny ruch - zakładam, że żadna bierka (poza królem) nie może startować ani kończyć na polu zastrzeżonym
			eo[pole(x2,y2)]=eo[pole(x1,y1)]
			eo[pole(x1,y1)]=0
		zbijanie(eo,x2,y2,x2-x1+(y2-y1)*13);
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
