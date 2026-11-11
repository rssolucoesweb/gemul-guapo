<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>

<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 27/11/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Notas
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->
<script>
	function cadastrarNotas(){
		var form = window.document.forms[0];
		var intContMarcado=0;
		var strAlunos='';
		var strEja='';
		
		if (frm.cmbSemestre.value == 0){
			alert("O Semestre deve ser informado!");
			frm.cmbSemestre.focus();
			return false;
		}
		
		if (frm.cmbMes.value == "0"){
			alert("Mês deve ser informado!");
			frm.cmbMes.focus();
			return false;
		}		

		//*****verifica se o chkTipoNota foi selecionado
		intContMarcado==0
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "radio"){
				if (form.elements[i].name == "chkTipoNota"){
					//verifica se o checkbox está marcado
					if (form.elements[i].checked){
						intContMarcado = intContMarcado + 1;
					}
				}
			}
		}
		
		if (intContMarcado==0){
			alert("A avaliação deve ser informada!");
			return false;
		}
		
		//*****verifica se um aluno foi selecionado
		intContMarcado=0;
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				if (form.elements[i].name == "chkAluno"){
					//verifica se o checkbox está marcado
					if (form.elements[i].checked){
						intContMarcado = intContMarcado + 1;
					}
				}
			}
		}	
		if (intContMarcado==0){
			alert("O(s) aluno(s) deve(m) ser informado(s)!");
			return false;
		}
		
		frm.action = "FaltasHorario_cad.asp";
		frm.submit();
		
		return true;	
	}
	function lancarOcorrencias(codAluno){
		var frm = document.getElementById("frm")
		window.open("FaltasHorarioOcorrencia_cad.asp?txtCodAluno="+codAluno,"Lancar", "top=50,left=50,height=650,width=900,menubar=no,toolbar=no,scrollbars=no,status=no");
		return true;
	}
</script>
<%
	strPaginaTitulo = "FaltasHorario_con.asp"
	strExecutarSubmitDisciplinaDoProfessor = "S"
	strBloqueia_NotasDocente = ""
	' Consulta a Categoria	
	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and codLotacao = " & Session("CodEmpresa")
	sql = sql & " and (CodCategoria = 1 or CodCategoria = 8) "'professor
	sql = sql & " and Situacao = 'A'" 'Ativo
	rs.open sql, cnn
	if rs.EOF = false then	
		strVerificaCategoria 		= "Professor"
		intCodColaboradorProfessor 	= trim(rs("codigo"))
	else
		strVerificaCategoria = ""
	end if
	rs.close


	
	strExecutarSubmitCurso	  	= "S"
	strExecutarSubmitPeriodo  	= "S"
	strExecutarSubmitSemestre 	= "S"
	strExecutarSubmitTurno	  	= "S"
	strExecutarSubmitTurma	 	= "S"
	strExecutarSubmitMes 		= "S"
	strSemestre 				= session("strSemestre")
	
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if
	strQtdeFaltas = request("txtQtdeFaltas")
	if strQtdeFaltas = "" then strQtdeFaltas = "1"
	
	'REGRA QUANDO O ANO DIGITADO FOR MENOR QUE O DA SESSION
	'SERÁ GRAVADO DO ARQUIVO DE HISTORICO
	if Cint(strAnoLetivo) < Cint(session("strAnoLetivo")) then
		'GRAVANDO NO ARQUIVO DE HISTORICO
		strGravarOnde = "HISTORICO"
		strMsnBotaoHistorico  = " notas no Histórico"
	else
		'GRAVANDO NO ARQUIVO DE NOTAS
		strGravarOnde = "NOTA"
		strMsnBotaoHistorico  = ""
	end if
	
	if  Trim(Request("cmbTurma")) <> "" then
		intCodTurma 			= Trim(Request("cmbTurma"))
		intCodTurmaProfessor	= Trim(Request("cmbTurma"))
	else
		intCodTurma				= Trim(Request("cmbTurmaProfessor"))
		intCodTurmaProfessor	= Trim(Request("cmbTurmaProfessor"))
	end if
	
	if  Trim(Request("cmbDisciplinaTurma")) <> "" then
		intCodDisciplina			= Trim(Request("cmbDisciplinaTurma"))
		intCodDisciplinaTurma		= Trim(Request("cmbDisciplinaTurma"))
	else
		intCodDisciplina			 = Trim(Request("cmbDisciplinaDoProfessor"))
		intCodDisciplinaTurma		 = Trim(Request("cmbDisciplinaDoProfessor"))
	end if
	if intCodTurma = "" then intCodTurma = "0"
	if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	if intCodDisciplina = "" then intCodDisciplina = "0"
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"
	
	intCodCurso	 			= Trim(Request("cmbCurso"))
	intCodPeriodo 			= Trim(Request("cmbPeriodo"))
	if strVerificaCategoria = "Professor" then 
		intSemestre 		= session("strSemestre")
		strAnoLetivo		= session("strAnoLetivo")
	else	
		intSemestre 		= Trim(Request("cmbSemestre"))
	end if	
	intCodGrade				= Trim(Request("cmbGrade"))
	intCodDisciplina		= Trim(Request("cmbDisciplinaDoProfessor"))
	strMes					= Trim(Request("cmbMes"))
	strQuinzena		 		= Trim(Request("cmbQuinzena"))	

	intCodTurno		 		= Trim(Request("cmbTurno"))
	intCodPlanoPagamento	= Trim(Request("cmbPlanoPagamento"))
	strSala		 			= Trim(Request("txtSala"))
	intAno		 			= Trim(Request("txtAno"))
	intAnoLetivo 			= Trim(Request("txtAnoLetivo"))
	
	intCodTipoLancamento    = trim(request("cmbTipoLancamento"))
	intCodDisciplina  		= trim(request("cmbDisciplinaDoProfessor"))
	strDataLancamento		= trim(request("txtDataLancamento"))
		
	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
	if intCodDisciplina = "" then intCodDisciplina = "0"
	strTipoPeriodo = "D"
	sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, "
	sql = sql & " SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma, SCA_PERIODO.Tipo "
	sql = sql & " FROM SCA_TURMA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
	SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
	sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurma
	RS.OPEN SQL, CNN
	IF not RS.EOF THEN
		intCodCurso 	= rs("cod_curso")
		intCodPeriodo = rs("cod_periodo")
		intCodTurno = rs("cod_turno")
		intSemestre = rs("cod_Semestre")
		strTipoLancamento = rs("Tipo")
	END IF
	rs.close
	
	

	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""

