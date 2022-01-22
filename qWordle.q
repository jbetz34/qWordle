// initialize word list
wordz:system "curl http://wiki.puzzlers.org/pub/wordlists/unixdict.txt";
wordz:wordz where all (5=count each wordz;all each wordz in .Q.a);

// create base word table
w:([]word:wordz;I:wordz[;0];II:wordz[;1];III:wordz[;2];IV:wordz[;3];V:wordz[;4]);

// generic wordzScore function 
// x - words table
// y - column to analyze
// 
prb:{{x%sum x} ?[x;();y;(count;`i)]};

// Function to identify the best guess at each situation
guessTable:([]guess:();clues:();wc:())

// expecting string guess (g)
// list of longs corresponding to clues (c)
// 0 - not in word;
// -1 - correct letter, wrong spot;
// 1 - correct letter, correct spot;
guess:{[g;c]
	wc:{(not;(in;`I`II`III`IV`V@y;x y))}[g] each where c=-1;
	wc,:{(in/:;x y;`word)}[g] each where c=-1;
	wc,:{(not;(in/:;x y;`word))}[g] each where c=0;
	wc,:{(in;`I`II`III`IV`V@y;x y)}[g] each where c=1;
	`guessTable upsert enlist (g;c;wc);
	:guessTable
 }	

// function to determine best guess from existing letters
// where w exists globally and is base word table
// where prb exists globally and is letter probability function
topList:{[wc]
	t:?[`w;wc;0b;()];
	s:?[t;();0b;n!{(@;x y;y)}[prb[t]] each n:`I`II`III`IV`V];
	t:update score:(exec sum (I;II;III;IV;V) from s) from t;
	:`score xdesc t
 }
	
