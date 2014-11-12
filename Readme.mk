Flipull: An Exciting Cube Game: FAQ/Walkthrough by ASchultz
Version: 1.0.0 | Last Updated: 2006-08-19 | View/Download Original File Hosted by GameFAQs
Return to Flipull: An Exciting Cube Game (NES) FAQs & Guides
Would you recommend this FAQ? Yes No
Flipull(NES) FAQ version 1.0.0
copyright 2006 by Andrew Schultz schultz.andrew@sbcglobal.net

Please do not reproduce for profit without my consent. You won't be getting 
much profit anyway, but that's not the point. This took time and effort, and 
I just wanted to save a memory of a great game and the odd solutions any way 
I could. Please send me an email referring to me and this guide by name if 
you'd like to post it on your site.

**** AD SPACE ****
My website: http://www.geocities.com/SoHo/Exhibit/2762

================================

            OUTLINE

  1. INTRODUCTION

  2. CONTROLS

  3. STRATEGIES

  4. ADVANCE WALKTHROUGH

  5. NORMAL

  6. CHEAT CODES

  7. VERSIONS

  8. CREDITS

================================

  1. INTRODUCTION

Flipull is an interesting little game, at least for a while. You're an orange 
blob on a ladder on the right of the screen. There are walls and pipes that 
deflect the blocks you fire to the left, off at a ninety degree angle, where 
they bounce on the blocks below. If you touch two blocks together, the still 
one disappears. In fact there is a chain effect left than down. The first 
block that is not the same color as yours is flipped back to you. There are 
also power blocks that will vaporize any color block, too. If you have no 
legal moves, and you have more than the required number of blocks, you 
replace your block with a power-up. You have three to start in normal mode.

Each level in free mode has a time limit(always 3 minutes, but man do those 3 
minutes go fast later on) and a minimum number of blocks to leave on the 
board. Everything gets faster and tougher as you go from 4x4 to 6x6. It's not 
terribly linear or sensible and quite frankly 3 minutes is not enough to 
calculate all the permutations. Let's just say that although Flipull is fun 
for a while, it was more fulfilling to write an algorithm that solved various 
levels for the Advance mode. I did that for 33 and 38-on. Even level 46, 
which my algorithm didn't work for. I figured it out and was doubly ashamed, 
of my coding error and of not taking a few seconds to look at it.

Apparently there's a story tied into Flipull, too, but it's fairly 
pedestrian. And it has some amusing cut scenes too.

Anyway, it deserves a FAQ, so I gave it one.

  2. CONTROLS

Move your guy up and down the ladder and fire with A or B. You'll get one 
bounce off a wall or pipe then the block will go at a right angle and bounce 
back up to you. If you try to make an illegal move, you'll be stunned for a 
bit and lose 1 power in advance mode.

Points are pretty straightforward.

100x^2 points for dispatching x blocks at once
10*(# of seconds) blocks for time left at the end of a normal level
  (advance has no time limit)
1000 + 1000 * (blocks under limit) in normal
10000 for each level solved in advance

Extra power-ups at 20000, 50000, 100000, and every 100000 after that in 
normal.

Clearly it's to your advantage to try to wait as much as possible to knock 
out a brick, unless you're under 30 seconds(time forfeit unless you're clear 
or below.) In fact killing a lot of blocks overall is more important than 
killing a bunch at once, so it pays never to get greedy.

  3. STRATEGIES

These are a bit spare as Flipull is a nonlinear game.

--Sometimes random moves work as well as certain "greedy" strategies so it's 
tough to strategize.
--If you must lose a powerup, try to set things up so that you have an easy 
time the rest of the way through. They're easy to lose in bunches.
--Note that the only way you can get <3 powerups on the board is to take out 
one sort of block for a losing move.
--Pipes can be useful to bounce blocks off. Try at the start of the level to 
evaluate which columns you can't knock stuff down and try to make those 
columns a priority when you shoot rows from the side.
--Look for rows you can pick off when you get the same color back or even 
rows that you can almost get. If you have:

#
oT T
TTTx
ooo#o

