<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Response.Buffer = True
Server.ScriptTimeout = 900
%>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_formataCPF.asp"-->
<%
'==========================================================================
' sca_rel_aluno_pdf.asp
' Gera o PDF do relatorio de alunos NO SERVIDOR, desenhando o PDF direto em
' VBScript (sem navegador, sem componentes externos, sem arquivos temporarios).
' Recebe o mesmo POST do formulario de sca_rel_alunoCon.asp.
' Todas as variaveis deste arquivo comecam com p_ (ou pdf_) para nao
' colidir com as variaveis dos includes.
'==========================================================================

'---------------------- funcoes auxiliares ---------------------------------
Function pdf_Digitos(v, padrao)
	Dim s, k, ok
	s = Trim(v & "")
	ok = (Len(s) > 0)
	For k = 1 To Len(s)
		If InStr("0123456789", Mid(s, k, 1)) = 0 Then ok = False
	Next
	If ok Then pdf_Digitos = s Else pdf_Digitos = padrao
End Function

Function pdf_Lista(v, padrao)
	Dim s, k, ok
	s = Replace(Trim(v & ""), " ", "")
	ok = (Len(s) > 0)
	For k = 1 To Len(s)
		If InStr("0123456789,", Mid(s, k, 1)) = 0 Then ok = False
	Next
	If ok Then pdf_Lista = s Else pdf_Lista = padrao
End Function

Function pdf_SN(v)
	v = UCase(Trim(v & ""))
	If v = "S" Or v = "N" Then pdf_SN = v Else pdf_SN = "0"
End Function

Function pdf_On(nome)
	pdf_On = (Trim(Request.Form(nome) & "") = "S")
End Function

Function pdf_Enc(v)
	pdf_Enc = Server.HTMLEncode(v & "")
End Function

' "celulaarial10" -> 10
Function pdf_Fonte(classe)
	Dim k, d
	d = ""
	For k = Len(classe) To 1 Step -1
		If InStr("0123456789", Mid(classe, k, 1)) > 0 Then
			d = Mid(classe, k, 1) & d
		Else
			Exit For
		End If
	Next
	If d = "" Or Len(d) > 2 Then d = "10"
	If CInt(d) < 6 Then d = "6"
	If CInt(d) > 16 Then d = "16"
	pdf_Fonte = d
End Function

Sub pdf_Erro(msg)
	Response.Clear
	Response.ContentType = "text/html"
	Response.Write "<html><body style='font-family:Arial'><h3>N&atilde;o foi poss&iacute;vel gerar o PDF</h3><p>" & Server.HTMLEncode(msg) & "</p></body></html>"
	Response.End
End Sub

'---------------------- definicao das colunas ------------------------------
Dim p_cT(80), p_cC(80), p_cTp(80), p_cAl(80), p_n
p_n = 0
Sub pdf_Col(titulo, campo, tipo, alin)
	p_cT(p_n) = titulo : p_cC(p_n) = campo : p_cTp(p_n) = tipo : p_cAl(p_n) = alin
	p_n = p_n + 1
End Sub

'==========================================================================
' 1) FILTROS (mesmos nomes de campo do formulario), todos validados
'==========================================================================
Dim p_mostraEmpresa, p_empresa, p_ano, p_sem, p_curso, p_periodo, p_turno, p_turma
Dim p_sit, p_sexo, p_mes, p_idade, p_atend, p_aee, p_necSN, p_defic
Dim p_ordem, p_agrupa, p_lpp, p_fonte

If Session("NivelPermissao") = "A" Then
	p_empresa = pdf_Digitos(Request.Form("cmbEmpresaGrupo"), "0")
Else
	p_empresa = pdf_Digitos(Session("CodEmpresa"), "0")
End If

If pdf_Digitos(Request.Form("txtAnoLetivo"), "") <> "" Then
	p_ano = pdf_Digitos(Request.Form("txtAnoLetivo"), "")
Else
	p_ano = pdf_Digitos(Session("strAnoLetivo"), "0")
End If

p_sem     = pdf_Lista(Request.Form("cmbSemestre"), "")
p_curso   = pdf_Digitos(Request.Form("cmbCurso"), "0")
p_periodo = pdf_Digitos(Request.Form("cmbPeriodo"), "0")
p_turno   = pdf_Digitos(Request.Form("cmbTurno"), "0")
p_turma   = pdf_Digitos(Request.Form("cmbTurma"), "0")
p_sit     = pdf_Digitos(Request.Form("cmbSituacaoAluno"), "0")
p_sexo    = Replace(Trim(Request.Form("cmbSexo") & ""), "'", "''")
If p_sexo = "" Then p_sexo = "0"
p_mes     = pdf_Digitos(Request.Form("cmbMes"), "0")
p_idade   = pdf_Digitos(Request.Form("cmbIdade"), "0")
p_atend   = pdf_SN(Request("cmbAtendimentoEspecial"))
p_aee     = pdf_SN(Request("cmbSalaAEE"))
p_necSN   = Trim(Request("cmbNecessidadeEspecialSN") & "")
p_defic   = "0"
If p_necSN = "S" Then p_defic = pdf_Lista(Request.Form("chkDeficiencia"), "0")

p_ordem   = LCase(Trim(Request.Form("cmbOrdem") & ""))
p_agrupa  = (Trim(Request.Form("cmbQuebraPagina") & "") = "TURMA")
p_lpp     = CLng(pdf_Digitos(Request.Form("cmblpp"), "0"))
p_fonte   = pdf_Fonte(Trim(Request.Form("cmbTamanhoFonteArial") & ""))

' titulo (igual ao relatorio em tela)
p_titulo = "Relatório de Alunos"
If p_idade <> "0" Then p_titulo = p_titulo & " - Com idade de " & p_idade
If p_mes <> "0" Then
	If CInt(p_mes) >= 1 And CInt(p_mes) <= 12 Then p_titulo = p_titulo & " - Aniversariantes de " & UCase(MonthName(CInt(p_mes)))
End If
If p_atend = "S" Then p_titulo = p_titulo & " - Com Atendimento Especial"
If p_aee = "S" Then p_titulo = p_titulo & " - Usa Sala AEE"

