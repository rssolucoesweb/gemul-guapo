<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/03/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Relatório Remanejamento
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
		var intContMarcado=0;
		var strAlunos='';

	
		if (frm.cmbSemestre.value == 0){
			alert("O Semestre deve ser informado!");
			frm.cmbSemestre.focus();
			return false;
		}
		
		if (frm.cmbCurso.value == 0){
			alert("O Curso deve ser informado!");
			frm.cmbCurso.focus();
			return false;
		}		
		
		frm.action = "Rel_Remanejamento_rel.asp";
		frm.submit();
		return true;	
	}	
</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	strPaginaTitulo = "Rel_Remanejamento_con.asp"

	strExecutarSubmitCurso	  		= "S"
	strExecutarSubmitPeriodo  		= "S"
	strExecutarSubmitSemestre		= "S"
	strExecutarSubmitTurno	  		= "S"
	strExecutarSubmitTurma	  		= "S"
	strExecutarSubmit		  		= "S"
	strExecutarSubmitSitDisciplina	= "S"
	
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")
	
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurno 			= Trim(Request.Form("cmbTurno"))
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodDisciplinaTurma	= Trim(Request.Form("cmbDisciplinaTurma"))
	intCodSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))
	strSituacaoDisciplina 	= Trim(Request.Form("cmbSituacaoDisciplina"))
	strRemanejamento		= Trim(Request.Form("cmbRemanejamento"))

	if intCodTurno 	= "" then intCodTurno = "0"
	if intCodTurma 	= "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento 	= "" then intCodTipoLancamento = "0"
	if intCodDisciplinaTurma 	= "" then intCodDisciplinaTurma = "0"
	if strRemanejamento = "" then strRemanejamento = "N"

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

	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""

%>
<form method="post" id="frm" action="Rel_Remanejamento_con.asp">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center">
<br>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
	  <tr>
        <td width="18%" class="texto1">Ano Letivo:</td>
	    <td width="82%"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
	    </tr>
	  <tr>
        <td class="texto1">Semestre:</td>
	    <td><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
	    </tr>
      <tr>
        <td class="texto1">Curso:</td>
        <td><span class="texto1">
          <!--#include file="../includes/inc_cmdCurso.asp"-->
        </span></td>
      </tr>
      <tr>
        <td class="texto1">Per&iacute;odo:</td>
        <td><!--#include file="../includes/inc_cmdPeriodo.asp"--></td>
      </tr>
      <tr>
        <td class="texto1">Turno:</td>
        <td><!--#include file="../includes/inc_cmdTurno.asp"--></td>
      </tr>
      <tr>
      <td class="texto1">Turma:</td>
      <td><!--#include file="../includes/inc_cmdTurma.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Disciplina:</td>
      <td><!--#include file="../includes/inc_cmbDisciplinaTurma.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Situa&ccedil;&atilde;o Acad&ecirc;mica</td>
      <td><span class="texto1">
        <!--#include file="../includes/inc_cmdSituacaoAluno.asp"-->
      </span></td>
    </tr>
    <tr>
      <td class="texto1">Situa&ccedil;&atilde;o Disciplinar: </td>
      <td><!--#include file="../includes/inc_cmdSituacaoDisciplina.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Somente Remanejamento?</td>
      <td>
      <select name="cmbRemanejamento" id="cmbRemanejamento" style="width:100pt" class="combo"  onChange="submit()" >
      <option value="S" <%if strRemanejamento = "S" then response.Write("selected") %>>Sim</option>
      <option value="N" <%if strRemanejamento = "N" then response.Write("selected") %>>N&atilde;o</option>
    </select>
