// models/Todo.js
import mongoose from 'mongoose';

const todoSchema = new mongoose.Schema({
    text: { type: String, required: true },
    completed: { type: Boolean, default: false },
    createdAt: { type: Date, default: Date.now }
});


export const Todo = mongoose.models.Todo || mongoose.model('Todo', todoSchema);