'==========================================================================
' 2) COLUNAS (mesma ordem e mesmos rotulos do relatorio em tela)
'==========================================================================
If p_empresa = "0" Then pdf_Col "Unidade", "UNIDADE", "txt", "l"
If pdf_On("turma") Then pdf_Col "Turma", "", "turma", "c"
pdf_Col "Matrícula", "MATRICULA", "txt", "c"
pdf_Col "Nome do Aluno", "NOMEALUNO", "txt", "l"
If pdf_On("sexo") Then pdf_Col "Sexo", "SEXOALUNO", "txt", "c"
If pdf_On("cpf") Then pdf_Col "CPF", "CPF", "cpf", "c"
If pdf_On("identidade") Then pdf_Col "Número RG Nasc.", "NUMREGISTRONASC", "txt", "l"
If pdf_On("datamatricula") Then pdf_Col "Data da Matrícula", "DATAMATRICULA", "data", "c"
If pdf_On("datanascimento") Then pdf_Col "Data Nascimento", "DATANASCIMENTO", "data", "c"
If pdf_On("dataafastamento") Then pdf_Col "Data Afastamento", "DATAFASTAMENTO", "data", "c"
If pdf_On("idade") Then pdf_Col "Idade", "IDADE", "txt", "c"
If pdf_On("naturalidade") Then pdf_Col "Naturalidade", "CIDADENASCIMENTO", "txt", "l"
If pdf_On("endereco") Then pdf_Col "Endereço", "LOGRADOURO", "txt", "l"
If pdf_On("numeroendereco") Then pdf_Col "Número", "NUMERO_ENDERECO", "txt", "l"
If pdf_On("complementoendereco") Then pdf_Col "Complemento", "COMP_ENDERECO", "txt", "l"
If pdf_On("bairro") Then pdf_Col "Bairro", "BAIRROALUNO", "txt", "l"
If pdf_On("cidade") Then pdf_Col "Cidade", "CIDADERESIDENCIA", "txt", "l"
If pdf_On("telefonecomercial") Then pdf_Col "Fone Comercial", "FONECOMERCIAL", "txt", "l"
If pdf_On("telefoneresidencial") Then pdf_Col "Fone Residencial", "FONERESIDENCIAL", "txt", "l"
If pdf_On("telefonecelular") Then pdf_Col "Celular", "FONECELULAR", "txt", "l"
If pdf_On("cartaosus") Then pdf_Col "Cartão SUS", "CARTAOSUS", "txt", "l"
If pdf_On("bolsafamilia") Then pdf_Col "Auxílio Brasil", "BOLSA_FAMILIA", "txt", "l"
If pdf_On("nomepai") Then pdf_Col "Pai", "PAI", "txt", "l"
If pdf_On("nomemae") Then pdf_Col "Mãe", "MAE", "txt", "l"
If pdf_On("nomeresponsavel") Then pdf_Col "Responsável", "RESPONSAVEL", "txt", "l"
If pdf_On("telefoneresponsavel") Then pdf_Col "Fone Responsável", "RESPONSAVELFONE", "txt", "l"
If pdf_On("email") Then pdf_Col "Email", "EMAIL", "txt", "l"
If pdf_On("codigoseguranca") Then pdf_Col "Cod.Segurança", "CODIGO", "txt", "c"
If pdf_On("situacaoaluno") Then pdf_Col "Situação", "DESC_SITUACAOALUNO", "txt", "l"
If pdf_On("atendimentoespecial") Then pdf_Col "Atend. Especial", "ATENDIMENTOESPECIAL", "txt", "l"
If pdf_On("necessidadeespeciais") Then pdf_Col "Necessidade Especial", "NECESSIDADES", "txt", "l"
If pdf_On("sala_aee") Then pdf_Col "Usa Sala AEE", "SALA_AEE", "txt", "l"
If pdf_On("UNIFORME_TAMANHO") Then pdf_Col "Tamanho do uniforme", "UNIFORME_TAMANHO", "txt", "c"
If pdf_On("TENIS_TAMANHO") Then pdf_Col "Tamanho calçado", "TENIS_TAMANHO", "txt", "c"
If pdf_On("medicamento") Then pdf_Col "Faz uso de medicamento controlado?", "MEDICAMENTO_CONTROLADO", "txt", "c"
If pdf_On("transportescolar") Then pdf_Col "Utiliza transporte escolar municipal?", "TRANSPORTE_ESCOLAR", "txt", "c"
If pdf_On("usodaimagem") Then pdf_Col "Autoriza o uso da imagem do filho(a) em eventos da SEMEC/ESCOLA?", "AUTORIZA_USO_IMAGEM", "txt", "c"
If pdf_On("restricaoalimentar") Then pdf_Col "Possui restrição alimentar?", "RESTRICAO_ALIMENTAR", "txt", "c"
If pdf_On("alergia") Then pdf_Col "Possui alergia?", "ALERGIA", "txt", "c"
If pdf_On("cod_etnia") Then pdf_Col "Etnia", "ETNIA", "txt", "c"
If pdf_On("id_censo") Then pdf_Col "ID Censo", "ID_CENSO", "txt", "c"
If pdf_On("assinatura") Then pdf_Col "Assinatura", "", "assin", "c"
If pdf_On("assinaturapaiemae") Then
	pdf_Col "Pai", "PAI", "txt", "c"
	pdf_Col "Assinatura", "", "assin", "c"
	pdf_Col "Mãe", "MAE", "txt", "c"
	pdf_Col "Assinatura", "", "assin", "c"
End If
If pdf_On("controlerequerimento") Then
	pdf_Col "Ano/Semestre", "", "ano", "c"
	pdf_Col "Emissão no Portal", "", "branco", "c"
	pdf_Col "Entrega Secretaria", "", "branco", "c"
	pdf_Col "Resp. Baixa", "", "branco", "c"
End If

'==========================================================================
' 3) SQL (mesmo FROM/WHERE do relatorio em tela, com valores validados)
'==========================================================================
Dim p_sql, p_filtroDef
p_sql = "SELECT DISTINCT A.CODIGO, A.MATRICULA, A.CPF, A.NOMEALUNO, A.DATANASCIMENTO, A.DATAFASTAMENTO, A.DATAMATRICULA, FLOOR(DATEDIFF(DAY, A.DataNascimento, GETDATE()) / 365.25) AS IDADE, "
p_sql = p_sql & " A.MAE, A.PAI, SA.DESC_SITUACAOALUNO, A.ATENDIMENTOESPECIAL, iif(A.sala_aee='S','Sim','Não') as sala_aee, NE.Desc_NecEspecial AS NECESSIDADEESPECIAIS, "
p_sql = p_sql & " A.LOGRADOURO, A.NUMERO_ENDERECO, A.COMP_ENDERECO, A.NUMREGISTRONASC, A.CEPRESIDENCIA, A.RESPONSAVELFONE, A.RESPONSAVEL, A.CIDADENASCIMENTO, A.CIDADERESIDENCIA, A.BAIRROALUNO, A.SEXOALUNO, "
p_sql = p_sql & " A.FONECOMERCIAL, A.FONERESIDENCIAL, A.FONECELULAR, A.bolsa_Familia, A.CARTAOSUS, A.EMAIL, T.COD_TURMA, T.NomeTurma, T.TURMAALUNO, TC.DESCRICAO + ' (' + TC.RESUMO + ')' AS TENIS_TAMANHO, TR.DESCRICAO AS UNIFORME_TAMANHO,"
p_sql = p_sql & " case when A.MEDICAMENTO_CONTROLADO = 'S' then 'Sim. ' + A.MEDICAMENTO_CONTROLADO_QUAL else 'Não' end as MEDICAMENTO_CONTROLADO,"
p_sql = p_sql & " case when A.TRANSPORTE_ESCOLAR = 'S' then 'Sim' else 'Não' end as TRANSPORTE_ESCOLAR,"
p_sql = p_sql & " case when A.AUTORIZA_USO_IMAGEM = 'S' then 'Sim' else 'Não' end as AUTORIZA_USO_IMAGEM,"
p_sql = p_sql & " case when A.RESTRICAO_ALIMENTAR = 'S' then 'Sim. ' + A.RESTRICAO_ALIMENTAR_QUAL else 'Não' end as RESTRICAO_ALIMENTAR,"
p_sql = p_sql & " case when A.ALERGIA = 'S' then 'Sim. ' + A.ALERGIA_QUAL else 'Não' end as ALERGIA, EM.RAZAOSOCIAL AS UNIDADE, A.ID_CENSO, ETN.DESCRICAO AS ETNIA"

