const express = require('express');
const axios = require('axios');

const app = express();
const port = 3000;

// Middleware
app.use(express.json());

// Routes
app.get('/chain', async (req, res) => {
    try {
        // Call Service-C
        const serviceCUrl = 'http://service-c:5000/chain';

        let serviceCResponse = 'Service-C call failed';
        try {
            const response = await axios.get(serviceCUrl);
            serviceCResponse = response.data;
        } catch (error) {
            serviceCResponse = `Service-C call failed: ${error.message}`;
        }

        const response = `Service-B (Node.js) → ${serviceCResponse}`;
        res.json(response);

    } catch (error) {
        res.status(500).json({
            error: 'Service-B internal error',
            message: error.message
        });
    }
});

app.get('/health', (req, res) => {
    res.json({ status: 'OK', service: 'service-b', language: 'nodejs' });
});

app.listen(port, () => {
    console.log(`Service-B (Product Service) running on port ${port}`);
});