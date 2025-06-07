require('dotenv').config();
const { Client, GatewayIntentBits } = require('discord.js');
const mongoose = require('mongoose');
const Tournament = require('./Tournament');
const Team = require('./Team');

// Connect to MongoDB
mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).then(() => {
  console.log('Connected to MongoDB');
}).catch(err => {
  console.error('MongoDB connection error:', err);
});

// Create a new Discord client
const client = new Client({ intents: [GatewayIntentBits.Guilds, GatewayIntentBits.GuildMessages, GatewayIntentBits.MessageContent] });

client.once('ready', () => {
  console.log(`Logged in as ${client.user.tag}!`);
});

client.on('interactionCreate', async interaction => {
  if (!interaction.isChatInputCommand()) return;

  if (interaction.commandName === 'ping') {
    await interaction.reply('Pong!');
  } else if (interaction.commandName === 'create-tournament') {
    // Prompt for tournament name (for now, use a default or random name)
    const name = `Tournament-${Date.now()}`;
    const tournament = new Tournament({ name });
    await tournament.save();
    await interaction.reply(`Tournament created: **${name}**`);
  } else if (interaction.commandName === 'register-team') {
    // For now, use the user's Discord name as the team name and register to the latest tournament
    const teamName = interaction.user.username;
    const latestTournament = await Tournament.findOne().sort({ createdAt: -1 });
    if (!latestTournament) {
      await interaction.reply('No tournament found. Please create a tournament first.');
      return;
    }
    const team = new Team({ name: teamName, tournament: latestTournament._id });
    await team.save();
    latestTournament.teams.push(team._id);
    await latestTournament.save();
    await interaction.reply(`Team **${teamName}** registered for tournament **${latestTournament.name}**!`);
  } else if (interaction.commandName === 'list-teams') {
    // List teams for the latest tournament
    const latestTournament = await Tournament.findOne().sort({ createdAt: -1 }).populate('teams');
    if (!latestTournament) {
      await interaction.reply('No tournament found. Please create a tournament first.');
      return;
    }
    if (!latestTournament.teams.length) {
      await interaction.reply('No teams registered yet.');
      return;
    }
    const teamList = latestTournament.teams.map(t => t.name).join(', ');
    await interaction.reply(`Teams in **${latestTournament.name}**: ${teamList}`);
  }
});

client.login(process.env.DISCORD_TOKEN);