--You can knock out the # with another o from the right,  Get an o with the # 
above and then take out the whole row. Note that you also made a 4-row of T's 
instead of a 3-row. These are combos to watch out for.
--Look for columns all of the same color--you can bounce something down there 
and get it back. Though it is a problem if that's the only thing left.
--There's no steadfast rule if one color is good to get rid of or not. Just 
beware that putting something in the very DL with no other blocks of the same 
color is dangerous as late on you may have to bounce things off back there. 
If you have a color 1U1R of the corner that is best. You can get around it.
--It's best to keep structures compact.
--There's nothing wrong with a one-two between different colors.
--I find you can really only look three moves ahead, although if you can 
eliminate certain moves as definite dead ends then you can go a bit more. 3 
is only practical in normal but in advanced you may wish to branch things off 
a bit more if you don't want to follow the walkthrough proper.
--email me if you'd like the C code to look through any random level.

  4. ADVANCE WALKTHROUGH

Advance mode of Flipull has 50 levels. You can continue endlessly but your 
score gets zapped. You get no extra power-ups, and the object for each level 
is to wind up with four blocks: one of each color, where you are holding one. 
You always have enough power to win a level in advance mode even if you only 
take one brick at a time, unless you make an illegal move. Many of the first 
levels are pretty easy to solve but sadly as they got tougher I didn't 
understand what was going on, so no commentary. Search for "LEVEL X" where 
you need help.

The notation should be pretty clear--(x)U is x stairs up the ladder. 12 is 
the top. Some of these may cost you a few extra keystrokes, and I may fix 
that later, or I may have lint to clean out of some bathrobe I never wear 
anyway.

The blocks should make sense too
#=green square
x=black X
o=red circle
T=blue triangle

Very PlayStation-y, even before the PlayStation! But nothing near Lucky 
Charms.

LEVEL 1

Map for level 1:
****
***
**
*




x###
oxxx
TTTT
#ooo
Start with #3

Nothing fancy here. The obvious moves are the right ones.
2U 3U 2U 1U

LEVEL 2

Map for level 2:
****
***
**
*




xooo
#xxx
Tooo
oxxx
Start with #5

Still no tricks yet.

1U 1U 1U 1U 4U

LEVEL 3

Map for level 3:
****
***
**
*




oooo
TTTo
oooo
Tx#o
Start with #5

The left-right moves are bad as you get a blue and the rest are hidden. So:

11U (take the right column) 2U 2U 2U

LEVEL 4

Map for level 4:
****
***
**
*




xoxo
xoxo
oxox
#Tox
Start with #5

Assault from above is the way to go since there are more items in a row. 8U 
9U 10U 11U 10U 2U 1U

LEVEL 5

Map for level 5:
****
***
**
*




x#To
#Tox
#Tox
#Tox
Start with #5

Nothing quick here but the solution's not too painful.

8U 9U 10U 11U
8U 9U 10U 11U
8U 9U 10U 11U
8U

LEVEL 6

Map for level 6:
*****
**
*





TT##
ooTT
Txxx
o#Tx
Start with #4

Marginally tougher. The first two moves are forced or you reach a quick dead 
end. Note you can't go 8U until you can "see" a red. This cuts down 
possibilities further.

4U 11U 1U(2U is a move slower) 2U 1U 4U 2U 2U

LEVEL 7

Map for level 7:
****
***
**
*




x##T
TxxT
TTT#
oxoT
Start with #3

Don't be too greedy when you see a row to take out.

11U 4U 3U 11U(get rid of the stray blue) 2U 1U 2U

LEVEL 8

Map for level 8:
****
***
**
*




##xx
T##T
TToo
oT##
Start with #2

More just setting up rows of equal blocks and letting it fly where it makes 
sense.

4U 1U 2U 3U 2U 1U 3U

LEVEL 9

Map for level 9:
****
***
**
*




TT#x
oTxT
To#o
#xTo
Start with #4

The first move is clear and then the
10U 11U 4U 1U 9U(greens are a dead end) 1U 1U 2U 3U 2U

LEVEL 10

Map for level 10:
****
***
*
*




xoTo
o##o
Txoo
x#To
Start with #1

Picking off the 4-column leads to a dead end. Though there are a lot of ways 
to go wrong the right solution can be stumbled on--there are actually a lot 
of combniations that get to it.

1U 4U 11U 2U 5U 1U 1U 2U 9U 1U 3U

Flipull kicks a zap-block off th left edge and a triple-size blue triangle 
block comes down just left.

LEVEL 11

Map for level 11:
****
**
**
*




oxxT
oxo#
oT##
Tooo
Start with #3

4U 9U 10U 8U 10U 3U 1U 1U9

