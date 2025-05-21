
# Implementation Guide

## Game Mechanics
- The grid size changes with difficulty: from 4x4 (easy) to 10x10 (hard).
- Each tile holds a random number within a range depending on difficulty.
- Players swipe on a tile to move it in one of four directions.
- Movement happens only if the tile number is less than or equal to the adjacent tile.
- The modulo operation updates the destination tile's value; if remainder is zero, it empties.

## Scoring
- Each successful move increments the score by 1.
- High score is stored locally and updated if surpassed.
- On game end (win or no moves), user can submit their score with a player name.

## Leaderboard
- Scores submitted to Firebase Firestore under collection `modulo_leaderboard`.
- Leaderboard displays top 10 scores sorted descending by score.
- UI allows players to view leaderboard anytime via AppBar button.

