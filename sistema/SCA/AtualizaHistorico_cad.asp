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
</script></head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%=session("strCaminhoRaiz")%>/images/botao_verde_over.gif')">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<script>
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		var form = document.getElementById("frm");
		var intContMarcado=0;
		var strAlunos='';
		
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

		if (frm.cmbTipoAtualizacao.value=='F'){
			if (frm.cmbSituacaoAluno.value=='0'){
			alert("A situação de destino deve ser informada.")
			frm.cmbSituacaoAluno.focus();
			return false
			}
		}
		
		frm.action="AtualizaHistorico_cod.asp";
		frm.submit();
		return true;
 	}

</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<%
	strPaginaTitulo = "AtualizaHistorico_cad.asp"

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	
	strSemestre 			= session("strSemestre")
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request.Form("txtAnoLetivo")
	end if

	intCodTurma 			= Trim(Request("cmbTurma"))
	intCodCurso	 			= Trim(Request("cmbCurso"))
	intCodPeriodo 			= Trim(Request("cmbPeriodo"))
	intSemestre 			= Trim(Request("cmbSemestre"))
	intCodGrade				= Trim(Request("cmbGrade"))

	intCodTurno		 		= Trim(Request("cmbTurno"))
	strSala		 			= Trim(Request("txtSala"))
	intAno		 			= Trim(Request("txtAno"))
	intAnoLetivo 			= Trim(Request("txtAnoLetivo"))
	
	intCodTipoLancamento    = trim(request("cmbTipoLancamento"))
	intCodDisciplinaTurma  = trim(request("cmbDisciplinaTurma"))

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0"

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


	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))
	TipoAtualizacao	= Trim(Request("cmbTipoAtualizacao"))

	if strMatricula <> "" then
		sql = "Select Codigo, NomeAluno, matricula from sca_aluno"
		sql = sql & " where cod_empresa = " & session("CodEmpresa")
		sql = sql & " and matricula = " & strMatricula
		rs.open sql, cnn
		if rs.eof = false then
			strCodAluno			= Trim(rs("codigo"))
			strMatricula 		= Trim(rs("Matricula"))
			strNomealuno 		= Trim(rs("Nomealuno"))
		end if
		rs.close	
	else
		strCodAluno			= ""
		strMatricula 		= ""
		strNomealuno 		= ""
	end if


	strDesabilitaIncluir = "" 'Desabilita o botão Incluir'
	strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
	strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
	strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
	
	strRetiraAtivo = "S" 'retira da combo os ativos

%>
<form method="post" id="frm" action="AtualizaHistorico_cad.asp">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td  align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center">
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
	<tr>
      <td width="19%" class="texto1">Ano Letivo:</td>
      <td width="81%" colspan="2"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
    </tr>
    <tr>
      <td class="texto1">Semestre:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
    </tr>
    <tr> 
      <td class="texto1">Turma : </td>
      <td colspan="2"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Tipo Atualiza&ccedil;&atilde;o: </td>
      <td colspan="2"><label>
        <select name="cmbTipoAtualizacao" class="combo" onChange="submit()">
          <option <%if TipoAtualizacao = "A" then%> selected <%end if%> value="A">Atualiza&ccedil;&atilde;o Curricular</option>
          <option <%if TipoAtualizacao = "F" then%> selected <%end if%> value="F">Fechamento</option>
        </select>
      </label></td>
    </tr>
<%if TipoAtualizacao = "F" then%>
    <tr>
      <td class="texto1">Situa&ccedil;&atilde;o Acad&ecirc;mica de Destino: </td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSituacaoAluno.asp"--></td>
    </tr>
	
	
<%end if%>
    <tr> 
      <td class="texto1">&nbsp;</td>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr> 
      <td colspan="3"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
    </tr>
    <tr>
      <td colspan="3">
	  <%
			if intCodTurma    = "" then intCodTurma="0"
			if intCodSemestre = "" then intCodSemestre="0"
			if intCodTurma<>"0" then%> 
					
					<table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
				  <tr class="CabecalhoConsulta"> 
					<td width="37" align="center" class="celula">
					<input type="checkbox" name="chkTodos" onClick="return MarcaTodos(this.checked)"></td>
					<td width="130" class="celula"><strong>Matr&iacute;cula</strong></td>
					<td width="811" class="celula"><strong>Nome</strong></td>
				    <td width="193" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
				  </tr>
				  <%					
							'seleciona os alunos da turma
							'seleciona os alunos da turma - intCodTurma
							'sql = sqlAlunoTurma(intCodTurma, intCodDisciplinaTurma)
							sql = " SELECT DISTINCT "
							sql = sql & " AD.COD_ALUNO AS CODIGO, " 
							sql = sql & " AD.COD_TURMA_REMANEJAMENTO AS COD_TURMA, "
							sql = sql & " A.NOMEALUNO, "
							sql = sql & " A.MATRICULA, SA.DESC_SITUACAOALUNO"
							sql = sql & " FROM SCA_ALUNO_DISCIPLINA AD INNER JOIN " 
							sql = sql & " SCA_ALUNO A ON A.CODIGO = AD.COD_ALUNO  INNER JOIN "
							sql = sql & " SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = A.COD_SITUACAOALUNO AND SA.Cod_Empresa = A.COD_EMPRESA "
							sql = sql & " WHERE AD.COD_EMPRESA = " & Session("CodEmpresa") 
							sql = sql & " AND AD.COD_TURMA_REMANEJAMENTO= " & intCodTurma	
							sql = sql & " ORDER BY A.NOMEALUNO "
							cont = 0
							rs.open sql, cnn
							if rs.eof = false then
								while not rs.eof
									strCodAluno             = rs("CODIGO")
									intCodEmp               = Session("CodEmpresa") 
									strDesabilitaAluno 	  	= ""
									strSituacaoAluno 		= ""
									strMatricula		          = rs("MATRICULA")
		                            strDesc_SituacaoAluno		  = rs("Desc_SituacaoAluno")
									
									'Função que verifica a siuação do aluno
									strSituacaoPromocao = "" 'Não é necessário mostrar a situação promoção nesta tela
		                            
									strAlunoFechado = "NO"
									sql = " SELECT COD_ALUNO "
									sql = sql & " FROM SCA_CONTROLE_FECHAMENTO " 
									sql = sql & " WHERE COD_ALUNO = " & strCodAluno
									sql = sql & " AND COD_TURMA = " & intCodTurma	
									cont = 0
									rs1.open sql, cnn
									if rs1.eof = false then
									   if TipoAtualizacao = "F" then
									      strAlunoFechado = "OK"
									   end if	  
									end if
									rs1.close
									
									if strAlunoFechado = "NO" then	
										%>
										  <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
											<td class="celula" align="center"><input type="checkbox" id="chkAluno" name="chkAluno" <%=strDesabilitaAluno%> value="<%=rs("codigo")%>"></td>
											<td class="celula"><%=strMatricula%></td>
											<td class="celula"><%=rs("NOMEALUNO") & " " & strSituacaoAluno%></td>
											<td class="celula"><%=strDesc_SituacaoAluno%></td>
										  </tr>
										  <%
										  cont = cont + 1
									end if	  
								rs.movenext
							wend%>
									  <tr >
									    <td colspan="4" class="celula">&nbsp;&nbsp;Total de Registros: <%=cont%></td>
				      </tr>
							
							<%
						else
							%>
				  <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
					<td colspan="6" align="center" class="celula"><%=session("strMensagemNaoEncontrado")%></td>
				  </tr>
				  <%
							end if
							rs.close
					end if
							%>
				</table>	  
			  <br>
<br></td>
    </tr>
  </table>
  		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>