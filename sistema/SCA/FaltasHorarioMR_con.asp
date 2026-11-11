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
	
	
	
</script>
<%	

	Function QuantosDiasTemOMes(Mes,Ano)
	  Select Case Mes
		Case 1,3,5,7,8,10,12: QuantosDiasTemOMes = 31
		Case 4,6,9,11: QuantosDiasTemOMes = 30
		Case Else
		  If Ano Mod 4 = 0 And (Ano Mod 100 <> 0 Or Ano Mod 400 = 0) Then
			QuantosDiasTemOMes = 29
		  Else
			QuantosDiasTemOMes = 28
		  End If
	  End Select
	End Function

	strExecutarSubmitMes = "SIM"
	strPaginaTitulo = "FaltasHorario_con.asp"
	strExecutarSubmitDisciplinaDoProfessor = "S"
	strBloqueia_NotasDocente = ""
	
	' Consulta a Categoria	
	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	'sql = sql & " and codLotacao = " & Session("CodEmpresa")
	sql = sql & " and CodCategoria = 1 "'professor
	sql = sql & " and Situacao = 'A'" 'Ativod
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

	intCodTurno		 		= Trim(Request("cmbTurno"))
	intCodPlanoPagamento	= Trim(Request("cmbPlanoPagamento"))
	strSala		 			= Trim(Request("txtSala"))
	intAno		 			= Trim(Request("txtAno"))
	intAnoLetivo 			= Trim(Request("txtAnoLetivo"))
	
	intCodTipoLancamento    = trim(request("cmbTipoLancamento"))
	intCodDisciplina  		= trim(request("cmbDisciplinaDoProfessor"))
	strData					= trim(request("txtData"))
	strMes					= trim(request("cmbMes"))
	strSemana				= trim(request("cmbSemana"))
	
	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
	if intCodDisciplina = "" then intCodDisciplina = "0"
	
	if strMes = "" then strMes = "0"
	if strAno = "" then strAno = year(date)
	if strSemana = "" then strSemana = "0"
	
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
     <%
	  if strVerificaCategoria = "" then%>
        <tr>
          <td class="texto1">Turma Disciplina:</td>
          <td colspan="2"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
        </tr>
     <%end if%>
     	
     <% if strVerificaCategoria = "Professor" then
	 %>
        <tr> 
          <td class="texto1">Turma Professor:</td>
          <td colspan="2"><!--#include file="../includes/inc_cmdTurmaProfessor.asp"--></td>
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

    <% if strVerificaCategoria = "Professor" then
	%>
        <tr>
          <td class="texto1">Disciplina Professor:</td>
          <td colspan="2" class="texto">
		  <!--include file="../includes/inc_cmdDisciplinaDoProfessorFaltas.asp"--> 
          <!--#include file="../includes/inc_cmbDisciplinaTurmaFaltas.asp"-->   
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
       <td class="texto1">M&ecirc;s:</td>
       <td colspan="2"><!--#include file="../includes/inc_cmbMes.asp"--></td>
     </tr>
     <!--<tr>
       <td class="texto1">Semana</td>
       <td colspan="2">
       <select name="cmbSemana" id="cmbSemana" style="width:80pt" class="combo">
       <option  value="0">Selecione...</option>
      <%
	  if strMes <> "0" then

        diaInicioMes = 1
		diaFimMes	= QuantosDiasTemOMes(strMes,strAno)
		cont = 0

        for k=diaInicioMes to diaFimMes
		
			if cont = 0 then
				diaInicioSemana = k
			end if
			
            if cont = 7 then
			
			   diaFinalSemana = k-1
			   dataInicial = formataDataAP(diaInicioSemana & "/" & strMes & "/" & strAno) 
			   dataFinal =  formataDataAP(diaFinalSemana & "/" & strMes & "/" & strAno)
			   
		       response.write "<option value=" & dataInicial & "_" & dataFinal & " " & strSelecionado &">" & ZeroLeft(diaInicioSemana,2) & " a " & ZeroLeft(diaFinalSemana,2) & "</option> "  & vbcrlf
               cont = 0
			   diaInicioSemana = diaFinalSemana+1
			   
		
		    end if 
			
			cont = cont + 1
			
        next
		
		 x = (diaFimMes - diaFinalSemana) - 1
		 diaFinalSemana = diaInicioSemana + x
		 
		 dataInicial = formataDataAP(diaInicioSemana & "/" & strMes & "/" & strAno)
		 dataFinal =  formataDataAP(diaFinalSemana & "/" & strMes & "/" & strAno)
		 response.write "<option value=" & dataInicial & "_" & dataFinal & " " & strSelecionado &">" & ZeroLeft(diaInicioSemana,2) & " a " & diaFinalSemana & "</option> "  & vbcrlf

		end if
		%>
       </select>-->
       </td>
     </tr>
    <tr>
      <td class="texto1">&nbsp;</td>
      <td colspan="2" class="texto">&nbsp;</td>
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
        <input type="button" name="cmdLimpar"  value="Limpar"  class="botao" <%=strDesabilitaLimpar%>  onClick="window.navigate('FaltasHorario_con.asp')"> 
        <input class="botao" type="button" value="Principal" name="BtnFechar" onClick="window.navigate('default.asp')">      </td>
    </tr>
    <tr> 
      <td colspan="3" class="texto1"> <br> <%
			if intCodTurma    	= "" then intCodTurma="0"
			if intCodSemestre 			= "" then intCodSemestre="0"
			if intCodTurma<>"0" then%> 
			
			<table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
          <tr class="CabecalhoConsulta"> 
            <td width="64" align="center" class="celula"><input type="checkbox" name="chkTodos" onClick="return MarcaTodos(this.checked)"></td>
            <td width="114" class="celula"><strong>Ordem</strong></td>
            <td width="148" class="celula"><strong>Matr&iacute;cula</strong></td>
            <td width="880" class="celula"><strong>Nome</strong></td>
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
					sql = sql & " SA.DESC_SITUACAOALUNO "
					sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN " 
					sql = sql & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
					sql = sql & " SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA "
					sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa")
					sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO = " & intCodTurma	
				  	sql = sql & " AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PRÉ-MATRÍCULA') " 
					sql = sql & " ORDER BY A.NOMEALUNO "
					rs.open sql, cnn
					if rs.eof = false then
						while not rs.eof

							strCodigoAluno      = rs("codigo")
							strMatricula		= rs("MATRICULA")

							'Função que verifica a siuação do aluno
							strSituacaoPromocao = "" 'Não é necessário mostrar a situação promoção nesta tela

							%>
          <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
            <td class="celula" align="center">&nbsp;<input type="checkbox" id="chkAluno" name="chkAluno" value="<%=rs("codigo")%>"></td>
            <td class="celula"><%=rs("sequencia")%>&nbsp;</td>
            <td class="celula"><%=strMatricula%></td>
            <td class="celula"><%=rs("NOMEALUNO") & " " & strSituacaoAluno%>&nbsp;</td>
            </tr>
          <%
						rs.movenext
					wend
				else
					%>
          <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
            <td colspan="4" align="center" class="celula"><%=session("strMensagemNaoEncontrado")%></td>
          </tr>
          <%
					end if
					rs.close
			end if
					%>
        </table></td>
    </tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
