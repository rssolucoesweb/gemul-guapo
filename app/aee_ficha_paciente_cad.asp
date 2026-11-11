<%
Function Html(v)
    If IsNull(v) Then
        Html = ""
    Else
        Html = Server.HTMLEncode(CStr(v))
    End If
End Function

Function DataTela(v)
    If IsNull(v) Or Trim(CStr(v & "")) = "" Then
        DataTela = ""
    ElseIf IsDate(v) Then
        DataTela = Right("0" & Day(CDate(v)), 2) & "/" & Right("0" & Month(CDate(v)), 2) & "/" & Year(CDate(v))
    Else
        DataTela = v
    End If
End Function

Function CampoRS(nomeCampo)
    On Error Resume Next
    CampoRS = rs(nomeCampo)
    If Err.Number <> 0 Then
        CampoRS = ""
        Err.Clear
    End If
    On Error GoTo 0
End Function

strAcao = UCase(Trim(Request("acao")))
intCodigo = Trim(Request("txtCodigo"))
strTipoPaciente = UCase(Trim(Request("txtTipoPaciente")))
strCodAluno = Trim(Request("txtCodAluno"))
strCodPacienteExterno = Trim(Request("txtCodPacienteExterno"))
strMatriculaLocalizar = Trim(Request("txtMatriculaLocalizar"))

If strTipoPaciente = "" Then strTipoPaciente = "R"

strNomealuno = ""
strDatanascimento = ""
strDatamatricula = ""
strCPF = ""
strSexoaluno = ""
strNumeroRegistroNascimento = ""
strCidadenascimento = ""
intUFnascimento = ""
strNacionalidade = ""
strTipoNacionalidade = ""
intCodEtnia = ""
strCartaoSUS = ""
strBolsaFamilia = ""
strEmail = ""
strFonecelular = ""
strAtendimentoespecial = "N"
strSalaAEE = "N"
intCodCondicaoEspecial = ""
strCondicaoEspecialOutro = ""
strLogradouro = ""
strNumeroEndereco = ""
strComp_endereco = ""
strBairroaluno = ""
strCidaderesidencia = ""
strUFResidencia = ""
strCepresidencia = ""
strPai = ""
strPaifalecido = "N"
strPaidatanascimento = ""
strPaifone = ""
intPaiCodProfissao = ""
intPaiCodGrauInstrucao = ""
strMae = ""
strMaefalecida = "N"
strMaedatanascimento = ""
strMaefone = ""
intMaeCodProfissao = ""
intMaeCodGrauInstrucao = ""
intQtdeIrmao = ""
intQtdeIrmaoEscola = ""
RESPONSAVEL_QUEM = "0"
RESPONSAVEL_GRAU_PARESTESCO = ""
strResponsavel = ""
strCPFResponsavel = ""
strResponsaveldatanascimento = ""
strResponsavelfone = ""
intResponsavelCodProfissao = ""
intResponsavelCodGrauInstrucao = ""
MEDICAMENTO_CONTROLADO = "N"
MEDICAMENTO_CONTROLADO_QUAL = ""
TRANSPORTE_ESCOLAR = "N"
AUTORIZA_USO_IMAGEM = "N"
RESTRICAO_ALIMENTAR = "N"
RESTRICAO_ALIMENTAR_QUAL = ""
ALERGIA = "N"
ALERGIA_QUAL = ""
strSituacao = "A"
strMatricula = ""
strUnidadeAluno = ""
strAnoLetivoAluno = ""
strFotoPaciente = "img/aluno-sem-foto-incluir.jpg"

' Localização rápida de aluno da rede pela matrícula.
If strAcao = "L" And strMatriculaLocalizar <> "" Then
    sql = "SELECT TOP 1 A.*, C.COD_EMPRESA, C.ANO_LETIVO, E.RAZAOSOCIAL AS UNIDADE "
    sql = sql & "FROM SCA_ALUNO A "
    sql = sql & "OUTER APPLY (SELECT TOP 1 COD_EMPRESA, ANO_LETIVO FROM SCA_CONTROLE_SITUACAO_ALUNO "
    sql = sql & "WHERE COD_ALUNO=A.CODIGO ORDER BY CODIGO DESC) C "
    sql = sql & "LEFT JOIN SEG_EMPRESA E ON E.CODIGO=C.COD_EMPRESA "
    sql = sql & "WHERE A.MATRICULA='" & Replace(strMatriculaLocalizar, "'", "''") & "'"
    rs.Open sql, cnn
    If Not rs.EOF Then
        strTipoPaciente = "R"
        strCodAluno = rs("CODIGO")
        strMatricula = rs("MATRICULA")
        strNomealuno = CampoRS("NOMEALUNO")
        strDatanascimento = DataTela(CampoRS("DATANASCIMENTO"))
        strDatamatricula = DataTela(CampoRS("DATAMATRICULA"))
        strCPF = CampoRS("CPF")
        strSexoaluno = CampoRS("SEXOALUNO")
        strNumeroRegistroNascimento = CampoRS("NUMREGISTRONASC")
        strCidadenascimento = CampoRS("CIDADENASCIMENTO")
        intUFnascimento = CampoRS("UFNASCIMENTO")
        strNacionalidade = CampoRS("NACIONALIDADE")
        strTipoNacionalidade = CampoRS("COD_TIPONACIONALIDADE")
        intCodEtnia = CampoRS("COD_ETNIA")
        strCartaoSUS = CampoRS("CartaoSUS")
        strBolsaFamilia = CampoRS("bolsa_Familia")
        strEmail = CampoRS("EMAIL")
        strFonecelular = CampoRS("FONECELULAR")
        strAtendimentoespecial = CampoRS("ATENDIMENTOESPECIAL")
        strSalaAEE = CampoRS("sala_aee")
        intCodCondicaoEspecial = CampoRS("Cod_condicao_especial")
        strCondicaoEspecialOutro = CampoRS("condicao_especial_outro")
        strLogradouro = CampoRS("LOGRADOURO")
        strNumeroEndereco = CampoRS("NUMERO_ENDERECO")
        strComp_endereco = CampoRS("COMP_ENDERECO")
        strBairroaluno = CampoRS("BAIRROALUNO")
        strCidaderesidencia = CampoRS("CIDADERESIDENCIA")
        strUFResidencia = CampoRS("UFRESIDENCIA")
        strCepresidencia = CampoRS("CEPRESIDENCIA")
        strPai = CampoRS("PAI")
        strPaifalecido = CampoRS("PAIFALECIDO")
        strPaidatanascimento = DataTela(CampoRS("PAIDATANASCIMENTO"))
        strPaifone = CampoRS("PAIFONE")
        intPaiCodProfissao = CampoRS("PAI_COD_PROFISSAO")
        intPaiCodGrauInstrucao = CampoRS("PAI_COD_GRAUINSTRUCAO")
        strMae = CampoRS("MAE")
        strMaefalecida = CampoRS("MAEFALECIDA")
        strMaedatanascimento = DataTela(CampoRS("MAEDATANASCIMENTO"))
        strMaefone = CampoRS("MAEFONE")
        intMaeCodProfissao = CampoRS("MAE_COD_PROFISSAO")
        intMaeCodGrauInstrucao = CampoRS("MAE_COD_GRAUINSTRUCAO")
        intQtdeIrmao = CampoRS("QTDE_IRMAO")
        intQtdeIrmaoEscola = CampoRS("QTDE_IRMAO_ESCOLA")
        RESPONSAVEL_QUEM = CampoRS("RESPONSAVEL_QUEM")
        RESPONSAVEL_GRAU_PARESTESCO = CampoRS("RESPONSAVEL_GRAU_PARESTESCO")
        strResponsavel = CampoRS("RESPONSAVEL")
        strCPFResponsavel = CampoRS("CPFRESPONSAVEL")
        strResponsaveldatanascimento = DataTela(CampoRS("RESPONSAVELDATANASCIMENTO"))
        strResponsavelfone = CampoRS("RESPONSAVELFONE")
        intResponsavelCodProfissao = CampoRS("RESPONSAVEL_COD_PROFISSAO")
        intResponsavelCodGrauInstrucao = CampoRS("RESPONSAVEL_COD_GRAUINSTRUCAO")
        MEDICAMENTO_CONTROLADO = CampoRS("MEDICAMENTO_CONTROLADO")
        MEDICAMENTO_CONTROLADO_QUAL = CampoRS("MEDICAMENTO_CONTROLADO_QUAL")
        TRANSPORTE_ESCOLAR = CampoRS("TRANSPORTE_ESCOLAR")
        AUTORIZA_USO_IMAGEM = CampoRS("AUTORIZA_USO_IMAGEM")
        RESTRICAO_ALIMENTAR = CampoRS("RESTRICAO_ALIMENTAR")
        RESTRICAO_ALIMENTAR_QUAL = CampoRS("RESTRICAO_ALIMENTAR_QUAL")
        ALERGIA = CampoRS("ALERGIA")
        ALERGIA_QUAL = CampoRS("ALERGIA_QUAL")
        strUnidadeAluno = CampoRS("UNIDADE")
        strAnoLetivoAluno = CampoRS("ANO_LETIVO")
    Else
        mensagem_alerta_pagina = "Aluno não localizado para a matrícula informada."
    End If
    rs.Close
