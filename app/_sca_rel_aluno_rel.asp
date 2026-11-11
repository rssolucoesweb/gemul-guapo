<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
response.Expires=0
Server.ScriptTimeOut = 5000
response.Buffer = false
%>
<html>
<head>
<title>GEMUL - Alunos</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_formataCPF.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->	
<!--#include file="includes/inc_aguarde.asp"-->	
<br>
<%
	dim intPagina
	dim strInfoTurma
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"

	'campos selecionados
	mostra_matricula		= Trim(Request.Form("matricula"))
	mostra_nomealuno		= Trim(Request.Form("nomealuno"))
	mostra_cpf				= Trim(Request.Form("cpf"))
	mostra_identidade		= Trim(Request.Form("identidade"))
	mostra_datamatricula	= Trim(Request.Form("datamatricula"))
	mostra_dataafastamento	= Trim(Request.Form("dataafastamento"))
	mostra_datanascimento	= Trim(Request.Form("datanascimento"))
	mostra_idade			= Trim(Request.Form("idade"))
	mostra_naturalidade		= Trim(Request.Form("naturalidade"))
	mostra_endereco			= Trim(Request.Form("endereco"))
	mostra_numeroendereco	= Trim(Request.Form("numeroendereco"))
	mostra_complementoendereco	= Trim(Request.Form("complementoendereco"))
	mostra_bairro			= Trim(Request.Form("bairro"))
	mostra_cidade			= Trim(Request.Form("cidade"))
	mostra_cep			= Trim(Request.Form("cep"))
	mostra_sexo				= Trim(Request.Form("sexo"))
	mostra_telefonecomercial= Trim(Request.Form("telefonecomercial"))
	mostra_telefoneresidencial	= Trim(Request.Form("telefoneresidencial"))
	mostra_telefonecelular	= Trim(Request.Form("telefonecelular"))
	mostra_cartaosus		= Trim(Request.Form("cartaosus"))
	mostra_bolsafamilia		= Trim(Request.Form("bolsafamilia"))
	mostra_nomepai			= Trim(Request.Form("nomepai"))
	mostra_nomemae			= Trim(Request.Form("nomemae"))
	mostra_nomeresponsavel	= Trim(Request.Form("responsavel"))
	mostra_telefoneresponsavel	= Trim(Request.Form("telefoneresponsavel"))
	mostra_email			= Trim(Request.Form("email"))
	mostra_codigoseguranca	= Trim(Request.Form("codigoseguranca"))
	mostra_situacaoaluno	= Trim(Request.Form("situacaoaluno"))
	mostra_numerotenis 		= Trim(Request.Form("TENIS_TAMANHO"))
	mostra_tamanhouniforme 	= Trim(Request.Form("UNIFORME_TAMANHO"))
											
	mostra_atendimentoespecial 	= Trim(Request.Form("atendimentoespecial"))
	mostra_necessidadeespeciais = Trim(Request.Form("necessidadeespeciais"))
	mostra_turma 				= Trim(Request.Form("turma"))
	mostra_assinatura			= Trim(Request.Form("assinatura"))
	mostra_assinaturapaiemae	= Trim(Request.Form("assinaturapaiemae"))
	mostra_controlerequerimento	= Trim(Request.Form("controlerequerimento"))

	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodTurmaQuebra		= Trim(Request.Form("cmbQuebraPagina"))
	intCodDisciplinaTurma   = trim(request("cmbDisciplinaTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	strSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))
	strSexo					= Trim(Request.Form("cmbSexo"))
	strOrdem				= Trim(Request.Form("cmbOrdem"))
	strQuebraPagina			= Trim(Request.Form("cmbQuebraPagina"))
	intCodFormaIngresso 	= Trim(Request.Form("cmbFormaIngresso"))
	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	if Trim(Request.Form("txtAnoLetivo")) <> "" then
	   strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	else
	   strAnoLetivo = session("strAnoLetivo")   
	end if   

	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
	strAniversariante       = Trim(Request.Form("cmbMes"))
	strIdade                = Trim(Request.Form("cmbIdade"))
	strNecessidadeEspecial                = Trim(Request.Form("cmbNecessidadeEspecial"))
	strTituloRelatorio = "Relatório de Alunos"

	if strIdade <> "0" then
		strTituloRelatorio  	= strTituloRelatorio & " - Com idade de " & strIdade
	end if	
	if strAniversariante <> "0" then
		strTituloRelatorio  	= strTituloRelatorio & " - Aniversariantes de " & ucase(monthname(strAniversariante))
	end if
	if strNecessidadeEspecial = "S" then
		strTituloRelatorio  	= strTituloRelatorio & " - Com Atendimento Especial"
	end if
    sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<%if mostra_turma = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Turma</strong></div></td>
		<%end if%>
		<%if mostra_matricula = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Matr&iacute;cula</strong></div></td>
		<%end if%>
		<td width="25%" class="<%=strclasse%>"><div align="center"><strong>Nome do Aluno</strong></div></td>
		<%if mostra_sexo = "S" then%>
		<td width="2%" class="<%=strclasse%>"><div align="center"><strong>Sexo</strong></div></td>
		<%end if%>
		<%if mostra_cpf = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>CPF</strong></div></td>
		<%end if%>
		<%if mostra_identidade = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Número RG Nasc.</strong></div></td>
		<%end if%>
		<%if mostra_datamatricula = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Data da Matr&iacute;cula</strong></div></td>
		<%end if%>
		<%if mostra_datanascimento = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Data Nascimento</strong></div></td>
		<%end if%>
		<%if mostra_dataafastamento = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Data Afastamento</strong></div></td>
		<%end if%>
		<%if mostra_idade = "S" then%>
		<td width="2%" class="<%=strclasse%>"><div align="center"><strong>Idade</strong></div></td>
		<%end if%>
		<%if mostra_naturalidade = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Naturalidade</strong></div></td>
		<%end if%>
		<%if mostra_endereco = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Endereço</strong></div></td>
		<%end if%>
		<%if mostra_numeroendereco = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Número</strong></div></td>
		<%end if%>
		<%if mostra_complementoendereco = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Complemento</strong></div></td>
		<%end if%>
		<%if mostra_bairro = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Bairro</strong></div></td>
		<%end if%>
		<%if mostra_cidade = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Cidade</strong></div></td>
		<%end if%>
		<%if mostra_telefonecomercial = "S" then%>
		<td width="8%" class="<%=strclasse%>"><div align="center"><strong>Fone Comercial</strong></div></td>
		<%end if%>
		<%if mostra_telefoneresidencial = "S" then%>
		<td width="8%" class="<%=strclasse%>"><div align="center"><strong>Fone Residencial</strong></div></td>
		<%end if%>
		<%if mostra_telefonecelular = "S" then%>
		<td width="8%" class="<%=strclasse%>"><div align="center"><strong>Celular</strong></div></td>
		<%end if%>
		<%if mostra_cartaosus = "S" then%>
		<td width="8%" class="<%=strclasse%>"><div align="center"><strong>Cartão SUS</strong></div></td>
		<%end if%>
		<%if mostra_bolsafamilia = "S" then%>
		<td width="8%" class="<%=strclasse%>"><div align="center"><strong>Auxílio Brasil</strong></div></td>
		<%end if%>
		<%if mostra_nomepai = "S" then%>
		<td width="20%" class="<%=strclasse%>"><div align="center"><strong>Pai</strong></div></td>
		<%end if%>
		<%if mostra_nomemae = "S" then%>
		<td width="20%" class="<%=strclasse%>"><div align="center"><strong>Mãe</strong></div></td>
		<%end if%>
		<%if mostra_nomeresponsavel = "S" then%>
		<td width="20%" class="<%=strclasse%>"><div align="center"><strong>Responsável</strong></div></td>
		<%end if%>
		<%if mostra_telefoneresponsavel = "S" then%>
		<td width="20%" class="<%=strclasse%>"><div align="center"><strong>Fone Responsável</strong></div></td>
		<%end if%>
		<%if mostra_email = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Email</strong></div></td>
		<%end if%>
		<%if mostra_codigoseguranca = "S" then%>
		<td width="2%" class="<%=strclasse%>"><div align="center"><strong>Cod.Segurança</strong></div></td>
		<%end if%>
		<%if mostra_situacaoaluno = "S" then%>
		<td width="8%" class="<%=strclasse%>"><div align="center"><strong>Situação</strong></div></td>
		<%end if%>
		<%if mostra_atendimentoespecial = "S" then%>
		<td width="5%" class="<%=strclasse%>"><div align="center"><strong>Atend. Especial</strong></div></td>
		<%end if%>
		<%if mostra_necessidadeespeciais = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Necessidade Especial</strong></div></td>
		<%end if%>
		<%if mostra_tamanhouniforme = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Tamanho do uniforme</strong></div></td>
		<%end if%>
		<%if mostra_numerotenis = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Número do tênis</strong></div></td>
		<%end if%>
		<%if mostra_assinatura = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center">Assinatura</div></td>
		<%end if%>
		<%if mostra_assinaturapaiemae = "S" then%>
		<td width="25%" class="<%=strclasse%>"><div align="center">Pai</div></td>
		<td width="10%" class="<%=strclasse%>"><div align="center">Assinatura</div></td>
		<td width="25%" class="<%=strclasse%>"><div align="center">Mãe</div></td>
		<td width="10%" class="<%=strclasse%>"><div align="center">Assinatura</div></td>
		<%end if%>
		<%if mostra_controlerequerimento = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center">Ano/Semestre</div></td>
		<td width="10%" class="<%=strclasse%>"><div align="center">Emissão no Portal</div></td>
		<td width="10%" class="<%=strclasse%>"><div align="center">Entrega Secretaria</div></td>
		<td width="10%" class="<%=strclasse%>"><div align="center">Resp. Baixa</div></td>
		<%end if%>

	  </tr>
	<%
	end Sub
	
	sub quebraTurma() 
	%>
	  <tr bgcolor="#E2E2E2">
	    <td colspan="5" class="<%=strclasse%>"><%=strInfoTurma%>&nbsp;</td>
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
	
   sql = "SELECT  DISTINCT   A.CODIGO, A.MATRICULA, A.CPF, A.NOMEALUNO, A.DATANASCIMENTO, A.DATAFASTAMENTO, A.DATAMATRICULA, FLOOR(DATEDIFF(DAY, A.DataNascimento, GETDATE()) / 365.25) AS IDADE, "
   sql = sql & " A.MAE, A.PAI, SA.DESC_SITUACAOALUNO, A.ATENDIMENTOESPECIAL, NE.Desc_NecEspecial AS NECESSIDADEESPECIAIS, "
   sql = sql & " A.LOGRADOURO, A.NUMERO_ENDERECO, A.COMP_ENDERECO, A.NUMREGISTRONASC, A.CEPRESIDENCIA, A.RESPONSAVELFONE, A.RESPONSAVEL, A.CIDADENASCIMENTO, A.CIDADERESIDENCIA, A.BAIRROALUNO,  A.SEXOALUNO, "
   sql = sql & " A.FONECOMERCIAL, A.FONERESIDENCIAL, A.FONECELULAR, A.bolsa_Familia, A.CARTAOSUS, A.EMAIL, T.COD_TURMA, T.NomeTurma, T.TURMAALUNO, A.UNIFORME_TAMANHO, A.TENIS_TAMANHO"
   sql = sql & " FROM SCA_ALUNO A "
   sql = sql & " INNER JOIN SCA_ALUNO_TURMA AT ON AT.COD_ALUNO = A.CODIGO "
   sql = sql & " LEFT JOIN SCA_TURMA T ON AT.COD_TURMA = T.Cod_Turma  AND AT.ANO_LETIVO = T.AnoLetivo AND AT.SEMESTRE = T.Cod_Semestre AND AT.cod_empresa = T.cod_empresa "
   sql = sql & " LEFT JOIN SCA_GRADECURRICULAR G ON T.Cod_GradeCurricular = G.Cod_GradeCurricular"
   sql = sql & " LEFT JOIN SCA_PERIODO P ON P.Cod_Periodo = G.Cod_Periodo "
   sql = sql & " LEFT JOIN SCA_CURSO C ON C.Cod_Curso = P.Cod_Curso "
   sql = sql & " LEFT JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SITUACAOALUNO = A.COD_SITUACAOALUNO"
   sql = sql & " LEFT JOIN SCA_NECESSIDADEESPECIAL NE ON NE.Cod_NecEspecial = A.COD_NECESPECIAL"
   sql = sql & " where T.cod_empresa = " & session("CodEmpresa")
   sql = sql & " AND T.SITUACAO='A'"
   if trim(strAnoLetivo) = trim(session("strAnoLetivo")) and trim(strSemestre) =  trim(session("strSemestre")) then
	  sql = sql & " and 	AT.situacao = 'A'"
   end if	
	 
   sql = sql & " and 	AT.Ano_Letivo = " &  strAnoLetivo
   sql = sql & " and 	AT.Semestre in (" & strSemestre & ")"
   
   if intCodCurso <> "0" then
	  sql = sql & " and C.Cod_Curso = " & intCodCurso
   end if
   
   if intCodPeriodo <> "0" then
	  sql = sql & " and G.Cod_Periodo = " & intCodPeriodo
   end if
   
   if intCodTurno <> "0" then
	  sql = sql & " and T.COD_TURNO = " & intCodTurno
   end if
   
   if intCodTurma <> "0" then
	  sql = sql & " and AT.COD_TURMA = " & intCodTurma
   end if
   
   if intCodSituacaoAluno <> "0" then
	  sql = sql & " and A.COD_SITUACAOALUNO = " & intCodSituacaoAluno
   end if 
   
   if strSexo <> "0" then
	  sql = sql & " and A.SEXOALUNO = '" & strSexo & "'"
   end if
   
   if strAniversariante <> "0" then
	  sql = sql & " and month(A.DATANASCIMENTO) = " & strAniversariante
   end if
   
   if strIdade <> "0" then
	  sql = sql & " and FLOOR(DATEDIFF(DAY, A.DataNascimento, GETDATE()) / 365.25)  = " & strIdade
   end if
   
   if strNecessidadeEspecial <> "0" then
	  sql = sql & " and A.ATENDIMENTOESPECIAL = '" & strNecessidadeEspecial & "'"
   end if
   
	'ordem de classificação do relatorio
   if intCodTurmaQuebra = "TURMA" then
   
	   if strOrdem = "alfabetica" then
		  sql = sql & " Order By T.NomeTurma, A.NOMEALUNO"
	   elseif strOrdem = "matricula" then
		  sql = sql & " Order By T.NomeTurma, A.matricula"
	   elseif strOrdem = "datamatricula" then
		  sql = sql & " Order By T.NomeTurma, A.datamatricula"
	   elseif strOrdem = "dataafastamento" then
	   'verificar qual o campos data afastamento no cadastro
		  sql = sql & " Order By T.NomeTurma, A.DATAFASTAMENTO"
	   elseif strOrdem = "idade" then
		  sql = sql & " Order By T.NomeTurma, A.DATANASCIMENTO desc"
	   elseif strOrdem = "bairro" then
		  sql = sql & " Order By T.NomeTurma, A.BAIRROALUNO"
	   end if
	else
		if strOrdem = "alfabetica" then
		  sql = sql & " Order By A.NOMEALUNO"
	   elseif strOrdem = "matricula" then
		  sql = sql & " Order By A.matricula"
	   elseif strOrdem = "datamatricula" then
		  sql = sql & " Order By A.datamatricula"
	   elseif strOrdem = "dataafastamento" then
	   'verificar qual o campos data afastamento no cadastro
		  sql = sql & " Order By A.DATAFASTAMENTO"
	   elseif strOrdem = "idade" then
		  sql = sql & " Order By A.DATANASCIMENTO desc"
	   elseif strOrdem = "bairro" then
		  sql = sql & " Order By A.BAIRROALUNO"
	   end if
		
	end if   
	
	rs.open sql, cnn
	if not rs.eof then 
		controle = 0
		contPorTurma = 0
		While not rs.eof
		
			IF intCodTurmaQuebra = "TURMA"  then
				IF intCodTurma <> RS("COD_TURMA") THEN
					if controle = 1 then
					   %>
					   <tr>
					   <td colspan="40" class="<%=strclasse%>">Quantidade de Alunos Por Turma: <%=contPorTurma%></td>
					   </tr>
					   <%
					   contPorTurma = 0
					end if
					if trim(strQuebraPagina) = "TURMA" and controle = 1 then
					   intPagina = intPagina + 1
					   intQtdeRegistroPorPagina = 1
					   fimTabela
					   %>
					   <pre></pre>				
					   <%			
					   mostraCabecalho
					end if
					strInfoTurma =  "<strong>" & RS("NomeTurma") & "</strong> - " & RS("TURMAALUNO")
					quebraTurma
				END IF
				controle = 1
			end if	
			%>
			<tr>
				<%if mostra_turma = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="center"><%=rs("nometurma")%> - <%=rs("turmaaluno")%></div></td>
				<%end if%>
				<%if mostra_matricula = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="center"><%=rs("MATRICULA")%></div></td>
				<%end if%>
				<td width="25%" class="<%=strclasse%>"><div align="left"><%=rs("NOMEALUNO")%></div></td>
				<%if mostra_sexo = "S" then%>
				<td width="2%" class="<%=strclasse%>"><div align="center"><%=rs("sexoaluno")%></div></td>
				<%end if%>
				<%if mostra_cpf = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="center"><%=formataCPFap(rs("CPF"))%></div></td>
				<%end if%>
				<%if mostra_identidade = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="left"><%=rs("NUMREGISTRONASC")%></div></td>
				<%end if%>
				<%if mostra_datamatricula = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="center"><%=formatadataAP(rs("DATAMATRICULA"))%></div></td>
				<%end if%>
				<%if mostra_datanascimento = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="center"><%=formatadataAP(rs("DATANASCIMENTO"))%></div></td>
				<%end if%>
				<%if mostra_dataafastamento = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="center"><%=formatadataAP(rs("DATAFASTAMENTO"))%></div></td>
				<%end if%>
				<%if mostra_idade = "S" then%>
				<td width="2%" class="<%=strclasse%>"><div align="center"><%=RS("IDADE")%></div></td>
				<%end if%>
				<%if mostra_naturalidade = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="left"><%=RS("CIDADENASCIMENTO")%></div></td>
				<%end if%>
				<%if mostra_endereco = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="left"><%=rs("LOGRADOURO")%></div></td>
				<%end if%>
				<%if mostra_numeroendereco = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="left"><%=rs("NUMERO_ENDERECO")%></div></td>
				<%end if%>
				<%if mostra_complementoendereco = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="left"><%=rs("COMP_ENDERECO")%></div></td>
				<%end if%>
				<%if mostra_bairro = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="left"><%=rs("BAIRROALUNO")%></div></td>
				<%end if%>
				<%if mostra_cidade = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="left"><%=rs("CIDADERESIDENCIA")%></div></td>
				<%end if%>
				<%if mostra_cep = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="left"><%=rs("CEPRESIDENCIA")%></div></td>
				<%end if%>
				<%if mostra_telefonecomercial = "S" then%>
				<td width="8%" class="<%=strclasse%>"><div align="left"><%=rs("FONECOMERCIAL")%></div></td>
				<%end if%>
				<%if mostra_telefoneresidencial = "S" then%>
				<td width="8%" class="<%=strclasse%>"><div align="left"><%=rs("FONERESIDENCIAL")%></div></td>
				<%end if%>
				<%if mostra_telefonecelular = "S" then%>
				<td width="8%" class="<%=strclasse%>"><div align="left"><%=rs("FONECELULAR")%></div></td>
				<%end if%>
				<%if mostra_cartaosus = "S" then%>
				<td width="8%" class="<%=strclasse%>"><div align="left"><%=rs("CartaoSUS")%></div></td>
				<%end if%>
				<%if mostra_bolsafamilia = "S" then%>
				<td width="8%" class="<%=strclasse%>"><div align="left"><%=rs("bolsa_Familia")%></div></td>
				<%end if%>
				<%if mostra_nomepai = "S" then%>
				<td width="20%" class="<%=strclasse%>"><div align="left"><%=rs("pai")%></div></td>
				<%end if%>
				<%if mostra_nomemae = "S" then%>
				<td width="20%" class="<%=strclasse%>"><div align="left"><%=rs("mae")%></div></td>
				<%end if%>
				<%if mostra_nomeresponsavel = "S" then%>
				<td width="20%" class="<%=strclasse%>"><div align="left"><%=rs("responsavel")%></div></td>
				<%end if%>
				<%if mostra_telefoneresponsavel = "S" then%>
				<td width="20%" class="<%=strclasse%>"><div align="left"><%=rs("responsavelfone")%></div></td>
				<%end if%>
				<%if mostra_email = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="left"><%=rs("email")%></div></td>
				<%end if%>
				<%if mostra_codigoseguranca = "S" then%>
				<td width="2%" class="<%=strclasse%>"><div align="center"><%=rs("codigo")%></div></td>
				<%end if%>
				<%if mostra_situacaoaluno = "S" then%>
				<td width="8%" class="<%=strclasse%>"><div align="left"><%=rs("desc_situacaoaluno")%></div></td>
				<%end if%>
				<%if mostra_atendimentoespecial = "S" then%>
				<td width="5%" class="<%=strclasse%>"><div align="left"><%=rs("ATENDIMENTOESPECIAL")%></div></td>
				<%end if%>
				<%if mostra_necessidadeespeciais = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="left"><%=rs("necessidadeespeciais")%></div></td>
				<%end if%>
				<%if mostra_tamanhouniforme = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="center"><%=rs("UNIFORME_TAMANHO")%></div></td>
				<%end if%>
				<%if mostra_numerotenis = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="center"><%=rs("TENIS_TAMANHO")%></div></td>
				<%end if%>
				<%if mostra_assinatura = "S" then%>
				<td height="30" width="10%" class="<%=strclasse%>"><div align="center">_____________________________________</div></td>
				<%end if%>
				<%if mostra_assinaturapaiemae = "S" then%>
				<td height="30" width="25%" class="<%=strclasse%>"><div align="center"><%=rs("pai")%></div></td>
				<td height="30" width="10%" class="<%=strclasse%>"><div align="center">_____________________________________</div></td>
				<td height="30" width="25%" class="<%=strclasse%>"><div align="center"><%=rs("mae")%></div></td>
				<td height="30" width="10%" class="<%=strclasse%>"><div align="center">_____________________________________</div></td>
				<%end if%>
				<%if mostra_controlerequerimento = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="center">______/_______</div></td>
				<td width="10%" class="<%=strclasse%>"><div align="center"> </div></td>
				<td width="10%" class="<%=strclasse%>"><div align="center"> </div></td>
				<td width="10%" class="<%=strclasse%>"><div align="center"> </div></td>
				<%end if%>
			</tr>
			<%

			'quantidade de registros da página
			if int(intQtdeRegistroPorPagina) = int(strlpp) - 1 then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				%>
				<pre></pre>				
				<%			
				mostraCabecalho
			end if	
			cont = cont + 1
			contPorTurma = contPorTurma + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			intCodTurma = RS("COD_TURMA") 
			rs.movenext
		wend
		IF intCodTurmaQuebra = "TURMA"  then
		   %>
		   <tr>
			<td colspan="40" class="<%=strclasse%>">Quantidade de Alunos Por Turma: <%=contPorTurma%></td>
		   </tr>
           <%
		end if
		   %>   
		  <tr>
			<td colspan="40" class="<%=strclasse%>">Quantidade de Alunos: <%=cont%></td>
		  </tr>
		 <%
	else
		%>
		  <tr>
			<td colspan="40" class="<%=strclasse%>" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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