' necessidades especiais: uma unica consulta (em vez de 1 consulta por aluno)
If pdf_On("necessidadeespeciais") Then
	p_filtroDef = ""
	If p_defic <> "0" Then p_filtroDef = " AND x.COD_NECESSIDADEESPECIAL IN (" & p_defic & ")"
	p_sql = p_sql & ", (SELECT STUFF((SELECT DISTINCT ', ' + n.Desc_NecEspecialNova FROM SCA_ALUNO_NECESSIDADEESPECIAL x INNER JOIN SCA_NECESSIDADEESPECIAL n ON n.Cod_NecEspecial = x.COD_NECESSIDADEESPECIAL WHERE x.COD_ALUNO = A.CODIGO" & p_filtroDef & " FOR XML PATH(''), TYPE).value('.','nvarchar(4000)'), 1, 2, '')) AS NECESSIDADES"
End If

p_sql = p_sql & " FROM SCA_ALUNO A "
p_sql = p_sql & " INNER JOIN sca_aluno_turma AT ON AT.COD_ALUNO = A.CODIGO "
p_sql = p_sql & " INNER JOIN sca_aluno_turma_situacao ATC ON ATC.COD_ALUNO_TURMA = AT.CODIGO "
p_sql = p_sql & " LEFT JOIN SCA_TURMA T ON AT.COD_TURMA = T.Cod_Turma AND AT.ANO_LETIVO = T.AnoLetivo AND AT.SEMESTRE = T.Cod_Semestre AND AT.cod_empresa = T.cod_empresa "
p_sql = p_sql & " LEFT JOIN SCA_GRADECURRICULAR G ON T.Cod_GradeCurricular = G.Cod_GradeCurricular"
p_sql = p_sql & " LEFT JOIN SCA_PERIODO P ON P.Cod_Periodo = G.Cod_Periodo "
p_sql = p_sql & " LEFT JOIN SCA_CURSO C ON C.Cod_Curso = P.Cod_Curso "
p_sql = p_sql & " LEFT JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SITUACAOALUNO = ATC.COD_SITUACAOALUNO"
p_sql = p_sql & " LEFT JOIN SCA_NECESSIDADEESPECIAL NE ON NE.Cod_NecEspecial = A.COD_NECESPECIAL"
p_sql = p_sql & " LEFT JOIN SEG_EMPRESA EM ON EM.CODIGO = AT.COD_EMPRESA"
p_sql = p_sql & " LEFT JOIN SCA_ETNIAS ETN ON ETN.CODIGO = A.COD_ETNIA"
p_sql = p_sql & " LEFT JOIN SCA_TAMANHO_CALCADO TC ON TC.CODIGO = A.COD_TAMANHO_CALCADO"
p_sql = p_sql & " LEFT JOIN SCA_TAMANHO_ROUPA TR ON TR.CODIGO = A.COD_TAMANHO_ROUPA"
p_sql = p_sql & " WHERE 1=1"
If p_empresa <> "0" Then p_sql = p_sql & " AND T.cod_empresa = " & p_empresa
p_sql = p_sql & " AND T.SITUACAO='A'"
p_sql = p_sql & " AND AT.Ano_Letivo = " & p_ano
If p_sem <> "" Then p_sql = p_sql & " AND AT.Semestre IN (" & p_sem & ")"
If p_curso <> "0" Then p_sql = p_sql & " AND C.Cod_Curso = " & p_curso
If p_periodo <> "0" Then p_sql = p_sql & " AND G.Cod_Periodo = " & p_periodo
If p_turno <> "0" Then p_sql = p_sql & " AND T.COD_TURNO = " & p_turno
If p_turma <> "0" Then p_sql = p_sql & " AND AT.COD_TURMA = " & p_turma
If p_sit <> "0" Then p_sql = p_sql & " AND ATC.cod_situacaoaluno = " & p_sit
If p_sexo <> "0" Then p_sql = p_sql & " AND A.SEXOALUNO = '" & p_sexo & "'"
If p_mes <> "0" Then p_sql = p_sql & " AND month(A.DATANASCIMENTO) = " & p_mes
If p_idade <> "0" Then p_sql = p_sql & " AND FLOOR(DATEDIFF(DAY, A.DataNascimento, GETDATE()) / 365.25) = " & p_idade
If p_atend <> "0" Then p_sql = p_sql & " AND A.ATENDIMENTOESPECIAL = '" & p_atend & "'"
If p_aee <> "0" Then p_sql = p_sql & " AND A.sala_aee = '" & p_aee & "'"
If p_necSN = "S" Then p_sql = p_sql & " AND A.codigo IN (SELECT DISTINCT cod_aluno FROM sca_aluno_necessidadeespecial WHERE COD_NECESSIDADEESPECIAL IN (" & p_defic & "))"

' ordem (lista branca, igual ao relatorio em tela)
Dim p_pref, p_ord
p_pref = ""
If p_agrupa Then p_pref = "T.NomeTurma, T.COD_TURMA, "
Select Case p_ordem
	Case "unidade"
		If p_agrupa Then p_ord = "EM.RAZAOSOCIAL, T.NomeTurma, T.COD_TURMA, A.NOMEALUNO" Else p_ord = "EM.RAZAOSOCIAL, A.NOMEALUNO"
	Case "matricula"
		p_ord = p_pref & "A.matricula"
	Case "datamatricula"
		p_ord = p_pref & "A.datamatricula"
	Case "dataafastamento"
		p_ord = p_pref & "A.DATAFASTAMENTO"
	Case "idade"
		p_ord = p_pref & "A.DATANASCIMENTO desc"
	Case "bairro"
		p_ord = p_pref & "A.BAIRROALUNO"
	Case Else
		p_ord = p_pref & "A.NOMEALUNO"
End Select
p_sql = p_sql & " ORDER BY " & p_ord


'==========================================================================
' 4) PARAMETROS DE PAGINA E FONTES (Helvetica padrao do PDF)
'==========================================================================
Const PDF_ESCALA_FONTE = 0.8     ' tamanho da fonte em pt = (fonte da tela) x este fator

Dim p_PgW, p_PgH, p_mg, p_mT, p_mB, p_pad, p_fs, p_lead, p_minH
Dim p_wR(), p_wB()
Dim p_cx(80), p_cw(80), p_cmx(80), p_cmn(80)
Dim p_wl(80), p_hl(80)
Dim p_pg(), p_np, p_cur, p_y, p_rowsPg, p_tx(), p_twm()
Dim p_cabStr, p_cabH, p_cabPgX, p_cabPgY, p_ssz

If p_n <= 6 Then
	p_PgW = 595 : p_PgH = 842
