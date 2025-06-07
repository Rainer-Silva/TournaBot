require('dotenv').config();
const { REST, Routes, SlashCommandBuilder } = require('discord.js');

const commands = [
  new SlashCommandBuilder()
    .setName('create-tournament')
    .setDescription('Create a new tournament'),
  new SlashCommandBuilder()
    .setName('register-team')
    .setDescription('Register a new team for the tournament'),
  new SlashCommandBuilder()
    .setName('list-teams')
    .setDescription('List all registered teams')
].map(command => command.toJSON());

const rest = new REST({ version: '10' }).setToken(process.env.DISCORD_TOKEN);
const GUILD_ID = '1075743215598174208';

(async () => {
  try {
    console.log('Started refreshing guild (/) commands.');
    await rest.put(
      Routes.applicationGuildCommands(process.env.CLIENT_ID, GUILD_ID),
      { body: commands }
    );
    console.log('Successfully reloaded guild (/) commands.');
  } catch (error) {
    console.error(error);
  }
})();
