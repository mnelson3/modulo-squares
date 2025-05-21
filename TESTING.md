
# Testing Guide

## Manual Testing
1. Start the app and verify the grid appears with correct size and random values.
2. Move tiles by swiping up/down/left/right and verify modulo logic updates tiles correctly.
3. Verify score increments with each successful move.
4. Increase difficulty with slider and check grid size and values update accordingly.
5. Play until the board is cleared (win) or no moves are left (lose) and verify dialogs appear.
6. Submit a name and check if leaderboard updates with new score.
7. Open leaderboard from AppBar button and verify scores display correctly.
8. Restart the game using the restart button and check state resets.

## Edge Cases
- Try moving tiles when no valid moves exist; verify no change and game ends.
- Submit empty or whitespace names (should not submit).
- Test leaderboard with multiple players and check correct sorting.

## Automated Testing
- Unit tests can be created for modulo logic and move validation (not included here).