ElseIf p_n <= 14 Then
	p_PgW = 842 : p_PgH = 595
Else
	p_PgW = 1191 : p_PgH = 842
End If
p_mg = 24 : p_mT = 24 : p_mB = 36 : p_pad = 2.5
p_fs = CDbl(p_fonte) * PDF_ESCALA_FONTE
If p_fs < 5 Then p_fs = 5
p_lead = p_fs * 1.2
p_minH = 0
For p_i = 0 To p_n - 1
	If p_cTp(p_i) = "assin" Then p_minH = 26
Next

Sub pdf_InitFontes()
	Dim a, b, c, mp, bc
	ReDim p_wR(255)
	ReDim p_wB(255)
	a = Split("278,278,355,556,556,889,667,191,333,333,389,584,278,333,278,278,556,556,556,556,556,556,556,556,556,556,278,278,584,584,584,556,1015,667,667,722,722,667,611,778,722,278,500,667,556,833,722,778,667,778,722,667,611,722,667,944,667,667,611,278,278,278,469,556,333,556,556,500,556,556,278,556,556,222,222,500,222,833,556,556,556,556,333,500,278,556,500,722,500,500,500,334,260,334,584", ",")
	b = Split("278,333,474,556,556,889,722,238,333,333,389,584,278,333,278,278,556,556,556,556,556,556,556,556,556,556,333,333,584,584,584,611,975,722,722,722,722,667,611,778,722,278,556,722,611,833,722,778,667,778,722,667,611,722,667,944,667,667,611,333,278,333,584,556,333,556,611,556,611,556,333,611,611,278,278,556,278,889,611,611,611,611,389,556,333,611,556,778,556,556,500,389,280,389,584", ",")
	mp = "AAAAAAACEEEEIIIIDNOOOOOxOUUUUYPsaaaaaaaceeeeiiiidnooooo/ouuuuypy"
	For c = 0 To 255
		p_wR(c) = 556 : p_wB(c) = 556
	Next
	For c = 32 To 126
		p_wR(c) = CLng(a(c - 32)) : p_wB(c) = CLng(b(c - 32))
	Next
	p_wR(160) = 278 : p_wB(160) = 278
	For c = 192 To 255
		bc = Asc(Mid(mp, c - 191, 1))
		p_wR(c) = p_wR(bc) : p_wB(c) = p_wB(bc)
	Next
End Sub

' largura do texto em pontos
Function pdf_TWS(s, bold, sz)
	Dim k, c, t
	t = 0
	If bold Then
		For k = 1 To Len(s)
			c = AscW(Mid(s, k, 1))
			If c < 0 Or c > 255 Then c = 63
			t = t + p_wB(c)
		Next
	Else
		For k = 1 To Len(s)
			c = AscW(Mid(s, k, 1))
			If c < 0 Or c > 255 Then c = 63
			t = t + p_wR(c)
		Next
	End If
	pdf_TWS = t * sz / 1000
End Function

Function pdf_TW(s, bold)
	pdf_TW = pdf_TWS(s, bold, p_fs)
End Function

' numero com ponto decimal (independente da configuracao regional)
Function pdf_N(x)
	pdf_N = Replace(CStr(Round(x, 2)), ",", ".")
End Function

' texto -> literal de string PDF (somente ASCII; acentos em octal WinAnsi)
Function pdf_Esc(s)
	Dim k, c, r
	r = ""
	For k = 1 To Len(s)
		c = AscW(Mid(s, k, 1))
		If c < 0 Then c = c + 65536
		If c = 40 Or c = 41 Or c = 92 Then
			r = r & "\" & Chr(c)
		ElseIf c >= 32 And c <= 126 Then
			r = r & Chr(c)
		ElseIf c >= 160 And c <= 255 Then
			r = r & "\" & Right("000" & Oct(c), 3)
		ElseIf c = 8211 Then
			r = r & "\226"
		ElseIf c = 8212 Then
			r = r & "\227"
		ElseIf c = 8216 Then
			r = r & "\221"
		ElseIf c = 8217 Then
			r = r & "\222"
		ElseIf c = 8220 Then
			r = r & "\223"
		ElseIf c = 8221 Then
			r = r & "\224"
		ElseIf c = 8226 Then
			r = r & "\225"
		ElseIf c = 8364 Then
			r = r & "\200"
		Else
			r = r & "?"
		End If
	Next
	pdf_Esc = r
End Function

Function pdf_Limpa(v)
	Dim s
	s = v & ""
	s = Replace(s, vbCr, " ")
	s = Replace(s, vbLf, " ")
	s = Replace(s, vbTab, " ")
	pdf_Limpa = Trim(s)
End Function

' quebra o texto em linhas que cabem em wlim pontos
Function pdf_Wrap(s, wlim, bold)
	Dim out, cur, wd, k, arr, t, m
	If pdf_TW(s, bold) <= wlim Then
		pdf_Wrap = Array(s)
		Exit Function
	End If
	arr = Split(s, " ")
	out = "" : cur = ""
	For k = 0 To UBound(arr)
		wd = arr(k)
		If cur = "" Then t = wd Else t = cur & " " & wd
		If pdf_TW(t, bold) <= wlim Then
			cur = t
		Else
			If cur <> "" Then
				out = out & cur & Chr(1)
				cur = ""
			End If
			Do While Len(wd) > 1 And pdf_TW(wd, bold) > wlim
				m = Len(wd)
				Do While m > 1 And pdf_TW(Left(wd, m), bold) > wlim
					m = m - 1
				Loop
				out = out & Left(wd, m) & Chr(1)
				wd = Mid(wd, m + 1)
			Loop
			cur = wd
		End If
	Next
	out = out & cur
	pdf_Wrap = Split(out, Chr(1))
End Function

'==========================================================================
' 5) LEITURA DOS DADOS E LARGURA DAS COLUNAS
'==========================================================================
pdf_InitFontes

Dim p_rs, p_dat, p_nl, p_idx, p_j, p_r, p_k, p_v, p_ci(80)
Dim p_iCod, p_iTurma, p_iTAl
Set p_rs = Server.CreateObject("ADODB.Recordset")
p_rs.Open p_sql, cnn, 0, 1
p_nl = 0
If Not p_rs.EOF Then
	p_dat = p_rs.GetRows()
	p_nl = UBound(p_dat, 2) + 1
End If
Set p_idx = CreateObject("Scripting.Dictionary")
For p_k = 0 To p_rs.Fields.Count - 1
	p_idx(UCase(p_rs.Fields(p_k).Name)) = p_k
Next
p_rs.Close
Set p_rs = Nothing

p_iCod = p_idx("COD_TURMA") : p_iTurma = p_idx("NOMETURMA") : p_iTAl = p_idx("TURMAALUNO")
For p_j = 0 To p_n - 1
	p_ci(p_j) = -1
	If p_cC(p_j) <> "" Then
		If p_idx.Exists(UCase(p_cC(p_j))) Then p_ci(p_j) = p_idx(UCase(p_cC(p_j)))
	End If
Next

' larguras por coluna: minima (maior palavra do titulo) e desejada (maior conteudo)
Dim p_hw, p_dm(80), p_ww, p_mn, p_words, p_wd, p_cod, p_turmaAnt, p_nTurma
For p_j = 0 To p_n - 1
	p_dm(p_j) = 0
