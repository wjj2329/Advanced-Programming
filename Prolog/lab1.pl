customer(hugh).
customer(ida).
customer(jeremy).
customer(leroy).
cutomer(stella).

rose(cottageBeauty).
rose(goldenSunset).
rose(mountainBloom).
rose(pinkParadise).
rose(sweetDreams).

event(anniversaryParty).
event(charityAuction).
event(retirementBanquet).
event(seniorProm).
event(wedding).

item(ballons).
item(candles).
item(chocolates).
item(placeCards).
item(streamers).

solve:-
  rose(HughRose), rose(IdaRose), rose(JeremyRose), rose(LeroyRose), rose(StellaRose),
    all_different([HughRose, IdaRose, JeremyRose, LeroyRose, StellaRose]),

  event(HughEvent), event(IdaEvent), event(JeremyEvent), event(LeroyEvent), event(StellaEvent),
    all_different([HughEvent, IdaEvent, JeremyEvent, LeroyEvent, StellaEvent]),

  item(HughItem), item(IdaItem), item(JeremyItem), item(LeroyItem), item(StellaItem),
    all_different([HughItem, IdaItem, JeremyItem, LeroyItem, StellaItem]),

  Quads=[[hugh, HughItem, HughEvent, HughRose],
          [ida, IdaItem, IdaEvent, IdaRose],
          [jeremy, JeremyItem, JeremyEvent, JeremyRose],
          [leroy, LeroyItem, LeroyEvent, LeroyRose],
          [stella, StellaItem, StellaEvent, StellaRose] ],

          %Jeremy made a purchase for the senior prom. Stella (didnt choose wedding picked Cottage Beauty)
  member([jeremy, _, seniorProm, _], Quads),
  member([stella, _, _, cottageBeauty], Quads),
  \+ member([stella, _ , wedding, _], Quads),
  % Hugh selected the PinkParadise didnt have auction or wedding
  member([hugh, _, _, pinkParadise], Quads),
  \+ member([hugh, _, charityAuction, _], Quads),
  \+ member([hugh, _, wedding, _ ], Quads),
  % whoever chose roses with AnniversaryParty did Streamers
  % whoever shoped for a wedding chose Ballons
  member([_, streamers, anniversaryParty, _],Quads),
  member([_,ballons, wedding, _], Quads),
  %whoever bought sweet dreams bought gourmet Chocolates
  %Jeremey didnt get Mountain MountainBloom
  member([_, chocolates, _, sweetDreams], Quads),
  \+ member([jeremy, _, _, mountainBloom], Quads),
  %Leroy went to RetirementBanquet
  %whoever went to senior prom got the Candles
  member([leroy, _, retirementBanquet, _ ], Quads),
  member([_, candles, seniorProm, _], Quads),



  tell(hugh	, HughItem	, HughEvent	, HughRose	),
  tell(ida	, IdaItem		, IdaEvent	, IdaRose	),
  tell(jeremy	, JeremyItem	, JeremyEvent, JeremyRose),
  tell(leroy	, LeroyItem	, LeroyEvent	, LeroyRose	),
  tell(stella	, StellaItem	, StellaEvent, StellaRose).

all_different([H | T]) :- member(H, T), !, fail.
all_different([_ | T]) :- all_different(T).
all_different([_]).


tell(X, Y, Z, A) :-
    write(X), write(' is buying a '),
    write(Y), write(' and went to  '),
    write(Z), write(' and got this rose '),
    write(A), write('.'), nl.


%member(x, [x|r]).   X is in the list.
%member(x, [y|r]) :- member(x,r).  Then it will still be in the list if we add stuff to it.
