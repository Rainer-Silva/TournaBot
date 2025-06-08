require('dotenv').config();
const { Client, GatewayIntentBits, ModalBuilder, TextInputBuilder, TextInputStyle, ActionRowBuilder, ChannelType, StringSelectMenuBuilder, InteractionType } = require('discord.js');
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
  if (interaction.isChatInputCommand()) {
    try {
      if (interaction.commandName === 'ping') {
        await interaction.reply('Pong!');
      } else if (interaction.commandName === 'create-tournament') {
        // Step 1: ask for tournament name only
        const modal = new ModalBuilder()
          .setCustomId('tournamentNameModal')
          .setTitle('Create Tournament');
        const nameInput = new TextInputBuilder()
          .setCustomId('tournamentName')
          .setLabel('Tournament Name')
          .setStyle(TextInputStyle.Short)
          .setRequired(true);
        modal.addComponents(new ActionRowBuilder().addComponents(nameInput));
        await interaction.showModal(modal);
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
    } catch (error) {
      console.error(error);
      if (interaction.replied || interaction.deferred) {
        await interaction.followUp({ content: 'An error occurred while processing your command.', ephemeral: true });
      } else {
        await interaction.reply({ content: 'An error occurred while processing your command.', ephemeral: true });
      }
    }
  } else if (interaction.type === InteractionType.ModalSubmit && interaction.customId === 'tournamentNameModal') {
    // Step 2: ask for number of teams
    const tournamentName = interaction.fields.getTextInputValue('tournamentName');
    const modal = new ModalBuilder()
      .setCustomId(`numberTeamsModal|${tournamentName}`)
      .setTitle('Number of Teams');
    const teamsInput = new TextInputBuilder()
      .setCustomId('numberOfTeams')
      .setLabel('Number of Teams')
      .setStyle(TextInputStyle.Short)
      .setPlaceholder('Enter a number')
      .setRequired(true);
    modal.addComponents(new ActionRowBuilder().addComponents(teamsInput));
    await interaction.showModal(modal);
  } else if (interaction.type === InteractionType.ModalSubmit && interaction.customId.startsWith('numberTeamsModal|')) {
    // After second modal, prompt for channel selection
    const [_, tournamentName] = interaction.customId.split('|');
    const numberOfTeams = interaction.fields.getTextInputValue('numberOfTeams');
    if (!/^[0-9]+$/.test(numberOfTeams) || parseInt(numberOfTeams) < 2) {
      await interaction.reply({ content: 'Please enter a valid number of teams (minimum 2).', ephemeral: true });
      return;
    }
    // Get all text channels in the guild
    const channels = interaction.guild.channels.cache.filter(c => c.type === ChannelType.GuildText);
    if (!channels.size) {
      await interaction.reply({ content: 'No text channels found in this server.', ephemeral: true });
      return;
    }
    const options = channels.map(c => ({ label: c.name, value: c.id })).slice(0, 25); // Discord max 25 options
    const selectMenu = new StringSelectMenuBuilder()
      .setCustomId(`selectTournamentChannel|${tournamentName}|${numberOfTeams}`)
      .setPlaceholder('Select a channel for the tournament')
      .addOptions(options);
    await interaction.reply({
      content: `Select a channel for **${tournamentName}** (Teams: ${numberOfTeams}):`,
      components: [new ActionRowBuilder().addComponents(selectMenu)],
      ephemeral: true
    });
  } else if (interaction.isStringSelectMenu() && interaction.customId.startsWith('selectTournamentChannel|')) {
    // After channel selection, create tournament
    const [_, tournamentName, numberOfTeams] = interaction.customId.split('|');
    const channelId = interaction.values[0];
    const tournament = new Tournament({ name: tournamentName, numberOfTeams });
    await tournament.save();
    await interaction.update({
      content: `Tournament **${tournamentName}** (Teams: ${numberOfTeams}) created and will run in <#${channelId}>!`,
      components: []
    });
  }
});

client.login(process.env.DISCORD_TOKEN);
