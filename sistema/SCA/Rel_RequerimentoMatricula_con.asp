<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 27/11/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Requerimento de Matricula
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
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<script>

	function Descricao(tipo){
		
			if (document.all["mostraDescricao"+tipo].style.display =="none"){
				document.all["mostraDescricao"+tipo].style.display="block";
				document.all["imgDescricao"+tipo].src="../../images/up.jpg";
			}
			else{
				document.all["mostraDescricao"+tipo].style.display="none";
				document.all["imgDescricao"+tipo].src="../../images/down.jpg";
			}
	}	
	
	function marcaTodasDisciplinas(){
		
		var frm = document.getElementById("frm");
		
		if(frm.chkdisciplina.checked == true)
		{ 
			for (var i = 0; i < frm.elements.length; i++) 
			{
				//verifica todos os checkbox
				if (frm.elements[i].name.substring(0,19) == "chkdisciplina"){				
					if (frm.elements[i].disabled == false) {
						frm.elements[i].checked = true;				
					}
				}
			}
		}
		else
		{
			for (var i = 0; i < frm.elements.length; i++) 
			{
				//verifica todos os checkbox
				if (frm.elements[i].name.substring(0,19) == "chkdisciplina"){				
					frm.elements[i].checked = false;				
				}
			}
		}
		return true;
	}
	
	function gerar(){
		
		var frm = document.getElementById("frm");
		var form = window.document.forms[0];
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
		
		if (frm.optOpcao[0].checked==false && frm.optOpcao[1].checked==false && frm.optOpcao[2].checked==false) {
			alert("Opção de Impressão deve ser informada !");
			frm.optOpcao[0].focus();
			return false;
		}	
	
		if (intContMarcado==0){
			alert("O aluno deve ser informado ou selecionado!");
			return false;
		}
		
		frm.action = "Rel_RequerimentoMatricula_rel.asp?codsimounao=" +frm.cmbSimouNao.value;
		frm.submit();
		return true;	
	}