Next
If p_nl > 0 Then
	ReDim p_tx(p_n - 1, p_nl - 1)
	ReDim p_twm(p_n - 1, p_nl - 1)
	For p_r = 0 To p_nl - 1
		For p_j = 0 To p_n - 1
			Select Case p_cTp(p_j)
				Case "cpf"
					p_v = formataCPFap(p_dat(p_ci(p_j), p_r))
				Case "data"
					p_v = formatadataAP(p_dat(p_ci(p_j), p_r))
				Case "turma"
					p_v = p_dat(p_iTurma, p_r) & " - " & p_dat(p_iTAl, p_r)
				Case "ano"
					p_v = "____/____"
				Case "assin", "branco"
					p_v = ""
				Case Else
					If p_ci(p_j) >= 0 Then p_v = p_dat(p_ci(p_j), p_r) Else p_v = ""
			End Select
			p_tx(p_j, p_r) = pdf_Limpa(p_v)
			p_ww = pdf_TW(p_tx(p_j, p_r), False)
			p_twm(p_j, p_r) = p_ww
			If p_ww > p_dm(p_j) Then p_dm(p_j) = p_ww
		Next
	Next
End If

Dim p_sMax, p_sMin, p_avail, p_f, p_totW
p_sMax = 0 : p_sMin = 0
For p_j = 0 To p_n - 1
	p_hw = 0
	p_words = Split(p_cT(p_j), " ")
	For Each p_wd In p_words
		p_ww = pdf_TW(p_wd, True)
		If p_ww > p_hw Then p_hw = p_ww
	Next
	If p_cTp(p_j) = "assin" Then
		If p_dm(p_j) < 110 Then p_dm(p_j) = 110
	ElseIf p_cTp(p_j) = "ano" Or p_cTp(p_j) = "branco" Then
		If p_dm(p_j) < 70 Then p_dm(p_j) = 70
	End If
	p_cmx(p_j) = p_dm(p_j)
	If p_hw > p_cmx(p_j) Then p_cmx(p_j) = p_hw
	p_mn = p_dm(p_j)
	If p_mn > 28 Then p_mn = 28
	If p_hw > p_mn Then p_mn = p_hw
	If p_cTp(p_j) = "assin" Then p_mn = 80
	p_cmx(p_j) = p_cmx(p_j) + 2 * p_pad + 1
	p_cmn(p_j) = p_mn + 2 * p_pad + 1
	If p_cmn(p_j) > p_cmx(p_j) Then p_cmn(p_j) = p_cmx(p_j)
	p_sMax = p_sMax + p_cmx(p_j)
	p_sMin = p_sMin + p_cmn(p_j)
Next

p_avail = p_PgW - 2 * p_mg
For p_j = 0 To p_n - 1
	If p_sMax <= p_avail Then
		p_cw(p_j) = p_cmx(p_j) * p_avail / p_sMax
	ElseIf p_sMin >= p_avail Then
		p_cw(p_j) = p_cmn(p_j) * p_avail / p_sMin
	Else
		p_f = (p_avail - p_sMin) / (p_sMax - p_sMin)
		p_cw(p_j) = p_cmn(p_j) + (p_cmx(p_j) - p_cmn(p_j)) * p_f
	End If
Next
p_totW = 0
For p_j = 0 To p_n - 1
	p_cx(p_j) = p_mg + p_totW
	p_totW = p_totW + p_cw(p_j)
Next

'==========================================================================
' 6) DESENHO DAS PAGINAS
'==========================================================================
Sub pdf_Celulas(h, hdr, arr)
	Dim j, i, ln, tw, x, s, y
	y = p_y - h
	s = ""
	If hdr Then
		s = "0.82 g" & vbLf
		For j = 0 To p_n - 1
			s = s & pdf_N(p_cx(j)) & " " & pdf_N(y) & " " & pdf_N(p_cw(j)) & " " & pdf_N(h) & " re" & vbLf
		Next
		s = s & "f" & vbLf & "0 g" & vbLf
	End If
	For j = 0 To p_n - 1
		s = s & pdf_N(p_cx(j)) & " " & pdf_N(y) & " " & pdf_N(p_cw(j)) & " " & pdf_N(h) & " re" & vbLf
	Next
	s = s & "S" & vbLf
	If hdr Then
		s = s & "BT /F2 " & pdf_N(p_fs) & " Tf" & vbLf
	Else
		s = s & "BT /F1 " & pdf_N(p_fs) & " Tf" & vbLf
	End If
	For j = 0 To p_n - 1
		ln = arr(j)
		For i = 0 To UBound(ln)
			If ln(i) <> "" Then
				tw = pdf_TW(ln(i), hdr)
				If hdr Or p_cAl(j) = "c" Then
					x = p_cx(j) + (p_cw(j) - tw) / 2
				Else
					x = p_cx(j) + p_pad
				End If
				s = s & "1 0 0 1 " & pdf_N(x) & " " & pdf_N(p_y - p_pad - p_fs * 0.85 - i * p_lead) & " Tm (" & pdf_Esc(ln(i)) & ") Tj" & vbLf
			End If
		Next
	Next
	s = s & "ET" & vbLf
	p_cur = p_cur & s
End Sub

Sub pdf_DrawHeader()
	Dim j, mx, h
	mx = 1
	For j = 0 To p_n - 1
		p_hl(j) = pdf_Wrap(p_cT(j), p_cw(j) - 2 * p_pad, True)
		If UBound(p_hl(j)) + 1 > mx Then mx = UBound(p_hl(j)) + 1
	Next
	h = mx * p_lead + 2 * p_pad
	pdf_Celulas h, True, p_hl
	p_y = p_y - h
End Sub

Function pdf_WrapSz(s, wlim, bold, sz)
	Dim sv
	sv = p_fs
	p_fs = sz
	pdf_WrapSz = pdf_Wrap(s, wlim, bold)
	p_fs = sv
End Function

Function pdf_TxtOp(x, y, txt, bold, sz)
	Dim f
	If bold Then f = "/F2 " Else f = "/F1 "
	pdf_TxtOp = "BT " & f & pdf_N(sz) & " Tf 1 0 0 1 " & pdf_N(x) & " " & pdf_N(y) & " Tm (" & pdf_Esc(txt) & ") Tj ET" & vbLf
End Function

