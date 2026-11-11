<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = true
server.ScriptTimeout = 6000
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Extrato de NOtas
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
<script type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif')">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript " src="../../js/js_dragdrop.js"></script>
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
		
		frm.action = "Rel_Faltas_Ocorrencia_rel.asp";
		frm.submit();
		
		return true;	
	}	
</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_validaPermissaoPagina.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<%
	strPaginaTitulo = "Rel_Faltas_Ocorrencia_con.asp"

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	strExecutarSubmit	  = "S"
	

	strMatriculaAluno		= Trim(Request.Form("txtMatricula"))
    strCodAluno			    = Trim(Request("txtCodAluno"))
	strNomealuno 		    = Trim(Request("txtNomealuno"))
	
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
	intCodSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))

	strPeriodoInicial					= Trim(Request.Form("txtPeriodoInicial"))	
	strPeriodoFinal						= Trim(Request.Form("txtPeriodoFinal"))	

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
	'controla os botões
	strDesabilitaIncluir = "disabled"
	strDesabilitaExcluir = "disabled"
	strDesabilitaAlterar = ""
	strDesabilitaLimpar = ""
	
	if intQtdeQuebraExtrato = "" then intQtdeQuebraExtrato = 2

%>
<form method="post" id="frm" action="#">
<input name="txtTipoRelatorio" type="hidden" value="<%=intTipoRelatorio%>">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td width="700" height="18" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center">
<br>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
  <tr>
    <td width="14%" height="12"><span class="texto1">Matr&iacute;cula : </span></td>
    <td width="86%" colspan="2"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodAluno%>" maxlength="10">
      <span class="texto1">
        <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="20" value="<%=strMatriculaAluno%>"  onKeyPress="return formataCampo(this, 2, 9)" onBlur="submit()">
        <a  href="#" onClick="return abreConsulta('Aluno_con.asp')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image7','','<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif',1)"><img alt="Clique para consultar o aluno" src="<%=session("strCaminhoRaiz")%>/images/botao_verde_normal.gif" name="Image7" width="26" height="26" border="0"  align="absmiddle" ></a></span>&nbsp;
      <input readonly name="txtNomealuno" type="text" class="textDesabilita" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>" ></td>
  </tr>
  <tr>
    <td class="texto1">Ano Letivo:</td>
    <td colspan="2"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
  </tr>
  <tr>
    <td class="texto1">Semestre:</td>
    <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
  </tr>
  <tr>
    <td width="14%" class="texto1">Turma</td>
    <td width="86%" colspan="2"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
  </tr>
  <tr>
    <td class="texto1">Per&iacute;odo</td>
    <td colspan="2" class="texto1"><span class="texto"><span class="TextoForm">
      <input name="txtPeriodoInicial" type="text" class="text" id="txtPeriodoInicial" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" value="<%=strPeriodoInicial%>" style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio">
      </span>a <span class="TextoForm">
        <input name="txtPeriodoFinal" type="text" class="text" id="txtPeriodoFinal" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" value="<%=strPeriodoFinal%>" style="cursor:hand" title="Click aqui para visualizar o calend&aacute;rio" onChange="return verificaDatas(frm.txtPeriodoInicial.value, frm.txtPeriodoFinal.value)">
      </span></span></td>
  </tr>
  <tr>
    <td class="texto1">&nbsp;</td>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3"><hr size="1" color="#CCCCCC"></td>
  </tr>
  <tr>
    <td colspan="3"><!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->
      &nbsp;</td>
  </tr>
  <tr>
    <td colspan="3"><br>
      <%
			if intCodTurma    = "" then intCodTurma="0"
			if intCodPeriodo = "" then intCodPeriodo="0"

			if intCodTurma<>"0" then%>
      <table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
        <tr class="CabecalhoConsulta">
          <td class="celula" width="38" align="center"><input type="checkbox" name="chkTodos" onClick="return marcaTodos(this.checked)"></td>
          <td width="132" class="celula"><strong>Matr&iacute;cula</strong></td>
          <td width="620" class="celula"><strong>Nome do aluno </strong></td>
          <td width="135" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
        </tr>
        <%
		  buscaHistorico = "N"
		  if trim(intSemestre) = "3" then
			 if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  then
			    buscaHistorico = "S"
			 end if
		  else
		     if trim(strAnoLetivo) <> trim(session("strAnoLetivo"))  or trim(intSemestre) <> trim(session("strSemestre")) then
		  	    buscaHistorico = "S"
			 end if	   
		  end if
		  if buscaHistorico = "N" then
			'seleciona os alunos do ano e semestre corrente 			
			sql = " SELECT DISTINCT "
			sql = sql & " AD.COD_ALUNO AS CODIGO, " 
			sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
			sql = sql & " A.NOMEALUNO, "
			sql = sql & " A.MATRICULA, "
			sql = sql & " SA.DESC_SITUACAOALUNO "
			sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN " 
			sql = sql & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
			sql = sql & " SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA "
			sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa")
			'sql = sql & " AND AD.COD_DISCIPLINA= " & intCodDisciplina
			sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO = " & intCodTurma	
			if intCodSituacaoAluno = "" or intCodSituacaoAluno = "0" then
			   sql = sql & "AND (SA.Desc_SituacaoAluno = 'ATIVO' OR SA.Desc_SituacaoAluno = 'PR&Eacute;-MATR&Iacute;CULA') " 
			else
			   sql = sql & "AND SA.Cod_SituacaoAluno = " & intCodSituacaoAluno
			end if
			if strMatriculaAluno <> "" then
			    sql = sql & "AND A.MATRICULA = '" & strMatriculaAluno & "'"
			end if	
    		sql = sql & " ORDER BY A.NOMEALUNO "
		else			
			'seleciona os alunos pelo ano e semestres do hist&oacute;rico 			
			sql = " select DISTINCT A.CODIGO, HED.COD_TURMA, A.NOMEALUNO, A.MATRICULA, SA.DESC_SITUACAOALUNO "
			sql = sql & " from SCA_HISTORICO_ESCOLAR_DISCIPLINA HED "
			sql = sql & " INNER JOIN SCA_HISTORICO_ESCOLAR HE ON HE.CODIGO = HED.COD_HISTORICO_ESCOLAR "
			sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = HE.COD_ALUNO AND A.COD_EMPRESA = HE.COD_EMPRESA "
			sql = sql & " INNER JOIN SCA_SITUACAOALUNO SA ON SA.COD_SITUACAOALUNO = A.COD_SITUACAOALUNO AND SA.COD_EMPRESA = A.COD_EMPRESA " 
			sql = sql & " WHERE A.COD_EMPRESA = " & Session("CodEmpresa")
			sql = sql & " AND HED.COD_TURMA = " & intCodTurma	
			sql = sql & " AND HE.ANO_LETIVO = " & strAnoLetivo
			sql = sql & " AND HE.SEMESTRE = " & intSemestre 
			if intCodSituacaoAluno <> "" and intCodSituacaoAluno <> "0" then
			   sql = sql & "AND SA.Cod_SituacaoAluno = " & intCodSituacaoAluno
			end if   
			if strMatriculaAluno <> "" then
			    sql = sql & "AND A.MATRICULA = '" & strMatriculaAluno & "'"
			end if	
			sql = sql & " ORDER BY NOMEALUNO "
         end if
	 
 		 rs.open sql, cnn
					
					'Armazena o c&oacute;digo de todos os alunos da turma'
					strAlunosTurma=""
					if rs.eof = false then
						while not rs.eof
							strCodigoAluno        = rs("codigo")
							strMatricula		  = rs("MATRICULA")
'							intStatusAluno        = rs("codigo_status")
'							strCodigoSituacao     = rs("codigoSitAluno")

							'Fun&ccedil;&atilde;o que verifica a siua&ccedil;&atilde;o do aluno
							strSituacaoPromocao = "" 'N&atilde;o &eacute; necess&aacute;rio mostrar a situa&ccedil;&atilde;o promo&ccedil;&atilde;o nesta tela

							%>
        <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
          <td class="celula" align="center"><input type="checkbox" id="chkAluno" name="chkAluno" <%=strDesabilitaAluno%> value="<%=rs("codigo")%>"></td>
          <td class="celula"><%=strMatricula%></td>
          <td class="celula"><%=rs("NOMEALUNO") & " " & strSituacaoAluno%>&nbsp;</td>
          <td class="celula"><%=rs("DESC_SITUACAOALUNO")%>&nbsp;</td>
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
      </table><br>
<br>
</td>
  </tr>
</table></td>
		</tr>
  </table><input type="hidden" name="txtHiddenAlunosTurma" value="<%=strAlunosTurma%>">
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>