End If

' Carrega uma ficha já cadastrada.
If intCodigo <> "" And IsNumeric(intCodigo) Then
    sql = "SELECT F.*, "
    sql = sql & "A.MATRICULA, A.NOMEALUNO AS R_NOMEALUNO, A.DATANASCIMENTO AS R_DATANASCIMENTO, A.DATAMATRICULA AS R_DATAMATRICULA, A.CPF AS R_CPF, A.SEXOALUNO AS R_SEXOALUNO, "
    sql = sql & "A.NUMREGISTRONASC AS R_NUMREGISTRONASC, A.CIDADENASCIMENTO AS R_CIDADENASCIMENTO, A.UFNASCIMENTO AS R_UFNASCIMENTO, "
    sql = sql & "A.NACIONALIDADE AS R_NACIONALIDADE, A.COD_TIPONACIONALIDADE AS R_COD_TIPONACIONALIDADE, A.COD_ETNIA AS R_COD_ETNIA, "
    sql = sql & "A.CartaoSUS AS R_CARTAOSUS, A.bolsa_Familia AS R_BOLSA_FAMILIA, A.EMAIL AS R_EMAIL, A.FONECELULAR AS R_FONECELULAR, "
    sql = sql & "A.ATENDIMENTOESPECIAL AS R_ATENDIMENTOESPECIAL, A.sala_aee AS R_SALA_AEE, A.Cod_condicao_especial AS R_COD_CONDICAO_ESPECIAL, A.condicao_especial_outro AS R_CONDICAO_ESPECIAL_OUTRO, "
    sql = sql & "A.LOGRADOURO AS R_LOGRADOURO, A.NUMERO_ENDERECO AS R_NUMERO_ENDERECO, A.COMP_ENDERECO AS R_COMP_ENDERECO, A.BAIRROALUNO AS R_BAIRROALUNO, A.CIDADERESIDENCIA AS R_CIDADERESIDENCIA, A.UFRESIDENCIA AS R_UFRESIDENCIA, A.CEPRESIDENCIA AS R_CEPRESIDENCIA, "
    sql = sql & "A.PAI AS R_PAI, A.PAIFALECIDO AS R_PAIFALECIDO, A.PAIDATANASCIMENTO AS R_PAIDATANASCIMENTO, A.PAIFONE AS R_PAIFONE, A.PAI_COD_PROFISSAO AS R_PAI_COD_PROFISSAO, A.PAI_COD_GRAUINSTRUCAO AS R_PAI_COD_GRAUINSTRUCAO, "
    sql = sql & "A.MAE AS R_MAE, A.MAEFALECIDA AS R_MAEFALECIDA, A.MAEDATANASCIMENTO AS R_MAEDATANASCIMENTO, A.MAEFONE AS R_MAEFONE, A.MAE_COD_PROFISSAO AS R_MAE_COD_PROFISSAO, A.MAE_COD_GRAUINSTRUCAO AS R_MAE_COD_GRAUINSTRUCAO, "
    sql = sql & "A.QTDE_IRMAO AS R_QTDE_IRMAO, A.QTDE_IRMAO_ESCOLA AS R_QTDE_IRMAO_ESCOLA, A.RESPONSAVEL AS R_RESPONSAVEL, A.CPFRESPONSAVEL AS R_CPFRESPONSAVEL, A.RESPONSAVELFONE AS R_RESPONSAVELFONE, A.RESPONSAVELDATANASCIMENTO AS R_RESPONSAVELDATANASCIMENTO, A.RESPONSAVEL_COD_PROFISSAO AS R_RESPONSAVEL_COD_PROFISSAO, A.RESPONSAVEL_COD_GRAUINSTRUCAO AS R_RESPONSAVEL_COD_GRAUINSTRUCAO, A.RESPONSAVEL_GRAU_PARESTESCO AS R_RESPONSAVEL_GRAU_PARESTESCO, A.RESPONSAVEL_QUEM AS R_RESPONSAVEL_QUEM, "
    sql = sql & "A.MEDICAMENTO_CONTROLADO AS R_MEDICAMENTO_CONTROLADO, A.MEDICAMENTO_CONTROLADO_QUAL AS R_MEDICAMENTO_CONTROLADO_QUAL, A.TRANSPORTE_ESCOLAR AS R_TRANSPORTE_ESCOLAR, A.AUTORIZA_USO_IMAGEM AS R_AUTORIZA_USO_IMAGEM, A.RESTRICAO_ALIMENTAR AS R_RESTRICAO_ALIMENTAR, A.RESTRICAO_ALIMENTAR_QUAL AS R_RESTRICAO_ALIMENTAR_QUAL, A.ALERGIA AS R_ALERGIA, A.ALERGIA_QUAL AS R_ALERGIA_QUAL, "
    sql = sql & "P.* "
    sql = sql & "FROM AEE_FICHA_PACIENTE F "
    sql = sql & "LEFT JOIN SCA_ALUNO A ON A.CODIGO=F.Cod_Aluno "
    sql = sql & "LEFT JOIN AEE_PACIENTE_EXTERNO P ON P.Cod_Paciente_Externo=F.Cod_Paciente_Externo "
    sql = sql & "WHERE F.Cod_Ficha_Paciente=" & CLng(intCodigo) & " AND F.Cod_Empresa=" & CLng(Session("CodEmpresa"))
    rs.Open sql, cnn
    If Not rs.EOF Then
        strTipoPaciente = CampoRS("Tipo_Paciente")
        strCodAluno = CampoRS("Cod_Aluno")
        strCodPacienteExterno = CampoRS("Cod_Paciente_Externo")
        strSituacao = CampoRS("Situacao")

        If strTipoPaciente = "R" Then
            strMatricula = CampoRS("MATRICULA")
            strNomealuno = CampoRS("R_NOMEALUNO")
            strDatanascimento = DataTela(CampoRS("R_DATANASCIMENTO"))
            strDatamatricula = DataTela(CampoRS("R_DATAMATRICULA"))
            strCPF = CampoRS("R_CPF")
            strSexoaluno = CampoRS("R_SEXOALUNO")
            strNumeroRegistroNascimento = CampoRS("R_NUMREGISTRONASC")
            strCidadenascimento = CampoRS("R_CIDADENASCIMENTO")
            intUFnascimento = CampoRS("R_UFNASCIMENTO")
            strNacionalidade = CampoRS("R_NACIONALIDADE")
            strTipoNacionalidade = CampoRS("R_COD_TIPONACIONALIDADE")
            intCodEtnia = CampoRS("R_COD_ETNIA")
            strCartaoSUS = CampoRS("R_CARTAOSUS")
            strBolsaFamilia = CampoRS("R_BOLSA_FAMILIA")
            strEmail = CampoRS("R_EMAIL")
            strFonecelular = CampoRS("R_FONECELULAR")
            strAtendimentoespecial = CampoRS("R_ATENDIMENTOESPECIAL")
            strSalaAEE = CampoRS("R_SALA_AEE")
            intCodCondicaoEspecial = CampoRS("R_COD_CONDICAO_ESPECIAL")
            strCondicaoEspecialOutro = CampoRS("R_CONDICAO_ESPECIAL_OUTRO")
            strLogradouro = CampoRS("R_LOGRADOURO")
            strNumeroEndereco = CampoRS("R_NUMERO_ENDERECO")
            strComp_endereco = CampoRS("R_COMP_ENDERECO")
            strBairroaluno = CampoRS("R_BAIRROALUNO")
            strCidaderesidencia = CampoRS("R_CIDADERESIDENCIA")
            strUFResidencia = CampoRS("R_UFRESIDENCIA")
            strCepresidencia = CampoRS("R_CEPRESIDENCIA")
            strPai = CampoRS("R_PAI")
            strPaifalecido = CampoRS("R_PAIFALECIDO")
            strPaidatanascimento = DataTela(CampoRS("R_PAIDATANASCIMENTO"))
            strPaifone = CampoRS("R_PAIFONE")
            intPaiCodProfissao = CampoRS("R_PAI_COD_PROFISSAO")
            intPaiCodGrauInstrucao = CampoRS("R_PAI_COD_GRAUINSTRUCAO")
            strMae = CampoRS("R_MAE")
            strMaefalecida = CampoRS("R_MAEFALECIDA")
            strMaedatanascimento = DataTela(CampoRS("R_MAEDATANASCIMENTO"))
            strMaefone = CampoRS("R_MAEFONE")
            intMaeCodProfissao = CampoRS("R_MAE_COD_PROFISSAO")
            intMaeCodGrauInstrucao = CampoRS("R_MAE_COD_GRAUINSTRUCAO")
            intQtdeIrmao = CampoRS("R_QTDE_IRMAO")
            intQtdeIrmaoEscola = CampoRS("R_QTDE_IRMAO_ESCOLA")
            strResponsavel = CampoRS("R_RESPONSAVEL")
            strCPFResponsavel = CampoRS("R_CPFRESPONSAVEL")
            strResponsavelfone = CampoRS("R_RESPONSAVELFONE")
            strResponsaveldatanascimento = DataTela(CampoRS("R_RESPONSAVELDATANASCIMENTO"))
            intResponsavelCodProfissao = CampoRS("R_RESPONSAVEL_COD_PROFISSAO")
            intResponsavelCodGrauInstrucao = CampoRS("R_RESPONSAVEL_COD_GRAUINSTRUCAO")
            RESPONSAVEL_GRAU_PARESTESCO = CampoRS("R_RESPONSAVEL_GRAU_PARESTESCO")
            RESPONSAVEL_QUEM = CampoRS("R_RESPONSAVEL_QUEM")
            MEDICAMENTO_CONTROLADO = CampoRS("R_MEDICAMENTO_CONTROLADO")
            MEDICAMENTO_CONTROLADO_QUAL = CampoRS("R_MEDICAMENTO_CONTROLADO_QUAL")
            TRANSPORTE_ESCOLAR = CampoRS("R_TRANSPORTE_ESCOLAR")
            AUTORIZA_USO_IMAGEM = CampoRS("R_AUTORIZA_USO_IMAGEM")
            RESTRICAO_ALIMENTAR = CampoRS("R_RESTRICAO_ALIMENTAR")
            RESTRICAO_ALIMENTAR_QUAL = CampoRS("R_RESTRICAO_ALIMENTAR_QUAL")
            ALERGIA = CampoRS("R_ALERGIA")
            ALERGIA_QUAL = CampoRS("R_ALERGIA_QUAL")
        Else
            strNomealuno = CampoRS("NomeAluno")
            strDatanascimento = DataTela(CampoRS("DataNascimento"))
            strDatamatricula = DataTela(CampoRS("DataMatricula"))
            strCPF = CampoRS("CPF")
            strSexoaluno = CampoRS("SexoAluno")
            strNumeroRegistroNascimento = CampoRS("NumRegistroNasc")
            strCidadenascimento = CampoRS("CidadeNascimento")
            intUFnascimento = CampoRS("UFNascimento")
            strNacionalidade = CampoRS("Nacionalidade")
            strTipoNacionalidade = CampoRS("Cod_TipoNacionalidade")
            intCodEtnia = CampoRS("Cod_Etnia")
            strCartaoSUS = CampoRS("CartaoSUS")
            strBolsaFamilia = CampoRS("Bolsa_Familia")
            strEmail = CampoRS("Email")
            strFonecelular = CampoRS("FoneCelular")
            strAtendimentoespecial = CampoRS("AtendimentoEspecial")
            strSalaAEE = CampoRS("Sala_AEE")
            intCodCondicaoEspecial = CampoRS("Cod_Condicao_Especial")
            strCondicaoEspecialOutro = CampoRS("Condicao_Especial_Outro")
            strLogradouro = CampoRS("Logradouro")
            strNumeroEndereco = CampoRS("Numero_Endereco")
            strComp_endereco = CampoRS("Comp_Endereco")
            strBairroaluno = CampoRS("BairroAluno")
            strCidaderesidencia = CampoRS("CidadeResidencia")
            strUFResidencia = CampoRS("UFResidencia")
            strCepresidencia = CampoRS("CEPResidencia")
            strPai = CampoRS("Pai")
            strPaifalecido = CampoRS("PaiFalecido")
            strPaidatanascimento = DataTela(CampoRS("PaiDataNascimento"))
            strPaifone = CampoRS("PaiFone")
            intPaiCodProfissao = CampoRS("Pai_Cod_Profissao")
            intPaiCodGrauInstrucao = CampoRS("Pai_Cod_GrauInstrucao")
            strMae = CampoRS("Mae")
            strMaefalecida = CampoRS("MaeFalecida")
            strMaedatanascimento = DataTela(CampoRS("MaeDataNascimento"))
            strMaefone = CampoRS("MaeFone")
            intMaeCodProfissao = CampoRS("Mae_Cod_Profissao")
            intMaeCodGrauInstrucao = CampoRS("Mae_Cod_GrauInstrucao")
            intQtdeIrmao = CampoRS("Qtde_Irmao")
            intQtdeIrmaoEscola = CampoRS("Qtde_Irmao_Escola")
            RESPONSAVEL_QUEM = CampoRS("Responsavel_Quem")
            RESPONSAVEL_GRAU_PARESTESCO = CampoRS("Responsavel_Grau_Parentesco")
            strResponsavel = CampoRS("Responsavel")
            strCPFResponsavel = CampoRS("CPFResponsavel")
            strResponsaveldatanascimento = DataTela(CampoRS("ResponsavelDataNascimento"))
            strResponsavelfone = CampoRS("ResponsavelFone")
            intResponsavelCodProfissao = CampoRS("Responsavel_Cod_Profissao")
            intResponsavelCodGrauInstrucao = CampoRS("Responsavel_Cod_GrauInstrucao")
            MEDICAMENTO_CONTROLADO = CampoRS("Medicamento_Controlado")
            MEDICAMENTO_CONTROLADO_QUAL = CampoRS("Medicamento_Controlado_Qual")
            TRANSPORTE_ESCOLAR = CampoRS("Transporte_Escolar")
            AUTORIZA_USO_IMAGEM = CampoRS("Autoriza_Uso_Imagem")
            RESTRICAO_ALIMENTAR = CampoRS("Restricao_Alimentar")
            RESTRICAO_ALIMENTAR_QUAL = CampoRS("Restricao_Alimentar_Qual")
            ALERGIA = CampoRS("Alergia")
            ALERGIA_QUAL = CampoRS("Alergia_Qual")
        End If
    End If
    rs.Close
