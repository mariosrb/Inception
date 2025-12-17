const http = require('http');
const os = require('os');

const port = 3000;

// Fonction utilitaire pour convertir l'uptime en format lisible
function formatUptime(uptime) {
    const hours = Math.floor(uptime / 3600);
    const minutes = Math.floor((uptime % 3600) / 60);
    const seconds = Math.floor(uptime % 60);
    return `${hours}h ${minutes}m ${seconds}s`;
}

const requestHandler = (request, response) => {
  console.log(`[INFO] Requête reçue : ${request.url}`);

  // Récupération des infos système dynamiques
  const hostname = os.hostname();
  const type = os.type();
  const arch = os.arch();
  const cpus = os.cpus().length;
  const memory = (os.totalmem() / (1024 * 1024 * 1024)).toFixed(2);
  const uptime = formatUptime(os.uptime());

  // Contenu HTML/CSS intégré (Single File Component)
  const htmlContent = `
    <!DOCTYPE html>
    <html lang="fr">
    <head>
        <meta charset="UTF-8">
        <title>Inception Bonus - Node.js</title>
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Share+Tech+Mono&display=swap');

            body {
                font-family: 'Share Tech Mono', monospace;
                background-color: #0d0d0d;
                color: #00ff41;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
                overflow: hidden;
            }
            .container {
                border: 1px solid #00ff41;
                padding: 40px;
                box-shadow: 0 0 20px rgba(0, 255, 65, 0.2);
                background: rgba(0, 20, 0, 0.8);
                width: 500px;
                position: relative;
            }
            .container::before {
                content: "SYSTEM_STATUS: ONLINE";
                position: absolute;
                top: -10px;
                left: 20px;
                background: #0d0d0d;
                padding: 0 10px;
                font-size: 0.8em;
            }
            h1 {
                text-align: center;
                border-bottom: 1px solid #00ff41;
                padding-bottom: 20px;
                margin-top: 0;
                text-transform: uppercase;
                letter-spacing: 2px;
            }
            .grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px;
                margin-top: 20px;
            }
            .item {
                border-left: 2px solid #003300;
                padding-left: 10px;
                transition: all 0.3s;
            }
            .item:hover {
                border-left: 2px solid #00ff41;
                background: rgba(0, 255, 65, 0.05);
            }
            .label {
                font-size: 0.8em;
                color: #008f11;
                display: block;
            }
            .value {
                font-size: 1.1em;
                font-weight: bold;
            }
            .footer {
                margin-top: 30px;
                text-align: center;
                font-size: 0.7em;
                color: #005500;
                border-top: 1px dashed #003300;
                padding-top: 10px;
            }
            .blink { animation: blinker 1s linear infinite; }
            @keyframes blinker { 50% { opacity: 0; } }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>MONITORING NODE<span class="blink">_</span></h1>

            <div class="grid">
                <div class="item">
                    <span class="label">HOSTNAME</span>
                    <span class="value">${hostname}</span>
                </div>
                <div class="item">
                    <span class="label">ARCHITECTURE</span>
                    <span class="value">${arch}</span>
                </div>
                <div class="item">
                    <span class="label">OS TYPE</span>
                    <span class="value">${type}</span>
                </div>
                <div class="item">
                    <span class="label">CPU CORES</span>
                    <span class="value">${cpus}</span>
                </div>
                <div class="item">
                    <span class="label">MEMORY</span>
                    <span class="value">${memory} GB</span>
                </div>
                <div class="item">
                    <span class="label">UPTIME</span>
                    <span class="value">${uptime}</span>
                </div>
            </div>

            <div class="footer">
                SERVED VIA NGINX REVERSE PROXY<br>
                PORT 3000 -> 443
            </div>
        </div>
    </body>
    </html>
  `;

  response.setHeader('Content-Type', 'text/html; charset=utf-8');
  response.writeHead(200);
  response.end(htmlContent);
};

const server = http.createServer(requestHandler);

server.listen(port, (err) => {
  if (err) {
    return console.log('FATAL ERROR:', err);
  }
  console.log(`Server is listening on port ${port}`);
});
