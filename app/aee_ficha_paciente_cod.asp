<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Response.Charset = "utf-8"
Response.ContentType = "text/html"
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_log.asp"-->
<%
Function Q(v)
    If IsNull(v) Then v = ""
    Q = "'" & Replace(Trim(CStr(v)), "'", "''") & "'"
End Function

Function N(v)
    v = Trim(CStr(v & ""))
    If v = "" Or Not IsNumeric(v) Then N = "NULL" Else N = CLng(v)
End Function

Function D(v)
    Dim p, dt
    v = Trim(CStr(v & ""))
    If v = "" Then D = "NULL": Exit Function
    p = Split(v, "/")
    If UBound(p) = 2 Then
        On Error Resume Next
        dt = DateSerial(CInt(p(2)), CInt(p(1)), CInt(p(0)))
        If Err.Number = 0 Then
            D = "CONVERT(datetime,'" & Year(dt) & Right("0" & Month(dt),2) & Right("0" & Day(dt),2) & "',112)"
        Else
            D = "NULL"
            Err.Clear
        End If
        On Error GoTo 0
    ElseIf IsDate(v) Then
        dt = CDate(v)
        D = "CONVERT(datetime,'" & Year(dt) & Right("0" & Month(dt),2) & Right("0" & Day(dt),2) & "',112)"
    Else
        D = "NULL"
    End If
End Function

Function SN(v)
    v = UCase(Trim(CStr(v & "")))
    If v = "S" Then SN = "'S'" Else SN = "'N'"
End Function

Sub SalvarFotoPacienteExterno(codPaciente, base64, nomeArquivo, tipoArquivo, usuario)
    Dim cmdFoto, sqlFoto, rsFoto, existeFoto, tamanhoBase64

    If Trim(CStr(base64 & "")) = "" Then Exit Sub

    If Not IsNumeric(codPaciente) Then
        Err.Raise vbObjectError + 200, , "Paciente externo inválido para gravação da foto."
        Exit Sub
    End If

    sqlFoto = "SELECT COUNT(*) AS QTDE FROM AEE_PACIENTE_EXTERNO_FOTO WHERE Cod_Paciente_Externo=" & CLng(codPaciente)
    Set rsFoto = cnn.Execute(sqlFoto)

    existeFoto = 0
    If Not rsFoto.EOF Then existeFoto = CLng(rsFoto("QTDE"))

    rsFoto.Close
    Set rsFoto = Nothing

    tamanhoBase64 = Len(base64)
    If tamanhoBase64 <= 0 Then Exit Sub

    Set cmdFoto = Server.CreateObject("ADODB.Command")
    cmdFoto.ActiveConnection = cnn
    cmdFoto.CommandType = 1

    If existeFoto > 0 Then
        cmdFoto.CommandText = _
            "UPDATE AEE_PACIENTE_EXTERNO_FOTO SET " & _
            "Nome_Arquivo=?, Tipo_Arquivo=?, BASE64=?, usuario_altr=?, data_hora_altr=GETDATE() " & _
            "WHERE Cod_Paciente_Externo=?"

        cmdFoto.Parameters.Append cmdFoto.CreateParameter("@NomeArquivo", 202, 1, 255, Left(nomeArquivo, 255))
        cmdFoto.Parameters.Append cmdFoto.CreateParameter("@TipoArquivo", 200, 1, 100, Left(tipoArquivo, 100))
        cmdFoto.Parameters.Append cmdFoto.CreateParameter("@Base64", 201, 1, tamanhoBase64, base64)
        cmdFoto.Parameters.Append cmdFoto.CreateParameter("@Usuario", 200, 1, 50, Left(usuario, 50))
        cmdFoto.Parameters.Append cmdFoto.CreateParameter("@CodPaciente", 3, 1, , CLng(codPaciente))
    Else
        cmdFoto.CommandText = _
            "INSERT INTO AEE_PACIENTE_EXTERNO_FOTO " & _
            "(Cod_Paciente_Externo,Nome_Arquivo,Tipo_Arquivo,BASE64,usuario_incl,data_hora_incl) " & _
            "VALUES (?,?,?,?,?,GETDATE())"

        cmdFoto.Parameters.Append cmdFoto.CreateParameter("@CodPaciente", 3, 1, , CLng(codPaciente))
        cmdFoto.Parameters.Append cmdFoto.CreateParameter("@NomeArquivo", 202, 1, 255, Left(nomeArquivo, 255))
        cmdFoto.Parameters.Append cmdFoto.CreateParameter("@TipoArquivo", 200, 1, 100, Left(tipoArquivo, 100))
        cmdFoto.Parameters.Append cmdFoto.CreateParameter("@Base64", 201, 1, tamanhoBase64, base64)
        cmdFoto.Parameters.Append cmdFoto.CreateParameter("@Usuario", 200, 1, 50, Left(usuario, 50))
    End If

    cmdFoto.Execute
    Set cmdFoto = Nothing
