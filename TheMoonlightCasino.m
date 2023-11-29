%create a universal balance for every game
%Only choose a value to a maximum of 10000. Our game is not designed
%to handle balances of over 99999 (at least visually). Since the odds of 
%making over $99999 is extremely low (given that games have max bets)
%the edge case is very improbable.
balance = 0;

%calls the function to start the game (This will load for a while
%because looping audio in matlab is likely not possible
%without special downloaded libraries/modules. So we opted for an hour long
%audio file of copyright free lofi music.

% MAKE SURE YOU ARE ON MATLAB R2023B (DICTIONARY SUPPORT UPDATED)
% THIS IS REQUIRED FOR BLACKJACK TO WORK!!!!
firstscreen(balance)
            
%Game explanation:

%This is a brief explanation of what our game includes.
%In the front you'll be greated by a splashscreen that allows you to quit
%or enter (PLEASE USE QUIT TO END THE GAME. THE FIGURE WILL BE DRAWN UNTIL
%YOU CLICK QUIT AND THE MUSIC WILL NOT TERMINATE)

%On the second screen is the casino, if you leave the casino by clicking
%the door button on the top right your balance will be reset to whatever
%balance you set before the game (let's just pretend you went to the bank
%and grabbed more money.

%In the casino are 4 games. Roulette, Slots, Blackjack, and War.

%Roulette has a max bet of 300 per straight bet and some bets allow you to place
%more chips depending if they are outside bets (less payout). This way the
%maximum payout is 1:35 which is 300 x 35 = 10500. Each row bet pays out
%1:3. Even, Odd pays out 1:2 and even does not include the number 0. The other
%bets are just standard payouts you would expect.

%Slots is a game that has 3 wheels and 4 different symbols. You have an
%equal chance of getting every symbol and the payouts are on the gui. The 
%payout is "unfair" but welcome to a Casino! Bet's are fixed at 100 for
%slots per spin.

%Blackjack allows bets in increments of 100 with a max bet of 2000. If you
%don't know how to play blackjack refer to https://bicyclecards.com/how-to-play/blackjack/

%War is less visually appealing but serves as a bonus game for casual play.
%Rules are here: https://bicyclecards.com/how-to-play/war.
%Tap the space bar to fight throw down a card. (Hold Space because the game
%is incredibly long.) and if you win you will earn back whatever bet you
%input. (Technically the only winning game out of all the games since War
%is a real 50/50.)





