const mongoose = require('mongoose');

const TournamentSchema = new mongoose.Schema({
  name: { type: String, required: true },
  numberOfTeams: { type: Number },
  createdAt: { type: Date, default: Date.now },
  teams: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Team' }]
});

module.exports = mongoose.model('Tournament', TournamentSchema);
