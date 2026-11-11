<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 25/03/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Vincula aluno ao estagio
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
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
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (acao=='E'){
		
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
			
			if (frm.cmbCurso.value == 0){
				alert("O Curso deve ser informado!");
				frm.cmbCurso.focus();
				return false;
			}		
			
			if (frm.cmbEstagio.value == 0){
				alert("O Estagio deve ser informado!");
				frm.cmbEstagio.focus();
				return false;
			}
			
			var men = 'ATENÇÃO: Deseja realmente excluir este Vinculo de Estagio?\n '
			if (confirm(men)) {
			
				frm.action= "Estagio_Vincula_Aluno_cod.asp?acao=" + acao;
				frm.submit();
				return true;
			} else {
				return false;
			}
		}
		else
		{
			
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
			
			if (frm.cmbCurso.value == 0){
				alert("O Curso deve ser informado!");
				frm.cmbCurso.focus();
				return false;
			}		
			
			if (frm.cmbEstagio.value == 0){
				alert("O Estagio  Projeto Social deve ser informado!");
				frm.cmbEstagio.focus();
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
			
			frm.action= "Estagio_Vincula_Aluno_cod.asp?acao=" + acao;
			frm.submit();
			return true;
			
		}	
	}
</script>
<%
	strPaginaTitulo = "Estagio_Vincula_Aluno_cad.asp"

	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intAno		 			= Trim(Request.Form("txtAno"))
	intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	intCodEstagio		 	= Trim(Request.Form("cmbEstagio"))
	
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")

	if intCodCurso = "" then intCodCurso = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	
	if intCodCurso <> "0" then
	
		sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
		sql = sql & " FROM SCA_TURMA "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
		SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
		sql = sql & " AND SCA_PERIODO.Cod_Curso = " & intCodCurso
		RS.OPEN SQL, CNN
		IF not RS.EOF THEN
			intCodPeriodo 	= rs("cod_periodo")
			intCodTurno 	= rs("cod_turno")
			intSemestre 	= rs("cod_Semestre")
		END IF
		rs.close
	
		sql = "SELECT Cod_aluno "
		sql = sql & " FROM SCA_ESTAGIO_VINCULO EV"
		sql = sql & " INNER JOIN SCA_TURMA T ON T.Cod_Turma = EV.codTurma "
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR GR ON T.Cod_GradeCurricular = GR.Cod_GradeCurricular "
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.Cod_Periodo = GR.Cod_Periodo "
		sql = sql & " WHERE 1=1 "
		sql = sql & " AND P.Cod_Curso = " & intCodCurso
		rs.open sql, cnn
	
		if rs.eof = false then
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
		else
			strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		end if
		rs.close
	
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
%>
<table width="100%" height="355" border="0" bgcolor="#FFFFFF"  cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="100%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post">
		  <table width="98%" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="700" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  <table width="98%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="16%" class="texto1">Ano Letivo:</td>
            <td width="88%"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">           </td>
          </tr>
          <tr>
            <td height="19" class="texto1">Semestre:</td>
            <td><!--#include file="../includes/inc_cmdSemestre.asp" -->            </td>
          </tr>
         <tr>
          <td width="16%" class="texto1">Curso:</td>
          <td colspan="2"><span class="texto1"><!--#include file="../includes/inc_cmdCurso.asp"--></span></td>
        </tr>
          
          <tr>
            <td class="texto1">Estagio: </td>
            <td><!--#include file="../includes/inc_cmdEstagio.asp"--></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><br>
            <%
			if intCodCurso = "" then intCodCurso = "0"

			if intCodCurso<>"0" then%>
              <table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
                <tr class="CabecalhoConsulta">
                <td width="36" align="center" class="celula"><input type="checkbox" name="chkTodos" onClick="return MarcaTodos(this.checked)"></td>
                <td width="133" class="celula"><strong>Matr&iacute;cula</strong></td>
                <td width="470" class="celula"><strong>Nome</strong></td>
                <td width="300" class="celula"><strong>Turma</strong></td>
                <td width="300" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
                </tr>
                <%					
				sql = "SELECT DISTINCT SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MAE , SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.DESCRICAO AS CURSO, SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma, SCA_SITUACAOALUNO.DESC_SITUACAOALUNO"
				sql = sql & " FROM SCA_ALUNO_TURMA "
				sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
				sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
				sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa"
                sql = sql & " INNER JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.Cod_SituacaoAluno and SCA_SITUACAOALUNO.cod_empresa = SCA_ALUNO.cod_empresa"				
				sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa"
				sql = sql & " where SCA_TURMA.cod_empresa = " & session("CodEmpresa")
				if trim(strAnoLetivo) = trim(session("strAnoLetivo")) and trim(strSemestre) =  trim(session("strSemestre")) then
				  sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
				end if	
				sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
				sql = sql & " and 	SCA_ALUNO_TURMA.Semestre IN (" & intSemestre & ")"
				if intCodCurso <> "0" then
					sql = sql & " and SCA_CURSO.Cod_Curso = " & intCodCurso
				end if
				sql = sql & " Order By SCA_TURMA.COD_TURMA, SCA_ALUNO.NOMEALUNO"
				rs.open sql, cnn
				
				if rs.eof = false then
				
				while not rs.eof
					strMarca  				= ""
					strCodigoAluno        	= rs("codigo")
					strMatricula		  	= rs("MATRICULA")
												
			   
					sql = "SELECT cod_aluno "
					sql = sql & " FROM SCA_ESTAGIO_VINCULO"
					sql = sql & " WHERE Cod_aluno = " & strCodigoAluno
					sql = sql & " and CodEstagio = " & intCodEstagio
					sql = sql & " and cod_empresa = " & session("CodEmpresa")

					RsAux.open sql, cnn
			
					if RsAux.eof = false then
						strMarca = "checked"
					end if
					RsAux.close
					%>
                	<tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
                 		<td class="celula" align="center"><input type="checkbox" id="chkAluno" name="chkAluno" <%=strMarca%> value="<%=rs("codigo")%>"></td>
                   <td class="celula">&nbsp;<%=strMatricula%></td>
                    <td class="celula"><%=rs("NOMEALUNO")%>&nbsp;</td>
                    <td class="celula"><%=rs("NOMETURMA")%>&nbsp;</td>
                    <td class="celula"><%=rs("DESC_SITUACAOALUNO")%>&nbsp;</td>
                  	</tr>
                	<%
						rs.movenext
					wend
				else
				%>
                <tr onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
                <td colspan="4" align="center" class="celula">&nbsp;<%=session("strMensagemRelatorioNaoEncontrado")%></td>
                </tr>
                <%
				end if
				rs.close
			end if
			%>
              </table>
              <br></td>
          </tr>
        </table>
		</form>
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
<!--#include file="../rodape.asp"-->
</body>
</html>