%>
<form method="post" id="frm" action="FaltasHorario_con.asp">
<input  name="cmbCurso" type="hidden" id="cmbCurso" value="<%=intCodCurso%>">
<input  name="cmbPeriodo" type="hidden" id="cmbPeriodo" value="<%=intCodPeriodo%>">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  </table>
  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="2" bgcolor="#FFFFFF" class="Formulario">
    <tr>
      <td colspan="3" align="center" class="texto1"><span class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></span></td>
    </tr>
    <tr>
      <td width="12%" class="texto1">Ano Letivo:</td>
      <td width="88%" colspan="2"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
    </tr>
    <tr>
      <td class="texto1">Semestre:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
    </tr>
     <% if strVerificaCategoria = "" then%>
        <tr>
          <td class="texto1">Turma Disciplina:</td>
          <td colspan="2"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
        </tr>
     <%end if%>
     	
     <% if strVerificaCategoria = "Professor" then%>
        <tr> 
          <td class="texto1">Turma Professor:</td>
          <td colspan="2"><!--#include file="../includes/inc_cmdTurmaProfessorFaltas.asp"--></td>
        </tr>
    <%end if %>

	<% if trim(strTipoLancamento) = "D" then %>
		%>
		<script>
			alert("Essa aplicação se destina ao lançamento INTERDISCIPLINAR. \nPor favor, para essa turma utilize lancamento DISCIPLINAR.");
			window.location.href  = '../Principal.asp'
		</script>
		<%
    end if %>

<%
	'if intCodTurmaProfessor <> "" and strVerificaCategoria = "Professor" then	
'		sql = "select count(*) as qtde"
'		SQL = SQL & " from SRH_TURMA_MODULACAO_FUNCAO"
'		SQL = SQL & " where Cod_Turma = " & intCodTurmaProfessor
'		response.write sql
'		RS.OPEN SQL, CNN
'		IF not RS.EOF THEN
'			if rs("qtde")>1 then
'				strTurmaIntegralComDoisTurno = "S"
'			end if
'		END IF
'		rs.close
'	end if