End If


' Variáveis esperadas pelos includes padrão do GEMUL.
strUFNaturalidade = intUFnascimento
intCodProfissaoPai = intPaiCodProfissao
intCodGrauInstrucaoPai = intPaiCodGrauInstrucao
intCodProfissaoMae = intMaeCodProfissao
intCodGrauInstrucaoMae = intMaeCodGrauInstrucao
intCodProfissaoResponsavel = intResponsavelCodProfissao
intCodGrauInstrucaoResponsavel = intResponsavelCodGrauInstrucao
strExecutarSubmitEtnia = ""
strExecutarSubmitNacionalidade = ""

' Foto do aluno da rede: reaproveita a mesma origem utilizada pela Ficha do Aluno.
If strTipoPaciente = "R" And Trim(CStr(strCodAluno & "")) <> "" And IsNumeric(strCodAluno) Then
    sql = "SELECT TOP 1 BASE64 FROM SCA_ALUNO_FOTO WHERE COD_ALUNO=" & CLng(strCodAluno) & " AND ISNULL(BASE64,'')<>'' AND BASE64<>'img/aluno-sem-foto.jpg'"
    rs.Open sql, cnn
    If Not rs.EOF Then
        strFotoPaciente = Trim(CStr(rs("BASE64") & ""))
    End If
    rs.Close