</script>
<%
	dim intCodSituacaoAluno

	strPaginaTitulo = "Rel_RequerimentoMatricula_con.asp"
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmit	  = "S"
	
	intSemestre 			= session("strSemestre")
	strAnoLetivo 			= session("strAnoLetivo")

	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if trim(intSemestre) = "" or  trim(intSemestre) = "0"  then 	intSemestre  = session("strSemestre")
	
	strCodAluno			= Trim(Request("txtCodAluno"))
	strMatricula 		= Trim(Request("txtMatricula"))
	strNomealuno 		= Trim(Request("txtNomealuno"))
	strSimouNao         = Trim(Request.Form("cmbSimouNao"))
	strOpcaoRelatorio	= Trim(Request.Form("optOpcao"))
    if Trim(Request.Form("optOpcao")) = "" then strOpcaoRelatorio = "0"
	
    if strSimouNao <> "S" and strSimouNao <> "N" then
	   strSimouNao      = "N"
	end if   
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

	'VERIFICAÇÃO DE BLOQUEIO
	intCodAluno = strCodAluno
	%>
	<!--#include file="../includes/inc_VerificaBloqueio.asp"-->
	<%			

	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intCodCurso	 		= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodTurno		 	= Trim(Request.Form("cmbTurno"))
	intCodSituacaoAluno		= Trim(Request.Form("cmbSituacaoAluno"))
	if intCodSituacaoAluno = "" then intCodSituacaoAluno = 0

	if trim(intCodTurma) <> "" then
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
	
	strFiltroSerie 			= "0"
	strFiltroTurno 			= "0"

	if intCodCurso 		= "" then intCodCurso 		= "0"
	if intCodSerie 		= "" then intCodSerie 		= "0"
	if intCodTurno 		= "" then intCodTurno 		= "0"
	if intCodTurma 		= "" then intCodTurma 		= "0"

	strMostraAlunos = ""
	if 	intCodCurso <> "0" then strMostraAlunos = "S"
	if 	intCodSerie <> "0" then strMostraAlunos = "S"
	if 	intCodTurno <> "0" then strMostraAlunos = "S"
	if 	intCodTurma <> "0" then strMostraAlunos = "S"


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
      <td width="17%" height="12">&nbsp;</td>
      <td width="83%" colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">Op&ccedil;&otilde;es de Impress&atilde;o </td>
      <td class="texto1"><strong>
        <input <% if strOpcaoRelatorio = "0" then response.Write("checked")%> name="optOpcao" type="radio" value="0">
        Matr&iacute;cula&nbsp;&nbsp;&nbsp;&nbsp; <br>
          <input <% if strOpcaoRelatorio = "1" then response.Write("checked")%> name="optOpcao" type="radio" value="1">
        Pr&eacute;-Matr&iacute;cula <br>
        <input <% if strOpcaoRelatorio = "2" then response.Write("checked")%> name="optOpcao" type="radio" value="2">
        Requerimento em Branco  </strong>
          
        </td>
    </tr>
    <tr>
      <td class="texto1">&nbsp;</td>
      <td class="texto1">&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">Ano Letivo: </td>
      <td class="texto1"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
    </tr>
    <tr>
      <td class="texto1">Semestre:</td>
      <td class="texto1"><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
    </tr>
    <tr> 
      <td class="texto1">Curso:</td>
      <td class="texto1"><!--#include file="../includes/inc_cmdCurso.asp"--></td>
    </tr>
    <tr> 
      <td class="texto1">Per&iacute;odo:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdPeriodo.asp"--></td>
    </tr>
    
    <tr> 
      <td class="texto1">Turno:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdTurno.asp"--></td>
    </tr>
    
    <tr> 
      <td class="texto1">Turma:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdTurma.asp"--></td>
    </tr>
    <tr>
      <td class="texto1">Situa&ccedil;&atilde;o:</td>
      <td colspan="2"><!--#include file="../includes/inc_cmdSituacaoAluno.asp"--></td>
    </tr>
    <tr> 
      <td class="texto1">Promover S&eacute;rie/Per&iacute;odo?</td>
 	  <td colspan="2"><!--#include file="../includes/inc_cmbSimouNao.asp"--></td>
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
			if strMostraAlunos = "S" and strMatricula = "" then%> 
			
			<table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
          <tr bgcolor="#CCCCCC" class="CabecalhoConsulta"> 
            <td width="32" align="center" class="celula"><input type="checkbox" name="chkTodos" onClick="return MarcaTodos(this.checked)"></td>
            <td width="125" class="celula"><strong>Matr&iacute;cula</strong></td>
            <td width="443" class="celula"><strong>Nome</strong></td>
            <td width="499" class="celula"><strong>Data de Nascimento </strong></td>
            <td width="89" align="center" class="celula"><strong>Disciplinas</strong></td>
          </tr>
          <%					
			sql = "SELECT     SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MAE , SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.DESCRICAO AS CURSO, SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma"
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
			if intCodSituacaoAluno <> "0" then
				sql = sql & " And SCA_ALUNO.COD_SITUACAOALUNO = " & intCodSituacaoAluno
			end if
			sql = sql & " Order By SCA_TURMA.COD_TURMA, SCA_ALUNO.NOMEALUNO"
			rs.open sql, cnn
			if rs.eof = false then
				while not rs.eof
					strCodigoAluno        = rs("codigo")
					strMatricula		  = rs("MATRICULA")
					%>
          <tr>
            <td class="celula" align="center"><input type="checkbox" id="chkAluno" name="chkAluno" <%=strDesabilitaAluno%> value="<%=rs("codigo")%>"></td>
            <td class="celula"><%=strMatricula%></td>
            <td class="celula"><%=rs("NOMEALUNO")%></td>
            <td class="celula"><%=FORMATADATAAP(rs("DATANASCIMENTO"))%></td>
            <td align="center" class="celula"><img style="cursor:hand" onClick="return Descricao('<%=rs("codigo")%>')" id="imgDescricao<%=rs("codigo")%>" src="../../images/down.jpg"></td>
          </tr>
           <tr id="mostraDescricao<%=rs("codigo")%>" style="display:none">
            <td height="38" colspan="5" align="center" class="celula">
			<br>
              <table width="91%" border="0" cellspacing="0" cellpadding="0" align="center" class="tabela" >
                <tr bgcolor="#EBEBEB">
                  <td colspan="11" align="center" class="celula"><strong>Disciplinas</strong></td>
                  </tr>
                <tr bgcolor="#EBEBEB">
                  <td width="60" align="center" class="celula"><strong>
                    <input name="chkTodosRecibos" type="checkbox" value="" onClick="return marcaTodasDisciplinas()">
                  </strong></td>
                  <td width="215" align="center" class="celula"><strong>Cod. Disciplina  </strong></td>
                  <td width="385" align="center" class="celula"><strong>Nome</strong></td>
                  <td width="428" align="center" class="celula"><strong>Turma</strong></td>
                </tr>
                <%
			  	cont = 0
				sql = " select ad.codigo, d.desc_disciplina, t.cod_semestre, t.AnoLetivo, t.nometurma, ad.cod_disciplina, ad.situacao"
				sql = sql & " from sca_aluno_disciplina ad"
				sql = sql & " inner join sca_disciplina d on d.cod_disciplina = ad.cod_disciplina "
				sql = sql & " 	and d.cod_empresa = ad.cod_empresa"
				sql = sql & " inner join sca_turma t on t.cod_turma = ad.cod_turma"
				sql = sql & " 	and t.cod_empresa = ad.cod_empresa"
				sql = sql & " where		ad.cod_aluno = " & strCodigoAluno
				sql = sql & " order by d.desc_disciplina"
				rsAux.open sql, cnn	
						
				IF NOT rsAux.EOF THEN
					 WHILE NOT rsAux.EOF
						
						%>
                        <tr bgcolor="#FFFFFF">
                        <td class="celula" align="center"><input  <%=strdesabilitaRecibo%> type="checkbox" name="chkdisciplina" value="<%=rsAux("codigo")%>" ></td>
                        <td height="24" class="celula"><%=rsAux("codigo")%></td>
                        <td class="celula"><%=UCASE(rsAux("DESC_Disciplina"))%></td>
                        <td class="celula"><%=rsAux("nometurma")%></td>
                       </tr>
                		<%
						 cont = cont + 1
						rsAux.movenext
				wend 
			end if			
			rsAux.close
			%>
              </table>
              <p>&nbsp;</p></td>
            </tr>
          <%
						rs.movenext
					wend
				else
					%>
					  <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"> 
						<td colspan="5" align="center" class="celula"><%=session("strMensagemRelatorioNaoEncontrado")%></td>
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