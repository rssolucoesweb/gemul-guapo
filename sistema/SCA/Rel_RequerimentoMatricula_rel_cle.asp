<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
if request.QueryString("dest")<>"" then
	strPaginaDestino = "window.location='" & request.QueryString("dest") & "'"
end if

%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/09/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Ficha Individual do Aluno
-->
<html>
<head>
<title><%=session("Titulo")%> - Alunos Por Turma</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
<style type="text/css">
<!--
.style1 {
	font-family: Arial;
	font-size: 6pt;
}
.style11 {
	font-family: Arial;
	font-size: 7pt;
}
.style12 {font-family: Arial; font-size: 7pt; font-weight: bold; }
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

	strOpcaoRelatorio	= Trim(Request.Form("optOpcao"))
    if strOpcaoRelatorio = "0" then
	   strTituloRelatorio  	= "REQUERIMENTO DE MATRÍCULA"
	else 
	   strTituloRelatorio  	= "REQUERIMENTO DE PRÉ-MATRÍCULA"
	end if   

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorioSemAnoSemestre.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<%
	end Sub
	sub fimTabela()
		response.Write("</table>")
	end Sub	
	
	
	if request.QueryString("sem")<>"" then 
		strSemestre 		= request.QueryString("sem")
	else
		strSemestre 			= Trim(Request.Form("cmbSemestre"))
		if trim(strSemestre) = "" or  trim(strSemestre) = "0"  then 	strSemestre  = session("strSemestre")
	end if
	
	strCod_empresa 		= Session("CodEmpresa")
	if request.QueryString("ano")<>"" then 
		strAnoLetivo 		= request.QueryString("ano")
	else
		strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
		if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	end if
	strCodAluno			= Trim(Request("txtCodAluno"))
	if strCodAluno = "" then
		strCodAluno			=	Trim(Request.form("chkAluno"))
	end if
    strSimouNao         =  Trim(request.QueryString("codsimounao"))
    if strSimouNao <> "S" and strSimouNao <> "N" then
	   strSimouNao      = "N"
	end if   
	
	strDisciplina			=	Trim(Request.form("chkdisciplina"))
	
	
    if strSimouNao="S"  then  
	   'regra ano / semestre destino
	   if Session("strSemestre") = "1" then
	  	  intAnoLetivo = Session("strAnoLetivo")
		  intSemestre	 = 2
		  strDesSemestre = "2º Semestre"
	   elseif Session("strSemestre") = "2" then
		  intAnoLetivo = Session("strAnoLetivo")+1
		  intSemestre	 = 1
		  strDesSemestre = "1º Semestre"
	   elseif Session("strSemestre") = "3" then
		  intAnoLetivo = Session("strAnoLetivo")+1
		  intSemestre	 = 3
		  strDesSemestre = "Anual"
	   end if
     else
	    'regra ano / semestre Atual
	   if strSemestre = "1" then
		  strDesSemestre = "1º Semestre"
	   elseif strSemestre = "2" then
		  strDesSemestre = "2º Semestre"
	   elseif strSemestre = "3" then
		  strDesSemestre = "Anual"
	   end if
	end if 
	
	' Busca o contrato cadastrado para o requerimento de matrícula
	strTexto = ""
	sql = "SELECT texto"
	sql = sql & " FROM SCA_CONTRATOREQUERIMENTO "
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa")			
	rs.open sql, cnn
	if not RS.EOF then
		strTexto = rs("Texto")
	end if
	rs.close

	
	if trim(strCodAluno) <> "" then
		'VERIFICAÇÃO DE BLOQUEIO
		intCodAluno = strCodAluno
		%>
		<!--#include file="../includes/inc_VerificaBloqueio.asp"-->
		<%			
		sql = "SELECT S.Desc_SituacaoAluno, "
		sql = sql & " P.Desc_Profissao AS profissao,"
		sql = sql & " EC.Desc_EstadoCivil AS EstadoCivil,"
		sql = sql & " R.Desc_Religiao	AS Religiao,"
		sql = sql & " NE.Desc_NecEspecial AS NececidadeEspecial,"
		sql = sql & " PP.Desc_Profissao AS profissaoPai,"
		sql = sql & " PM.Desc_Profissao AS profissaoMae,"
		sql = sql & " GIP.Descricao AS GrauInstrucaoPai,"
		sql = sql & " GIM.Descricao AS GrauInstrucaoMae,"
		sql = sql & " PR.Desc_Profissao AS profissaoResp,"
		sql = sql & " GIR.Descricao AS GrauInstrucaoResp,"
		sql = sql & " UFI.Sigla AS descUFIDENTIDADE,"
		sql = sql & " UFN.Sigla AS descUFNASCIMENTO,"
		sql = sql & " UFR.Sigla AS descUfresidencia,"
		sql = sql & " O.DESCRICAO AS FORMAINGRESSO,"
		sql = sql & " DE.DESCRICAO AS DESCONTO,"
		sql = sql & " A.* "
		sql = sql & " FROM SCA_ALUNO A "
		sql = sql & " LEFT JOIN SCA_SITUACAOALUNO S	ON S.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND S.COD_EMPRESA = A.COD_EMPRESA "
		sql = sql & " LEFT JOIN SCA_PROFISSAO P		ON P.COD_PROFISSAO = A.COD_PROFISSAO "
		sql = sql & " LEFT JOIN SCA_ESTADOCIVIL EC	ON EC.COD_EstadoCivil = A.COD_EstadoCivil"
		sql = sql & " LEFT JOIN SCA_RELIGIAO R		ON R.COD_RELIGIAO = A.COD_RELIGIAO"
		sql = sql & " LEFT JOIN SCA_NECESSIDADEESPECIAL NE ON NE.COD_NECESPECIAL = A.COD_NECESPECIAL"
		sql = sql & " LEFT JOIN SCA_PROFISSAO PP		ON PP.COD_PROFISSAO = A.PAI_COD_PROFISSAO "
		sql = sql & " LEFT JOIN SCA_GRAUINSTRUCAO GIP ON GIP.CODIGO = A.PAI_COD_GRAUINSTRUCAO "
		sql = sql & " LEFT JOIN SCA_PROFISSAO PM		ON PM.COD_PROFISSAO = A.MAE_COD_PROFISSAO "
		sql = sql & " LEFT JOIN SCA_GRAUINSTRUCAO GIM ON GIM.CODIGO = A.MAE_COD_GRAUINSTRUCAO "
		sql = sql & " LEFT JOIN SCA_PROFISSAO PR		ON PR.COD_PROFISSAO = A.RESPONSAVEL_COD_PROFISSAO "
		sql = sql & " LEFT JOIN SCA_GRAUINSTRUCAO GIR ON GIR.CODIGO = A.RESPONSAVEL_COD_GRAUINSTRUCAO "
		sql = sql & " LEFT JOIN SCF_UF UFI				ON UFI.CODIGO = A.IdentidadeUF "
		sql = sql & " LEFT JOIN SCF_UF UFN				ON UFN.CODIGO = A.UFNASCIMENTO "
		sql = sql & " LEFT JOIN SCF_UF UFR				ON UFR.CODIGO = A.UFRESIDENCIA "
		sql = sql & " LEFT JOIN SCA_FORMAINGRESSO O		ON O.CODIGO = A.COD_FORMAINGRESSO AND O.COD_EMPRESA = A.COD_EMPRESA "
		sql = sql & " LEFT JOIN SCF_CATEGORIA_DESCONTO DE			ON DE.CODIGO = A.cod_categoria_desconto AND DE.COD_EMPRESA = A.COD_EMPRESA "
		sql = sql & " Where A.COD_EMPRESA = " & strCod_empresa
		sql = sql & " And 	A.codigo in (" & strCodAluno & ")"
		
		rs.open sql, cnn
		if rs.eof = false then
			while not rs.eof
				strSituacaoAluno	= TRIM(rs("Desc_SituacaoAluno"))
				'dados pessoais
				strCodigo			= TRIM(rs("Codigo"))
				strMatricula 		= TRIM(rs("Matricula"))
				strFormaIngresso    = TRIM(rs("FORMAINGRESSO"))
				strNomealuno 		= TRIM(rs("Nomealuno"))
				strDatamatricula 	= formataDataAP(TRIM(rs("Datamatricula")))
				strNumeroRegistroNascimento  = TRIM(rs("NUMREGISTRONASC"))
				strSexo		 		= TRIM(rs("SexoAluno"))
				if strSexo = "M" then strSexo = "Masculino"
				if strSexo = "F" then strSexo = "Feminino"
				
				strDatanascimento 	= formataDataAP(TRIM(rs("Datanascimento")))
				strCidadenascimento = TRIM(rs("Cidadenascimento"))
				strUfnascimento 	= TRIM(rs("descUfnascimento"))
				strNacionalidade 	= TRIM(rs("Nacionalidade"))
				strEstadocivil 		= TRIM(rs("EstadoCivil"))
				strProfissao 		= TRIM(rs("Profissao"))
				strReligiao 		= TRIM(rs("Religiao"))
				strNecessidadeEspecial 	= TRIM(rs("NececidadeEspecial"))
				strAtendimentoespecial 	= TRIM(rs("Atendimentoespecial"))
				if strAtendimentoespecial = "S" then strAtendimentoespecial = "Sim"
				if strAtendimentoespecial = "N" then strAtendimentoespecial = "Não"
				strFoneResidencial 	= TRIM(rs("FoneResidencial"))
				strFonecomercial 	= TRIM(rs("Fonecomercial"))
				strFoneCelular	 	= TRIM(rs("Fonecelular"))
				strEmail 			= TRIM(rs("Email"))
				
				'endereço
				strLogradouro 		= TRIM(rs("Logradouro"))
				if not isnull(rs("Numero_endereco")) then strLogradouro = strLogradouro & ", " & rs("Numero_endereco")
				if not isnull(rs("Comp_endereco")) then strLogradouro = strLogradouro & ", " & rs("Comp_endereco")
				
				strBairroaluno 		= TRIM(rs("Bairroaluno"))
				strCidaderesidencia	= TRIM(rs("Cidaderesidencia"))
				strUfresidencia 	= TRIM(rs("descUfresidencia"))
				strCepresidencia 	= TRIM(rs("Cepresidencia"))
				
				'dados familiares
				strPai 				= TRIM(rs("Pai"))
				strPaifalecido 		= TRIM(rs("Paifalecido"))
				if strPaifalecido = "S" then strPaifalecido = "Sim"
				if strPaifalecido = "N" then strPaifalecido = "Não"
				
				
				strPaifone 			= TRIM(rs("Paifone"))
				strPaidatanascimento= formataDataAP(TRIM(rs("Paidatanascimento")))
				strProfissaoPai= TRIM(rs("profissaoPai"))
				strGrauInstrucaoPai= TRIM(rs("grauinstrucaoPai"))
	
				strMae 				= TRIM(rs("Mae"))
				strMaefalecida 		= TRIM(rs("Maefalecida"))
				if strMaefalecida = "S" then strMaefalecida = "Sim"
				if strMaefalecida = "N" then strMaefalecida = "Não"
				
				
				strMaefone 			= TRIM(rs("Maefone"))
				strMaedatanascimento= formataDataAP(TRIM(rs("Maedatanascimento")))
				strProfissaoMae= TRIM(rs("profissaoMae"))
				strGrauInstrucaoMae= TRIM(rs("grauinstrucaoMae"))
	
				strResponsavel 				= TRIM(rs("Responsavel"))
				strResponsavelfone 			= TRIM(rs("Responsavelfone"))
				strResponsaveldatanascimento= formataDataAP(TRIM(rs("Responsaveldatanascimento")))
				strProfissaoResponsavel= TRIM(rs("profissaoResp"))
				strGrauInstrucaoResponsavel= TRIM(rs("grauinstrucaoResp"))
	
				intQtdeIrmao 		= TRIM(rs("Qtde_irmao"))
				intQtdeIrmaoEscola	= TRIM(rs("Qtde_irmao_escola"))
	
				'documentos
				strIdentidade 		= TRIM(rs("Identidade"))
				if not isnull(rs("IdentidadeOrgao")) then strIdentidade = strIdentidade & " - " & rs("IdentidadeOrgao")
				if not isnull(rs("descUFIDENTIDADE")) then strIdentidade = strIdentidade & " - " & rs("descUFIDENTIDADE")
								
				
				strTituloEleitor 	= ""
				if not isnull(rs("TituloEleitor")) then strTituloEleitor = rs("TituloEleitor")
				if not isnull(rs("TituloZona")) then strTituloEleitor = strTituloEleitor & ", ZONA " & rs("TituloZona")
				if not isnull(rs("TituloSecao")) then strTituloEleitor = strTituloEleitor & ", SEÇÃO " & rs("TituloSecao")
				
				strRegmilitar 		= TRIM(rs("Regmilitar"))
				strCpfaluno 		= TRIM(rs("Cpfaluno"))
	
				strEscolaOrigem		= Trim(RS("Escola_origem"))				
			
				strDescCurso = ""
				strTurma = ""
				strCodTurma = ""
				strreconhecimentoAutorizacao	= ""
				
				'sql = "SELECT SCA_CURSO.DESCRICAO AS CURSO, SCA_CURSO.autorizacao, SCA_CURSO.reconhecimento, SCA_TURMA.nometurma, SCA_TURMA.cod_turma"
				 sql = "SELECT SCA_CURSO.DESCRICAO AS CURSO, SCA_CURSO.autorizacao, SCA_CURSO.reconhecimento, SCA_TURMA.nometurma, SCA_TURMA.Sala, SCA_TURMA.Ano, SCA_TURMA.AnoLetivo, SCA_TURMA.Cod_Turma, SCA_TURMA.Cod_Turno, SCA_TURMA.Cod_SemestreCriacao, SCA_PERIODO.Cod_Periodo as Cod_Periodo, SCA_PERIODO.Sequencia as SEQUENCIA, SCA_CURSO.Cod_curso as Cod_Curso "
				sql = sql & " FROM SCA_ALUNO_TURMA "
				sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
				sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo "
				sql = sql & " and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
				sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa "
				sql = sql & " where SCA_TURMA.cod_empresa = " & Session("CodEmpresa") 
				sql = sql & " and SCA_ALUNO.CODIGO = " & strCodigo
				sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
				sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
				sql = sql & " and 	SCA_ALUNO_TURMA.Semestre in (" & strSemestre & ")"
				rsaux.open sql, cnn
				if strSimouNao="N"  then  
				   if not rsaux.eof then
					  strCodTurma		= rsaux("cod_turma")
					  strTurma			= rsaux("nometurma")
					  strDescCurso		= rsaux("CURSO")
					  strreconhecimentoAutorizacao = rsaux("reconhecimento")
					  if not isnull(rsaux("autorizacao")) then 
					     strreconhecimentoAutorizacao = strreconhecimentoAutorizacao & " / " & rsaux("autorizacao")
					  end if
				   else	
				      %>
					  <script>
						 alert("ATENÇÃO: Turma Não Cadastrada.");
						 window.history.back();
					  </script>
					  <%
			       end if  
				   rsaux.close
				else
				   if not rsaux.eof then
				  	  strCodCursoAtual 	          = rsaux("COD_CURSO")
			          strCodPeriodoAtual 		  = rsaux("COD_PERIODO")
     		          strSequenciaAtual 		  = rsaux("SEQUENCIA")
			          strSequenciaDestino		  = rsaux("SEQUENCIA")+1
			          strCodTurnoDestino 		  = rsaux("COD_TURNO")
			          strSalaDestino 			  = rsaux("SALA")
			          strAnoLetivoDestino    	  = rsaux("ANOLETIVO")
			          strSemestreCriacaoDestino   = rsaux("Cod_SemestreCriacao")
				      strSemestreDestino          = session("strSemestre")
			          strNomeTurmaAtual	          = rsaux("NOMETURMA")
				      strNomeTurmaDestino         = rsaux("NOMETURMA")
			          strCodTurma			      = rsaux("cod_turma")
				      strCodTurmaDestino          = rsaux("cod_turma")
				    end if
					rsaux.close
					'  
					'BUSCA DADOS PARA O PROXIMO PERIODO	
					'
					sql = "select COD_PERIODO"
					sql = sql & " from SCA_PERIODO"
					sql = sql & " WHERE	COD_EMPRESA	= " & Session("CodEmpresa") 
					sql = sql & " AND COD_CURSO = " & strCodCursoAtual
					sql = sql & " AND SEQUENCIA = " & strSequenciaDestino
					rsaux.open sql, cnn
					if not rsaux.EOF then	
					   strCodPeriodoDestino = rsaux("COD_PERIODO")
					end if
					rsaux.close	
					'
					'Montando a nova turma
					'
					strTurma = left(strNomeTurmaAtual,2) & strSequenciaDestino & right(strNomeTurmaAtual,6)		
					'
					if trim(strCodPeriodoDestino) = "0" then
					   cnn.rollbackTrans
					   %>
					   <script>
					   alert("ATENÇÃO: Não existe período cadastrado para turma: <%=strTurma%>.");
						  window.history.back();
					   </script>
					   <%
					   response.End()
					end if
					bolExisteTurma = false
					'
					'VERIFICA SE A TURMA JÁ FOI CADASTRADA
					'
					sql = "SELECT Cod_turma, nometurma, AnoLetivo, Cod_Semestre, Cod_PlanoPagamento "
					sql = sql & " FROM	SCA_TURMA "
					sql = sql & " WHERE	NOMETURMA	= '" & strTurma & "'"
					sql = sql & " AND COD_EMPRESA	= " & Session("CodEmpresa") 
					sql = sql & " AND Cod_Semestre = " & intSemestre
		            sql = sql & " AND AnoLetivo = " & intAnoLetivo
     				rsaux.open sql, cnn
					if not rsaux.EOF then	
					   strCodTurmaDestino	    = rsaux("cod_turma")
					   strAnoLetivoDestino 		= rsaux("AnoLetivo")
					   strSemestreDestino 		= rsaux("Cod_Semestre")
                       strTurma	                = rsaux("nometurma")					   
                       strCodTurma = strCodTurmaDestino
					   strAnoLetivo = strAnoLetivoDestino
					   strSemestre = strSemestreDestino
				   else
					   bolExisteTurma         = true  	
				   end if
				   rsaux.close	
				   if bolExisteTurma then
  				      %>
					  <script>
						 alert("ATENÇÃO: Turma <%=strTurma%> Não Cadastrada.");
						 window.history.back();
					  </script>
					  <%
					  response.End()
				   end if	
				end if
				'
				' Fim da Promoção
				'
				strFoto =  "FOTO<BR>3X4"
		
				sql = "SELECT arquivo "
				sql = sql & " FROM 	SCA_ALUNO_FOTO"
				sql = sql & " Where COD_EMPRESA = " & strCod_empresa
				sql = sql & " And 	codAluno = " & strCodigo
				rsaux.open sql, cnn
				if rsaux.eof = false then
					strCaminhoFoto = session("strCaminhoRaiz") & "/fotoAluno/" & strCod_empresa & "/" & rsaux("arquivo")
					strFoto =  "<img src='" & strCaminhoFoto & "' width='100' height='110'>"
				end if
				rsaux.close
				
				mostraCabecalho
				
				if strOpcaoRelatorio = "2" then
				   'strDescCurso = ""
				   'strreconhecimentoAutorizacao = ""
				   'strDesSemestre = ""
				   'strTurma = ""
				   'strAnoLetivo = ""
				   strMatricula = ""
				   strFormaIngresso = ""
				   strEscolaOrigem = ""
				   strFoto =  "FOTO<BR>3X4"
				   strNomealuno = ""
				   strDatanascimento = ""
				   strCidadenascimento = ""
				   strUfnascimento = ""
				   strUFResidencia = ""
				   strNacionalidade = ""
				   strLogradouro = ""
				   strBairroaluno = ""
				   strCidaderesidencia = ""
				   strUFResidencia = ""
				   strCepresidencia = ""
				   strPai = ""
				   strMae = ""
				   strIdentidade = ""
				   strTituloEleitor = ""
				   strCpfaluno = ""
				   strRegmilitar = ""
				   strFoneResidencial = ""
				   strFonecelular = ""
				   strFoneComercial = ""
				   strEmail = ""
				end if 
				
				%>
				  <tr valign="top">
					<td>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr valign="top">
						<td colspan="2" align="center">
						  <table width="90%" border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td height="569" colspan="2">
								<!-- INICIO CAMPO - DADOS PESSOAIS-->
								<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabela">
								  <tr>
								    <td colspan="5" class="celula">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="12%" class="style1">NOME DO CURSO</td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strDescCurso%>&nbsp;</strong></td>
                                      </tr>
                                    </table></td>
								    <td width="13%" rowspan="5" class="celula" align="center"><%=strFoto%></td>
							      </tr>
								  <tr>
								    <td colspan="5" class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="12%" class="style1">RECONHECIMENTO/AUTORIZA&Ccedil;&Atilde;O </td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strreconhecimentoAutorizacao%>&nbsp;</strong></td>
                                      </tr>
                                    </table></td>
						          </tr>
								  <tr>
								    <td width="16%" class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="45%" class="style1">REGIME</td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strDesSemestre%>&nbsp;</strong>&nbsp;</td>
                                      </tr>
                                    </table></td>
								    <td colspan="2" class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="18%" class="style1">TURMA</td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strTurma%>&nbsp;</strong></td>
                                      </tr>
                                    </table></td>
								    <td colspan="2" class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="23%" class="style1">ANO LETIVO </td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strAnoLetivo%>&nbsp;</strong></td>
                                      </tr>
                                    </table></td>
						          </tr>
								  <tr>
								    <td class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="45%" class="style1">MATR&Iacute;CULA</td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strMatricula%>&nbsp;</strong></td>
                                      </tr>
                                    </table></td>
								    <td colspan="4" class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="23%" class="style1">FORMA DE INGRESSO </td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strFormaIngresso%>&nbsp;</strong></td>
                                      </tr>
                                    </table></td>
						          </tr>
								  <tr>
								    <td colspan="5" class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="18%" class="style1">INSTITUI&Ccedil;&Atilde;O DE ORIGEM </td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strEscolaOrigem%>&nbsp;</strong></td>
                                      </tr>
                                    </table></td>
						          </tr>
								  <tr>
								    <td colspan="5" class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="18%" class="style1">NOME DO(A) ALUNO(A) </td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strNomealuno%>&nbsp;</strong></td>
                                      </tr>
                                    </table></td>
							        <td class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td class="style1">DATA NASCIMENTO </td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strDatanascimento%>&nbsp;</strong></td>
                                      </tr>

                                    </table></td>
								  </tr>
								  <tr>
								    <td colspan="4" class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="22%" class="style1">CIDADE NASCIMENTO </td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strCidadenascimento%>&nbsp;</strong></td>
                                      </tr>
                                    </table></td>
								    <td width="16%" class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td class="style1">UF</td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strUfnascimento%>&nbsp;</strong></td>
                                      </tr>
                                    </table></td>
								    <td class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td class="style1">NACIONALIDADE</td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strNacionalidade%>&nbsp;</strong></td>
                                      </tr>
                                    </table></td>
							      </tr>
								<tr>
								    <td colspan="4" class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="11%" class="style1">ENDERE&Ccedil;O</td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strLogradouro%>&nbsp;</strong></td>
                                      </tr>
                                    </table></td>
								    <td colspan="2" class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="23%" class="style1">BAIRRO</td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strBairroaluno%></strong></td>
                                      </tr>
                                    </table></td>
							      </tr>								  
									<tr>
								    <td colspan="4" class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="11%" class="style1">CIDADE  </td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strCidaderesidencia%></strong> </td>
                                      </tr>
                                    </table></td>
								    <td width="16%" class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td class="style1">UF</td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strUFResidencia%>&nbsp;</strong></td>
                                      </tr>
                                    </table></td>
								    <td class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td class="style1">CEP</td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strCepresidencia%>&nbsp;</strong></td>
                                      </tr>
                                    </table></td>
							      </tr>								  
								  <tr>
								    <td colspan="6" class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="8%" class="style1">NOME DO PAI  </td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strPai%>&nbsp;</strong></td>
                                      </tr>
                                    </table></td>
							      </tr>
								  <tr>
								    <td colspan="6" class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="8%" class="style1">NOME DA M&Atilde;E </td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strMae%>&nbsp;</strong></td>
                                      </tr>
                                    </table></td>
							      </tr>
								  <tr>
								    <td colspan="3" class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="17%" class="style1">RG</td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strIdentidade%>&nbsp;</strong></td>
                                      </tr>
                                    </table></td>
								    <td colspan="3" class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="23%" class="style1">T&Iacute;TULO DE ELEITOR </td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strTituloEleitor%></strong>&nbsp;</td>
                                      </tr>
                                    </table></td>
							      </tr>
								  <tr>
								    <td colspan="3" class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="17%" class="style1">CPF</td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strCpfaluno%></strong>&nbsp;&nbsp;</td>
                                      </tr>
                                    </table></td>
								    <td colspan="3" class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="23%" class="style1">CERT. MILITAR N&ordm;. </td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strRegmilitar%></strong>&nbsp;</td>
                                      </tr>
                                    </table></td>
							      </tr>
								  <tr>
								    <td class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="23%" class="style1">FONE RESIDENCIAL </td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strFoneResidencial%>&nbsp;</strong></td>
                                      </tr>
                                    </table></td>
								    <td width="32%" class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="23%" class="style1">CELULAR</td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strFonecelular%>&nbsp;</strong></td>                                      </tr>
                                    </table></td>
								    <td class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="23%" class="style1">FONE COMERCIAL </td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strFoneComercial%>&nbsp;</strong></td>
                                      </tr>
                                    </table></td>
								    <td colspan="3" class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="23%" class="style1">EMAIL</td>
                                      </tr>
                                      <tr>
                                        <td><strong><%=strEmail%>&nbsp;</strong></td>
                                      </tr>
                                    </table></td>
							      </tr>
								  <tr>
								    <td colspan="6" class="celula"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      
                                      
                                    </table></td>
							      </tr>
								  <tr>
								    <td colspan="6" class="celula">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
								    <tr>
									 <td colspan="5" class="style1">MATRIZ CURRICULAR DO SEMESTRE </td>
								  </tr>
								   <%
									if strSimouNao="N"  then  
									
										sql = "SELECT gcd.cod_gradecurricularDisciplina as codigo, d.desc_disciplina, t.cod_semestre, t.AnoLetivo, t.nometurma, D.cod_disciplina "
										sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA GCD"
										sql = sql & " INNER JOIN SCA_GRADECURRICULAR GC ON GC.Cod_GRADECURRICULAR = GCD.COD_GRADECURRICULAR"
										sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_periodo = GC.COD_periodo and P.cod_empresa = GC.cod_empresa "
										sql = sql & " INNER JOIN SCA_DISCIPLINA D ON GCD.Cod_Disciplina = D.COD_Disciplina "
										sql = sql & " INNER JOIN SCA_TURMA T ON T.Cod_GradeCurricular = GC.Cod_GRADECURRICULAR and T.cod_empresa = GC.cod_empresa "
										sql = sql & " WHERE D.Cod_Empresa = " & session("CodEmpresa")
				                        sql = sql & " AND 	T.Cod_turma = " & strCodTurma
										if strDisciplina <> "" then
											sql = sql & " AND gcd.cod_gradecurricularDisciplina not in (" & strDisciplina & ")"
										end if
										sql = sql & " order by d.desc_disciplina"
										rsAux.open sql, cnn		
										IF NOT rsAux.EOF THEN
										   WHILE NOT rsAux.EOF
										      %>
										      <tr>
									          <td width="5%">&nbsp;</td>
										      <td width="13%" class="style11"><strong><%=rsAux("codigo")%></strong></td>
										      <td width="50%" class="style11"><strong><%=UCASE(rsAux("DESC_Disciplina"))%></strong></td>
									          <td width="32%" class="style11"><strong><%=rsAux("nometurma")%></strong></td>
										      </tr>
										      <%		
										      rsAux.movenext
										   wend 
									   else
									      %>
									      <tr>
									      <td width="5%" height="19">&nbsp;</td>
							   		      <td width="13%">&nbsp;</td>
									      <td width="50%">&nbsp;</td>
							      	      <td width="32%">&nbsp;</td>
									      </tr>
									      <%	
									   end if
									   RSAUX.CLOSE
									else  
										
										sql = "SELECT SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina, SCA_DISCIPLINA.DESC_Disciplina "
										sql = sql & " FROM SCA_GRADECURRICULARDISCIPLINA "
										sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_GRADECURRICULAR.Cod_GRADECURRICULAR = SCA_GRADECURRICULARDISCIPLINA.COD_GRADECURRICULAR"
										sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_periodo = SCA_GRADECURRICULAR.COD_periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
										sql = sql & " INNER JOIN SCA_DISCIPLINA ON SCA_GRADECURRICULARDISCIPLINA.Cod_Disciplina = SCA_DISCIPLINA.COD_Disciplina "
										sql = sql & " INNER JOIN SCA_TURMA ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GRADECURRICULAR and SCA_TURMA.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
										sql = sql & " WHERE SCA_DISCIPLINA.Cod_Empresa = " & session("CodEmpresa")
										sql = sql & " AND 	SCA_PERIODO.Cod_Curso = " & strCodCursoAtual
										sql = sql & " AND 	SCA_PERIODO.Cod_periodo = " & strCodPeriodoDestino
			                            sql = sql & " AND 	SCA_TURMA.Cod_turma = " & strCodTurma
										rsAux.open sql, cnn		
										IF NOT rsAux.EOF THEN
										   WHILE NOT rsAux.EOF
										      %>
										      <tr>
									          <td width="5%">&nbsp;</td>
										      <td width="13%" class="style11"><strong><%=rsAux("Cod_Disciplina")%></strong></td>
										      <td width="50%" class="style11"><strong><%=UCASE(rsAux("DESC_Disciplina"))%></strong></td>
									          <td width="32%" class="style11"><strong><%=strTurma%></strong></td>
										      </tr>
										      <%		
										      rsAux.movenext
										   wend 
									   else
									      %>
									      <tr>
									      <td width="5%" height="19">&nbsp;</td>
							   		      <td width="13%">&nbsp;</td>
									      <td width="50%">&nbsp;</td>
							      	      <td width="32%">&nbsp;</td>
									      </tr>
									      <%	
									   end if
									   RSAUX.CLOSE
									end if
									                                   
									sql = " select d.desc_Historico, hed.ano_letivo, hed.semestre, hed.situacao, he.serie, p.descricao "
									sql = sql & " from sca_historico_escolar_disciplina hed "
									sql = sql & " inner join sca_historico_escolar he on he.codigo = hed.cod_historico_escolar "
									sql = sql & " inner JOIN sca_disciplina d ON d.cod_disciplina = hed.cod_disciplina AND d.cod_empresa = he.cod_empresa "
									sql = sql & " inner JOIN sca_periodo p ON p.cod_periodo = hed.cod_periodo AND p.cod_empresa = he.cod_empresa "
									sql = sql & " inner JOIN SCF_UF u ON u.codigo = he.uf "
									sql = sql & " left JOIN SCA_OPTATIVAS op ON op.cod_empresa = he.cod_empresa and op.Ano_Letivo = hed.ano_letivo and op.Semestre_Letivo = hed.semestre and op.cod_curso = p.cod_curso and op.cod_periodo = p.cod_periodo "
									sql = sql & " left JOIN sca_disciplina dop ON dop.cod_disciplina = op.cod_disciplina AND dop.cod_empresa = op.cod_empresa "
									sql = sql & " WHERE	COD_ALUNO = " & strCodigo
									sql = sql & " AND SITUACAO = 'RP' "
									sql = sql & " order by hed.ano_letivo, hed.semestre, p.descricao "
									rsAux.open sql, cnn		
									IF NOT rsAux.EOF THEN
									   %>
									      <tr>
									        <td height="13" colspan="5" class="style1">&nbsp;</td>
							          </tr>
									      <tr>
                                         <td height="13" colspan="5" class="style1">DISCIPLINA(S) PENDENTE(S) </td>
                                         </tr>
									   <% 
									   WHILE NOT rsAux.EOF
										  %>
                                          <tr>
                                          <td colspan="5" class="style12">&nbsp;<%=rsAux("ano_letivo")%>/<%=rsAux("semestre")%>&nbsp;&nbsp;-&nbsp;&nbsp;<%=rsAux("serie")%>&nbsp;&nbsp;-&nbsp;&nbsp;<%=rsAux("desc_Historico")%>&nbsp;&nbsp;-&nbsp;&nbsp;( Reprovado )</td>
                                          </tr>
										  <%		
										  rsAux.movenext
									   wend 
									   	%>								      
										<tr>
									    <td height="13" colspan="5" class="style1">&nbsp;</td>
							            </tr>
 										<%
									 end if  
								     RSAUX.CLOSE
									%>
                                    </table>									</td>
							      </tr>
								  
								  <% if strTexto <> "" then %>
									  <tr>
										<td colspan="6" class="celula"><div align="center"><%=strTexto%></div></td>
									  </tr>
								  <% end if %>	  
								  <tr>
								    <td colspan="6" class="celula"><table width="97%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td width="9%" class="style1">OBS.:</td>
                                        <td width="91%" rowspan="2">&nbsp;</td>
                                      </tr>
                                      <tr>
                                        <td>&nbsp;</td>
                                      </tr>
                                      
                                      <tr>
                                        <td>&nbsp;</td>
                                        <td><div align="right"><strong>[&nbsp;&nbsp;&nbsp;]&nbsp;DEFERIDO &nbsp;&nbsp;&nbsp;[&nbsp;&nbsp;&nbsp;]&nbsp;INDEFERIDO</strong></div></td>
                                      </tr>
                                    </table></td>
							      </tr>
							  </table>
							</td>
						  </tr>
						</table>
						<!--#include file="../includes/inc_RepresentantesLegaisComAluno.asp"-->
						  
  					   <pre></pre>				
		          <%
				rs.movenext
				if not rs.eof then
					fimTabela
					%>
				          <%			
				end if
			wend
		end if 
		rs.close
	else
		%>
		<script>
			alert("Aluno não foi encontrato, verifique.");
			window.history.back();
		</script>
		<%
		response.end
	end if 
	%>
	<script>
		aguarde.style.display="none";
	</script>
</body>
</html>