End If

' Foto do paciente externo: mantida exclusivamente pelo módulo AEE.
If strTipoPaciente = "E" And Trim(CStr(strCodPacienteExterno & "")) <> "" And IsNumeric(strCodPacienteExterno) Then
    sql = "SELECT TOP 1 BASE64 FROM AEE_PACIENTE_EXTERNO_FOTO WHERE Cod_Paciente_Externo=" & CLng(strCodPacienteExterno) & " AND ISNULL(BASE64,'')<>''"
    rs.Open sql, cnn
    If Not rs.EOF Then
        strFotoPaciente = Trim(CStr(rs("BASE64") & ""))
    End If
    rs.Close
End If

Dim necessidadesMarcadas
Set necessidadesMarcadas = Server.CreateObject("Scripting.Dictionary")

' Para aluno da rede, as necessidades especiais são lidas do cadastro oficial do aluno.
' Para paciente externo, são mantidas exclusivamente pela ficha AEE.
If strTipoPaciente = "R" And Trim(CStr(strCodAluno & "")) <> "" And IsNumeric(strCodAluno) Then
    sql = "SELECT COD_NECESSIDADEESPECIAL " & _
          "FROM SCA_ALUNO_NECESSIDADEESPECIAL " & _
          "WHERE COD_ALUNO = " & CLng(strCodAluno)

    rs.Open sql, cnn
    Do While Not rs.EOF
        necessidadesMarcadas(CStr(rs("COD_NECESSIDADEESPECIAL"))) = True
        rs.MoveNext
    Loop
    rs.Close

ElseIf strTipoPaciente = "E" And intCodigo <> "" And IsNumeric(intCodigo) Then
    sql = "SELECT Cod_Necessidade " & _
          "FROM AEE_FICHA_PACIENTE_NECESSIDADE " & _
          "WHERE Cod_Ficha_Paciente = " & CLng(intCodigo)

    rs.Open sql, cnn
    Do While Not rs.EOF
        necessidadesMarcadas(CStr(rs("Cod_Necessidade"))) = True
        rs.MoveNext
    Loop
    rs.Close
End If

Function CheckedNec(cod)
    If necessidadesMarcadas.Exists(CStr(cod)) Then CheckedNec = " checked" Else CheckedNec = ""
End Function

If strTipoPaciente = "R" Then
    strReadOnly = " readonly"
    strDisabled = " disabled"
    strFieldsetDisabled = " disabled"
    strDisabledNecessidade = " disabled"
Else
    strReadOnly = ""
    strDisabled = ""
    strFieldsetDisabled = ""
    strDisabledNecessidade = ""
End If
%>