LEVEL 12

Map for level 12:
****
***
*
*




##T#
#To#
#Tx#
To#T
Start with #4

Here you want to save a green block in the corner you could have picked off 
for later.

5U 1U 11U 10U 4U 9U 8U 1U 2U

LEVEL 13

Map for level 13:
****
**
**
*




ooxx
TTxT
Tox#
TTTT
Start with #2

That bottom row is tempting but...not at first!

4U 5U 3U 4U 9U 1U 10U 9U 8U 10U

LEVEL 14

Map for level 14:
****
***
**
*




oxT#
TxTx
To#x
#xxT
Start with #3

10U 11U 9U 8U 1U 9U 1U 2U 1U

LEVEL 15

Map for level 15:
****
***
*
*




T#T#
####
Tooo
x#oo
Start with #5

3U 4U 9U 1U 9U 1U 1U 2U

LEVEL 16

Map for level 16:
****
***
**
*




#ooT
xoTo
o#oo
TT##
Start with #3

4U 9U 1U 10U 11U 2U 1U 3U

LEVEL 17

Map for level 17:
****
***
**
*




oTTx
ox#T
To#x
#TxT
Start with #5

5U 9U 4U 9U 8U 1U 1U 9U 8U 2U 1U 10U 9U 1U

LEVEL 18

Map for level 18:
****
***
**
*




oTTx
ox#T
To#x
#TxT
Start with #5

3U gets you in a trap where you have a single blue blocking a bunch of other 
blocks. So...

9U 4U 5U 9U 8U 1U 5U 1U 1U 10U 1U

LEVEL 19

Map for level 19:
****
***
**
*




xoxx
oToo
oT##
xTTx
Start with #2

8 loses quickly as does 1. Don't try to bite off too much here at once.

4U 10U 2U 11U 5U(4U actually loses) 1U 3U 9U 3U 1U 3U 2U

LEVEL 20

Map for level 20:
****
***
**
*




oox#
#oxx
TToT
#oTo
Start with #4

4U 3U 4U 10U 8U 11U 4U 2U 1U 4U

LEVEL 21

Map for level 21:
****
***
*
*




To#x
#xxx
oT#T
#oTo
Start with #1

1U loses quickly(1 9 11 3 or 5 4) so:

9U 3U (11U 8U 4U loses) 1U 4U 3U 2U 9U 11U 8U 1U 9U

LEVEL 22

Map for level 22:
****
***
**
*




x##x
oxoo
T#oT
xTT#
Start with #2

5U 3U 3U 1U 1U 4U 3U 2U 4U 1U 2U

LEVEL 23

Map for level 23:
****
***
**
*




xx#T
#oo#
To#o
T#x#
Start with #3

Best to knock off the two X's at once.

11U 10U 2U 1U 4U 10U 9U 2U 1U 2U 1U

LEVEL 24

Map for level 24:
****
***
**
*




oTox
ooT#
xoo#
##TT
Start with #1

10U 1U 1U 5U 2U 3U 1U 3U 2U

LEVEL 25

Map for level 25:
****
***
**
*




ooo#
##o#
T#oT
##x#
Start with #5

5U 3U 4U 2U 4U 9U 11U 3U

LEVEL 26

Map for level 26:
****
***
*
*



xxxxx
xxxTx
ox#Tx
TxTxx
Txoox
Start with #5

If you can zap a few rows in succession it's rather easy.

12U 10U 5U 1U 11U 3U 1U

LEVEL 27

Map for level 27:
****
***
**
*



xxxxx
xT#xx
xooxx
xxxxx
oooox
Start with #2

12U 5U 1U 11U 1U 1U

LEVEL 28

Map for level 28:
****
***
*
*



To###
Txooo
Txxxx
Toxxx
T#xxx
Start with #5

So many ways to get close, so few to close the deal.
9U 2U 9U 1U 3U 2U 1U 5U

LEVEL 29

Map for level 29:
****
**
**
*



TTTTT
TTTxT
TxTT#
TxoTT
#TTTT
Start with #3

5U 3U 1U 12U 9U 3U 9U 10U 9U 1U

LEVEL 30

Map for level 30:
****
***
**
*



ooTxo
xooTx
TxooT
###o#
T#oox
Start with #1

6U 11U

3U 4U 1U 4U

3U 11U 12U 2U 10U 9U 1U 2U 9U

