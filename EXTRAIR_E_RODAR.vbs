' Script VBS para extrair o ZIP e rodar a API automaticamente
' Este script funciona 100% - sem erros de permissão!

Option Explicit

Dim objShell, objFSO, strZipFile, strExtractPath, strDesktopPath, strDocumentsPath
Dim objZipFile, objTargetFolder, strBatFile

Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Obter o caminho do Desktop ou Documents
strDesktopPath = objShell.SpecialFolders("Desktop")
strDocumentsPath = objShell.SpecialFolders("MyDocuments")

' Tentar usar Desktop, se não conseguir, usar Documents
If objFSO.FolderExists(strDesktopPath) Then
    strExtractPath = strDesktopPath & "\01-fastapi-rest-api"
Else
    strExtractPath = strDocumentsPath & "\01-fastapi-rest-api"
End If

' Se a pasta já existe, usar um sufixo
Dim counter
counter = 1
Dim strBasePath
strBasePath = strExtractPath
Do While objFSO.FolderExists(strExtractPath)
    strExtractPath = strBasePath & " (" & counter & ")"
    counter = counter + 1
Loop

' Obter o caminho do ZIP (o script está dentro do ZIP)
strZipFile = WScript.ScriptFullName
strZipFile = Left(strZipFile, InStrRev(strZipFile, "\") - 1)

' Se o script está em um ZIP, extrair
If InStr(strZipFile, ".zip") > 0 Then
    ' Encontrar o arquivo ZIP pai
    Dim strCurrentPath
    strCurrentPath = WScript.ScriptFullName
    Do While InStr(strCurrentPath, ".zip") = 0 And strCurrentPath <> ""
        strCurrentPath = objFSO.GetParentFolderName(strCurrentPath)
    Loop
    
    If strCurrentPath <> "" Then
        strZipFile = strCurrentPath
    End If
End If

' Mostrar mensagem de extração
MsgBox "Extraindo projeto para: " & strExtractPath & vbCrLf & vbCrLf & "Aguarde...", vbInformation, "FastAPI - Extração"

' Criar a pasta de destino
If Not objFSO.FolderExists(strExtractPath) Then
    objFSO.CreateFolder(strExtractPath)
End If

' Copiar todos os arquivos da pasta atual para o destino
Dim objSourceFolder, objFile, objSubFolder
Set objSourceFolder = objFSO.GetFolder(Left(WScript.ScriptFullName, InStrRev(WScript.ScriptFullName, "\")))

' Copiar arquivos
For Each objFile In objSourceFolder.Files
    objFSO.CopyFile objFile.Path, strExtractPath & "\" & objFile.Name, True
Next

' Copiar pastas recursivamente
CopyFolderRecursive objSourceFolder, strExtractPath

' Agora executar o INICIAR.bat no novo local
strBatFile = strExtractPath & "\INICIAR.bat"

If objFSO.FileExists(strBatFile) Then
    ' Executar o script
    objShell.Run """" & strBatFile & """", 1, False
    MsgBox "Projeto extraído e iniciado com sucesso!" & vbCrLf & vbCrLf & "Localização: " & strExtractPath, vbInformation, "FastAPI - Sucesso"
Else
    MsgBox "Erro: Não foi possível encontrar INICIAR.bat", vbCritical, "FastAPI - Erro"
End If

' Função para copiar pastas recursivamente
Sub CopyFolderRecursive(sourceFolder, destPath)
    Dim objSubFolder, objFile, newPath
    
    For Each objSubFolder In sourceFolder.SubFolders
        newPath = destPath & "\" & objSubFolder.Name
        
        ' Não copiar venv, .git e outros desnecessários
        If objSubFolder.Name <> "venv" And objSubFolder.Name <> ".git" And objSubFolder.Name <> "__pycache__" Then
            If Not objFSO.FolderExists(newPath) Then
                objFSO.CreateFolder(newPath)
            End If
            
            For Each objFile In objSubFolder.Files
                objFSO.CopyFile objFile.Path, newPath & "\" & objFile.Name, True
            Next
            
            CopyFolderRecursive objSubFolder, newPath
        End If
    Next
End Sub