IF intCodTurmaProfessor<>"0" and strVerificaCategoria = "Professor" THEN
	strTurmaIntegral=""
	sql = "select DISTINCT T.DESC_TURNO"
	sql = sql & " from SCA_TURMA A"
	sql = sql & " INNER JOIN SCA_TURNO T ON T.COD_TURNO = A.Cod_Turno"
	sql = sql & " WHERE A.COD_TURMA =" & intCodTurmaProfessor
	sql = sql & " AND LEFT(T.DESC_TURNO,1) = 'I'"
	SQL = SQL & " AND A.cod_empresa=" & Session("CodEmpresa")
	RS.OPEN SQL, CNN
	IF not RS.EOF THEN
		strTurmaIntegral = "S"
	end if
	rs.close
	
	sql = "select DISTINCT T.DESC_TURNO"
	sql = sql & " from SCA_HORARIO_AULA A"
	sql = sql & " INNER JOIN SCA_HORARIO H ON A.COD_HORARIO = H.CODIGO"
	sql = sql & " INNER JOIN SCA_TURNO T ON T.COD_TURNO = H.CodTurno"
	sql = sql & " where A.cod_colaborador = " & intCodColaboradorProfessor
	sql = sql & " AND A.COD_TURMA =" & intCodTurmaProfessor
	sql = sql & " AND LEFT(T.DESC_TURNO,1) = 'V'"
	SQL = SQL & " AND A.cod_empresa=" & Session("CodEmpresa")
'	response.write sql

	RS.OPEN SQL, CNN
	IF not RS.EOF THEN
		strMostraMensagemBloqueiaLancFaltas = "S"
	END IF
	rs.close
	
	if strMostraMensagemBloqueiaLancFaltas = "S" and strTurmaIntegral = "S" then
		%>
		<script>
			alert("Turma selecionada é de turno INTEGRAL, só poderá lançar de faltas no turno matutino, você poderá lançar ocorrências, clicando no icone na coluna ocorrências!");
		</script>
		<%
		strDisabilitaLancFaltas = "disabled"
	end if
