# 🪟 Guia de Instalação e Execução no Windows

Este guia fornece instruções passo a passo para executar a API FastAPI no Windows.

## ✅ Pré-requisitos

- **Windows 10/11** (ou superior)
- **Python 3.9+** instalado
- **Git** (opcional, para clonar o repositório)

### Verificar se Python está instalado

Abra o **PowerShell** ou **Prompt de Comando** e execute:

```bash
python --version
```

Se você ver uma versão do Python 3.9 ou superior, está tudo bem. Caso contrário, [baixe Python aqui](https://www.python.org/downloads/).

## 📥 Instalação Rápida (Recomendado)

### Opção 1: Usando o Script Batch (Mais Fácil)

1. **Abra o Prompt de Comando** (cmd.exe) ou **PowerShell**
2. **Navegue até o diretório do projeto**:
   ```bash
   cd caminho\para\01-fastapi-rest-api
   ```
3. **Execute o script de setup**:
   ```bash
   setup.bat
   ```

Este script irá:
- ✅ Criar um ambiente virtual
- ✅ Instalar todas as dependências
- ✅ Criar o arquivo `.env` (se não existir)

### Opção 2: Instalação Manual

Se o script não funcionar, siga estes passos:

#### 1. Criar o Ambiente Virtual

```bash
python -m venv venv
```

#### 2. Ativar o Ambiente Virtual

**No Prompt de Comando:**
```bash
venv\Scripts\activate.bat
```

**No PowerShell:**
```bash
venv\Scripts\Activate.ps1
```

Se receber erro de permissão no PowerShell, execute:
```bash
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### 3. Instalar as Dependências

```bash
pip install -r requirements.txt
```

#### 4. Criar o Arquivo .env

```bash
copy .env.example .env
```

Edite o arquivo `.env` e atualize a `SECRET_KEY` se necessário.

## 🚀 Executar a API

### Opção 1: Usando o Script Batch (Recomendado)

```bash
run.bat
```

### Opção 2: Usando o Script PowerShell

```bash
powershell -ExecutionPolicy Bypass -File run.ps1
```

### Opção 3: Manualmente

1. **Ativar o ambiente virtual** (se não estiver ativado):
   ```bash
   venv\Scripts\activate.bat
   ```

2. **Iniciar o servidor**:
   ```bash
   uvicorn app.main:app --reload
   ```

## ✨ Acessar a API

Após iniciar o servidor, acesse:

- **API**: http://127.0.0.1:8000
- **Documentação Swagger**: http://127.0.0.1:8000/docs
- **ReDoc**: http://127.0.0.1:8000/redoc
- **Health Check**: http://127.0.0.1:8000/api/v1/health

## 🧪 Executar os Testes

Com o ambiente virtual ativado:

```bash
pytest
```

Ou com mais detalhes:

```bash
pytest -v
```

## 🔧 Solução de Problemas

### Erro: "python: command not found"

- Python não está instalado ou não está no PATH
- [Baixe e instale Python](https://www.python.org/downloads/)
- **Importante**: Marque a opção "Add Python to PATH" durante a instalação

### Erro: "venv\Scripts\activate.bat: The system cannot find the file specified"

- O ambiente virtual não foi criado
- Execute: `python -m venv venv`

### Erro: "pip: command not found"

- Tente: `python -m pip install -r requirements.txt`

### Erro: "Permission denied" no PowerShell

- Execute: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

### Erro: "ModuleNotFoundError: No module named 'fastapi'"

- O ambiente virtual não está ativado
- Execute o comando de ativação correspondente ao seu shell

### Erro: "Address already in use"

- A porta 8000 já está em uso
- Mude a porta: `uvicorn app.main:app --reload --port 8001`

## 📚 Estrutura do Projeto

```
01-fastapi-rest-api/
├── app/                    # Código principal da aplicação
│   ├── core/              # Configurações e segurança
│   ├── routers/           # Endpoints da API
│   ├── models.py          # Modelos do banco de dados
│   ├── schemas.py         # Schemas Pydantic
│   ├── database.py        # Configuração do banco
│   └── main.py            # Ponto de entrada
├── venv/                  # Ambiente virtual (criado automaticamente)
├── requirements.txt       # Dependências do projeto
├── .env                   # Variáveis de ambiente (crie a partir de .env.example)
├── run.bat               # Script para executar no Windows
├── setup.bat             # Script de setup inicial
└── README.md             # Documentação principal
```

## 🔐 Segurança

**IMPORTANTE**: Antes de colocar em produção:

1. **Gere uma SECRET_KEY forte**:
   ```bash
   python -c "import secrets; print(secrets.token_urlsafe(32))"
   ```

2. **Atualize o arquivo `.env`** com a chave gerada

3. **Nunca** compartilhe o arquivo `.env` ou a `SECRET_KEY`

## 📖 Documentação Adicional

- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [SQLAlchemy Documentation](https://docs.sqlalchemy.org/)
- [Python venv Documentation](https://docs.python.org/3/library/venv.html)

---

**Desenvolvido com ❤️ para Windows**

Se tiver dúvidas ou problemas, consulte o README.md ou abra uma issue no repositório.
