# 🧪 Guia de Uso - Testador de API Interativo

## O que é?

O **Testador de API Interativo** é uma página web que permite testar todos os endpoints da API FastAPI com um simples clique, sem precisar de ferramentas externas como Postman ou Insomnia.

## 🚀 Como Usar

### Opção 1: Automática (RECOMENDADA)

No Windows, execute o script que inicia tudo automaticamente:

**Prompt de Comando:**
```bash
start_with_tester.bat
```

**PowerShell:**
```bash
powershell -ExecutionPolicy Bypass -File start_with_tester.ps1
```

Isso irá:
- ✅ Criar o ambiente virtual (se necessário)
- ✅ Instalar dependências (se necessário)
- ✅ Iniciar a API na porta 8000
- ✅ Iniciar o testador na porta 8001
- ✅ Abrir automaticamente no navegador

### Opção 2: Manual

Se preferir iniciar manualmente:

#### Terminal 1 - Iniciar a API:
```bash
python -m venv venv
venv\Scripts\activate.bat
pip install -r requirements.txt
uvicorn app.main:app --reload
```

#### Terminal 2 - Iniciar o Testador:
```bash
venv\Scripts\activate.bat
python serve_tester.py
```

#### Abrir no Navegador:
```
http://127.0.0.1:8001/api_tester.html
```

---

## 📍 URLs Importantes

| Serviço | URL |
|---------|-----|
| **Testador Interativo** | http://127.0.0.1:8001/api_tester.html |
| **API** | http://127.0.0.1:8000 |
| **Documentação Swagger** | http://127.0.0.1:8000/docs |
| **ReDoc** | http://127.0.0.1:8000/redoc |
| **Health Check** | http://127.0.0.1:8000/api/v1/health |

---

## 🧪 Endpoints Disponíveis para Teste

### 1. **Health Check** ✅
- **Método**: GET
- **Descrição**: Verifica se a API está online
- **Autenticação**: Não requerida
- **Teste Rápido**: Clique em "🚀 Testar"

### 2. **Criar Usuário** 👤
- **Método**: POST
- **Descrição**: Cria um novo usuário no sistema
- **Autenticação**: Não requerida
- **Campos**:
  - Email (obrigatório)
  - Senha (obrigatório)
- **Padrão**: `testuser@example.com` / `password123`

### 3. **Login (Obter Token)** 🔐
- **Método**: POST
- **Descrição**: Faz login e obtém um token JWT para autenticação
- **Autenticação**: Não requerida
- **Campos**:
  - Email (obrigatório)
  - Senha (obrigatório)
- **Importante**: Execute este teste ANTES de testar endpoints que requerem autenticação
- **Padrão**: `testuser@example.com` / `password123`

### 4. **Obter Dados do Usuário** 👥
- **Método**: GET
- **Descrição**: Retorna os dados do usuário autenticado
- **Autenticação**: Requerida ✅
- **Pré-requisito**: Execute o teste de Login primeiro

### 5. **Criar Tarefa** ✏️
- **Método**: POST
- **Descrição**: Cria uma nova tarefa
- **Autenticação**: Requerida ✅
- **Campos**:
  - Título (obrigatório)
  - Descrição (opcional)
  - Prioridade (obrigatório, número)
- **Padrão**: "Tarefa de Teste" / "Esta é uma tarefa de teste" / 1

### 6. **Listar Tarefas** 📋
- **Método**: GET
- **Descrição**: Lista todas as tarefas do usuário
- **Autenticação**: Requerida ✅
- **Pré-requisito**: Execute o teste de Login primeiro

### 7. **Obter Tarefa Específica** 🔍
- **Método**: GET
- **Descrição**: Obtém os detalhes de uma tarefa específica
- **Autenticação**: Requerida ✅
- **Campos**:
  - ID da Tarefa (obrigatório)
- **Pré-requisito**: Execute o teste de Login e Criar Tarefa primeiro

### 8. **Atualizar Tarefa** 🔄
- **Método**: PUT
- **Descrição**: Atualiza uma tarefa existente
- **Autenticação**: Requerida ✅
- **Campos**:
  - ID da Tarefa (obrigatório)
  - Novo Título (obrigatório)
  - Nova Descrição (opcional)
  - Nova Prioridade (obrigatório)
