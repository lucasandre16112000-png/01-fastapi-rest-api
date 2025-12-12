# 🚀 App 1: API REST Profissional com FastAPI e JWT

Este projeto é um exemplo de uma API REST robusta e segura, construída com **FastAPI**. Ele demonstra as melhores práticas para desenvolvimento de back-end, incluindo autenticação de usuário com **JSON Web Tokens (JWT)**, validação de dados com Pydantic e documentação de API gerada automaticamente via OpenAPI (Swagger UI).

## ✨ Funcionalidades Principais

- **Autenticação de Usuário Completa**: Endpoints para registro (`/auth/register`) e login (`/auth/login`) de usuários.
- **Segurança com JWT**: Proteção de endpoints que exigem que o usuário esteja autenticado, utilizando tokens de acesso Bearer.
- **Validação de Dados Rigorosa**: Modelos Pydantic para garantir que os dados de entrada (requests) e saída (responses) estejam no formato correto.
- **Operações CRUD para Tarefas**: Funcionalidade completa para Criar, Ler, Atualizar e Deletar (CRUD) tarefas associadas a um usuário.
- **Documentação Automática**: Interface interativa do Swagger UI (`/docs`) e ReDoc (`/redoc`) gerada automaticamente pelo FastAPI.

## 🛠️ Tecnologias Utilizadas

| Tecnologia | Versão | Propósito |
| :--- | :--- | :--- |
| **Python** | 3.11+ | Linguagem principal |
| **FastAPI** | 0.104.1 | Framework web de alta performance |
| **Uvicorn** | 0.24.0 | Servidor ASGI para rodar a API |
| **Pydantic** | 2.5.0 | Validação de dados e gerenciamento de configurações |
| **PyJWT** | 2.8.1 | Implementação de JSON Web Tokens (JWT) |

## 📋 Guia de Instalação e Execução (Para Qualquer Pessoa)

Este guia foi feito para que qualquer pessoa, mesmo sem conhecimento técnico, possa executar este projeto.

### Pré-requisitos

Antes de começar, você precisa ter duas ferramentas instaladas no seu computador:

1.  **Git**: Ferramenta para baixar (clonar) o código do GitHub.
    - [**Download do Git aqui**](https://git-scm.com/downloads)
2.  **Python**: A linguagem de programação usada no projeto (versão 3.8 ou superior).
    - [**Download do Python aqui**](https://www.python.org/downloads/)
    - **Importante**: Durante a instalação do Python no Windows, marque a caixa que diz **"Add Python to PATH"**.

### Passo 1: Baixar o Projeto (Clonar)

Abra o seu terminal (ou **Git Bash** no Windows) e use o comando abaixo para baixar o projeto:

```bash
git clone https://github.com/lucasandre16112000-png/01-fastapi-rest-api.git
```

### Passo 2: Entrar na Pasta do Projeto

Agora, navegue para a pasta que você acabou de baixar:

```bash
cd 01-fastapi-rest-api
```

### Passo 3: Criar um Ambiente Virtual

Isso cria uma "caixa" isolada para as bibliotecas do projeto, evitando conflitos com outros projetos. É uma prática recomendada.

```bash
# No Windows
python -m venv venv

# No macOS ou Linux
python3 -m venv venv
```

### Passo 4: Ativar o Ambiente Virtual

Agora, ative o ambiente que você criou:

```bash
# No Windows
.\venv\Scripts\activate

# No macOS ou Linux
source venv/bin/activate
```

Se funcionar, você verá `(venv)` no início da linha do seu terminal.

### Passo 5: Instalar as Bibliotecas do Projeto

Com o ambiente ativado, instale todas as dependências com um único comando:

```bash
pip install -r requirements.txt
```

### Passo 6: Executar a Aplicação

Finalmente, inicie o servidor da API:

```bash
uvicorn main:app --reload
```

O terminal mostrará algo como:

```
INFO:     Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)
```

### Passo 7: Testar a API

O link `http://127.0.0.1:8000` **só funciona na sua máquina local enquanto o servidor estiver rodando**.

1.  Abra seu navegador e acesse [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs).
2.  Você verá a documentação interativa da API.
3.  Use o endpoint `POST /auth/register` para criar um usuário.
4.  Use `POST /auth/login` para obter um token de acesso.
5.  Clique em **"Authorize"** no canto superior direito e cole seu token (no formato `Bearer <seu_token>`) para testar os outros endpoints.

## 🤔 Solução de Problemas Comuns

- **`'uvicorn' não é reconhecido...`**: Certifique-se de que o ambiente virtual (venv) está ativado (Passo 4) e que você instalou as dependências (Passo 5).
- **`'python' ou 'git' não é reconhecido...`**: Certifique-se de que você instalou o Python e o Git e que eles estão no PATH do seu sistema.
- **Erro de "Porta já em uso"**: Se a porta 8000 já estiver sendo usada, você pode rodar em outra porta:
  ```bash
  uvicorn main:app --reload --port 8001
  ```

## 👨‍💻 Autor

Lucas André S - [GitHub](https://github.com/lucasandre16112000-png)