' Cabecalho igual ao da versao HTML (inc_cabecalhoRelatorio.asp): brasao, dados da
' escola (variaveis de sessao), titulo a direita, linha cinza e "Data da Impressao".
' Montado uma vez; o numero da pagina e' acrescentado no fim (precisa do total).
Sub pdf_PreparaCabecalho()
	Dim yTop, av, xB, wBlk, xT, wT, nsz, ssz, y, s, arr, i, hBlk, hT, hHdr, yT, tw
	Dim nome, l2, l3, nmDiretor, nmSecret, ySep, yRow, bairro, agora
	av = p_PgW - 2 * p_mg
	yTop = p_PgH - p_mT
	nsz = p_fs + 2
	ssz = p_fs
	p_ssz = ssz
	xB = p_mg + 46
	wBlk = av * 0.64 - 46
	xT = p_mg + av * 0.66
	wT = av * 0.34

	nome = Trim(Session("EmpresaWeb") & "")
	l2 = Trim(Session("EnderecoEmpresaWeb") & "")
	bairro = Trim(Session("BairroEmpresaWeb") & "")
	If bairro <> "" Then l2 = l2 & ", " & bairro
	l3 = Trim(Session("CidadeEmpresaWeb") & "") & "-" & Trim(Session("ufEmpresaWeb") & "") & ", " & Trim(Session("CepEmpresaWeb") & "") & "  -  " & Trim(Session("TelefoneEmpresaWeb") & "")
	nmDiretor = Trim(Session("NomeDiretorEmpresaWeb") & "")
	nmSecret = Trim(Session("NomeSecretariaEmpresaWeb") & "")
	If nmDiretor <> "" Then l3 = l3 & "    | Diretor(a): " & nmDiretor
	If nmSecret <> "" Then l3 = l3 & "    | Secretário(a): " & nmSecret

	s = "q 40 0 0 40 " & pdf_N(p_mg) & " " & pdf_N(yTop - 40) & " cm /Im1 Do Q" & vbLf
	y = yTop
	If nome <> "" Then
		arr = pdf_WrapSz(nome, wBlk, True, nsz)
		For i = 0 To UBound(arr)
			s = s & pdf_TxtOp(xB, y - nsz * 0.85, arr(i), True, nsz)
			y = y - nsz * 1.2
		Next
	End If
	If l2 <> "" Then
		arr = pdf_WrapSz(l2, wBlk, False, ssz)
		For i = 0 To UBound(arr)
			s = s & pdf_TxtOp(xB, y - ssz * 0.85, arr(i), False, ssz)
			y = y - ssz * 1.2
		Next
	End If
	arr = pdf_WrapSz(l3, wBlk, False, ssz)
	For i = 0 To UBound(arr)
		s = s & pdf_TxtOp(xB, y - ssz * 0.85, arr(i), False, ssz)
		y = y - ssz * 1.2
	Next
	hBlk = yTop - y
	If hBlk < 40 Then hBlk = 40

	arr = pdf_WrapSz(p_titulo, wT - 6, True, nsz)
	hT = (UBound(arr) + 1) * nsz * 1.2
	hHdr = hBlk
	If hT > hHdr Then hHdr = hT
	yT = yTop - (hHdr - hT) / 2
	For i = 0 To UBound(arr)
		tw = pdf_TWS(arr(i), True, nsz)
		s = s & pdf_TxtOp(xT + (wT - tw) / 2, yT - nsz * 0.85 - i * nsz * 1.2, arr(i), True, nsz)
	Next

	ySep = yTop - hHdr - 4
	s = s & "0.8 G 0.8 w " & pdf_N(p_mg) & " " & pdf_N(ySep) & " m " & pdf_N(p_mg + av) & " " & pdf_N(ySep) & " l S 0 G 0.5 w" & vbLf
	yRow = ySep - 4 - ssz * 0.85
	agora = Right("0" & Day(Now), 2) & "/" & Right("0" & Month(Now), 2) & "/" & Year(Now) & " " & Right("0" & Hour(Now), 2) & ":" & Right("0" & Minute(Now), 2) & ":" & Right("0" & Second(Now), 2)
	s = s & pdf_TxtOp(p_mg, yRow, "Data da Impressão: " & agora, False, ssz)

	p_cabStr = s
	p_cabPgX = p_mg + av
	p_cabPgY = yRow
	p_cabH = (yTop - yRow) + ssz * 0.35 + 8
End Sub

Sub pdf_NovaPagina()
	If p_np > 0 Then p_pg(p_np - 1) = p_cur
	If p_np > UBound(p_pg) Then ReDim Preserve p_pg(UBound(p_pg) + 500)
	p_np = p_np + 1
	p_cur = "0.5 w" & vbLf & p_cabStr
	p_rowsPg = 0
	p_y = p_PgH - p_mT - p_cabH
	pdf_DrawHeader
End Sub

Sub pdf_DrawDataRow(r)
	Dim j, mx, h
	mx = 1
	For j = 0 To p_n - 1
		If p_twm(j, r) <= p_cw(j) - 2 * p_pad Then
			p_wl(j) = Array(p_tx(j, r))
		Else
			p_wl(j) = pdf_Wrap(p_tx(j, r), p_cw(j) - 2 * p_pad, False)
			If UBound(p_wl(j)) + 1 > mx Then mx = UBound(p_wl(j)) + 1
		End If
	Next
	h = mx * p_lead + 2 * p_pad
	If h < p_minH Then h = p_minH
	If (p_lpp > 0 And p_rowsPg >= p_lpp) Or (p_y - h < p_mB) Then pdf_NovaPagina
	pdf_Celulas h, False, p_wl
	p_y = p_y - h
	p_rowsPg = p_rowsPg + 1
End Sub

' linha unica de largura total (titulo de turma / totais)
Sub pdf_Merged(txt, fill, bold)
	Dim ln, h, w, s, i, y, rc
	w = p_totW
	ln = pdf_Wrap(txt, w - 2 * p_pad, bold)
	h = (UBound(ln) + 1) * p_lead + 2 * p_pad
	If p_y - h < p_mB Then pdf_NovaPagina
	y = p_y - h
	rc = pdf_N(p_mg) & " " & pdf_N(y) & " " & pdf_N(w) & " " & pdf_N(h) & " re" & vbLf
	s = ""
	If fill Then s = "0.9 g" & vbLf & rc & "f" & vbLf & "0 g" & vbLf
	s = s & rc & "S" & vbLf
	If bold Then s = s & "BT /F2 " Else s = s & "BT /F1 "
	s = s & pdf_N(p_fs) & " Tf" & vbLf
	For i = 0 To UBound(ln)
		s = s & "1 0 0 1 " & pdf_N(p_mg + p_pad) & " " & pdf_N(p_y - p_pad - p_fs * 0.85 - i * p_lead) & " Tm (" & pdf_Esc(ln(i)) & ") Tj" & vbLf
	Next
	s = s & "ET" & vbLf
	p_cur = p_cur & s
	p_y = p_y - h
End Sub

pdf_PreparaCabecalho
ReDim p_pg(500)
p_np = 0
pdf_NovaPagina

If p_nl = 0 Then
	p_v = Session("strMensagemRelatorioNaoEncontrado") & ""
	If p_v = "" Then p_v = "Nenhum registro encontrado."
	pdf_Merged p_v, False, False
Else
	p_turmaAnt = "" : p_nTurma = 0
	For p_r = 0 To p_nl - 1
		p_cod = p_dat(p_iCod, p_r) & ""
		If p_agrupa And (p_r = 0 Or p_cod <> p_turmaAnt) Then
			If p_r > 0 Then
				pdf_Merged "Quantidade de Alunos Por Turma: " & p_nTurma, False, True
				pdf_NovaPagina
			End If
			pdf_Merged pdf_Limpa(p_dat(p_iTurma, p_r)) & " - " & pdf_Limpa(p_dat(p_iTAl, p_r)), True, True
			p_nTurma = 0
		End If
		pdf_DrawDataRow p_r
		p_nTurma = p_nTurma + 1
		p_turmaAnt = p_cod
	Next
	If p_agrupa Then pdf_Merged "Quantidade de Alunos Por Turma: " & p_nTurma, False, True
	pdf_Merged "Quantidade de Alunos: " & p_nl, False, True