End Sub

acao = UCase(Trim(Request.Form("acao")))
intCodigo = Trim(Request.Form("txtCodigo"))
tipoPaciente = UCase(Trim(Request.Form("txtTipoPaciente")))
codAluno = Trim(Request.Form("txtCodAluno"))
codPacienteExterno = Trim(Request.Form("txtCodPacienteExterno"))

fotoBase64 = Trim(Request.Form("txtFotoBase64"))
fotoNome = Trim(Request.Form("txtFotoNome"))
fotoTipo = Trim(Request.Form("txtFotoTipo"))

codEmpresa = CLng(Session("CodEmpresa"))
usuario = Trim(Session("usuarioWeb"))

If acao <> "I" And acao <> "A" And acao <> "E" Then
    Response.Redirect "aee_ficha_paciente.asp?msg=acao_invalida"
    Response.End
End If

If tipoPaciente <> "R" And tipoPaciente <> "E" Then
    Response.Redirect "aee_ficha_paciente.asp?msg=tipo_invalido"
    Response.End
End If

On Error Resume Next
cnn.BeginTrans
If Err.Number <> 0 Then
    Response.Write "Erro ao iniciar transação: " & Server.HTMLEncode(Err.Description)
    Response.End
End If
On Error GoTo 0

On Error Resume Next

msn=""
If acao = "E" Then
    If intCodigo = "" Or Not IsNumeric(intCodigo) Then Err.Raise vbObjectError + 1, , "Ficha inválida."
    sql = "UPDATE AEE_FICHA_PACIENTE SET Situacao='I', usuario_altr=" & Q(usuario) & ", data_hora_altr=GETDATE() WHERE Cod_Ficha_Paciente=" & CLng(intCodigo) & " AND Cod_Empresa=" & codEmpresa
    cnn.Execute sql
    sql = "UPDATE P SET P.Situacao='I', P.usuario_altr=" & Q(usuario) & ", P.data_hora_altr=GETDATE() FROM AEE_PACIENTE_EXTERNO P INNER JOIN AEE_FICHA_PACIENTE F ON F.Cod_Paciente_Externo=P.Cod_Paciente_Externo WHERE F.Cod_Ficha_Paciente=" & CLng(intCodigo) & " AND F.Tipo_Paciente='E' AND F.Cod_Empresa=" & codEmpresa
    cnn.Execute sql
	msn = "Registro inativado com sucesso!"
    If Err.Number <> 0 Then Err.Raise Err.Number, , Err.Description