- **Pré-requisito**: Execute o teste de Login e Criar Tarefa primeiro

### 9. **Deletar Tarefa** 🗑️
- **Método**: DELETE
- **Descrição**: Deleta uma tarefa
- **Autenticação**: Requerida ✅
- **Campos**:
  - ID da Tarefa (obrigatório)
- **Pré-requisito**: Execute o teste de Login e Criar Tarefa primeiro

---

## 🎯 Fluxo de Teste Recomendado

Para testar todos os endpoints em ordem:

1. **Health Check** ✅
   - Clique em "🚀 Testar"
   - Resultado esperado: `{"status": "healthy"}`

2. **Criar Usuário** 👤
   - Clique em "🚀 Testar" (usa valores padrão)
   - Resultado esperado: Usuário criado com ID

3. **Login** 🔐
   - Clique em "🚀 Testar" (usa valores padrão)
   - Resultado esperado: Token JWT gerado
   - ⚠️ O token é salvo automaticamente para próximos testes

4. **Obter Dados do Usuário** 👥
   - Clique em "🚀 Testar"
   - Resultado esperado: Dados do usuário autenticado

5. **Criar Tarefa** ✏️
   - Clique em "🚀 Testar" (usa valores padrão)
   - Resultado esperado: Tarefa criada com ID

6. **Listar Tarefas** 📋
   - Clique em "🚀 Testar"
   - Resultado esperado: Array com as tarefas do usuário

7. **Obter Tarefa Específica** 🔍
   - Digite o ID da tarefa criada (geralmente 1)
   - Clique em "🚀 Testar"
   - Resultado esperado: Detalhes da tarefa

8. **Atualizar Tarefa** 🔄
   - Digite o ID da tarefa (geralmente 1)
   - Modifique o título/descrição/prioridade
   - Clique em "🚀 Testar"
   - Resultado esperado: Tarefa atualizada

9. **Deletar Tarefa** 🗑️
   - Digite o ID da tarefa (geralmente 1)
   - Clique em "🚀 Testar"
   - Resultado esperado: Tarefa deletada (status 200)

---

## 💡 Dicas Úteis

### Status da API
- 🟢 **Verde**: API está online e funcionando
- 🔴 **Vermelho**: API está offline

### Resultados dos Testes
- ✅ **Verde**: Teste bem-sucedido
- ❌ **Vermelho**: Erro no teste
- ⏳ **Amarelo**: Teste em progresso

### Autenticação
- Alguns endpoints requerem autenticação (token JWT)
- O token é obtido automaticamente ao fazer login
- O token é salvo e reutilizado automaticamente nos próximos testes

### Valores Padrão
- Muitos campos têm valores padrão pré-preenchidos
- Você pode modificar qualquer valor antes de testar
- Clique em "🗑️ Limpar" para resetar aos valores padrão

---

## 🐛 Solução de Problemas

### A página não carrega
- Certifique-se de que o testador está rodando: `python serve_tester.py`
- Verifique a URL: `http://127.0.0.1:8001/api_tester.html`

### Status da API está vermelho (offline)
- Certifique-se de que a API está rodando: `uvicorn app.main:app --reload`
- Verifique se está na porta 8000: `http://127.0.0.1:8000`

### Erro "Not Found" ao testar
- Verifique se o endpoint está correto
- Certifique-se de que a API está rodando
- Verifique se o token é válido (faça login novamente)

### Erro de autenticação
- Execute o teste de Login primeiro
- O token será salvo automaticamente
- Tente novamente após fazer login

### CORS Error
- O servidor do testador já está configurado para permitir CORS
- Se o erro persistir, reinicie o servidor do testador

---

## 📚 Recursos Adicionais

- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [JWT Authentication](https://fastapi.tiangolo.com/advanced/security/oauth2-jwt/)
- [SQLAlchemy ORM](https://docs.sqlalchemy.org/)

---

## ✨ Recursos da Página

- ✅ Interface responsiva (funciona em desktop e mobile)
- ✅ Temas escuros com gradiente
- ✅ Animações suaves
- ✅ Verificação automática de status da API
- ✅ Salvamento automático de tokens
- ✅ Resultados em tempo real
- ✅ Suporte a múltiplos tipos de entrada
- ✅ Validação de campos obrigatórios

---

**Desenvolvido com ❤️ para facilitar testes de API**
