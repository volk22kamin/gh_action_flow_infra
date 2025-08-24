import express from 'express';
import mongoose from 'mongoose';
import cors from 'cors';

import todoRoutesV2 from './routes/v2/todos.js';
import { Todo } from './models/Todo.js';
import { uri } from './db.js';


export const app = express();

app.use(cors());
app.use(express.json());

mongoose.connect(uri, {
    useNewUrlParser: true,
    useUnifiedTopology: true
})
.catch(err => {
    console.error('Initial Database connection failed:', err);
});

mongoose.connection.on('error', (err) => {
    console.error('Database connection error:', err);
});

mongoose.connection.once('open', async () => {
    console.log('Database connected successfully.');
});


app.use('/api/v2/todos', todoRoutesV2);

app.get('/health', (req, res) => {
    res.status(200).send('OK');
});
  
if (process.env.NODE_ENV !== 'test') {
    const PORT = 3000;
    app.listen(PORT, () => {
        console.log(`Server running on port ${PORT}`);
    });
}

export { Todo };