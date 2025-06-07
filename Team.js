const mongoose = require('mongoose');

const TeamSchema = new mongoose.Schema({
  name: { type: String, required: true },
  tournament: { type: mongoose.Schema.Types.ObjectId, ref: 'Tournament' },
  registeredAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Team', TeamSchema);