End If
p_pg(p_np - 1) = p_cur

'==========================================================================
' 7) MONTA O ARQUIVO PDF (somente ASCII) E ENVIA AO NAVEGADOR
'==========================================================================
Dim p_stm, p_pos, p_off(), p_nObj, p_cont, p_foot, p_kids, p_xref, p_logoHex
Set p_stm = CreateObject("ADODB.Stream")
p_stm.Type = 2
p_stm.Charset = "iso-8859-1"
p_stm.Open
p_pos = 0

Sub pdf_Out(s)
	p_stm.WriteText s
	p_pos = p_pos + Len(s)
End Sub

p_nObj = 5 + 2 * p_np
ReDim p_off(p_nObj)

pdf_Out "%PDF-1.4" & vbLf

p_off(1) = p_pos
pdf_Out "1 0 obj" & vbLf & "<< /Type /Catalog /Pages 2 0 R >>" & vbLf & "endobj" & vbLf

p_kids = ""
For p_k = 0 To p_np - 1
	p_kids = p_kids & (6 + 2 * p_k) & " 0 R "
Next
p_off(2) = p_pos
pdf_Out "2 0 obj" & vbLf & "<< /Type /Pages /Kids [" & p_kids & "] /Count " & p_np & " >>" & vbLf & "endobj" & vbLf

p_off(3) = p_pos
pdf_Out "3 0 obj" & vbLf & "<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>" & vbLf & "endobj" & vbLf
p_off(4) = p_pos
pdf_Out "4 0 obj" & vbLf & "<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>" & vbLf & "endobj" & vbLf

' obj 5: brasao (RGB 50x50, Flate + hex)
p_logoHex = ""
p_logoHex = p_logoHex & "78dab599db6b545714c60ff4a5d03fa06f7d2814fad487522c7df0b104a42da135d0360f9140540c040c11a5639146834453"
p_logoHex = p_logoHex & "8cb1a491aa68a468954cda4c6334622e983438216d626c3b35182f2936d6fba5821692fed6f94ef6ec4c32938cb187c5b0cf"
p_logoHex = p_logoHex & "3e7beff5edb5beb5f63a67a6a7f3be2e5e1a6f4b24bababb749b1a1be3564267ff4052fd43433fd3f3dbefa9e9fff9fae7f1"
p_logoHex = p_logoHex & "e323c78e0d8f8cd038dbd7875e3a9f3c7d4ae7547881eae1c38782da71f224c3462f5c00dbc4c4c4730783f6cb972fd1402f"
p_logoHex = p_logoHex & "2af8c502d2ab01a03a373808a4e66ff6ba298067980f156cdac8d22f54b3b853877630d47fb9937e5ca94e9ea21ac0f43bab"
p_logoHex = p_logoHex & "ea96c134dc30797f89907013dbbc71f3a6330b2662716e7984461a824d1b9101d14b1b9cb469305273e9bf79fb36801d279f"
p_logoHex = p_logoHex & "ed028f2ce330d060f1caca4ada700607a1086a05e175e7ce5ddd020fda334cce75f064bda5d34c469041eeddbb8f5e567ef1"
p_logoHex = p_logoHex & "f5b7e88124084af10b9d60002760442a0cc2303aefdcbd8bc179242f3b322cd15cacfcf1fbcb41c566c180525420a81ebf7a"
p_logoHex = p_logoHex & "8d7e906022b4eb11a6e0112290cc427efd23c5222cf5bce2113bb047c10024f1a8b65cc32fb7b28f1a740246c881cd14c5a3"
p_logoHex = p_logoHex & "c8b044300a67b114fea01d5dd89f8d4b1d1e814b2842af50d160009d4c6100c318ac294c5762614198902f18a6af68dcf2c2"
p_logoHex = p_logoHex & "f68adae307d48377d8261c667134e20596fdf3fa75dd828a36b3101adcd209603c0548774be861c3bf6edc5068b7ecfd949e"
p_logoHex = p_logoHex & "c5230cea4a83e6c2a0bee054b2cfcf5af21d90d8bba8ab24e0c8a65ff52334b01edb610a21c9743f53f51e7e733a1500b2ab"
p_logoHex = p_logoHex & "e33b24071e6c6ea86a5606892250395b454ffb3b877f3cdefeed4e040bf04bcfbf13a9e9479326530fa2c6a3493a3592616c"
p_logoHex = p_logoHex & "8106b70cd63af81130d0e3d6b9e0c2f741ffa1c010e6b052cdca03275ad86059f34e4416e66a38dab6615fe2bdadfb828a46"
p_logoHex = p_logoHex & "82fda50f2b5eddb017a1e7938638f2eefe5e27eae1110318cf60a6d0a09345580a26606a3c08a4d37b82c76782a98100e459"
p_logoHex = p_logoHex & "516d5d0e30a35618f2e9fe92dd41c393a0b82358d3156c1eb55f093d4edef97ad6ad0623ebce0755c968308b94ecd69ac303"
p_logoHex = p_logoHex & "7d8041aeb546bf396c85e3ecb7b9b0f5cc89747f4563507335a8ecc92ac51dafd49f464c758e612c52d1e89635fb4c1a1e83"
p_logoHex = p_logoHex & "949ac75c4a025054a4220667a1cd810a236cef0e56b7ef3935d43a304ac36e1787ca0e8ec697c18313915f9aecc0f29f9207"
p_logoHex = p_logoHex & "60d4fd5b7f0338e3d182a830d1a58bbf3317a1611603eae25059f4a5cc56409a1e0c983ed7778436191843f9a45ad883c51d"
p_logoHex = p_logoHex & "90dc6270ea018d5c4e9c834a29025e612b50b924a60b24960d603b996aeb7282375f54b80f59d5329c2f2a90c85c08d8fc53"
p_logoHex = p_logoHex & "125ee144b3585d29e92e0f0fae6f09ca2c3304db866998fbcae2d6b968546409e15130aa58b5036e64c4cab9cfb620f3c766"
p_logoHex = p_logoHex & "3654c51d64217647f6264151cf602ef23f9df35b6c3e545c642d711e5466ba1952e1410e089d8019293d372aacc4be40c561"
p_logoHex = p_logoHex & "47a1a2778aacecf250914b5d03242e71b93c0f0c2315c71fc9aab9904268f1a87019470c873290c8e1a62b07e7675061019f"
p_logoHex = p_logoHex & "2796a9426a91be0ce10cab8d5450bdbe80fc909707858a7538ef642b6e73a0e218b2faa7ae3493f083e9ac4506609b11e0c2"
p_logoHex = p_logoHex & "0fd4a0a47c065472a2cdcd692b3b4c71ca6c54642d7910541c8e181ce3c02bd2170713550716cb238bce4165e5d3421e4445"
p_logoHex = p_logoHex & "c6d9611e1c3452e1417845ca2227189dea0b5ccacacb83963f3d540bf02a76252baa54642be25166b192322495d27bdebc9a"
p_logoHex = p_logoHex & "7a002a2a288019af72a0a2de0851f91e648a4ba44aefee11652abc525e75313b0b55f97866018396f2de20665513d8f825b1"
p_logoHex = p_logoHex & "abc4b244aa4a8631559de929e5e356748535897b290015859fa80e36a1a27655250caf74f4cccd57d268797bc75994aa3ce8"
p_logoHex = p_logoHex & "1f1a25fdd2d8dfda253c36000cb1b80e200638d1618490608d2a3d25be1618aee873f50ca8cc7775a596b5888e44915f5939"
p_logoHex = p_logoHex & "54c9f149a7025476deed382b010cb73e0c61d02efc012cd279e4078ba99e129597e91a7ed2a80ee17973999545435e65c46c"
p_logoHex = p_logoHex & "da832a415550f9a5a6efd30507c4aee041f42a5d4318d8c22f090a6094f119851f4e84ab4a59ccf2df6e16558b52063b5944"
p_logoHex = p_logoHex & "2d6a4e9971e28a1dab4466c7b48c4ba733b625d5e7818a4058dfc2e288550bdc661b49dd1e8bb320af2aa0929660d3326704"
p_logoHex = p_logoHex & "d2be3b6e487daa45796a474f4f09b37c541638b56171c27bc15ca968dcf5d56bc41142c3b640a78fd9496d0baf3c728d7126"
p_logoHex = p_logoHex & "a496258af8369d7a7e08603d03c3b0b0e463b028a7ef7b91ada8c6f9d53b0b06d9783092355d2029d9f551505dc3223428c5"
p_logoHex = p_logoHex & "233f828d4645a32d5e5dc3300e4aa172a99be28a5f065860d61764549b5cd80a13412df261745ecf8449e4c175e73faf7fdb"
p_logoHex = p_logoHex & "9456d7580f90f82d8ba30edff108a161e6228f619975e7f71f7a83c46892b2c0b7b7b3d083514dde5c28302689a2790b035d"
p_logoHex = p_logoHex & "d8479f599cdf230f82aa7c1c53905b0c98f22ad6281f070cfd0cb62d87f0947269a81250d2c6bf56afcea0b25dcb35402251"
p_logoHex = p_logoHex & "cc17fbc263f8256101af629557e9606d53c4f6d002662bbf06aeea04409a572452f10a6332cc09b7a05adb947e5308bf66e8"
p_logoHex = p_logoHex & "776e59eede07c99fb227045096a0022446ecddd98f41bd0efbb7f00da8886ee7a60b093138538bca831297b7fd171cae44f7"
p_logoHex = p_logoHex & "4f543e7e8f3ebc6847966639da58136cd9447aa90ab20d607a658fbefa52d445564a1429eec8031c0187dbbb331338d93b76"
p_logoHex = p_logoHex & "85c385b065a4a514acc4c490f364607dd398572217236559c730dd7d3ab6a22e0c79311ca5e6dccda37eb5c0bb09208d0f3c"
p_logoHex = p_logoHex & "2203e09d2ff6199e4dcbb02d08734487b3bcf17f6d53c6eb6db6cbb69c2882f09ceca617a5a8aeea0406602868c3fea49977"
p_logoHex = p_logoHex & "f3a882883009e3cb4e7f7dde3453d4b6341c6dcbfda1756eb6499f1a636368b437b258bc2d913006b2711208786aed5cb058"
p_logoHex = p_logoHex & "c0fbc0a84aea6b12a40a8b90a48d011203445d916475bb4d9783ac9e341f6173b6c3442a0434ea9cc562f63d7968947e9e32"
p_logoHex = p_logoHex & "46306c833a041178a258a6b3ba869412d9217c040ce6fa051e1920c2c6805a3ff093b38a49c75eb6b03df4bb9fea11c6e30e"
p_logoHex = p_logoHex & "36c55387c45f446b6aef280abfe1a07ade325817bb36ee01de45938a131f188f361ed436111ad196ab6bf8d5f94206b306da"
p_logoHex = p_logoHex & "192ffbb82f4bbeddc252d6fd1fb4e005a3227842e2c4aa825efbd5366b5b22c13e32b2fa234b26a36f11fe0a210d70aefb27"
p_logoHex = p_logoHex & "f1192e45a8d202ab4118522efca1b6a45f9f4c33844eb1ee5cf805de022a16e7d86211a6c0c30595fe07d564bcc8>"
p_off(5) = p_pos
pdf_Out "5 0 obj" & vbLf & "<< /Type /XObject /Subtype /Image /Width 50 /Height 50 /ColorSpace /DeviceRGB /BitsPerComponent 8 /Filter [/ASCIIHexDecode /FlateDecode] /Length " & Len(p_logoHex) & " >>" & vbLf & "stream" & vbLf & p_logoHex & vbLf & "endstream" & vbLf & "endobj" & vbLf