Blob shuffles under block, hits it underneath and a power up appears Mario 
style.

LEVEL 31

Map for level 31:
****
***
**
*



Txo#x
T#xo#
Txoxo
T##ox
TTox#
Start with #2

Clear out a path to the bottom and attack from the top.

5U 4U 3U 2U

3U 2U 1U 9U 2U 2U 1U

10U 9U 10U 9U 1U 5U

LEVEL 32

Map for level 32:
****
***
**
*



xTTo#
o#oo#
oTxxx
xTTTT
#T#xx
Start with #3

9U 4U 5U 9U 2U

1U 2U 1U 1U 5U 10U 3U

LEVEL 33

Map for level 33:
****
***
**
*



xTTo#
o#oo#
oTxxx
xTTTT
#T#xx
Start with #3

3U 1U 6U 3U 2U 3U 6U 4U 6U 2U 11U 4U 6U 1U 3U 1U 2U 3U 9U 1U 2U 1U

LEVEL 34

Map for level 34:
****
***
**
*



xT#Tx
#xT#T
TTxxT
ooooT
x#xxo
Start with #2

5U 12U 2U

2U 12U 5U 9U 2U 4U 10U 2U 3U 9U 11U

LEVEL 35

Map for level 35:
****
***
*
*



oTTTx
xToTT
#T#oT
TxooT
#TooT
Start with #2

5U 12U 10U 5U 4U 11U 6U 5U 2U 3U 2U 1U 3U 2U

LEVEL 36

Map for level 36:
****
***
**
*



oxT#T
TTTTT
#oxT#
#####
T#xoT
Start with #3

4U 2U

1U 4U 2U 9U 8U 1U 10U 9U 11U

LEVEL 37

Map for level 37:
*****
**
*




x#TxT
#oTxx
o##oo
x#Txx
TxToo
Start with #2

(pipe)

4U 11U 2U 4U 1U 4U 10U 9U 2U 4U 1U 11U 9U 1U

Map for level 38:
****
***
**
*



o#oTx
xxToT
##TTx
To##x
TTxoT
Start with #2

2U 9U 2U 9U 5U 3U 5U 9U 12U 4U 1U 11U 4U 10U 1U

Map for level 39:
****
***
**
*



xo#xT
#To#o
#xTox
oxoxo
###TT
Start with #2

3U 2U 5U 4U 2U 4U 2U 4U 10U 11U 1U 2U 9U 5U 2U 9U 2U

Map for level 40:
****
***
*
*



##Txx
##T##
xxT#o
ooT#x
#xT#x
Start with #5

1U 6U 4U 6U 2U 9U 4U 5U 12U 11U 9U 2U 5U 1U 4U 3U 11U 9U 1U 3U

Map for level 41:
****
**
**
*



ToTx#
#oox#
oxTTo
###Tx
xTxTx
Start with #1

Map for level 42:
****
***
**
*



xxxxo
#ToxT
To#x#
oTTxT
x####
Start with #4

1U 5U 2U 10U 3U 4U 12U 9U 3U 4U 10U 11U 3U 1U 9U

Map for level 43:
****
***
**
*



#ooxT
x#oox
oxTo#
T##ox
x##TT
Start with #1

9U 3U 9U 2U 4U 4U 9U 11U 10U 12U 10U 5U 3U 1U 3U 9U 3U 10U 1U 2U

Map for level 44:
****
***
**
*



#xoxo
xoToT
##TxT
oo#ox
oxToT
Start with #3

1U 4U 2U 5U 3U 12U 11U 1U 2U 10U 3U 3U 2U 4U 2U 1U 2U

Map for level 45:
****
***
*
*



xTTTo
To##T
Txxx#
#T#T#
o#xxx
Start with #2

1U 1U 11U 1U 6U 9U 2U 1U 5U 4U 9U 1U 9U 2U 1U 2U

Map for level 46:
*****
**
*



xxo###
xxoooo
xxo###
xxTTTT
#T####
#x####
Start with #4

Of course, you always get the biggest bonuses for the silliest stages.
1U 10U 2U 6U 1U 1U 1U 1U 11U

Map for level 47:
****
**
**
*


##xxTT
xx#TTT
xooooo
Txxooo
###xxx
Tox###
Start with #4

1U 1U 5U 10U 1U 4U 1U 1U 4U 3U 1U 5U 3U 4U 4U 10U 1U 9U 3U

