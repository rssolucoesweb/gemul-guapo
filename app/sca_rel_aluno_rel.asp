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
	mostra_nomeresponsavel	= Trim(Request.Form("nomeresponsavel"))

	mostra_telefoneresponsavel	= Trim(Request.Form("telefoneresponsavel"))
	mostra_email			= Trim(Request.Form("email"))
	mostra_codigoseguranca	= Trim(Request.Form("codigoseguranca"))
	mostra_situacaoaluno	= Trim(Request.Form("situacaoaluno"))
	mostra_numerotenis 		= Trim(Request.Form("TENIS_TAMANHO"))
	mostra_tamanhouniforme 	= Trim(Request.Form("UNIFORME_TAMANHO"))
											
	mostra_atendimentoespecial 	= Trim(Request.Form("atendimentoespecial"))
	mostra_sala_aee 			= Trim(Request.Form("sala_aee"))
	mostra_necessidadeespeciais = Trim(Request.Form("necessidadeespeciais"))
	mostra_turma 				= Trim(Request.Form("turma"))
	mostra_assinatura			= Trim(Request.Form("assinatura"))
	mostra_assinaturapaiemae	= Trim(Request.Form("assinaturapaiemae"))
	mostra_controlerequerimento	= Trim(Request.Form("controlerequerimento"))

	mostra_medicamento = trim(request.form("medicamento"))
	mostra_transportescolar = trim(request.form("transportescolar"))
	mostra_usodaimagem = trim(request.form("usodaimagem"))
	mostra_restricaoalimentar = trim(request.form("restricaoalimentar"))
	mostra_alergia 			= trim(request.form("alergia"))
	mostra_etnia 			= trim(request.form("cod_etnia"))
	mostra_id_censo 		= trim(request.form("id_censo"))
	

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
	intCodEmpresa	 		= Trim(Request.Form("cmbEmpresaGrupo"))
	
	if session("NivelPermissao") = "A" then
	else
		intCodEmpresa = Trim(Session("CodEmpresa"))
	end if
	
	
	if Trim(Request.Form("txtAnoLetivo")) <> "" then
	   strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	else
	   strAnoLetivo = session("strAnoLetivo")   
	end if   

	strlpp 					= Trim(Request.Form("cmblpp"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))
	strAniversariante       = Trim(Request.Form("cmbMes"))
	strIdade                = Trim(Request.Form("cmbIdade"))
	strAtendimentoEspecial                		= Trim(Request("cmbAtendimentoEspecial"))
	strSalaAEE 									= Trim(Request("cmbSalaAEE"))
	strNecessidadeEspecial                		= Trim(Request("cmbNecessidadeEspecialSN"))
	
	if strNecessidadeEspecial = "S" then
		deficiencias = request.form("chkDeficiencia")
		if trim(deficiencias) = "" then deficiencias = "0"
	end if
	
	strTituloRelatorio = "Relatório de Alunos"

	if strIdade <> "0" then
		strTituloRelatorio  	= strTituloRelatorio & " - Com idade de " & strIdade
	end if	
	if strAniversariante <> "0" then
		strTituloRelatorio  	= strTituloRelatorio & " - Aniversariantes de " & ucase(monthname(strAniversariante))
	end if
	if strAtendimentoEspecial = "S" then
		strTituloRelatorio  	= strTituloRelatorio & " - Com Atendimento Especial"
	end if
	if strSalaAEE = "S" then
		strTituloRelatorio  	= strTituloRelatorio & " - Usa Sala AEE"
	end if
    sub mostraCabecalho()
	%>
	<!--#include file="includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<%if intCodEmpresa = "0" then%>
		<td width="15%" class="<%=strclasse%>"><div align="left">Unidade</div></td>
		<%end if%>
		<%if mostra_turma = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Turma</strong></div></td>
		<%end if%>
		 <!--'if mostra_matricula = "S" then -->
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Matr&iacute;cula</strong></div></td>
		 <!--'end if -->
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
		<%if mostra_sala_aee = "S" then%>
		<td width="5%" class="<%=strclasse%>"><div align="center"><strong>Usa Sala AEE</strong></div></td>
		<%end if%>
		<%if mostra_tamanhouniforme = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Tamanho do uniforme</strong></div></td>
		<%end if%>
		<%if mostra_numerotenis = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Tamanho calçado</strong></div></td>
		<%end if%>

		<%if mostra_medicamento = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Faz uso de medicamento controlado?</strong></div></td>
		<%end if%>
		<%if mostra_transportescolar = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Utiliza transporte escolar municipal?</strong></div></td>
		<%end if%>
		<%if mostra_usodaimagem = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Autoriza o uso da imagem do filho(a) em eventos da SEMEC/ESCOLA?</strong></div></td>
		<%end if%>		
		<%if mostra_restricaoalimentar = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Possui restrição alimentar?</strong></div></td>
		<%end if%>	
		<%if mostra_alergia = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Possui alergia?</strong></div></td>
		<%end if%>
		<%if mostra_etnia = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>Etnia</strong></div></td>
		<%end if%>
		<%if mostra_id_censo = "S" then%>
		<td width="10%" class="<%=strclasse%>"><div align="center"><strong>ID Censo</strong></div></td>
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
	    <td colspan="20" class="<%=strclasse%>"><%=strInfoTurma%>&nbsp;</td>
      </tr>
	<%
	end Sub	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	
   sql = "SELECT  DISTINCT   A.CODIGO, A.MATRICULA, A.CPF, A.NOMEALUNO, A.DATANASCIMENTO, A.DATAFASTAMENTO, A.DATAMATRICULA, FLOOR(DATEDIFF(DAY, A.DataNascimento, GETDATE()) / 365.25) AS IDADE, "
   sql = sql & " A.MAE, A.PAI, SA.DESC_SITUACAOALUNO, A.ATENDIMENTOESPECIAL, iif(A.sala_aee='S','Sim','Não') as sala_aee, NE.Desc_NecEspecial AS NECESSIDADEESPECIAIS, "
   sql = sql & " A.LOGRADOURO, A.NUMERO_ENDERECO, A.COMP_ENDERECO, A.NUMREGISTRONASC, A.CEPRESIDENCIA, A.RESPONSAVELFONE, A.RESPONSAVEL, A.CIDADENASCIMENTO, A.CIDADERESIDENCIA, A.BAIRROALUNO,  A.SEXOALUNO, "
   sql = sql & " A.FONECOMERCIAL, A.FONERESIDENCIAL, A.FONECELULAR, A.bolsa_Familia, A.CARTAOSUS, A.EMAIL, T.COD_TURMA, T.NomeTurma, T.TURMAALUNO, TC.DESCRICAO + ' (' + TC.RESUMO + ')' AS TENIS_TAMANHO, TR.DESCRICAO AS UNIFORME_TAMANHO,"
   sql = sql & " case when A.MEDICAMENTO_CONTROLADO = 'S' then 'Sim. ' + A.MEDICAMENTO_CONTROLADO_QUAL else 'Não' end as MEDICAMENTO_CONTROLADO,"
   sql = sql & " case when A.TRANSPORTE_ESCOLAR = 'S' then 'Sim' else 'Não' end as TRANSPORTE_ESCOLAR,"
   sql = sql & " case when A.AUTORIZA_USO_IMAGEM = 'S' then 'Sim' else 'Não' end as AUTORIZA_USO_IMAGEM,"
   sql = sql & " case when A.RESTRICAO_ALIMENTAR = 'S' then 'Sim. ' + A.RESTRICAO_ALIMENTAR_QUAL else 'Não' end as RESTRICAO_ALIMENTAR,"
   sql = sql & " case when A.ALERGIA = 'S' then 'Sim. ' + A.ALERGIA_QUAL else 'Não' end as ALERGIA, EM.RAZAOSOCIAL AS UNIDADE, A.ID_CENSO, ETN.DESCRICAO AS ETNIA"   
   sql = sql & " FROM SCA_ALUNO A "
   sql = sql & " INNER JOIN sca_aluno_turma AT ON AT.COD_ALUNO = A.CODIGO "
   sql = sql & " INNER JOIN sca_aluno_turma_situacao ATC ON ATC.COD_ALUNO_TURMA = AT.CODIGO "
   sql = sql & " LEFT JOIN SCA_TURMA T ON AT.COD_TURMA = T.Cod_Turma  AND AT.ANO_LETIVO = T.AnoLetivo AND AT.SEMESTRE = T.Cod_Semestre AND AT.cod_empresa = T.cod_empresa "
   sql = sql & " LEFT JOIN SCA_GRADECURRICULAR G ON T.Cod_GradeCurricular = G.Cod_GradeCurricular"
   sql = sql & " LEFT JOIN SCA_PERIODO P ON P.Cod_Periodo = G.Cod_Periodo "
   sql = sql & " LEFT JOIN SCA_CURSO C ON C.Cod_Curso = P.Cod_Curso "
   sql = sql & " LEFT JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SITUACAOALUNO = ATC.COD_SITUACAOALUNO"
   sql = sql & " LEFT JOIN SCA_NECESSIDADEESPECIAL NE ON NE.Cod_NecEspecial = A.COD_NECESPECIAL"
   sql = sql & " LEFT JOIN SEG_EMPRESA EM ON EM.CODIGO = AT.COD_EMPRESA"
   sql = sql & " LEFT JOIN SCA_ETNIAS ETN ON ETN.CODIGO = A.COD_ETNIA"
   sql = sql & " LEFT JOIN SCA_TAMANHO_CALCADO TC ON TC.CODIGO = A.COD_TAMANHO_CALCADO"
   sql = sql & " LEFT JOIN SCA_TAMANHO_ROUPA TR ON TR.CODIGO = A.COD_TAMANHO_ROUPA"
   sql = sql & " where 1=1"
   IF intCodEmpresa <> "0" THEN
		sql = sql & " AND T.cod_empresa = " & intCodEmpresa
   END IF
   
   sql = sql & " AND T.SITUACAO='A'"
   
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
    
	'1	ATIVO
	'3	CANCELADO
	'4	DESISTENTE
	'5	TRANSFERIDO
	IF TRIM(intCodSituacaoAluno) <> "0"  THEN 
		sql = sql & " and 	ATC.cod_situacaoaluno = " & TRIM(intCodSituacaoAluno)
	END IF
   
   if strSexo <> "0" then
	  sql = sql & " and A.SEXOALUNO = '" & strSexo & "'"
   end if
   
   if strAniversariante <> "0" then
	  sql = sql & " and month(A.DATANASCIMENTO) = " & strAniversariante
   end if
   
   if strIdade <> "0" then
	  sql = sql & " and FLOOR(DATEDIFF(DAY, A.DataNascimento, GETDATE()) / 365.25)  = " & strIdade
   end if
   
	if strAtendimentoEspecial <> "0" then
	  sql = sql & " and A.ATENDIMENTOESPECIAL = '" & strAtendimentoEspecial & "'"
	end if
    if strSalaAEE <> "0" then
	  sql = sql & " and A.sala_aee = '" & strSalaAEE & "'"
	end if
       if strNecessidadeEspecial= "S" then
	  sql = sql & " and A.codigo in (select distinct cod_aluno from sca_aluno_necessidadeespecial where COD_NECESSIDADEESPECIAL in (" & deficiencias & "))"
	end if

   
	'ordem de classificação do relatorio
   if intCodTurmaQuebra = "TURMA" then
   
	   if strOrdem = "unidade" then
		  sql = sql & " Order By EM.RAZAOSOCIAL, T.NomeTurma, A.NOMEALUNO"
	   elseif strOrdem = "alfabetica" then
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
	
	   if strOrdem = "unidade" then
		  sql = sql & " Order By EM.RAZAOSOCIAL, A.NOMEALUNO"
	   elseif strOrdem = "alfabetica" then
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
	
	if session("usuarioWeb") = "SERGIO" THEN
		response.write sql
	END IF
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
			
				<%if intCodEmpresa = "0" then%>
				<td width="15%" class="<%=strclasse%>"><div align="left"><%=rs("unidade")%></div></td>
				<%end if%>
				<%if mostra_turma = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="center"><%=rs("nometurma")%> - <%=rs("turmaaluno")%></div></td>
				<%end if%>
				<%'if mostra_matricula = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="center"><%=rs("MATRICULA")%></div></td>
				<%'end if%>
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
				<td width="10%" class="<%=strclasse%>">
				
					<div align="left">
					<%
					necessidades=""
					sql = "select distinct n.Desc_NecEspecialNova"
					sql = sql & " from SCA_ALUNO_NECESSIDADEESPECIAL a"
					sql = sql & " inner join SCA_NECESSIDADEESPECIAL n on n.Cod_NecEspecial = a.COD_NECESSIDADEESPECIAL"
					sql = sql & " where a.COD_ALUNO = " & rs("codigo")
					if deficiencias<>"0" and deficiencias<>"" then
						sql = sql & " and  a.COD_NECESSIDADEESPECIAL in (" & deficiencias & ")"
					end if
					
					rsaux.open sql, cnn
					if not rsaux.eof then
						while not rsaux.eof
							if necessidades="" then
								necessidades = rsaux("Desc_NecEspecialNova")
							else
								necessidades = necessidades & ", " & rsaux("Desc_NecEspecialNova")
							end if
							rsaux.movenext
						wend
					end if
					rsaux.close
					
					response.write necessidades
					%>
					</div>
				
				</td>
				<%end if%>
				<%if mostra_sala_aee = "S" then%>
				<td width="5%" class="<%=strclasse%>"><div align="left"><%=rs("sala_aee")%></div></td>
				<%end if%>
				<%if mostra_tamanhouniforme = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="center"><%=rs("UNIFORME_TAMANHO")%></div></td>
				<%end if%>
				<%if mostra_numerotenis = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="center"><%=rs("TENIS_TAMANHO")%></div></td>
				<%end if%>


				<%if mostra_medicamento = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="center"><%=rs("MEDICAMENTO_CONTROLADO")%></div></td>
				<%end if%>
				<%if mostra_transportescolar = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="center"><%=rs("TRANSPORTE_ESCOLAR")%></div></td>
				<%end if%>
				<%if mostra_usodaimagem = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="center"><%=rs("AUTORIZA_USO_IMAGEM")%></div></td>
				<%end if%>		
				<%if mostra_restricaoalimentar = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="center"><%=rs("RESTRICAO_ALIMENTAR")%></div></td>
				<%end if%>	
				<%if mostra_alergia = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="center"><%=rs("ALERGIA")%></div></td>
				<%end if%>	
				<%if mostra_etnia = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="center"><%=rs("etnia")%></div></td>
				<%end if%>
				<%if mostra_id_censo = "S" then%>
				<td width="10%" class="<%=strclasse%>"><div align="center"><%=rs("id_censo")%></div></td>
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
