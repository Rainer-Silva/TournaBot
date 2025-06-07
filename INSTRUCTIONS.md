# TournaBot – Local Development Setup Instructions

The Discord-native tournament bot for Pro Clubs and beyond.

## 📦 Prerequisites
- Node.js (v18+)
- Git
- A MongoDB Atlas account (free tier is enough)
- A Discord Developer account

## 🧱 1. Clone the Repository
```bash
git clone https://github.com/Rainer-Silva/TournaBot.git
cd TournaBot
```

## 📁 2. Install Dependencies
```bash
npm install
```

## 🔐 3. Create a .env File
Inside the root folder, create a `.env` file and paste the following:

```
DISCORD_TOKEN=your-discord-bot-token
CLIENT_ID=your-discord-application-id
MONGO_URI=your-mongodb-connection-uri
```

💡 You can get these values from:

- Discord Developer Portal
- MongoDB Atlas Dashboard

## 🤖 4. Run the Bot
```bash
node index.js
```
Or if using nodemon:
```bash
npx nodemon index.js
```

## ✅ 5. Invite the Bot to Your Server
Use this link template to invite the bot (replace `CLIENT_ID`):
```
https://discord.com/oauth2/authorize?client_id=CLIENT_ID&scope=bot+applications.commands&permissions=277025508352
```

## 🧪 Slash Commands in Phase 1
These are the core commands for the MVP:
- `/create-tournament`
- `/register-team`
- `/list-teams`

(more coming soon...)

## 🧠 Coming Soon
- `/draw-groups`
- Group channel auto-creation
- Knockout pairings
- Match reporting
