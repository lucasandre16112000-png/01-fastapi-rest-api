# API Profissional de Gerenciamento de Tarefas

Uma API robusta e de nível enterprise para gerenciar usuários e tarefas, construída com FastAPI e as melhores práticas de desenvolvimento de software.

[![Python Version](https://img.shields.io/badge/python-3.9%2B-blue.svg)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.104.1-blue.svg)](https://fastapi.tiangolo.com/)
[![SQLAlchemy](https://img.shields.io/badge/SQLAlchemy-2.0-blue.svg)](https://www.sqlalchemy.org/)
[![Pytest](https://img.shields.io/badge/pytest-7.4.3-blue.svg)](https://docs.pytest.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/licenses/MIT)

---

## 🌟 Visão Geral

Esta API foi desenvolvida para ser um exemplo de como construir um serviço web moderno, seguro e escalável em Python. Ela oferece funcionalidades completas de CRUD (Create, Read, Update, Delete) para tarefas, autenticação de usuários baseada em JWT, e uma arquitetura de projeto profissional que separa as responsabilidades em módulos bem definidos.

## ✨ Features

- **Autenticação JWT**: Segurança baseada em tokens para proteger os endpoints.
- **Banco de Dados com SQLAlchemy**: Interação com o banco de dados de forma assíncrona e segura.
- **Validação de Dados com Pydantic**: Modelos de dados robustos e validação automática.
- **Arquitetura Profissional**: Código organizado em `routers`, `models`, `schemas`, `crud`, e `core`.
- **Testes Unitários e de Integração**: Cobertura de testes completa com `pytest` para garantir a qualidade e a estabilidade do código.
- **Configuração por Ambiente**: Gerenciamento de configurações sensíveis através de variáveis de ambiente (`.env`).
- **Documentação Automática**: Interface do Swagger UI e ReDoc gerada automaticamente pelo FastAPI.
- **Compatibilidade Cross-Platform**: Funciona perfeitamente no Windows, Linux e macOS.

## 🚀 Começando

Siga os passos abaixo para configurar e rodar o projeto em seu ambiente local.

### Pré-requisitos

- Python 3.9 ou superior
- `pip` e `venv`

> **Para usuários do Windows**: Veja o [Guia de Instalação Windows](./WINDOWS_SETUP.md) para instruções detalhadas e scripts de automação.

### 1. Clone o Repositório

```bash
git clone https://github.com/lucasandre16112000-png/01-fastapi-rest-api.git
cd 01-fastapi-rest-api
```

### 2. Crie e Ative o Ambiente Virtual

É uma boa prática usar um ambiente virtual para isolar as dependências do projeto.

**No Linux/macOS:**
```bash
python3 -m venv venv
source venv/bin/activate
```

**No Windows (Prompt de Comando):**
```bash
python -m venv venv
venv\Scripts\activate.bat
```

**No Windows (PowerShell):**
```bash
python -m venv venv
venv\Scripts\Activate.ps1
```

> **Dica**: Se receber erro de permissão no PowerShell, execute:
> ```bash
> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```

### 3. Instale as Dependências

```bash
pip install -r requirements.txt
```

### 4. Configure as Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto, copiando o exemplo `.env.example`:

```bash
copy .env.example .env
```

Edite o arquivo `.env` e atualize os valores conforme necessário:

```
SECRET_KEY=seu_segredo_super_secreto
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
```

> **Importante**: Substitua `seu_segredo_super_secreto` por uma chave secreta forte e única.

### 5. Rode a Aplicação

Com tudo configurado, inicie o servidor Uvicorn:

```bash
uvicorn app.main:app --reload
```

A API estará disponível em `http://127.0.0.1:8000`.

## 📚 Documentação da API

Após iniciar a aplicação, você pode acessar a documentação interativa gerada automaticamente pelo FastAPI:

- **Swagger UI**: [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)
- **ReDoc**: [http://127.0.0.1:8000/redoc](http://127.0.0.1:8000/redoc)

## ✅ Rodando os Testes

Para garantir que tudo está funcionando como esperado, rode a suíte de testes com `pytest`:

```bash
pytest
```

Ou com mais detalhes:

```bash
pytest -v
```

## 📂 Estrutura do Projeto

A arquitetura do projeto foi desenhada para ser modular e escalável:

```
01-fastapi-rest-api/
├── app/                    # Código principal da aplicação
│   ├── __init__.py
│   ├── core/              # Configurações centrais e segurança
│   │   ├── __init__.py
│   │   ├── config.py      # Gerenciamento de configurações
│   │   └── security.py    # Funções de hashing e JWT
│   ├── crud.py            # Funções de interação com o banco de dados (CRUD)
│   ├── database.py        # Configuração da conexão com o banco de dados
│   ├── dependencies.py    # Dependências reutilizáveis (ex: autenticação)
│   ├── main.py            # Ponto de entrada da aplicação FastAPI
│   ├── models.py          # Modelos de dados SQLAlchemy
│   ├── routers/           # Endpoints da API
│   │   ├── __init__.py
│   │   ├── tasks.py       # Endpoints para tarefas
│   │   └── users.py       # Endpoints para usuários e autenticação
│   ├── schemas.py         # Schemas Pydantic para validação de dados
│   └── tests/             # Testes unitários e de integração
│       ├── __init__.py
│       ├── test_main.py
│       ├── test_tasks.py
│       └── test_users.py
├── venv/                  # Ambiente virtual (criado automaticamente)
├── .env                   # Variáveis de ambiente (crie a partir de .env.example)
├── .env.example           # Exemplo de variáveis de ambiente
├── requirements.txt       # Dependências do projeto
├── main.py               # Ponto de entrada alternativo
├── run.bat               # Script para executar no Windows (Prompt de Comando)
├── run.ps1               # Script para executar no Windows (PowerShell)
├── setup.bat             # Script de setup inicial para Windows
├── README.md             # Documentação principal
└── WINDOWS_SETUP.md      # Guia detalhado para Windows
```

## 🪟 Compatibilidade Windows

Este projeto foi otimizado para funcionar perfeitamente no Windows! Recursos incluem:

- ✅ Caminhos de arquivo cross-platform (usando `pathlib`)
- ✅ Scripts batch e PowerShell para automação
- ✅ Guia detalhado de instalação para Windows
- ✅ Suporte completo a variáveis de ambiente

Veja [WINDOWS_SETUP.md](./WINDOWS_SETUP.md) para mais detalhes.

## 🔐 Segurança

**IMPORTANTE**: Antes de colocar em produção:

1. **Gere uma SECRET_KEY forte**:
   ```bash
   python -c "import secrets; print(secrets.token_urlsafe(32))"
   ```

2. **Atualize o arquivo `.env`** com a chave gerada

3. **Nunca** compartilhe o arquivo `.env` ou a `SECRET_KEY`

---

_Desenvolvido por Lucas André S com as melhores práticas de desenvolvimento de software em Python._
