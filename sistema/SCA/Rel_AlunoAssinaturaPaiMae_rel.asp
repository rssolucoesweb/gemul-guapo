<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de Notas
-->
<html>
<head>
<title><%=session("Titulo")%> - Alunos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<%
	dim intPagina
	dim strInfoTurma
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))
	strSexo					= Trim(Request.Form("cmbSexo"))
	strOrdem				= Trim(Request.Form("cmbOrdem"))
	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
	strAlunoSemSituacao     = Trim(Request.Form("AlunoSemSituacao"))

	strDataINasc			= formatadataAP(request.Form("txtDataINasc"))   
    strDataFNasc			= formatadataAP(request.Form("txtDataFNasc"))   
	strDataIAfast			= formatadataAP(request.Form("txtDataIAfast"))   
    strDataFAfast			= formatadataAP(request.Form("txtDataFAfast"))   
	strDataIMat				= formatadataAP(request.Form("txtDataIMat"))   
    strDataFMat				= formatadataAP(request.Form("txtDataFMat"))   

	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	strSemestre 			= session("strSemestre")
	strAnoLetivo 			= session("strAnoLetivo")

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	
	strTituloRelatorio  	= "ALUNOS<br>Assinatura"

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="7%" height="14" class="<%=strclasse%>"><div align="center"><strong>Matr&iacute;cula</strong></div></td>
		<td width="47%" class="<%=strclasse%>"><strong>Nome do Aluno</strong></td>
		<td width="7%" class="<%=strclasse%>"><strong>Turma</strong></td>
		<td width="4%" align="center" class="<%=strclasse%>"><div align="center"><strong>Data Nascimento</strong></div></td>
		<td width="4%" align="center" class="<%=strclasse%>"><strong>Idade</strong></td>
		<td width="31%" align="center" class="<%=strclasse%>"><strong>Assinatura</strong></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