&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    
    <tr>
      <td colspan="2"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr>
      <td colspan="2"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2">
	  <%
		if intCodCurso    = "" then intCodCurso="0"

		if intCodCurso <>"0" then%>
			<table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
              <tr bgcolor="#CCCCCC" class="CabecalhoConsulta">
                <td width="86" class="celula"><strong>Matr&iacute;cula</strong></td>
                <td width="163" class="celula"><strong>Nome do aluno </strong></td>
                <td width="130" class="celula"><strong>Turma Origem</strong></td>
                <td width="146" class="celula"><strong>Discip. Origem </strong></td>
                <td width="174" class="celula"><strong>Turma Remanejamento</strong></td>
                <td width="167" class="celula"><strong>Discip. Remanejamento </strong></td>
                <td width="78" align="center" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
              </tr>
          <%					
			   sql = " SELECT AD.CODIGO AS COD_ALUNO_DISCIPLINA, "
			   sql = sql & " AD.COD_ALUNO AS CODIGO, " 
			   sql = sql & " AD.COD_TURMA_REMANEJAMENTO, "
			   sql = sql & " AD.COD_DISCIPLINA, "
			   sql = sql & " AD.Situacao as SitDisciplinar, "
			   sql = sql & " A.NOMEALUNO, "
			   sql = sql & " A.MATRICULA, "
			   sql = sql & " A.DATANASCIMENTO, "
			   sql = sql & " A.DATAMATRICULA, "
			   sql = sql & " A.COD_FORMAINGRESSO, "
			   sql = sql & " P.DESCRICAO AS PERIODO, "
			   sql = sql & " C.DESCRICAO AS CURSO, "
			   sql = sql & " T.NomeTurma as TurmaRemanejada, "
			   sql = sql & " TTO.NomeTurma as TurmaOrigem, "
			   sql = sql & " SA.DESC_SITUACAOALUNO, "
			   sql = sql & " DO.Desc_Disciplina as DisciplinaOrigem , "
			   sql = sql & " DR.Desc_Disciplina as DisciplinaRemanejamento"
			   
			   sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD" 
			   sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO AND AD.COD_EMPRESA = A.COD_EMPRESA"
			   
			   sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_TURMA = AD.COD_TURMA_REMANEJAMENTO AND AD.COD_EMPRESA = T.COD_EMPRESA"
			   sql = sql & " INNER JOIN SCA_TURMA TTO ON TTO.COD_TURMA = AD.COD_TURMA AND AD.COD_EMPRESA = TTO.COD_EMPRESA"
			   
			   sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GOD ON GOD.Cod_GradeCurricularDisciplina = AD.COD_GRADECURRICULARDISCIPLINA "
   			   sql = sql & " INNER JOIN SCA_DISCIPLINA DO ON DO.Cod_Disciplina = GOD.Cod_Disciplina "
		   
			   sql = sql & " INNER JOIN SCA_GRADECURRICULARDISCIPLINA GRD ON GRD.Cod_GradeCurricularDisciplina = AD.COD_GRADECURRICULARDISCIPLINA_REMANEJAMENTO "
 			   sql = sql & " INNER JOIN SCA_DISCIPLINA DR ON DR.Cod_Disciplina = GRD.Cod_Disciplina "
			   
			   sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON T.Cod_GradeCurricular = G.Cod_GradeCurricular"
			   sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = G.Cod_Periodo and P.cod_empresa = G.cod_empresa"
			   sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa =  A.COD_EMPRESA"
			   sql = sql & " INNER JOIN SCA_CURSO C ON C.Cod_Curso = P.Cod_Curso and C.cod_empresa = P.cod_empresa"
			   sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa") 
			   sql = sql & " AND SA.Desc_SituacaoAluno = 'ATIVO' "
			   
			   if strRemanejamento = "S" then
			   	 sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO <>  AD.COD_TURMA " 
			   end if
			   
			   if intCodDisciplinaTurma <> "0" then
				   sql = sql & " AND AD.COD_DISCIPLINA= " & intCodDisciplinaTurma
			   end if
			   
			   if intCodTurma <> "0" then
				   sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO= " & intCodTurma	
			   end if
			 
			   if intCodCurso <> "0" then
				  sql = sql & " and C.Cod_Curso = " & intCodCurso
			   end if
			   
			   if intCodPeriodo <> "0" then
				  sql = sql & " and G.Cod_Periodo = " & intCodPeriodo
			   end if
			   
			   if intCodTurno <> "0" then
				  sql = sql & " and T.COD_TURNO = " & intCodTurno
			   end if
			   
			   if intCodSituacaoAluno <> "0" then
				  sql = sql & " and SA.COD_SITUACAOALUNO = " & intCodSituacaoAluno
			   end if
			   
			   if strSituacaoDisciplina <> "0" then
				  sql = sql & " and AD.Situacao = '" & strSituacaoDisciplina & "'"
			   end if
			   
			   sql = sql & " Order By A.NOMEALUNO"	
			   
			   rs.open sql, cnn
					
				'Armazena o código de todos os alunos da turma'
				if rs.eof = false then
					while not rs.eof
						strCodigoAluno        = rs("codigo")
						strMatricula		  = rs("MATRICULA")
						%>
						<tr> 
							<td class="celula"><%=strMatricula%></td>
							<td class="celula"><%=rs("NOMEALUNO") & " " & strSituacaoAluno%></td>
							<td class="celula"><%=rs("TurmaOrigem")%></td>
							<td class="celula"><%=rs("DisciplinaOrigem")%> &nbsp;</td>
							<td class="celula"><%=rs("TurmaRemanejada")%>&nbsp;</td>
							<td class="celula"><%=rs("DisciplinaRemanejamento")%>&nbsp;</td>
							<td align="center" class="celula"><%=rs("SitDisciplinar")%>&nbsp;</td>
						</tr>
						<%
						rs.movenext
					wend
				else
				%>
				  <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
					<td colspan="7" align="center" class="celula"><%=session("strMensagemNaoEncontrado")%></td>
				  </tr>
				<%
				end if
				rs.close
		 end if
		%>
        </table>
        </td>
    </tr>
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
    </table>
  </td>
</tr>
</table><input type="hidden" name="txtHiddenAlunosTurma" value="<%=strAlunosTurma%>">
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>