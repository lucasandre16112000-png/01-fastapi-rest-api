#!/usr/bin/env python3
"""
Script para servir a página HTML do testador de API
Executa um servidor HTTP simples na porta 8001
"""

import http.server
import socketserver
import os
from pathlib import Path

PORT = 8001
HANDLER = http.server.SimpleHTTPRequestHandler

class MyHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization')
        super().end_headers()

    def do_OPTIONS(self):
        self.send_response(200)
        self.end_headers()

    def log_message(self, format, *args):
        print(f"[{self.log_date_time_string()}] {format % args}")

if __name__ == "__main__":
    # Mudar para o diretório do projeto
    project_dir = Path(__file__).parent
    os.chdir(project_dir)
    
    with socketserver.TCPServer(("", PORT), MyHTTPRequestHandler) as httpd:
        print(f"""
╔════════════════════════════════════════════════════════════════╗
║           🧪 TESTADOR DE API - SERVIDOR INICIADO              ║
╚════════════════════════════════════════════════════════════════╝

📍 Acesse a página de testes em:
   👉 http://127.0.0.1:{PORT}/api_tester.html

🔗 API está rodando em:
   👉 http://127.0.0.1:8000

📚 Documentação Swagger:
   👉 http://127.0.0.1:8000/docs

⚠️  Certifique-se de que a API está rodando em outro terminal!

Pressione CTRL+C para parar o servidor...
        """)
        
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\n\n✅ Servidor parado com sucesso!")
            exit(0)
