<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/01/2009
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Vincula a Rota ao Aluno
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css"></head>
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
	
	function Excluir(acao, CodAluno){
		
		var frm = document.getElementById("frm");
		var men = 'ATENÇÃO: Deseja realmente excluir este Vinculo do Projeto Social?\n '
		if (confirm(men)) {
				
			frm.action="ProjetoSociais_Vincula_Aluno_cod.asp?acao=" + acao + "&CodAluno=" + CodAluno ;
			frm.submit();
			return true;

		} else {
			return false;
		}
	}

	
	function salvar(acao){
		
		var form = window.document.forms[0];
		var frm = document.getElementById("frm");
		
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
		
		if (frm.cmbProjetoSociais.value == 0){
			alert("A Projeto Social deve ser informado!");
			frm.cmbProjetoSociais.focus();
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
		
		frm.action= "ProjetoSociais_Vincula_Aluno_cod.asp?acao=" + acao;
		frm.submit();
		return true;
			
	}
</script>
<%

	strPaginaTitulo 		  = "ProjetoSociais_Vincula_Aluno_cad.asp"
	strPagina				  = "ProjetoSociais_Vincula_Aluno_cad.asp"
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"
	strExecutarSubmitTurno	  = "S"
	strExecutarSubmitTurma	  = "S"
	
	intCodTurma 			= Trim(Request.Form("cmbTurma"))
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intAno		 			= Trim(Request.Form("txtAno"))
	intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	intCodProjetoSociais 	= Trim(Request.Form("cmbProjetoSociais"))
	
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")

	if intCodTurma = "" then intCodTurma = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	
	if intCodTurma <> "0" then
	
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
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	
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
              <td align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  <table width="98%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="143" class="texto1">Ano Letivo:</td>
            <td width="815"><span class="texto1">
              <input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
            </span></td>
          </tr>
          <tr>
            <td height="25" class="texto1">Semestre:</td>
            <td><span class="texto1">
              <!--#include file="../includes/inc_cmdSemestre.asp" -->
            </span></td>
          </tr>
          <tr>
            <td height="30" class="texto1">Turma : </td>
            <td><!--#include file="../includes/inc_cmdTurma.asp"--></td>
          </tr>
          <tr>
            <td class="texto1">Projetos Sociais: </td>
            <td><!--#include file="../includes/inc_cmdProjetoSociais.asp"--></td>
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
'atualiza automatico os aluno de bolsa familia
if (UCASE(strProjetoSociais) = "BOLSA FAMILIA" OR UCASE(strProjetoSociais) = "BOLSA FAMÍLIA") and intCodTurma<>"0" and intCodProjetoSociais<>"0" then

	sql = " Delete From SCA_PROJETOSOCIAIS_VINCULO"
	sql = sql & " Where CodProjetoSociais = " & intCodProjetoSociais
	sql = sql & " and ano_letivo = " & strAnoLetivo
	sql = sql & " and codTurma = " & intCodTurma
	sql = sql & " and semestre = " & intSemestre
	sql = sql & " and cod_empresa = " & Session("CodEmpresa")
	cnn.execute sql
	
	sql = "SELECT distinct SCA_ALUNO.CODIGO,SCA_ALUNO.bolsa_Familia"
	sql = sql & " FROM SCA_ALUNO_TURMA "
	sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
	sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa"
	sql = sql & " INNER JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.Cod_SituacaoAluno and SCA_SITUACAOALUNO.cod_empresa = SCA_ALUNO.cod_empresa"				
	sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa"
	sql = sql & " where SCA_TURMA.cod_empresa = " & session("CodEmpresa")
	sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
	sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
	sql = sql & " and 	SCA_ALUNO_TURMA.Semestre IN (" & intSemestre & ")"
	sql = sql & " and SCA_ALUNO_TURMA.COD_TURMA = " & intCodTurma
	sql = sql & " and SCA_SITUACAOALUNO.DESC_SITUACAOALUNO = 'ATIVO'"
	rs.open sql, cnn
	if rs.eof = false then
		while not rs.eof
		
			strCodAluno			= rs("CODIGO")
			strBeneficio		= rs("bolsa_Familia")
			if isnull(strBeneficio) then strBeneficio = ""
			
			if strBeneficio <> "" then
				sql = " Insert into SCA_PROJETOSOCIAIS_VINCULO (cod_empresa, cod_aluno, codTurma, ano_letivo, semestre, CodProjetoSociais, DataVinculo, NumeroBeneficio)"
				sql = sql & " VALUES ("
				sql = sql & " " & session("CodEmpresa") & ","
				sql = sql & " " & strCodAluno & ","
				sql = sql & " " & intCodTurma & ","
				sql = sql & " " & strAnoLetivo & ","
				sql = sql & " " & intSemestre & ","
				sql = sql & " " & intCodProjetoSociais & ","
				sql = sql & " getdate(),"
				sql = sql & " '" & strBeneficio & "')"
				
				cnn.execute sql
			end if
			rs.movenext
		wend
	end if
	rs.close
end if
			  
			if intCodTurma    = "" then intCodTurma="0"
			if intCodPeriodo = "" then intCodPeriodo="0"
			classCampo = "text"
			if intCodTurma<>"0" then%>
              <table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
                <tr class="CabecalhoConsulta">
                <td width="31" align="center" class="celula"><input type="checkbox" name="chkTodos" onClick="return MarcaTodos(this.checked)"></td>
                <td width="115" class="celula"><strong>Matr&iacute;cula</strong></td>
                <td width="389" class="celula"><strong>Nome</strong></td>
                <td width="248" class="celula"><strong>Turma</strong></td>
                <td width="240" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
                <td width="182" class="celula"><strong>N&uacute;mero do Benef&iacute;cio</strong></td>
                <td width="77" align="center" class="celula"><strong>A&ccedil;&atilde;o</strong></td>
                </tr>
                <%					
				sql = "SELECT  SCA_ALUNO.CODIGO, SCA_ALUNO.MATRICULA, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.DATANASCIMENTO, SCA_ALUNO.MAE ,SCA_ALUNO.bolsa_Familia , SCA_PERIODO.DESCRICAO AS PERIODO, SCA_CURSO.DESCRICAO AS CURSO, SCA_TURMA.COD_TURMA, SCA_TURMA.NomeTurma, SCA_SITUACAOALUNO.DESC_SITUACAOALUNO"
				sql = sql & " FROM SCA_ALUNO_TURMA "
				sql = sql & " INNER JOIN SCA_ALUNO ON SCA_ALUNO_TURMA.COD_ALUNO = SCA_ALUNO.CODIGO "
				sql = sql & " INNER JOIN SCA_TURMA ON SCA_ALUNO_TURMA.COD_TURMA = SCA_TURMA.Cod_Turma  AND SCA_ALUNO_TURMA.ANO_LETIVO = SCA_TURMA.AnoLetivo AND SCA_ALUNO_TURMA.SEMESTRE = SCA_TURMA.Cod_Semestre AND SCA_ALUNO_TURMA.cod_empresa = SCA_TURMA.cod_empresa "
				sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular"
				sql = sql & " INNER JOIN SCA_PERIODO ON SCA_PERIODO.Cod_Periodo = SCA_GRADECURRICULAR.Cod_Periodo and SCA_PERIODO.cod_empresa = SCA_GRADECURRICULAR.cod_empresa"
                sql = sql & " INNER JOIN SCA_SITUACAOALUNO ON SCA_SITUACAOALUNO.Cod_SituacaoAluno = SCA_ALUNO.Cod_SituacaoAluno and SCA_SITUACAOALUNO.cod_empresa = SCA_ALUNO.cod_empresa"				
				sql = sql & " INNER JOIN SCA_CURSO ON SCA_CURSO.Cod_Curso = SCA_PERIODO.Cod_Curso and SCA_CURSO.cod_empresa = SCA_PERIODO.cod_empresa"
				sql = sql & " where SCA_TURMA.cod_empresa = " & session("CodEmpresa")
				sql = sql & " and 	SCA_ALUNO_TURMA.situacao = 'A'"
				sql = sql & " and 	SCA_ALUNO_TURMA.Ano_Letivo = " & strAnoLetivo
				sql = sql & " and 	SCA_ALUNO_TURMA.Semestre IN (" & intSemestre & ")"
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
				sql = sql & " and SCA_SITUACAOALUNO.DESC_SITUACAOALUNO = 'ATIVO'"
				sql = sql & " Order By SCA_TURMA.COD_TURMA, SCA_ALUNO.NOMEALUNO"
				rs.open sql, cnn
				
				if rs.eof = false then
				
				while not rs.eof
					strMarca  				= ""
					strBeneficio			= ""
					strCodigoAluno        	= rs("codigo")
					strMatricula		  	= rs("MATRICULA")
					if UCASE(strProjetoSociais) = "BOLSA FAMILIA" OR UCASE(strProjetoSociais) = "BOLSA FAMÍLIA" then
						bloq = " readonly "
						classCampo = "textDisabled"
						if not isnull(rs("bolsa_Familia")) then
							strBeneficio = rs("bolsa_Familia")
							strMarca = "checked"
						end if
					else
						sql = "SELECT cod_aluno, NumeroBeneficio "
						sql = sql & " FROM SCA_PROJETOSOCIAIS_VINCULO"
						sql = sql & " WHERE cod_aluno = " & strCodigoAluno
						sql = sql & " and CodProjetoSociais = " & intCodProjetoSociais
						sql = sql & " and cod_empresa = " & session("CodEmpresa")
						RsAux.open sql, cnn
						 
						if RsAux.eof = false then
							strMarca = "checked"
							strBeneficio = RsAux("NumeroBeneficio")
						end if
						RsAux.close
					end if
					%>
                	<tr>
                 		<td class="celula" align="center"><input type="checkbox" id="chkAluno" name="chkAluno" <%=strMarca%> value="<%=rs("codigo")%>"></td>
                   <td class="celula">&nbsp;<%=strMatricula%></td>
                    <td class="celula"><%=rs("NOMEALUNO")%>&nbsp;</td>
                    <td class="celula"><%=rs("NOMETURMA")%>&nbsp;</td>
                    <td class="celula"><%=rs("DESC_SITUACAOALUNO")%></td>
                    <td class="celula"><span class="texto1">
                     <input  name="txtBeneficio<%=strCodigoAluno%>" type="text" class="<%=classCampo%>" id="txtBeneficio<%=strCodigoAluno%>" value="<%=strBeneficio%>" onKeyPress="return formataCampo(this, 2, 20)" size="20" maxlength="20" <%=bloq%>>
                    </span></td>
                  	<td align="center" class="celula"><a href="#" onClick="Excluir('E','<%=strCodigoAluno%>')" ><img src="../../images/botao_vermelho_normal.gif" alt="Excluir Vinculo" width="26" height="26" border="0"></a></td>
                	</tr>
                	<%
						rs.movenext
					wend
				else
				%>
                <tr>
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