<main id="js-page-content" role="main" class="page-content">
    <div class="subheader">
        <h1 class="subheader-title">
            <i class="subheader-icon fal fa-notes-medical"></i> <%=pagina%>
            <small><%=descricao_pagina%></small>
        </h1>
    </div>

    <% If mensagem_alerta_pagina <> "" Then %>
    <div class="alert alert-warning"><%=mensagem_alerta_pagina%></div>
    <% End If %>

    <form id="frmFichaPaciente" name="frmFichaPaciente" method="post" action="aee_ficha_paciente_cod.asp" onsubmit="return AEEFichaPaciente.validar();">
        <input type="hidden" name="acao" id="acao" value="<% If intCodigo="" Then Response.Write("I") Else Response.Write("A") End If %>">
        <input type="hidden" name="txtCodigo" id="txtCodigo" value="<%=Html(intCodigo)%>">
        <input type="hidden" name="txtTipoPaciente" id="txtTipoPaciente" value="<%=Html(strTipoPaciente)%>">
        <input type="hidden" name="txtCodAluno" id="txtCodAluno" value="<%=Html(strCodAluno)%>">
        <input type="hidden" name="txtCodPacienteExterno" id="txtCodPacienteExterno" value="<%=Html(strCodPacienteExterno)%>">
        <input type="hidden" name="txtFotoBase64" id="txtFotoBase64" value="">
        <input type="hidden" name="txtFotoNome" id="txtFotoNome" value="">
        <input type="hidden" name="txtFotoTipo" id="txtFotoTipo" value="">

        <div class="panel">
            <div class="panel-hdr"><h2>Identificação da ficha</h2></div>
            <div class="panel-container show">
                <div class="panel-content">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="form-label">Tipo de paciente *</label>
                            <div class="frame-wrap">
                                <div class="custom-control custom-radio custom-control-inline">
                                    <input type="radio" class="custom-control-input" id="tipoRede" name="tipoPacienteUI" value="R" <%If strTipoPaciente="R" Then Response.Write("checked")%> onclick="AEEFichaPaciente.trocarTipo('R');" <%If intCodigo<>"" Then Response.Write("disabled")%>>
                                    <label class="custom-control-label" for="tipoRede">Aluno da Rede</label>
                                </div>
                                <div class="custom-control custom-radio custom-control-inline">
                                    <input type="radio" class="custom-control-input" id="tipoExterno" name="tipoPacienteUI" value="E" <%If strTipoPaciente="E" Then Response.Write("checked")%> onclick="AEEFichaPaciente.trocarTipo('E');" <%If intCodigo<>"" Then Response.Write("disabled")%>>
                                    <label class="custom-control-label" for="tipoExterno">Paciente Externo</label>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-5" id="bloco-localizar-rede" <%If strTipoPaciente<>"R" Then Response.Write("style='display:none'")%>>
                            <label class="form-label">Matrícula do aluno</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="txtMatriculaLocalizar" value="<%=Html(strMatriculaLocalizar)%>" <%If intCodigo<>"" Then Response.Write("disabled")%>>
                                <%If intCodigo="" Then%>
                                <div class="input-group-append">
                                    <button type="button" class="btn btn-primary" onclick="localizarAlunoRede();"><i class="fal fa-search"></i> Localizar</button>
                                </div>
                                <%End If%>
                            </div>
                        </div>
                        <div class="col-md-3 text-right pt-4">
                            <a href="aee_ficha_paciente_con.asp" class="btn btn-outline-primary"><i class="fal fa-search"></i> Consultar fichas</a>
                        </div>
                    </div>

                    <div id="aviso-paciente-rede" class="alert alert-info mt-3" <%If strTipoPaciente<>"R" Then Response.Write("style='display:none'")%>>
                        <strong>Aluno da rede:</strong> os dados cadastrais abaixo são provenientes da ficha do aluno e são apresentados somente para consulta. Alterações cadastrais devem ser realizadas na Ficha do Aluno.
                        <%If strMatricula<>"" Then%><br><strong>Matrícula:</strong> <%=Html(strMatricula)%><%End If%>
                        <%If strUnidadeAluno<>"" Then%> &nbsp; <strong>Unidade:</strong> <%=Html(strUnidadeAluno)%><%End If%>
                        <%If strAnoLetivoAluno<>"" Then%> &nbsp; <strong>Ano letivo:</strong> <%=Html(strAnoLetivoAluno)%><%End If%>
                    </div>
                    <div id="aviso-paciente-externo" class="alert alert-success mt-3" <%If strTipoPaciente<>"E" Then Response.Write("style='display:none'")%>>
                        <strong>Paciente externo:</strong> os dados serão mantidos exclusivamente no módulo AEE.
                    </div>
                </div>
            </div>
        </div>

        <div class="card border mb-2" id="card_dados_pessoais">
            <div class="card-header" style="cursor:pointer" data-toggle="collapse" data-target="#dados_pessoais" aria-expanded="true">
                <strong>Dados Pessoais&nbsp;&nbsp;<em class="fal fa-angle-down"></em></strong>
            </div>
            <div id="dados_pessoais" class="collapse show">
                <div class="p-4">
                    <div class="row">
                        <div class="col-md-2 text-center mb-3">
                            <img id="imgFotoPaciente" src="<%=Html(strFotoPaciente)%>" alt="Foto do paciente" class="img-fluid rounded border" style="width:120px;height:170px;object-fit:cover;">
                            <div class="small text-muted mt-2">Foto do paciente</div>

                            <div id="blocoFotoPacienteExterno" class="mt-2" <%If strTipoPaciente <> "E" Then Response.Write("style=""display:none;""")%>>
                                <label for="txtFotoPaciente" class="btn btn-sm btn-outline-primary mb-0" style="cursor:pointer;">
                                    <i class="fal fa-camera"></i> Selecionar foto
                                </label>
                                <input type="file"
                                       name="txtFotoPaciente"
                                       id="txtFotoPaciente"
                                       accept=".jpg,.jpeg,.png,image/jpeg,image/png"
                                       style="display:none;"
                                       onchange="prepararFotoPacienteExterno(this);">
                            </div>
                        </div>
                        <div class="col-md-10">
                            <div class="row">
                                <div class="col-md-3 form-group"><label class="form-label">Nome completo *</label><input name="txtNomealuno" id="txtNomealuno" maxlength="100" class="form-control" value="<%=Html(strNomealuno)%>" <%=strReadOnly%>></div>
                                <div class="col-md-2 form-group"><label class="form-label">Data nascimento *</label><input name="txtDataNascimento" id="txtDataNascimento" maxlength="10" class="form-control" value="<%=Html(strDatanascimento)%>" <%=strReadOnly%>></div>
                                <div class="col-md-2 form-group"><label class="form-label">CPF</label><input name="txtcpf" id="txtcpf" maxlength="14" class="form-control" value="<%=Html(strCPF)%>" <%=strReadOnly%>></div>
                                <div class="col-md-2 form-group"><label class="form-label">Data matrícula *</label><input name="txtDatamatricula" id="txtDatamatricula" maxlength="10" class="form-control" value="<%=Html(strDatamatricula)%>" <%=strReadOnly%>></div>
                                <div class="col-md-1 form-group"><label class="form-label">Sexo *</label><select name="cmbSexo" id="cmbSexo" class="form-control" <%=strDisabled%>><option value="">Selecione...</option><option value="M" <%If strSexoaluno="M" Then Response.Write("selected")%>>Masculino</option><option value="F" <%If strSexoaluno="F" Then Response.Write("selected")%>>Feminino</option></select></div>
                                <div class="col-md-2 form-group"><label class="form-label">Número RG Nasc.</label><input name="txtNumeroRegistroNascimento" maxlength="100" class="form-control" value="<%=Html(strNumeroRegistroNascimento)%>" <%=strReadOnly%>></div>
                            </div>
                            <div class="row">
                                <div class="col-md-2 form-group"><label class="form-label">Naturalidade</label><input name="txtCidadenascimento" maxlength="40" class="form-control" value="<%=Html(strCidadenascimento)%>" <%=strReadOnly%>></div>
                                <div class="col-md-2 form-group"><label class="form-label">UF nascimento</label><fieldset class="m-0 p-0 border-0" <%=strFieldsetDisabled%>><!--#include file="includes/inc_cmdUFNaturalidade.asp"--></fieldset></div>
                                <div class="col-md-2 form-group"><label class="form-label">Nacionalidade</label><fieldset class="m-0 p-0 border-0" <%=strFieldsetDisabled%>><!--#include file="includes/inc_cmdNacionalidade.asp"--></fieldset></div>
                                <div class="col-md-2 form-group"><label class="form-label">Tipo nacionalidade</label><fieldset class="m-0 p-0 border-0" <%=strFieldsetDisabled%>><!--#include file="includes/inc_cmdTipoNacionalidade.asp"--></fieldset></div>
                                <div class="col-md-2 form-group"><label class="form-label">Etnia</label><fieldset class="m-0 p-0 border-0" <%=strFieldsetDisabled%>><!--#include file="includes/inc_cmdEtnia.asp"--></fieldset></div>
                                <div class="col-md-2 form-group"><label class="form-label">Cartão SUS</label><input name="txtCartaoSUS" maxlength="35" class="form-control" value="<%=Html(strCartaoSUS)%>" <%=strReadOnly%>></div>
                            </div>
                            <div class="row">
                                <div class="col-md-2 form-group"><label class="form-label">Bolsa Família</label><input name="txtBolsaFamilia" maxlength="11" class="form-control" value="<%=Html(strBolsaFamilia)%>" <%=strReadOnly%>></div>
                                <div class="col-md-4 form-group"><label class="form-label">E-mail</label><input name="txtEmail" maxlength="100" class="form-control" value="<%=Html(strEmail)%>" <%=strReadOnly%>></div>
                                <div class="col-md-2 form-group"><label class="form-label">Celular</label><input name="txtFonecelular" maxlength="30" class="form-control" value="<%=Html(strFonecelular)%>" <%=strReadOnly%>></div>
                                <div class="col-md-2 form-group"><label class="form-label">Atendimento especial</label><select name="txtAtendimentoespecial" class="form-control" <%=strDisabled%>><option value="N" <%If strAtendimentoespecial="N" Then Response.Write("selected")%>>Não</option><option value="S" <%If strAtendimentoespecial="S" Then Response.Write("selected")%>>Sim</option></select></div>
                                <div class="col-md-2 form-group"><label class="form-label">Usa Sala AEE</label><select name="cmbSalaAEE" class="form-control" <%=strDisabled%>><option value="N" <%If strSalaAEE="N" Then Response.Write("selected")%>>Não</option><option value="S" <%If strSalaAEE="S" Then Response.Write("selected")%>>Sim</option></select></div>
                            </div>
                            <div class="row">
                                <div class="col-md-4 form-group"><label class="form-label">Condição especial</label><fieldset class="m-0 p-0 border-0" <%=strFieldsetDisabled%>><!--#include file="includes/inc_cmdCondicaoEspecial.asp"--></fieldset></div>
                                <div class="col-md-8 form-group"><label class="form-label">Outra condição especial</label><input name="txtCondicaoEspecialOutro" maxlength="50" class="form-control" value="<%=Html(strCondicaoEspecialOutro)%>" <%=strReadOnly%>></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card border mb-2" id="card_necessidades">
            <div class="card-header" style="cursor:pointer" data-toggle="collapse" data-target="#necessidades"><strong>Necessidades Especiais&nbsp;&nbsp;<em class="fal fa-angle-down"></em></strong></div>
            <div id="necessidades" class="collapse show"><div class="p-4">
                <% If strTipoPaciente = "R" And Trim(CStr(strCodAluno & "")) <> "" Then %>
                <div class="alert alert-info mb-3">
                    <i class="fal fa-info-circle mr-2"></i>
                    <strong>Aluno da Rede:</strong> as necessidades especiais abaixo são provenientes do cadastro do aluno e não podem ser alteradas nesta ficha.
                </div>
                <% End If %>
                <div class="row">
                    <div class="col-md-4"><h5>Deficiência</h5>
                        <label class="d-block"><input type="checkbox" name="chkNecessidade" value="2" <%=CheckedNec(2)%><%=strDisabledNecessidade%>> Baixa Visão</label>
                        <label class="d-block"><input type="checkbox" name="chkNecessidade" value="1" <%=CheckedNec(1)%><%=strDisabledNecessidade%>> Cegueira</label>
                        <label class="d-block"><input type="checkbox" name="chkNecessidade" value="15" <%=CheckedNec(15)%><%=strDisabledNecessidade%>> Deficiência Auditiva</label>
                        <label class="d-block"><input type="checkbox" name="chkNecessidade" value="14" <%=CheckedNec(14)%><%=strDisabledNecessidade%>> Deficiência Física</label>
                    </div>
                    <div class="col-md-4"><h5>&nbsp;</h5>
                        <label class="d-block"><input type="checkbox" name="chkNecessidade" value="5" <%=CheckedNec(5)%><%=strDisabledNecessidade%>> Deficiência Intelectual</label>
                        <label class="d-block"><input type="checkbox" name="chkNecessidade" value="18" <%=CheckedNec(18)%><%=strDisabledNecessidade%>> Visão Monocular</label>
                        <label class="d-block"><input type="checkbox" name="chkNecessidade" value="3" <%=CheckedNec(3)%><%=strDisabledNecessidade%>> Surdez</label>
                        <label class="d-block"><input type="checkbox" name="chkNecessidade" value="4" <%=CheckedNec(4)%><%=strDisabledNecessidade%>> Surdocegueira</label>
                    </div>
                    <div class="col-md-4"><h5>TEA / Altas Habilidades</h5>
                        <label class="d-block"><input type="checkbox" name="chkNecessidade" value="11" <%=CheckedNec(11)%><%=strDisabledNecessidade%>> Transtorno do Espectro Autista (TEA)</label>
                        <label class="d-block"><input type="checkbox" name="chkNecessidade" value="8" <%=CheckedNec(8)%><%=strDisabledNecessidade%>> Altas Habilidades ou Superdotação</label>
                    </div>
                </div>
            </div></div>
        </div>

        <div class="card border mb-2">
            <div class="card-header" style="cursor:pointer" data-toggle="collapse" data-target="#endereco"><strong>Endereço&nbsp;&nbsp;<em class="fal fa-angle-down"></em></strong></div>
            <div id="endereco" class="collapse"><div class="p-4">
                <div class="row">
                    <div class="col-md-2 form-group"><label class="form-label">CEP</label><input name="txtCepresidencia" id="txtCepresidencia" maxlength="10" class="form-control" value="<%=Html(strCepresidencia)%>" <%=strReadOnly%>></div>
                    <div class="col-md-4 form-group"><label class="form-label">Logradouro</label><input name="txtLogradouro" id="txtLogradouro" maxlength="100" class="form-control" value="<%=Html(strLogradouro)%>" <%=strReadOnly%>></div>
                    <div class="col-md-2 form-group"><label class="form-label">Número</label><input name="txtNumero_Endereco" maxlength="55" class="form-control" value="<%=Html(strNumeroEndereco)%>" <%=strReadOnly%>></div>
                    <div class="col-md-4 form-group"><label class="form-label">Complemento</label><input name="txtComp_endereco" id="txtComp_endereco" maxlength="100" class="form-control" value="<%=Html(strComp_endereco)%>" <%=strReadOnly%>></div>
                </div>
                <div class="row">
                    <div class="col-md-4 form-group"><label class="form-label">Bairro</label><input name="txtBairroaluno" id="txtBairroaluno" maxlength="140" class="form-control" value="<%=Html(strBairroaluno)%>" <%=strReadOnly%>></div>
                    <div class="col-md-4 form-group"><label class="form-label">Município</label><input name="txtCidaderesidencia" id="txtCidaderesidencia" maxlength="100" class="form-control" value="<%=Html(strCidaderesidencia)%>" <%=strReadOnly%>></div>
                    <div class="col-md-2 form-group"><label class="form-label">UF</label><input name="cmbUFResidencia" maxlength="2" class="form-control" value="<%=Html(strUFResidencia)%>" <%=strReadOnly%>></div>
                </div>
            </div></div>
        </div>

        <div class="card border mb-2">
            <div class="card-header" style="cursor:pointer" data-toggle="collapse" data-target="#familia"><strong>Dados Familiares&nbsp;&nbsp;<em class="fal fa-angle-down"></em></strong></div>
            <div id="familia" class="collapse"><div class="p-4">
                <div class="row">
                    <div class="col-md-3 form-group"><label class="form-label">Nome do pai</label><input name="txtPai" maxlength="50" class="form-control" value="<%=Html(strPai)%>" <%=strReadOnly%>></div>
                    <div class="col-md-1 form-group"><label class="form-label">Falecido</label><select name="txtPaifalecido" class="form-control" <%=strDisabled%>><option value="N" <%If strPaifalecido="N" Then Response.Write("selected")%>>Não</option><option value="S" <%If strPaifalecido="S" Then Response.Write("selected")%>>Sim</option></select></div>
                    <div class="col-md-2 form-group"><label class="form-label">Data nascimento</label><input name="txtPaidatanascimento" maxlength="10" class="form-control" value="<%=Html(strPaidatanascimento)%>" <%=strReadOnly%>></div>
                    <div class="col-md-2 form-group"><label class="form-label">Telefone</label><input name="txtPaifone" maxlength="30" class="form-control" value="<%=Html(strPaifone)%>" <%=strReadOnly%>></div>
                    <div class="col-md-2 form-group"><label class="form-label">Profissão</label><fieldset class="m-0 p-0 border-0" <%=strFieldsetDisabled%>><!--#include file="includes/inc_cmdProfissaoPai.asp"--></fieldset></div>
                    <div class="col-md-2 form-group"><label class="form-label">Grau instrução</label><fieldset class="m-0 p-0 border-0" <%=strFieldsetDisabled%>><!--#include file="includes/inc_cmdGrauInstrucaoPai.asp"--></fieldset></div>
                </div>
                <div class="row">
                    <div class="col-md-3 form-group"><label class="form-label">Nome da mãe</label><input name="txtMae" maxlength="120" class="form-control" value="<%=Html(strMae)%>" <%=strReadOnly%>></div>
                    <div class="col-md-1 form-group"><label class="form-label">Falecida</label><select name="txtMaefalecida" class="form-control" <%=strDisabled%>><option value="N" <%If strMaefalecida="N" Then Response.Write("selected")%>>Não</option><option value="S" <%If strMaefalecida="S" Then Response.Write("selected")%>>Sim</option></select></div>
                    <div class="col-md-2 form-group"><label class="form-label">Data nascimento</label><input name="txtMaedatanascimento" maxlength="10" class="form-control" value="<%=Html(strMaedatanascimento)%>" <%=strReadOnly%>></div>
                    <div class="col-md-2 form-group"><label class="form-label">Telefone</label><input name="txtMaefone" maxlength="30" class="form-control" value="<%=Html(strMaefone)%>" <%=strReadOnly%>></div>
                    <div class="col-md-2 form-group"><label class="form-label">Profissão</label><fieldset class="m-0 p-0 border-0" <%=strFieldsetDisabled%>><!--#include file="includes/inc_cmdProfissaoMae.asp"--></fieldset></div>
                    <div class="col-md-2 form-group"><label class="form-label">Grau instrução</label><fieldset class="m-0 p-0 border-0" <%=strFieldsetDisabled%>><!--#include file="includes/inc_cmdGrauInstrucaoMae.asp"--></fieldset></div>
                </div>
                <div class="row">
                    <div class="col-md-3 form-group"><label class="form-label">Quantidade de irmãos</label><input type="number" name="cmbQtdeIrmao" class="form-control" value="<%=Html(intQtdeIrmao)%>" <%=strReadOnly%>></div>
                    <div class="col-md-3 form-group"><label class="form-label">Na mesma escola</label><input type="number" name="cmbQtdeIrmaoEscola" class="form-control" value="<%=Html(intQtdeIrmaoEscola)%>" <%=strReadOnly%>></div>
                </div>
            </div></div>
        </div>

        <div class="card border mb-2">
            <div class="card-header" style="cursor:pointer" data-toggle="collapse" data-target="#responsavel"><strong>Dados do Responsável&nbsp;&nbsp;<em class="fal fa-angle-down"></em></strong></div>
            <div id="responsavel" class="collapse"><div class="p-4">
                <div class="row">
                    <div class="col-md-3 form-group"><label class="form-label">Responsável é</label><select name="RESPONSAVEL_QUEM" id="RESPONSAVEL_QUEM" class="form-control" onchange="verificaOutroResponsavel();" <%=strDisabled%>><option value="0">Selecione...</option><option value="PAI" <%If RESPONSAVEL_QUEM="PAI" Then Response.Write("selected")%>>Pai</option><option value="MAE" <%If RESPONSAVEL_QUEM="MAE" Then Response.Write("selected")%>>Mãe</option><option value="OUTRO" <%If RESPONSAVEL_QUEM="OUTRO" Then Response.Write("selected")%>>Outro</option></select></div>
                    <div class="col-md-3 form-group" id="coluna_outro_responsavel"><label class="form-label">Grau de parentesco</label><input name="RESPONSAVEL_GRAU_PARESTESCO" maxlength="50" class="form-control" value="<%=Html(RESPONSAVEL_GRAU_PARESTESCO)%>" <%=strReadOnly%>></div>
                    <div class="col-md-6 form-group"><label class="form-label">Nome do responsável</label><input name="txtResponsavel" maxlength="100" class="form-control" value="<%=Html(strResponsavel)%>" <%=strReadOnly%>></div>
                </div>
                <div class="row">
                    <div class="col-md-3 form-group"><label class="form-label">CPF</label><input name="txtCPFResponsavel" maxlength="14" class="form-control" value="<%=Html(strCPFResponsavel)%>" <%=strReadOnly%>></div>
                    <div class="col-md-3 form-group"><label class="form-label">Data nascimento</label><input name="txtResponsaveldatanascimento" maxlength="10" class="form-control" value="<%=Html(strResponsaveldatanascimento)%>" <%=strReadOnly%>></div>
                    <div class="col-md-2 form-group"><label class="form-label">Telefone</label><input name="txtResponsavelfone" maxlength="30" class="form-control" value="<%=Html(strResponsavelfone)%>" <%=strReadOnly%>></div>
                    <div class="col-md-2 form-group"><label class="form-label">Profissão</label><fieldset class="m-0 p-0 border-0" <%=strFieldsetDisabled%>><!--#include file="includes/inc_cmdProfissaoResponsavel.asp"--></fieldset></div>
                    <div class="col-md-2 form-group"><label class="form-label">Grau instrução</label><fieldset class="m-0 p-0 border-0" <%=strFieldsetDisabled%>><!--#include file="includes/inc_cmdGrauInstrucaoResponsavel.asp"--></fieldset></div>
                </div>
            </div></div>
        </div>

        <div class="card border mb-2">
            <div class="card-header" style="cursor:pointer" data-toggle="collapse" data-target="#adicionais"><strong>Informações adicionais&nbsp;&nbsp;<em class="fal fa-angle-down"></em></strong></div>
            <div id="adicionais" class="collapse"><div class="p-4">
                <div class="row">
                    <div class="col-md-3 form-group"><label class="form-label">Faz uso de medicamento controlado?</label><select name="MEDICAMENTO_CONTROLADO" id="MEDICAMENTO_CONTROLADO" class="form-control" onchange="verificaMedicamento();" <%=strDisabled%>><option value="N" <%If MEDICAMENTO_CONTROLADO="N" Then Response.Write("selected")%>>Não</option><option value="S" <%If MEDICAMENTO_CONTROLADO="S" Then Response.Write("selected")%>>Sim</option></select></div>
                    <div class="col-md-9 form-group" id="linha_medicamento_qual"><label class="form-label">Qual medicamento?</label><input name="MEDICAMENTO_CONTROLADO_QUAL" maxlength="50" class="form-control" value="<%=Html(MEDICAMENTO_CONTROLADO_QUAL)%>" <%=strReadOnly%>></div>
                </div>
                <div class="row">
                    <div class="col-md-4 form-group"><label class="form-label">Utiliza transporte escolar municipal?</label><select name="TRANSPORTE_ESCOLAR" class="form-control" <%=strDisabled%>><option value="N" <%If TRANSPORTE_ESCOLAR="N" Then Response.Write("selected")%>>Não</option><option value="S" <%If TRANSPORTE_ESCOLAR="S" Then Response.Write("selected")%>>Sim</option></select></div>
                    <div class="col-md-4 form-group"><label class="form-label">Autoriza o uso da imagem?</label><select name="AUTORIZA_USO_IMAGEM" class="form-control" <%=strDisabled%>><option value="N" <%If AUTORIZA_USO_IMAGEM="N" Then Response.Write("selected")%>>Não</option><option value="S" <%If AUTORIZA_USO_IMAGEM="S" Then Response.Write("selected")%>>Sim</option></select></div>
                </div>
                <div class="row">
                    <div class="col-md-3 form-group"><label class="form-label">Possui restrição alimentar?</label><select name="RESTRICAO_ALIMENTAR" id="RESTRICAO_ALIMENTAR" class="form-control" onchange="verificaRestricao();" <%=strDisabled%>><option value="N" <%If RESTRICAO_ALIMENTAR="N" Then Response.Write("selected")%>>Não</option><option value="S" <%If RESTRICAO_ALIMENTAR="S" Then Response.Write("selected")%>>Sim</option></select></div>
                    <div class="col-md-9 form-group" id="linha_restricao_qual"><label class="form-label">Qual restrição?</label><input name="RESTRICAO_ALIMENTAR_QUAL" maxlength="50" class="form-control" value="<%=Html(RESTRICAO_ALIMENTAR_QUAL)%>" <%=strReadOnly%>></div>
                </div>
                <div class="row">
                    <div class="col-md-3 form-group"><label class="form-label">Possui alergia?</label><select name="ALERGIA" id="ALERGIA" class="form-control" onchange="verificaAlergia();" <%=strDisabled%>><option value="N" <%If ALERGIA="N" Then Response.Write("selected")%>>Não</option><option value="S" <%If ALERGIA="S" Then Response.Write("selected")%>>Sim</option></select></div>
                    <div class="col-md-9 form-group" id="linha_alergia_qual"><label class="form-label">Qual alergia?</label><input name="ALERGIA_QUAL" maxlength="50" class="form-control" value="<%=Html(ALERGIA_QUAL)%>" <%=strReadOnly%>></div>
                </div>
            </div></div>
        </div>

        <div class="frame-wrap mt-3">
            <button type="submit" class="btn btn-primary"><i class="fal fa-save"></i> Salvar</button>
            <a href="aee_ficha_paciente.asp" class="btn btn-secondary"><i class="fal fa-file"></i> Nova ficha</a>
            <a href="aee_ficha_paciente_con.asp" class="btn btn-outline-primary"><i class="fal fa-search"></i> Consultar</a>
            <%If intCodigo<>"" Then%>
            <button type="button" class="btn btn-danger float-right" onclick="if(confirm('Deseja realmente inativar esta ficha?')){document.getElementById('acao').value='E';document.getElementById('frmFichaPaciente').submit();}"><i class="fal fa-ban"></i> Inativar</button>
            <%End If%>
        </div>
    </form>

    <form id="frmLocalizarAluno" method="post" action="aee_ficha_paciente.asp" style="display:none">
        <input type="hidden" name="acao" value="L">
        <input type="hidden" name="txtTipoPaciente" value="R">
        <input type="hidden" name="txtMatriculaLocalizar" id="txtMatriculaLocalizarPost">
    </form>