Else
    If tipoPaciente = "R" Then
        If codAluno = "" Or Not IsNumeric(codAluno) Then Err.Raise vbObjectError + 2, , "Aluno da rede não informado."

        sql = "SELECT COUNT(*) AS QTDE FROM SCA_ALUNO WHERE CODIGO=" & CLng(codAluno)
        Set rsVal = cnn.Execute(sql)
        If rsVal("QTDE") = 0 Then Err.Raise vbObjectError + 3, , "Aluno da rede não localizado."
        rsVal.Close
        Set rsVal = Nothing

        If acao = "I" Then
            sql = "SELECT TOP 1 Cod_Ficha_Paciente FROM AEE_FICHA_PACIENTE WHERE Cod_Empresa=" & codEmpresa & " AND Cod_Aluno=" & CLng(codAluno)
            Set rsVal = cnn.Execute(sql)
            If Not rsVal.EOF Then
                intCodigo = rsVal("Cod_Ficha_Paciente")
            Else
                sql = "SET NOCOUNT ON; " & _
                      "INSERT INTO AEE_FICHA_PACIENTE " & _
                      "(Cod_Empresa,Tipo_Paciente,Cod_Aluno,Cod_Paciente_Externo,Situacao,usuario_incl,data_hora_incl) " & _
                      "VALUES (" & codEmpresa & ",'R'," & CLng(codAluno) & ",NULL,'A'," & Q(usuario) & ",GETDATE()); " & _
                      "SELECT CAST(SCOPE_IDENTITY() AS INT) AS CODIGO;"
                Set rsNovo = cnn.Execute(sql)

                If rsNovo Is Nothing Then Err.Raise vbObjectError + 100, , "Não foi possível obter o código da ficha."
                If rsNovo.State = 0 Then Err.Raise vbObjectError + 101, , "O retorno da inclusão da ficha está fechado."
                If rsNovo.EOF Then Err.Raise vbObjectError + 102, , "Não foi retornado o código da ficha."

                intCodigo = CLng(rsNovo("CODIGO"))
                rsNovo.Close
                Set rsNovo = Nothing
            End If
            rsVal.Close
            Set rsVal = Nothing
        Else
            If intCodigo = "" Or Not IsNumeric(intCodigo) Then Err.Raise vbObjectError + 4, , "Ficha inválida."
            sql = "UPDATE AEE_FICHA_PACIENTE SET Situacao='A', usuario_altr=" & Q(usuario) & ", data_hora_altr=GETDATE() WHERE Cod_Ficha_Paciente=" & CLng(intCodigo) & " AND Cod_Empresa=" & codEmpresa
            cnn.Execute sql
        End If
    Else
        If Trim(Request.Form("txtNomealuno")) = "" Then Err.Raise vbObjectError + 7, , "O nome completo do paciente deve ser informado."
        If Trim(Request.Form("txtDataNascimento")) = "" Then Err.Raise vbObjectError + 8, , "A data de nascimento do paciente deve ser informada."
        If Trim(Request.Form("txtDatamatricula")) = "" Then Err.Raise vbObjectError + 9, , "A data de matrícula deve ser informada."
        If Trim(Request.Form("cmbSexo")) = "" Then Err.Raise vbObjectError + 10, , "O sexo deve ser informado."

        sqlCampos = "NomeAluno=" & Q(UCase(Trim(Request.Form("txtNomealuno")))) & _
            ",DataNascimento=" & D(Request.Form("txtDataNascimento")) & _
            ",DataMatricula=" & D(Request.Form("txtDatamatricula")) & _
            ",SexoAluno=" & Q(Request.Form("cmbSexo")) & _
            ",CPF=" & Q(Request.Form("txtcpf")) & _
            ",NumRegistroNasc=" & Q(Request.Form("txtNumeroRegistroNascimento")) & _
            ",CidadeNascimento=" & Q(Request.Form("txtCidadenascimento")) & _
            ",UFNascimento=" & N(Request.Form("cmbUFNaturalidade")) & _
            ",Nacionalidade=" & Q(Request.Form("cmbNacionalidade")) & _
            ",Cod_TipoNacionalidade=" & N(Request.Form("cmbTipoNacionalidade")) & _
            ",Cod_Etnia=" & N(Request.Form("cmbEtnia")) & _
            ",CartaoSUS=" & Q(Request.Form("txtCartaoSUS")) & _
            ",Bolsa_Familia=" & Q(Request.Form("txtBolsaFamilia")) & _
            ",Email=" & Q(Request.Form("txtEmail")) & _
            ",FoneCelular=" & Q(Request.Form("txtFonecelular")) & _
            ",AtendimentoEspecial=" & SN(Request.Form("txtAtendimentoespecial")) & _
            ",Sala_AEE=" & SN(Request.Form("cmbSalaAEE")) & _
            ",Cod_Condicao_Especial=" & N(Request.Form("cmbCondicaoEspecial")) & _
            ",Condicao_Especial_Outro=" & Q(Request.Form("txtCondicaoEspecialOutro")) & _
            ",Logradouro=" & Q(Request.Form("txtLogradouro")) & _
            ",Numero_Endereco=" & Q(Request.Form("txtNumero_Endereco")) & _
            ",Comp_Endereco=" & Q(Request.Form("txtComp_endereco")) & _
            ",BairroAluno=" & Q(Request.Form("txtBairroaluno")) & _
            ",CidadeResidencia=" & Q(Request.Form("txtCidaderesidencia")) & _
            ",UFResidencia=" & Q(Request.Form("cmbUFResidencia")) & _
            ",CEPResidencia=" & Q(Request.Form("txtCepresidencia")) & _
            ",Pai=" & Q(Request.Form("txtPai")) & _
            ",PaiFalecido=" & SN(Request.Form("txtPaifalecido")) & _
            ",PaiDataNascimento=" & D(Request.Form("txtPaidatanascimento")) & _
            ",PaiFone=" & Q(Request.Form("txtPaifone")) & _
            ",Pai_Cod_Profissao=" & N(Request.Form("cmbProfissaoPai")) & _
            ",Pai_Cod_GrauInstrucao=" & N(Request.Form("cmbGrauInstrucaoPai")) & _
            ",Mae=" & Q(Request.Form("txtMae")) & _
            ",MaeFalecida=" & SN(Request.Form("txtMaefalecida")) & _
            ",MaeDataNascimento=" & D(Request.Form("txtMaedatanascimento")) & _
            ",MaeFone=" & Q(Request.Form("txtMaefone")) & _
            ",Mae_Cod_Profissao=" & N(Request.Form("cmbProfissaoMae")) & _
            ",Mae_Cod_GrauInstrucao=" & N(Request.Form("cmbGrauInstrucaoMae")) & _
            ",Qtde_Irmao=" & N(Request.Form("cmbQtdeIrmao")) & _
            ",Qtde_Irmao_Escola=" & N(Request.Form("cmbQtdeIrmaoEscola")) & _
            ",Responsavel_Quem=" & Q(Request.Form("RESPONSAVEL_QUEM")) & _
            ",Responsavel_Grau_Parentesco=" & Q(Request.Form("RESPONSAVEL_GRAU_PARESTESCO")) & _
            ",Responsavel=" & Q(Request.Form("txtResponsavel")) & _
            ",CPFResponsavel=" & Q(Replace(Replace(Request.Form("txtCPFResponsavel"),".",""),"-","")) & _
            ",ResponsavelDataNascimento=" & D(Request.Form("txtResponsaveldatanascimento")) & _
            ",ResponsavelFone=" & Q(Request.Form("txtResponsavelfone")) & _
            ",Responsavel_Cod_Profissao=" & N(Request.Form("cmbProfissaoResponsavel")) & _
            ",Responsavel_Cod_GrauInstrucao=" & N(Request.Form("cmbGrauInstrucaoResponsavel")) & _
            ",Medicamento_Controlado=" & SN(Request.Form("MEDICAMENTO_CONTROLADO")) & _
            ",Medicamento_Controlado_Qual=" & Q(Request.Form("MEDICAMENTO_CONTROLADO_QUAL")) & _
            ",Transporte_Escolar=" & SN(Request.Form("TRANSPORTE_ESCOLAR")) & _
            ",Autoriza_Uso_Imagem=" & SN(Request.Form("AUTORIZA_USO_IMAGEM")) & _
            ",Restricao_Alimentar=" & SN(Request.Form("RESTRICAO_ALIMENTAR")) & _
            ",Restricao_Alimentar_Qual=" & Q(Request.Form("RESTRICAO_ALIMENTAR_QUAL")) & _
            ",Alergia=" & SN(Request.Form("ALERGIA")) & _
            ",Alergia_Qual=" & Q(Request.Form("ALERGIA_QUAL"))

        If acao = "I" Then
            sql = "SET NOCOUNT ON; " & _
                  "INSERT INTO AEE_PACIENTE_EXTERNO " & _
                  "(Cod_Empresa,NomeAluno,Situacao,usuario_incl,data_hora_incl) " & _
                  "VALUES (" & codEmpresa & "," & Q(UCase(Trim(Request.Form("txtNomealuno")))) & ",'A'," & Q(usuario) & ",GETDATE()); " & _
                  "SELECT CAST(SCOPE_IDENTITY() AS INT) AS CODIGO;"
            Set rsNovo = cnn.Execute(sql)

            If rsNovo Is Nothing Then Err.Raise vbObjectError + 103, , "Não foi possível obter o código do paciente externo."
            If rsNovo.State = 0 Then Err.Raise vbObjectError + 104, , "O retorno da inclusão do paciente externo está fechado."
            If rsNovo.EOF Then Err.Raise vbObjectError + 105, , "Não foi retornado o código do paciente externo."

            codPacienteExterno = CLng(rsNovo("CODIGO"))
            rsNovo.Close
            Set rsNovo = Nothing

            sql = "UPDATE AEE_PACIENTE_EXTERNO SET " & sqlCampos & " WHERE Cod_Paciente_Externo=" & CLng(codPacienteExterno) & " AND Cod_Empresa=" & codEmpresa
            cnn.Execute sql

            sql = "SET NOCOUNT ON; " & _
                  "INSERT INTO AEE_FICHA_PACIENTE " & _
                  "(Cod_Empresa,Tipo_Paciente,Cod_Aluno,Cod_Paciente_Externo,Situacao,usuario_incl,data_hora_incl) " & _
                  "VALUES (" & codEmpresa & ",'E',NULL," & CLng(codPacienteExterno) & ",'A'," & Q(usuario) & ",GETDATE()); " & _
                  "SELECT CAST(SCOPE_IDENTITY() AS INT) AS CODIGO;"
            Set rsNovo = cnn.Execute(sql)

            If rsNovo Is Nothing Then Err.Raise vbObjectError + 106, , "Não foi possível obter o código da ficha do paciente."
            If rsNovo.State = 0 Then Err.Raise vbObjectError + 107, , "O retorno da inclusão da ficha está fechado."
            If rsNovo.EOF Then Err.Raise vbObjectError + 108, , "Não foi retornado o código da ficha do paciente."

            intCodigo = CLng(rsNovo("CODIGO"))
            rsNovo.Close
            Set rsNovo = Nothing
        Else
            If intCodigo = "" Or Not IsNumeric(intCodigo) Then Err.Raise vbObjectError + 5, , "Ficha inválida."
            If codPacienteExterno = "" Or Not IsNumeric(codPacienteExterno) Then Err.Raise vbObjectError + 6, , "Paciente externo inválido."
            sql = "UPDATE AEE_PACIENTE_EXTERNO SET " & sqlCampos & ", usuario_altr=" & Q(usuario) & ", data_hora_altr=GETDATE() WHERE Cod_Paciente_Externo=" & CLng(codPacienteExterno) & " AND Cod_Empresa=" & codEmpresa
            cnn.Execute sql
            sql = "UPDATE AEE_FICHA_PACIENTE SET Situacao='A', usuario_altr=" & Q(usuario) & ", data_hora_altr=GETDATE() WHERE Cod_Ficha_Paciente=" & CLng(intCodigo) & " AND Cod_Empresa=" & codEmpresa
            cnn.Execute sql
        End If

        ' A foto é gravada somente para paciente externo.
        ' Se nenhuma nova foto foi selecionada, a foto atual permanece inalterada.
        If Err.Number = 0 And fotoBase64 <> "" Then
            Call SalvarFotoPacienteExterno( _
                CLng(codPacienteExterno), _
                fotoBase64, _
                fotoNome, _
                fotoTipo, _
                usuario _
            )
        End If
    End If

    ' Necessidades especiais do aluno da rede pertencem ao cadastro oficial
    ' SCA_ALUNO_NECESSIDADEESPECIAL e não são alteradas pelo módulo AEE.
    ' A tabela AEE_FICHA_PACIENTE_NECESSIDADE é utilizada somente para pacientes externos.
    If Err.Number = 0 And tipoPaciente = "E" Then
        sql = "DELETE FROM AEE_FICHA_PACIENTE_NECESSIDADE WHERE Cod_Ficha_Paciente=" & CLng(intCodigo)
        cnn.Execute sql

        Dim arrNec, i, codNec
        arrNec = Split(Request.Form("chkNecessidade"), ",")
        For i = 0 To UBound(arrNec)
            codNec = Trim(arrNec(i))
            If codNec <> "" And IsNumeric(codNec) Then
                sql = "INSERT INTO AEE_FICHA_PACIENTE_NECESSIDADE (Cod_Ficha_Paciente,Cod_Necessidade,usuario_incl,data_hora_incl) VALUES (" & CLng(intCodigo) & "," & CLng(codNec) & "," & Q(usuario) & ",GETDATE())"
                cnn.Execute sql
            End If
        Next
    End If
End If

If Err.Number <> 0 Then
    msgErro = Err.Description
    Err.Clear
    cnn.RollbackTrans
    On Error GoTo 0
    Response.Write "<script>alert('Erro ao gravar a ficha: " & Replace(Replace(msgErro, "'", ""), vbCrLf, " ") & "');history.back();</script>"
    Response.End
End If

cnn.CommitTrans
On Error GoTo 0


if msn = "" then msn = "Registro salvo com sucesso!"
Response.Write "<script>alert('" & msn & "');window.location='aee_ficha_paciente.asp?txtCodigo=" & intCodigo & "&salvo=S';</script>"
%>
