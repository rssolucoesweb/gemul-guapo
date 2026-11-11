<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 27/08/2012
	::	Desenvolvedores...: Sergio Borges - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Notas Faltas Historico
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<script>
	function marcaTodos(valor){
		
		var frm = document.getElementById("frm");
		var form = window.document.forms[0];
		var i;
		for (var i = 0; i < form.elements.length; i++) {
			//verifica todos os checkbox
			if (form.elements[i].type == "checkbox"){
				//verifica se o checkbox está marcado
				form.elements[i].checked=valor;
			}
		}
	}
	function gerar(){
	
		var frm = document.getElementById("frm");
		var form = window.document.forms[0];
		var intContMarcado=0;
		var strAlunos='';
		
		
		var intAnoSession = <%=session("strAnoLetivo")%>;
		if (frm.txtAnoLetivo.value=="") {
			alert("Ano Letivo deve ser informado.");
			frm.txtAnoLetivo.focus();
			return false
		}
		
		if (frm.txtAnoLetivo.value>intAnoSession) {
			alert("Ano/Semestre letivo não permitido.");
			frm.txtAnoLetivo.focus();
			return false
		}
	
		if (frm.cmbCurso.value == 0){
			alert("O Curso deve ser informado!");
			frm.cmbCurso.focus();
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
		
		frm.action = "Rel_NotasFaltasHistorico_rel.asp";
		frm.submit();
		
		return true;	
	}	
</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	strPaginaTitulo = "Rel_NotasFaltasHistorico_con.asp"

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))

	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	intCodPlanoPagamento	= Trim(Request.Form("cmbPlanoPagamento"))
	strSala		 			= Trim(Request.Form("txtSala"))
	intAno		 			= Trim(Request.Form("txtAno"))
	intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	strclasse               = Trim(Request.Form("cmbTamanhoFonteArial"))


	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"
	if intCodNota = "" then intCodNota="0"

	if intCodTurma = "" then intCodTurma = "0"
	if trim(intCodTurma) <> "0" then
		sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
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
		END IF
		rs.close
	end if	
	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""

