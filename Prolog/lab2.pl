teacher(appleton).
teacher(gross).
teacher(knight).
teacher(mcEvoy).
teacher(parnell).

activity(antiquing).
activity(camping).
activity(sightseeing).
activity(spelunking).
activity(waterskiing).

state(california).
state(florida).
state(maine).
state(oregon).
state(virginia).

subject(english).
subject(gym).
subject(history).
subject(math).
subject(science).

solve:-
  subject(AppletonSubj), subject(GrossSubj), subject(KnightSubj), subject(McEvoySubj), subject(ParnellSubj),
    all_different([AppletonSubj, GrossSubj, KnightSubj, McEvoySubj, ParnellSubj]),

  state(AppletonState), state(GrossState), state(KnightState), state(McEvoyState), state(ParnellState),
    all_different([AppletonState, GrossState, KnightState, McEvoyState, ParnellState]),

  activity(AppletonActi), activity(GrossActi), activity(KnightActi), activity(McEvoyActi), activity(ParnellActi),
    all_different([AppletonActi, GrossActi, KnightActi, McEvoyActi, ParnellActi]),

  Solutions=[[appleton, AppletonSubj, AppletonState, AppletonActi],
  [gross, GrossSubj, GrossState, GrossActi],
  [knight, KnightSubj, KnightState, KnightActi],
  [mcEvoy, McEvoySubj, McEvoyState, McEvoyActi],
  [parnell, ParnellSubj, ParnellState, ParnellActi] ],

   %Ms Gross teaches either math or science
  (member(  [gross	, math		, _	, _	],	Solutions);
	member(		[gross	, science	, _ , _ ],	Solutions)),

  %Ms Gross either does antiquing and goes to florida or she is going to California.

	(member(	[gross	, 	_ , florida 	, antiquing	],	Solutions);
	member(		[gross	, _, california		, _			],	Solutions),
  \+  member([gross, _, california, antiquing], Solutions)),

  %The science teacher (who does waterskiing) is going
  (member(	[_	, science, california , waterskiing	],	Solutions);
   member( [ _ , science, florida, waterskiing] , Solutions)),

   %Mr Mcevoy, who is history, is going to either Maine or Oregon
  (member( [mcEvoy, history, maine, _], Solutions );
   member( [mcEvoy, history, oregon, _], Solutions)),

   %Appleton vs Parnell
  (member([appleton, english, virginia,_ ], Solutions);
  member([parnell, _, virginia, _], Solutions)),

  member([parnell,_,_, spelunking], Solutions),

  % The person who is going to Maine isn;t the gym leader.
  \+ member([_, gym , maine, _], Solutions),
  \+ member([_,_, maine, sightseeing], Solutions),


  (member([appleton, _, _, camping], Solutions);
  member([parnell, _,_, camping], Solutions)),

  (member([appleton, _, _, antiquing], Solutions);
  member([gross, _,_,antiquing], Solutions);
  member([parnell, _, _, antiquing], Solutions)),


tell(appleton	, AppletonSubj	, AppletonState	, AppletonActi	),
tell(gross		, GrossSubj	 , 	GrossState	, GrossActi		),
tell(knight		, KnightSubj	, KnightState, KnightActi		),
tell(mcEvoy		, McEvoySubj	, McEvoyState	, McEvoyActi		),
tell(parnell	, ParnellSubj	, ParnellState	, ParnellActi	).






  all_different([H | T]) :- member(H, T), !, fail.
  all_different([_ | T]) :- all_different(T).
  all_different([_]).

  tell(X, Y, Z, A) :-
      write(X), write(' '),
      write(Y), write(' '),
      write(Z), write(' '),
      write(A), write('.'), nl.