Map for level 48:
*****
**
*



Too#Tx
xxxx#x
TT##xx
#xxxx#
T##x##
oTTT##
Start with #2

Map for level 49:
****
***
**
*


TTxxxo
#xToxo
TxxoTx
xTTTxo
xo##xT
xooox#
Start with #2

4U 2U 5U 2U 8U 1U 3U 8U 3U 8U 5U 8U 5U 9U 12U 2U 11U 12U 2U 1U 2U 9U 10U 1U

Map for level 50:
****
***
**
*


oTxTxx
#xox#x
ooooxT
x#To##
TTxTT#
oo#oT#

Start with #2

5U 1U 3U 1U 8U 1U 2U 2U 8U 2U 9U 2U 5U 11U 5U 10U 11U 5U 10U 1U 3U 1U 4U 2U 
9U 10U 3U 9U

The orange blob and his love(purple bow) drift together in the orange sunset. 
They try to hug, sort of, and wing up getting braided together. There's a big 
purple heart above them. It reminds me of those weird amoeba slides you used 
the microscope on in biology.

Amusing Japlish below:

"Congraturation!" (very weird as Congratulations is spelled right when you 
win each level)
"Directed of software"
"Charactor designer"

Oh, and if you wait long enough you get "Game Over" and a little "downer" 
tune.

  5. NORMAL

You'll probably get a bad shake eventually so it's not worth getting too hot 
under the collar. If you "just make" a level(ie exactly the blocks needed to 
clear it) you may get a level with fruits etc. with double the points next 
round.

All you can really do is look 2-3 moves ahead and make sure there are no 
disasters. Also if there are a lot of one type of square buried in the 
structure, try to pick away to get there ASAP. Having an imbalance of types 
is bad.

However a temporary one caused by getting a lot in a row is no problem, and 
if you can set up several of one block in a row by knocking out other colors 
then do so. Don't worry about perfection either.

After level 10 you bash a power square against a pipe and the power square 
lands on you.

After level 30 you throw a power square at a triangle piece and it grows legs 
and runs away. You bounce after.

Level 50: see Advance Mode, but no "game over."

Then the cut scenes repeat every 50 levels. I may add details here later.

  6. CHEAT CODES

This is where the RAM maps in FCEU. You may find it useful for cheats or 
tinkering around.
x40-x6f have the map for the level. The first 6 of 8 bytes store the blocks, 
and you have 8 rows of 8.
xf2 tells what level you're on, minus one. Fiddle with it just after you 
complete a level to get somewhere tough if you want. Remember (tough level)-
2! You should have enough time to type the level in, and you can make a save 
state right there just to muck around.
xc8-xce are the bytes for your score. Each byte represents a digit, with c8 
being millions and ce being ones.
x8d1 and x8d2 are low and high bytes for time.
x440-444 have information on the walls and how they are spread out.
xed tells how many powerups you have left. If you give >9 some garbage 
appears.
x128 tells how many continues you have.

If you use save states you can jiggle the controls between levels to get a 
different random set in normal mode.

End of FAQ Proper

================================

  7. VERSIONS

1.0.0: sent to GameFAQs 8/19/2006 with walkthrough of "advance" complete
todo: rewrite my algorithm so I can track the best score, best moves

  8. CREDITS

Thanks to CJayC as usual for such a great site and, though I hate to admit 
it, the people who write for more popular games so that these old school FAQs 
can be hosted for free.
Thanks to the usual GameFAQs gang. They know who they are, and you should, 
too, because they get some SERIOUS writing done. Good people too--bloomer, 
falsehead, Sashanan, Masters, Retro, Snow Dragon/Brui5ed Ego, ZoopSoul, 
BSulpher(thanks for the encouragement on this particular guide) and others I 
forgot. OK, even Hydrophant in his current not-yet-banned message board 
incarnation.
Thanks to the fceuxd programming group who let me try all sorts of new things 
to make this FAQ more detailed.
Thanks to the NES, GB and GBC completion project people. You all are a great 
inspiration.

Algorithm brewed with finest microchips and fastest processors.
Flipull: An Exciting Cube Game: FAQ/Walkthrough by ASchultz
Version: 1.0.0 | Last Updated: 2006-08-19 | View/Download Original File Hosted by GameFAQs
Return to Flipull: An Exciting Cube Game (NES) FAQs & Guides 