%>
<form method="post" id="frm" action="#">
<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center">
<br>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr>
      <td class="texto1">Ano Letivo:</td>
      <td colspan="2"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
    </tr>
    <tr>
      <td class="texto1">Semestre:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
    </tr>
    <tr>
      <td class="texto1">Curso:</td>
      <td colspan="2"><span class="texto1">
        <!--#include file="../includes/inc_cmdCurso.asp"-->
      </span></td>
    </tr>
    <tr>
      <td class="texto1">Per&iacute;odo:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdPeriodo.asp"--></td>
    </tr>
    <tr>
      <td width="15%" class="texto1">Turma:</td>
      <td width="85%" colspan="2"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Situa&ccedil;&atilde;o:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSituacaoAluno.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Tamanho da Fonte:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmbTamanhoFonteArial.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Extrato por Folha</td>
      <td colspan="2"><select name="cmbTotalExtrato" id="cmbTotalExtrato" style="width:50pt" class="combo">
        <option value="4" <%if intTotalExtrato = "4" then response.Write("selected") %>>04</option>
        <option value="1" <%if intTotalExtrato = "1" then response.Write("selected") %>>01</option>
        <option value="2" <%if intTotalExtrato = "2" then response.Write("selected") %>>02</option>
        <option value="3" <%if intTotalExtrato = "3" then response.Write("selected") %>>03</option>
        <option value="4" <%if intTotalExtrato = "4" then response.Write("selected") %>>04</option>
        <option value="6" <%if intTotalExtrato = "6" then response.Write("selected") %>>06</option>
        <option value="7" <%if intTotalExtrato = "7" then response.Write("selected") %>>07</option>
        <option value="8" <%if intTotalExtrato = "8" then response.Write("selected") %>>08</option>
        <option value="9" <%if intTotalExtrato = "9" then response.Write("selected") %>>09</option>
        <option value="10" <%if intTotalExtrato = "10" then response.Write("selected") %>>10</option>
      </select></td>
    </tr>
    <tr>
      <td class="texto1">Buscar alunos com mais de:</td>
      <td colspan="2"><select name="cmbFiltroTotalFaltas" id="cmbFiltroTotalFaltas" style="width:100pt" class="combo">
      	<option value="0">Selecione...</option>
        <option value="5" <%if FiltroTotalFaltas = "5" then response.Write("selected") %>>05</option>
        <option value="5" <%if FiltroTotalFaltas = "5" then response.Write("selected") %>>05</option>
        <option value="10" <%if FiltroTotalFaltas = "10" then response.Write("selected") %>>10</option>
        <option value="15" <%if FiltroTotalFaltas = "15" then response.Write("selected") %>>15</option>
        <option value="20" <%if FiltroTotalFaltas = "20" then response.Write("selected") %>>20</option>
        <option value="25" <%if FiltroTotalFaltas = "25" then response.Write("selected") %>>25</option>
        <option value="30" <%if FiltroTotalFaltas = "30" then response.Write("selected") %>>30</option>
        <option value="35" <%if FiltroTotalFaltas = "35" then response.Write("selected") %>>35</option>
        <option value="40" <%if FiltroTotalFaltas = "40" then response.Write("selected") %>>40</option>
        <option value="45" <%if FiltroTotalFaltas = "45" then response.Write("selected") %>>45</option>
        <option value="50" <%if FiltroTotalFaltas = "50" then response.Write("selected") %>>50</option>
        <option value="55" <%if FiltroTotalFaltas = "55" then response.Write("selected") %>>55</option>
        <option value="60" <%if FiltroTotalFaltas = "60" then response.Write("selected") %>>60</option>
        <option value="65" <%if FiltroTotalFaltas = "65" then response.Write("selected") %>>65</option>
        <option value="70" <%if FiltroTotalFaltas = "70" then response.Write("selected") %>>70</option>
      </select> 
      -Faltas</td>
    </tr>
    <tr>
      <td class="texto1">Mostrar Resultado:</td>
      <td colspan="2"><input type="checkbox" name="resultadoFinal" value="S"></td>
    </tr>

	<%

    strSomenteFonte7 = ""
    strSomenteFonte8 = ""
    strSomenteFonte9 = "N"
    strSomenteFonte10 = "N"
    strSomenteFonte11 = "N"
    strSomenteFonte12 = "N"
    
    %>
    
    <tr>
      <td colspan="3"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr>
      <td colspan="3" class="texto1">Obs: Para a impress&atilde;o da Acumulada de Notas e faltas, seu navegador dever&aacute; ser configurado com as margens direita 05, esquerda 05, superior 05 e inferior 5. Dever&aacute; tamb&eacute;m ser exclu&iacute;do cabe&ccedil;alho e rodap&eacute; de seu navegador na op&ccedil;&atilde;o configurar p&aacute;gina.</td>
    </tr>
    <tr>
      <td colspan="3"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
    </tr>
    <tr>
      <td colspan="3">
			<br>
			<%
			if intCodTurma    = "" then intCodTurma="0"
			if intCodPeriodo = "" then intCodPeriodo="0"
			if intCodSituacaoAluno = "" then intCodSituacaoAluno = "0"

			if intCodTurma<>"0" and intCodCurso<>"0" and intCodPeriodo<>"0" then%>
				<table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
          <tr class="CabecalhoConsulta">
            <td class="celula" width="30" align="center"><input type="checkbox" name="chkTodos" onClick="return marcaTodos(this.checked)"></td>
            <td width="100" class="celula"><strong>Matrícula</strong></td>
            <td class="celula"><strong>Nome do aluno </strong></td>
          </tr>
          <%					
					'seleciona os alunos da turma'					
					sql = "SELECT DISTINCT SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.DATAMATRICULA , SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.DESCRICAO AS CURSO, SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma"
					sql = sql & " FROM SCA_ALUNO_TURMA "
					sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
					sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
					sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
					sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa"
					sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa"
					sql = sql & " where SCA_TURMA.cod_empresa = " & session("CodEmpresa")
					sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
					
					if strSemestre <> "0" and strSemestre<>"" then
						sql = sql & " and 	SCA_ALUNO_TURMA.Semestre in (" & strSemestre & ")"
					end if
					
					if intCodCurso <> "0" then
						sql = sql & " and SCA_CURSO.Cod_Curso = " & intCodCurso
					end if
					
					if intCodPeriodo <> "0" then
						sql = sql & " and SCA_GRADECURRICULAR.Cod_Periodo = " & intCodPeriodo
					end if
					
					if intCodTurno <> "0" then
						sql = sql & " and SCA_TURMA.COD_TURNO = " & intCodTurno
					end if
					
					if intCodTurma <> "0" then
						sql = sql & " and SCA_TURMA.COD_TURMA = " & intCodTurma
					end if
					
					if intCodSituacaoAluno <> "0" then
						sql = sql & " and SCA_ALUNO.COD_SITUACAOALUNO = " & intCodSituacaoAluno
					end if
					sql = sql & " order by SCA_TURMA.NOMETURMA, SCA_ALUNO.NOMEALUNO"
					rs.open sql, cnn
					
					'Armazena o código de todos os alunos da turma'
					strAlunosTurma=""
					if rs.eof = false then
						while not rs.eof
							strCodigoAluno        = rs("codigo")
							strMatricula		  = rs("MATRICULA")
							strNomeTurma		  = rs("NOMETURMA")
							'Função que verifica a siuação do aluno
							strSituacaoPromocao = "" 'Não é necessário mostrar a situação promoção nesta tela
							if trim(strNomeTurma) <> trim(strNomeTurmaAnt) then
								%>
								  <tr bgcolor="#EFEFEF">
									<td colspan="3" align="center" class="celula"><strong>(<%=strNomeTurma%>)&nbsp;</strong></td>
									</tr>
								  <tr>
								<%
							end if
							%>
                            <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
                            <td class="celula" align="center"><input type="checkbox" id="chkAluno" name="chkAluno" <%=strDesabilitaAluno%> value="<%=rs("codigo")%>"></td>
                            <td class="celula"><%=strMatricula%></td>
                            <td class="celula"><%=rs("NOMEALUNO") & " " & strSituacaoAluno%>&nbsp;</td>
                            </tr>
                            <%
							strNomeTurmaAnt = strNomeTurma
                            rs.movenext
						wend
					else
					%>
                    <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
                    	<td colspan="3" align="center" class="celula"><%=session("strMensagemNaoEncontrado")%></td>
                    </tr>
					<%
					end if
					rs.close
			end if
					%>
        </table>        </td>
    </tr>
  </table>
		  </td>
		</tr>
  </table><input type="hidden" name="txtHiddenAlunosTurma" value="<%=strAlunosTurma%>">
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
