<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 27/11/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Criterio de Avaliação
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
<script type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
</script>
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif')">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<script>
	function marcaTodos(valor){
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
	
		if (frm.cmbSemestre.value == 0){
			alert("O Semestre deve ser informado!");
			frm.cmbSemestre.focus();
			return false;
		}
		
		if (frm.cmbTurma.value == 0){
			alert("A turma deve ser informada!");
			frm.cmbTurma.focus();
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
		
		frm.action = "Rel_FichaIndividualAluno_rel.asp";
		frm.submit();
		return true;	
	}	
</script>
<%
	strPaginaTitulo			  = "Rel_FichaIndividualAluno_con.asp"
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"

	strMatriculaAluno		= Trim(Request.Form("txtMatricula"))
    strCodAluno			    = Trim(Request("txtCodAluno"))
	strNomealuno 		    = Trim(Request("txtNomealuno"))
	
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intAno		 			= Trim(Request.Form("txtAno"))
	intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))

	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")
	if intCodTurma = "" then intCodTurma = "0"

	if trim(strMatriculaAluno) <> "" then
	
		sql = "Select Codigo, NomeAluno, matricula from sca_aluno"
		sql = sql & " where cod_empresa = " & session("CodEmpresa")
		sql = sql & " and matricula = " & strMatriculaAluno
		rs.open sql, cnn
		if rs.eof = false then
			strCodAluno			    = Trim(rs("codigo"))
			strMatriculaAluno 		= Trim(rs("Matricula"))
			strNomealuno 	    	= Trim(rs("Nomealuno"))
		else
			strCodAluno			= 0
			strNomealuno 		= ""
			%>
			<script>
				alert("Aluno não foi encontrado.");
			</script>
			<%
		end if
		rs.close
		'
		' Verificando a alocação do aluno
		sql = "SELECT TOP 1 SCA_CURSO.Cod_Curso, SCA_TURMA.COD_SEMESTRE, SCA_TURMA.COD_TURMA "
		sql = sql & " FROM SCA_ALUNO_TURMA "
		sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
		sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo "
		sql = sql & " and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa "
		sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa "
		sql = sql & " where SCA_TURMA.cod_empresa = " & Session("CodEmpresa")
		sql = sql & " and 	SCA_ALUNO.CODIGO = " & strCodAluno
		sql = sql & " order by SCA_ALUNO_TURMA.CODIGO DESC "
		rs.open sql, cnn
		if not rs.eof then
		   intCodCurso = rs("cod_curso") 
		   intCodTurma = rs("COD_TURMA")
		else
		   %>
		   <script>
			   alert("ATENÇÃO: O Aluno ainda não foi alocado em uma turma, verifique!");
		   </script>
		   <%
		end if
		rs.close

	else
		strCodAluno			    = ""
		strMatriculaAluno 		= ""
		strNomealuno 		    = ""
	end if

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
	if intCodSemestre = "" then intCodSemestre = "0"
	
	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""
%>
<form method="post" id="frm" action="#">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center">
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr> 
      <td width="10%" height="12">&nbsp;</td>
      <td width="90%" colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">Matr&iacute;cula : </td>
      <td class="texto1"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10">
        <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="20" value="<%=strMatriculaAluno%>"  onKeyPress="return formataCampo(this, 2, 10)" onBlur="submit()">
        <a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a>&nbsp;
        <input readonly name="txtNomealuno" type="text" class="textDesabilita" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>" ></td>
    </tr>
    <tr>
      <td class="texto1">Ano Letivo:</td>
      <td class="texto1"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
    </tr>
    <tr>
      <td class="texto1">Semestre:</td>
      <td class="texto1"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
    </tr>
    <tr> 
      <td class="texto1">Turma : </td>
      <td colspan="2"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
    </tr>
    <tr> 
      <td class="texto1">&nbsp;</td>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr> 
      <td colspan="3"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"--></td>
    </tr>
    <tr> 
      <td colspan="3" class="texto1"> <br> 
	  <%
			if intCodTurma    = "" then intCodTurma="0"
			if intCodPeriodo = "" then intCodPeriodo="0"

			if intCodTurma<>"0" then%>
			
			<table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
          	<tr class="CabecalhoConsulta"> 
            <td width="36" align="center" class="celula"><input type="checkbox" name="chkTodos" onClick="return MarcaTodos(this.checked)"></td>
            <td width="133" class="celula"><strong>Matr&iacute;cula</strong></td>
            <td width="470" class="celula"><strong>Nome</strong></td>
            <td width="300" class="celula"><strong>Data de Nascimento </strong></td>
          	</tr>
          <%					
			sql = "SELECT  SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MAE , SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.DESCRICAO AS CURSO, SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma"
			sql = sql & " FROM SCA_ALUNO_TURMA "
			sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
			sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
			sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa"
			sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa"
			sql = sql & " where SCA_TURMA.cod_empresa = " & session("CodEmpresa")
			sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
			sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
			sql = sql & " and 	SCA_ALUNO_TURMA.Semestre in (" & intSemestre & ")"
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
				sql = sql & " and SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
			end if
			if strMatriculaAluno <> "" then
			   sql = sql & "AND SCA_ALUNO.MATRICULA = '" & strMatriculaAluno & "'"
			end if	
			sql = sql & " Order By SCA_TURMA.COD_TURMA, SCA_ALUNO.NOMEALUNO"

			rs.open sql, cnn
			if rs.eof = false then
				while not rs.eof
					strCodigoAluno        = rs("codigo")
					strMatricula		  = rs("MATRICULA")
					%>
					  <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
						<td class="celula" align="center"><input type="checkbox" id="chkAluno" name="chkAluno" <%=strDesabilitaAluno%> value="<%=rs("codigo")%>"></td>
						<td class="celula"><%=strMatricula%></td>
						<td class="celula"><%=rs("NOMEALUNO")%>&nbsp;</td>
						<td class="celula"><%=FORMATADATAAP(rs("DATANASCIMENTO"))%>&nbsp;</td>
					  </tr>
          				<%
						rs.movenext
					wend
				else
					%>
					  <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
						<td colspan="4" align="center" class="celula"><%=session("strMensagemRelatorioNaoEncontrado")%></td>
					  </tr>
					  <%
					end if
					rs.close
			end if
					%>
        </table><br></td>
    </tr>
  </table>
  		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>