</main>
<script>
function localizarAlunoRede(){
    var matricula = ($("#txtMatriculaLocalizar").val() || "").trim();
    if(!matricula){ alert("Informe a matrícula do aluno."); return; }
    $("#txtMatriculaLocalizarPost").val(matricula);
    $("#frmLocalizarAluno").submit();
}

function prepararFotoPacienteExterno(input){

    if(!input || !input.files || input.files.length === 0){
        return;
    }

    var arquivo = input.files[0];

    if(arquivo.type !== "image/jpeg" && arquivo.type !== "image/png"){
        alert("Selecione uma imagem JPG ou PNG.");
        input.value = "";
        return;
    }

    if(arquivo.size > (10 * 1024 * 1024)){
        alert("A imagem selecionada deve possuir no máximo 10 MB.");
        input.value = "";
        return;
    }

    var reader = new FileReader();

    reader.onload = function(e){

        var imagem = new Image();

        imagem.onload = function(){

            var larguraMaxima = 480;
            var alturaMaxima = 640;
            var largura = imagem.width;
            var altura = imagem.height;

            if(largura > larguraMaxima || altura > alturaMaxima){
                var proporcao = Math.min(
                    larguraMaxima / largura,
                    alturaMaxima / altura
                );

                largura = Math.round(largura * proporcao);
                altura = Math.round(altura * proporcao);
            }

            var canvas = document.createElement("canvas");
            canvas.width = largura;
            canvas.height = altura;

            var contexto = canvas.getContext("2d");

            contexto.fillStyle = "#FFFFFF";
            contexto.fillRect(0, 0, largura, altura);
            contexto.drawImage(imagem, 0, 0, largura, altura);

            var base64 = canvas.toDataURL("image/jpeg", 0.75);

            var imgPreview = document.getElementById("imgFotoPaciente");
            if(imgPreview){
                imgPreview.src = base64;
            }

            var campoBase64 = document.getElementById("txtFotoBase64");
            var campoNome = document.getElementById("txtFotoNome");
            var campoTipo = document.getElementById("txtFotoTipo");

            if(campoBase64){
                campoBase64.value = base64;
            }

            if(campoNome){
                var nomeOriginal = arquivo.name || "foto_paciente.jpg";
                nomeOriginal = nomeOriginal.replace(/\.[^/.]+$/, "");
                campoNome.value = nomeOriginal + ".jpg";
            }

            if(campoTipo){
                campoTipo.value = "image/jpeg";
            }
        };

        imagem.onerror = function(){
            alert("Não foi possível processar a imagem selecionada.");
            input.value = "";
        };

        imagem.src = e.target.result;
    };

    reader.onerror = function(){
        alert("Não foi possível carregar a imagem selecionada.");
        input.value = "";
    };

    reader.readAsDataURL(arquivo);
}
</script>
