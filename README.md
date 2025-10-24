# TournaBot

TournaBot is a Discord bot that helps organize football tournaments.

## Setup
1. Install dependencies: `npm install`
2. Create a `.env` file with `DISCORD_TOKEN`, `CLIENT_ID`, and `MONGO_URI` values.
3. Register slash commands with `node registerCommands.js`.
4. Start the bot with `node index.js`.

## Commands
- `/create-tournament` – start the tournament creation flow.
- `/register-team` – register the invoking user as a team in the latest tournament.
- `/list-teams` – list teams registered in the latest tournament.

## Tournament Creation Flow
1. Trigger `/create-tournament`.
2. Enter the tournament name in the modal.
3. A second modal will prompt for the number of teams.
4. Select a channel where the tournament will run.
5. The bot confirms tournament creation in the selected channel.

## Development
The project uses Node.js and MongoDB with Mongoose for storage. Edit `index.js` for bot logic.

## Status Badges
[![Lint Code Base](https://github.com/Rainer-Silva/TournaBot/actions/workflows/super-linter.yml/badge.svg)](https://github.com/Rainer-Silva/TournaBot/actions/workflows/super-linter.yml)
