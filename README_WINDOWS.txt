================================================================================
                    FASTAPI - GUIA WINDOWS
================================================================================

⭐ LEIA ISSO PRIMEIRO!

================================================================================
PASSO 1: EXTRAIR O ZIP
================================================================================

IMPORTANTE: NAO execute nenhum arquivo .bat DENTRO DO ZIP!

Siga estes passos:

1. Localize o arquivo ZIP que voce baixou
2. Clique com botao DIREITO nele
3. Selecione "Extrair tudo..."
4. Escolha um local PERMANENTE:
   - Desktop
   - Documents
   - C:\Projetos\
   - OU qualquer pasta fixa (NAO use Temp!)
5. Clique em "Extrair"
6. Aguarde a extracao completar (pode levar alguns segundos)

================================================================================
PASSO 2: ABRIR A PASTA EXTRAIDA
================================================================================

Apos a extracao, uma janela abrira automaticamente.

Se nao abrir:
1. Navegue ate o local onde voce extraiu
2. Procure pela pasta "01-fastapi-rest-api"
3. Abra essa pasta

================================================================================
PASSO 3: INICIAR A API
================================================================================

Dentro da pasta "01-fastapi-rest-api", voce vera varios arquivos.

Clique DUAS VEZES em:
   COMECE_AQUI.bat

Pronto! O script fara tudo automaticamente:
- Verifica Python
- Cria ambiente virtual
- Instala dependencias
- Inicia a API
- Abre o navegador

================================================================================
PASSO 4: USAR A API
================================================================================

Quando a API iniciar, voce vera:

   API: http://127.0.0.1:8000
   Docs: http://127.0.0.1:8000/docs

O navegador abrira automaticamente em:
   http://127.0.0.1:8000/docs

Essa eh a documentacao interativa (Swagger). Voce pode testar todos os
endpoints diretamente nela!

Para parar a API:
   Pressione CTRL+C na janela do terminal

================================================================================
REQUISITOS
================================================================================

- Windows 7 ou superior
- Python 3.9 ou superior
- Conexao com a internet (para instalar dependencias)

Se nao tem Python instalado:
1. Visite: https://www.python.org/downloads/
2. Baixe Python 3.9 ou superior
3. Execute o instalador
4. IMPORTANTE: Marque "Add Python to PATH"
5. Clique em "Install Now"
6. Aguarde completar
7. Reinicie o computador
8. Tente novamente

================================================================================
PROBLEMAS COMUNS
================================================================================

PROBLEMA: "Python nao encontrado"
SOLUCAO:
   1. Instale Python (veja acima)
   2. Reinicie o computador
   3. Tente novamente

PROBLEMA: "requirements.txt nao encontrado"
SOLUCAO:
   1. Voce nao extraiu o ZIP corretamente
   2. Volte ao PASSO 1 e extraia novamente
   3. Certifique-se de extrair TODOS os arquivos

PROBLEMA: "Falha ao instalar dependencias"
SOLUCAO:
   1. Verifique sua conexao com a internet
   2. Tente novamente
   3. Se persistir, delete a pasta "venv" e tente novamente

PROBLEMA: "Acesso negado"
SOLUCAO:
   1. Execute como Administrador
   2. Clique direito em COMECE_AQUI.bat
   3. Selecione "Executar como administrador"

PROBLEMA: Nada funciona!
SOLUCAO:
   1. Clique em DIAGNOSTICO.bat
   2. Leia as mensagens de erro
   3. Siga as solucoes sugeridas

================================================================================
ARQUIVOS IMPORTANTES
================================================================================

COMECE_AQUI.bat      - Clique aqui para iniciar (PRINCIPAL)
INICIAR.bat          - Alternativa para iniciar
DIAGNOSTICO.bat      - Para diagnosticar problemas
README_WINDOWS.txt   - Este arquivo
LEIA-ME-PRIMEIRO.txt - Mais informacoes
README.md            - Documentacao completa

================================================================================
DICAS
================================================================================

1. Sempre extraia o ZIP ANTES de executar qualquer arquivo .bat

2. Use um local permanente (Desktop, Documents, etc)
   NAO use pastas temporarias

3. Se algo nao funcionar, clique em DIAGNOSTICO.bat

4. Mantenha a janela do terminal aberta enquanto usa a API

5. Para parar a API, pressione CTRL+C

6. Para iniciar novamente, clique em COMECE_AQUI.bat

================================================================================
SUPORTE
================================================================================

Repositorio GitHub:
https://github.com/lucasandre16112000-png/01-fastapi-rest-api

Documentacao completa:
README.md

Diagnostico:
DIAGNOSTICO.bat

================================================================================