For p_k = 0 To p_np - 1
	p_off(6 + 2 * p_k) = p_pos
	pdf_Out CStr(6 + 2 * p_k) & " 0 obj" & vbLf & "<< /Type /Page /Parent 2 0 R /MediaBox [0 0 " & p_PgW & " " & p_PgH & "] /Resources << /Font << /F1 3 0 R /F2 4 0 R >> /XObject << /Im1 5 0 R >> >> /Contents " & (7 + 2 * p_k) & " 0 R >>" & vbLf & "endobj" & vbLf

	p_foot = "Página " & (p_k + 1) & " / " & p_np
	p_cont = p_pg(p_k) & pdf_TxtOp(p_cabPgX - pdf_TWS(p_foot, False, p_ssz), p_cabPgY, p_foot, False, p_ssz)

	p_off(7 + 2 * p_k) = p_pos
	pdf_Out CStr(7 + 2 * p_k) & " 0 obj" & vbLf & "<< /Length " & Len(p_cont) & " >>" & vbLf & "stream" & vbLf & p_cont & vbLf & "endstream" & vbLf & "endobj" & vbLf
Next

p_xref = p_pos
pdf_Out "xref" & vbLf & "0 " & (p_nObj + 1) & vbLf & "0000000000 65535 f " & vbLf
For p_k = 1 To p_nObj
	pdf_Out Right("0000000000" & p_off(p_k), 10) & " 00000 n " & vbLf
Next
pdf_Out "trailer" & vbLf & "<< /Size " & (p_nObj + 1) & " /Root 1 0 R >>" & vbLf & "startxref" & vbLf & p_xref & vbLf & "%%EOF" & vbLf

p_stm.Position = 0
p_stm.Type = 1

Response.Clear
Response.ContentType = "application/pdf"
Response.AddHeader "Content-Disposition", "inline; filename=relatorio_alunos.pdf"
Do While Not p_stm.EOS
	Response.BinaryWrite p_stm.Read(65536)
	Response.Flush
Loop
p_stm.Close
Set p_stm = Nothing
Response.End
%>