end if%>



    <% if strVerificaCategoria = "Professor" then%>
        <tr>
          <td class="texto1">Disciplina Professor:</td>
          <td colspan="2" class="texto"> <!--#include file="../includes/inc_cmbDisciplinaTurmaFaltas.asp"-->   
    - Caso n&atilde;o seja informado a disciplina ser&aacute; atualizada pelo hor&aacute;rio.</td>
        </tr>
    <%end if%>
    <% if strVerificaCategoria = "" then%>
    <tr>
     	<td class="texto1">Disciplina Turma:</td>
   		<td colspan="2" class="texto"><!--#include file="../includes/inc_cmbDisciplinaTurmaFaltas.asp"--> - Caso n&atilde;o seja informado a disciplina ser&aacute; atualizada pelo hor&aacute;rio</td>
    </tr>
     <%end if%>
     <tr>
       <td class="texto1">Op&ccedil;&otilde;es de lan&ccedil;amentos::</td>
       <td colspan="2"><select name="cmbQuinzena" class="combo" id="cmbQuinzena" style="width:150pt" onChange='submit()'>
        <option value="1" <%if strQuinzena = "1" then response.Write("selected") %>>1º Quinzena</option>
        <option value="2" <%if strQuinzena = "2" then response.Write("selected") %>>2º Quinzena</option>
        <option value="3" <%if strQuinzena = "3" then response.Write("selected") %>>Por dia</option>
        </select></td>
     </tr>
     <% if strQuinzena = "3" then %>
        <tr>
          <td class="texto1">Data:</td>
          <td colspan="2"><input name="txtDataLancamento" type="text" class="text" id="txtDataLancamento" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataLancamento%>" title="Click aqui para visualizar o calend&aacute;rio"></td>
        </tr>
    <% end if%>
    <tr>
      <td class="texto1">M&ecirc;s:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmbMes.asp"--></td>
    </tr>
    </tr>
    <%
    if Trim(Request("cmbMes"))<> "0" and Trim(Request("cmbMes"))<> "" and strVerificaCategoria <> "" then

		' Consulta se o conteúdo já foi enviado

		sql = " select codigo from sca_conteudo "
		sql = sql & " where MONTH(DataInicial) = " & strMes
		sql = sql & " and AnoLetivo = " & strAnoLetivo
		sql = sql & " and Semestre = " &  intSemestre
		sql = sql & " and Cod_Colaborador = " & intCodColaboradorProfessor
		sql = sql & " and Cod_turma = " & intCodTurma
		sql = sql & " and Cod_Disciplina = " & intCodDisciplinaTurma
		sql = sql & " and Fechamento = 'S' "
		rs.open sql, cnn
		if rs.EOF = false then	
			%>
			<script>
				alert("Atenção! Mês já enviado, para uma possível alteração procure a Secretaria.");
				window.location.href  = '../Principal.asp'
			</script>
			<%
			response.end
		end if
		rs.close
	end if
	%>
    <tr align="left"> 
      <td colspan="3" class="texto1">
	  <br>
	  <%
			  	IF intCodCurso = "" THEN intCodCurso = 0

				sql="SELECT DISTINCT TA.CODIGO, TA.DESCRICAO, TA.BIMESTRE"
				sql=sql & " FROM SCA_CRITERIO_AVALIACAO CA"
				sql=sql & " INNER JOIN SCA_AVALIACAO A ON A.CODCRITERIOAVALIACAO = CA.CODIGO AND A.COD_EMPRESA = CA.COD_EMPRESA"
				sql=sql & " INNER JOIN SCA_TIPO_AVALIACAO TA ON A.CODTIPOAVALIACAO = TA.CODIGO AND A.COD_EMPRESA = TA.COD_EMPRESA"
				sql=sql & " WHERE	CA.COD_EMPRESA = " & Session("CodEmpresa") 
				sql=sql & " AND		CA.COD_CURSO = " & intCodCurso
				sql=sql & " AND		TA.digitar = 'S'"
				sql=sql & " ORDER BY TA.BIMESTRE"
				rs.open sql, cnn
				intCont = 0
				if rs.eof = false then
				%>
					<table width="50%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td width="77%" class="texto1"><strong>Avaliação</strong></td>
					  </tr>
				<%
					while not rs.eof
						if rs("bimestre") = "1" then strBim = "1º Bimestre"
						if rs("bimestre") = "2" then strBim = "2º Bimestre"
						if rs("bimestre") = "3" then strBim = "3º Bimestre"
						if rs("bimestre") = "4" then strBim = "4º Bimestre"
						if rs("bimestre") = "5" then strBim = "Exame Final"
						%>
						<tr>
						<td class="texto1"><input type="radio" name="chkTipoNota" value="<%=rs("codigo")%>"><%=rs("descricao")%></td>
						</tr>
						<%					
						trocaBim = trim(rs("bimestre"))
						rs.movenext
					wend
					%>
					</table>
	  <%
				end if
				rs.close
				%> </td>
    </tr>
	 <tr align="center"> 
      <td colspan="3" class="texto1"></td>
    </tr>
    <tr> 
      <td colspan="3"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr> 
      <td colspan="3"><input type="button" name="cmdCadastrar" value="Cadastrar<%=strMsnBotaoHistorico%>" class="botao" onClick="return cadastrarNotas()"> 
        <input type="button" name="cmdLimpar"  value="Limpar"  class="botao" <%=strDesabilitaLimpar%>  onClick="window.location='FaltasHorario_con.asp'"> 
        <input class="botao" type="button" value="Principal" name="BtnFechar" onClick="window.navigate('default.asp')">      </td>
    </tr>
    <tr> 
      <td colspan="3" class="texto1"> <br> <%
			if intCodTurma    	= "" then intCodTurma="0"
			if intCodSemestre 			= "" then intCodSemestre="0"
			if intCodTurma<>"0" then%> 
			
			<table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
          <tr class="CabecalhoConsulta"> 
            <td width="77" align="center" class="celula"><input type="checkbox" name="chkTodos" onClick="return MarcaTodos(this.checked)"></td>
            <td width="138" class="celula"><strong>Ordem</strong></td>
            <td width="180" class="celula"><strong>Matr&iacute;cula</strong></td>
            <td width="937" class="celula"><strong>Nome</strong></td>
            <td width="138" align="center" class="celula"><strong>Ocorr&ecirc;ncias</strong></td>
          </tr>
          <%					
					'seleciona os alunos da turma
					'seleciona os alunos da turma - intCodTurma
					'sql = sqlAlunoTurma(intCodTurma, "")
					sql = " SELECT distinct "
					sql = sql & " AD.COD_ALUNO AS CODIGO, " 
					sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
					sql = sql & " A.NOMEALUNO, "
					sql = sql & " A.MATRICULA, "
					sql = sql & " '' AS SEQUENCIA, "
					sql = sql & " SA.DESC_SITUACAOALUNO, O.COD_ALUNO as cod_aluno_ocorrencia  "
					sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN " 
					sql = sql & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
					sql = sql & " SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA "
					sql = sql & " LEFT JOIN SCA_OCORRENCIA_FALTAS O ON O.COD_ALUNO = A.CODIGO AND O.Cod_Empresa = A.COD_EMPRESA AND O.ANO_LETIVO = " & SESSION("strANOLETIVO") & " AND O.SEMESTRE = " & SESSION("strSemestre")
					sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa")
					sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO = " & intCodTurma	
				  	sql = sql & " AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
					sql = sql & " ORDER BY A.NOMEALUNO "
					rs.open sql, cnn
					if rs.eof = false then
						while not rs.eof

							strCodigoAluno      = rs("codigo")
							strMatricula		= rs("MATRICULA")
							corI = ""
							corF = ""
							if not isnull(rs("cod_aluno_ocorrencia")) then
								corI = "<strong><font color='#000099'>"
								corF = "</font></strong>"								
							end if
			  
							sql = " select ad.codigo, ad.COD_DISCIPLINA from SCA_ALUNO_DISCIPLINA ad "
							sql = sql & " left join SCA_NOTAS_FALTAS nf on nf.cod_aluno_disciplina = ad.CODIGO "
							sql = sql & " where ad.COD_ALUNO = " & strCodigoAluno
							sql = sql & " and ISNULL(nf.codigo,'0') = '0' " 
							rs1.open sql, cnn
							if rs1.eof = false then
								while not rs1.eof
								
									strCodAlunoDisciplina  	= rs1("CODIGO")
				  					strCodDisciplinaNovo  	= rs1("COD_DISCIPLINA")
									
									if strCodAlunoDisciplina <> "0" then
										'VERIFICA SE EXISTE REGISTRO DE NOTAS PARA O ALUNO 
										strCriaNotas = "S"
										sql = "SELECT COD_ALUNO_DISCIPLINA "
										sql = sql & " FROM SCA_NOTAS_FALTAS "
										sql = sql & " WHERE	COD_ALUNO_DISCIPLINA = " & strCodAlunoDisciplina
										rsAux.open sql, cnn
										if rsAux.eof then
											strCriaNotas = "N"
											strDesabilitaAluno 	= " disabled "
											strSituacaoAluno	= " <strong>(Não não existe registro de notas)</strong>"
										end if
										rsAux.close
										if strCriaNotas = "N" then
										   strMarcaCriaNotas = "N"
										   SQL = "INSERT INTO SCA_NOTAS_FALTAS (cod_empresa, cod_aluno, cod_aluno_disciplina, cod_periodo, "
										   SQL = SQL & "ano_letivo, semestre, cod_disciplina, nota01, falta01, nota02, falta02, nota03, falta03, nota04, falta04, nota05, falta05, nota06, falta06, nota07, falta07, nota08, falta08, nota09, falta09, nota10, falta10, nota11, falta11, nota12, falta12, nota13, falta13, nota14, falta14, nota15, falta15, situacao, media )  VALUES ("
										   SQL = SQL & "" & Session("CodEmpresa") & ","
										   SQL = SQL & "" & strCodigoAluno & ","
										   SQL = SQL & "" & strCodAlunoDisciplina & ","
										   SQL = SQL & "" & intCodPeriodo & ","
										   SQL = SQL & "" & strAnoLetivo & ","
										   SQL = SQL & "" & intSemestre & ","
										   SQL = SQL & "" & rs1("COD_DISCIPLINA") & ","
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null,"
										   SQL = SQL & "null)"
										   cnn.execute SQL
										   'GravarLog sql - Não é necessário porque o próprio sistema cria quando não tiver notas
										end if
									 end if
									rs1.movenext
								wend
							end if
							rs1.close
							

							'Função que verifica a siuação do aluno
							strSituacaoPromocao = "" 'Não é necessário mostrar a situação promoção nesta tela

							%>
          <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
            <td class="celula" align="center">&nbsp;<input type="checkbox" id="chkAluno" name="chkAluno" value="<%=rs("codigo")%>"></td>
            <td class="celula"><%=rs("sequencia")%>&nbsp;</td>
            <td class="celula"><%=strMatricula%></td>
            <td class="celula"><%=corI%><%=rs("NOMEALUNO") & " " & strSituacaoAluno%>&nbsp;<%=corF%></td>
            <td align="center" class="celula"><a href="#" onClick="lancarOcorrencias('<%=rs("codigo")%>')"><img src="../../images/botao_azul_normal.gif" width="26" height="26" alt="Lançar ocorrências"></a></td>
            </tr>
          <%
						rs.movenext
					wend
				else
					%>
          <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
            <td colspan="5" align="center" class="celula"><%=session("strMensagemNaoEncontrado")%></td>
          </tr>
          <%
					end if
					rs.close
			end if
					%>
        </table><br>
<br>
</td>
    </tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