%>
<%
	intPagina = 1
	mostraCabecalho
	cont = 0
	Idade= 0
	intCodTurma = 0


    sql = "SELECT  DISTINCT   SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.DATAMATRICULA , SCA_ALUNO.Responsavel, "
	sql = sql & " SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.DESCRICAO AS CURSO, SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma,  "
	sql = sql & " SCA_ALUNO.COD_FORMAINGRESSO, SCA_ALUNO.DATAFASTAMENTO, SCA_ALUNO.PAI, SCA_ALUNO.MAE"
    sql = sql & " FROM SCA_ALUNO_TURMA "
    sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
    sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
    sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
    sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa"
    sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa"
	sql = sql & " where SCA_ALUNO.Cod_empresa = " & session("CodEmpresa")
    sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " &  strAnoLetivo
	sql = sql & " and 	SCA_ALUNO_TURMA.Semestre in (" & strSemestre & ")"
	sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"	
	if strAlunoSemSituacao = "S" then
	  sql = sql & "and ISNULL(SCA_ALUNO.COD_SITUACAOALUNO, '0') = 0"
	else	    
	  if intCodSituacaoAluno <> "0" then
		  sql = sql & " and SCA_ALUNO.COD_SITUACAOALUNO = " & intCodSituacaoAluno
	  end if 
	end if
	
	if strSexo <> "0" then
		sql = sql & " and SCA_ALUNO.SEXOALUNO = '" & strSexo & "'"
	end if
	
	if strDataINasc <> "" and strDataFNasc <> "" then
	   	sql = sql & " and convert(datetime,convert(varchar, SCA_ALUNO.DATANASCIMENTO, 103),103) >=  convert(datetime, ' " & strDataINasc & "',103)"
        sql = sql & " and convert(datetime,convert(varchar, SCA_ALUNO.DATANASCIMENTO, 103),103) <=  convert(datetime, ' " & strDataFNasc & "',103)"
	end if
	
	if strDataIAfast <> "" and strDataFAfast <> "" then
	   	sql = sql & " and convert(datetime,convert(varchar, SCA_ALUNO.DATAFASTAMENTO, 103),103) >=  convert(datetime, ' " & strDataIAfast & "',103)"
        sql = sql & " and convert(datetime,convert(varchar, SCA_ALUNO.DATAFASTAMENTO, 103),103) <=  convert(datetime, ' " & strDataFAfast & "',103)"
	end if
	
	if strDataIMat <> "" and strDataFMat <> "" then
	   	sql = sql & " and convert(datetime,convert(varchar, SCA_ALUNO.DATAMATRICULA, 103),103) >=  convert(datetime, ' " & strDataIMat & "',103)"
        sql = sql & " and convert(datetime,convert(varchar, SCA_ALUNO.DATAMATRICULA, 103),103) <=  convert(datetime, ' " & strDataFMat & "',103)"
	end if

	'ordem de classificação do relatorio
	sql = sql & " Order By SCA_TURMA.NOMETURMA, SCA_ALUNO.NOMEALUNO"
	
	rs.open sql, cnn
	if not rs.eof then 

		contPorTurma = 0

		While not rs.eof
		
			strResponsavel = ""
			strNomeTurma  = rs("NomeTurma")
			
			if trim(rs("pai")) <> "" then 
				strNomePai = trim(rs("pai"))
			else
				strNomePai = "<span class='style1'>Falta informação no cadastro, Verifique! </span>"
			end if		
			
			if trim(rs("Mae")) <> "" then 
				strNomeMae = trim(rs("Mae"))
			else
				strNomeMae = "<span class='style1'>Falta informação no cadastro, Verifique! </span>"
			end if			
			
			if trim(rs("DATANASCIMENTO")) <> "" then 
				Idade = calculaIdade(rs("DATANASCIMENTO"))
			end if
			
			if trim(rs("Responsavel")) <> "" then 
				strResponsavel = trim(rs("Responsavel"))
			end if
			
			if Idade < 12 then
				strAssinatura = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
			else
				strAssinatura = ""
			end if
            
			%>
			  <tr>
			    <td height="22" align="left" bgcolor="#F0F0F0" class="<%=strclasse%>"><%=rs("MATRICULA")%></td>
                    <td align="left" bgcolor="#F0F0F0" class="<%=strclasse%>"><%=rs("NOMEALUNO")%></td>
                    <td align="left" bgcolor="#F0F0F0" class="<%=strclasse%>"><%=trim(strNomeTurma)%>&nbsp;</td>
                    <td align="left" bgcolor="#F0F0F0" class="<%=strclasse%>"><%=formataDataAP(rs("DATANASCIMENTO"))%></td>
                    <td align="center" bgcolor="#F0F0F0" class="<%=strclasse%>"><%=Idade%>anos</td>
                    <td align="center" bgcolor="#F0F0F0" class="<%=strclasse%>"><%=strAssinatura%>&nbsp;</td>
	  			</tr>
                <tr>
                    <td height="22" align="left" class="<%=strclasse%>"><strong>Nome do Pai</strong></td>
                    <td colspan="4" align="left" class="<%=strclasse%>"><%=strNomePai%>&nbsp;</td>
                    <td class="<%=strclasse%>" align="center">&nbsp;</td>
                </tr>
                <tr>
                  <td height="22" align="left" class="<%=strclasse%>"><strong>Nome da M&atilde;e</strong></td>
                  <td colspan="4" align="left" class="<%=strclasse%>" ><%=strNomeMae%></td>
                  <td class="<%=strclasse%>" align="center">&nbsp;</td>
                </tr>
                <tr>
                    <td height="22" align="left" class="<%=strclasse%>"><strong>Responsável:</strong></td>
                    <td colspan="4" align="left" class="<%=strclasse%>" ><%=strResponsavel%>&nbsp; </td>
                    <td class="<%=strclasse%>" align="center">&nbsp;</td>
                </tr>
			<%
			'quantidade de registros da página
			strNomeMae =""
			strNomepai = ""
			
			if int(intQtdeRegistroPorPagina) = 12 then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 0
				 fimTabela
				 response.write "<pre> </pre>"
				mostraCabecalho
			end if	
			cont = cont + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			intCodTurma  = rs("COD_TURMA")
			rs.movenext
			if not rs.eof then
				if intCodTurma  <> rs("COD_TURMA") then
				 	intPagina = 1
				 	intQtdeRegistroPorPagina = 0
				 	fimTabela
				 	response.write "<pre> </pre>"
				 	mostraCabecalho
				end if 
			else   
				 intPagina = 1
				 intQtdeRegistroPorPagina = 0
				 fimTabela
				 response.write "<pre> </pre>"
				 mostraCabecalho
			end if			   
			   
		wend
		%>
		  <tr>
			<td colspan="6" class="<%=strclasse%>">Quantidade de Alunos: <%=cont%></td>
		  </tr>
		 <%
	end if
	rs.close
%>
</table>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
