<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/07/2008
	::	Desenvolvedores...: Sergio Borges - Sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de horario 
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_g<strong></strong>erais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script>
	function resultadoConsulta(intCodigo){
	
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if (frm.txtDescricao.value == "" && frm.cmbMes.value == "0" ) {
			alert("O Conteúdo deve ser informado !");
			frm.txtDescricao.focus();
			return false;
		}
		
		if (frm.txtDataInicial.value == "") {
			alert("A Data Inicial deve ser informada !");
			frm.txtData.focus();
			return false;
		}

		if (frm.txtDataFinal.value == "") {
			alert("A Data Final deve ser informada !");
			frm.txtData.focus();
			return false;
		}

		if (frm.txtDataFinal.value <  frm.txtDataInicial.value) {
			alert("Verifique a Data informada !");
			frm.txtData.focus();
			return false;
		}
		
		if (frm.cmbTurmaProfessor.value == "0" ) {
			alert("A Turma deve ser Informada !");
			frm.txtDescricao.focus();
			return false;
		}

		if (frm.cmbDisciplinaDoProfessor.value == "0" ) {
			alert("A Disciplina deve ser Informada !");
			frm.txtDescricao.focus();
			return false;
		}

		frm.action="ConteudoProfessor_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	strExecutarSubmitSemestre 				= "S"
	strExecutarSubmitTurma					 = "S"
	strExecutarSubmitDisciplinaDoProfessor   = "S"
	strSemestre 		      = session("strSemestre")
    intSemestre 		      = session("strSemestre")
	
	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and cod_empresa = " & Session("CodEmpresa")
	sql = sql & " and CodCategoria = 1"'professor
	sql = sql & " and Situacao = 'A'"'ativo
	rs.open sql, cnn
	if rs.eof then
		rs.close
		%>
		<script>
			alert("ATENÇÃO: \n\nAcesso não autorizado, ou usuário não pertence a categoria de professores.");
			window.history.back();
		</script>
		<%	
		response.End()
	else
		intCodColaboradorProfessor = rs("codigo")
	    intCodProfessor 	       = rs("codigo")
	end if
	rs.close
	
	strPaginaTitulo         = "ConteudoProfessor_cad.asp"
	
	intCodTurmaProfessor 	    = Trim(Request("cmbTurmaProfessor"))
	intCodCurso	 			= Trim(Request("cmbCurso"))
	intCodPeriodo 			= Trim(Request("cmbPeriodo"))
	intCodGrade				= Trim(Request("cmbGrade"))

	intCodTurno		 		= Trim(Request("cmbTurno"))
	intCodPlanoPagamento	= Trim(Request("cmbPlanoPagamento"))
	strSala		 			= Trim(Request("txtSala"))
	intCodDisciplina        = trim(request("cmbDisciplinaDoProfessor"))
	strDataInicial          = formatadataAP(date)'Trim(Request("txtData"))
	strDataFinal            = formatadataAP(date)'Trim(Request("txtData"))
    strMes		 	        = Trim(Request("cmbMes"))

	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodTurmaProfessor = "" then intCodTurmaProfessor = "0"
	if intCodSemestre = "" then intCodSemestre = "0"
	if intCodTipoLancamento = "" then intCodTipoLancamento = "0"
	if intCodDisciplina= "" then intCodDisciplina = "0"

	sql = "SELECT SCA_TURMA.cod_turma, SCA_TURMA.cod_Semestre , SCA_PERIODO.Cod_Curso, SCA_PERIODO.Cod_Periodo, SCA_TURMA.cod_turno, SCA_TURMA.Sala, SCA_TURMA.NomeTurma"
	sql = sql & " FROM SCA_TURMA "
	sql = sql & " INNER JOIN SCA_GRADECURRICULAR ON SCA_TURMA.Cod_GradeCurricular = SCA_GRADECURRICULAR.Cod_GradeCurricular "
	sql = sql & " INNER JOIN SCA_PERIODO ON SCA_GRADECURRICULAR.Cod_Periodo = SCA_PERIODO.Cod_Periodo"
	SQL = SQL & " WHERE SCA_TURMA.cod_empresa=" & Session("CodEmpresa")
	sql = sql & " AND SCA_TURMA.Cod_Turma= " & intCodTurmaProfessor
	RS.OPEN SQL, CNN
	IF not RS.EOF THEN
		intCodCurso 	= rs("cod_curso")
		intCodPeriodo = rs("cod_periodo")
		intCodTurno = rs("cod_turno")
		intSemestre = rs("cod_Semestre")
		strSemestre = rs("cod_Semestre")

	END IF
	rs.close
	
	intCodigo 		= Trim(Request.Form("txtCodigo"))
	strDescricao 	= Trim(Request.Form("txtDescricao"))
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT *"
		sql = sql & " FROM sca_conteudo"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodHorario	 		= rs("codigo")
			strDescricao			= rs("conteudo")
			strAnoLetivo	 		= rs("anoletivo")
			intSemestre				= rs("semestre")
			intCodTurmaProfessor	= rs("cod_turma")
			intCodDisciplina		= rs("cod_disciplina")
			strDataInicial          = rs("datainicial")
	        strDataFinal            = rs("datafinal")
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir

		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
	end if 
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="100%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post" action="conteudoProfessor_cad.asp">
		<input name="txtCodigo" value="<%=intCodigo%>" type="hidden">
		  <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
          
          <tr>
            <td class="texto1">Semestre:</td>
            <td><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
          </tr>
          <tr>
            <td class="texto1">Turma:</td>
            <td><!--#include file="../includes/inc_cmdTurmaProfessor.asp"--></td>
          </tr>
          <tr>
            <td class="texto1">Disciplina:</td>
            <td><!--#include file="../includes/inc_cmdDisciplinaDoProfessor.asp"--></td>
          </tr>
          <tr>
            <td width="184" class="texto1">Data/Per&iacute;odo:</td>
            <td width="1050"><span class="texto1">
             <input name="txtDataInicial" type="text" class="text" id="txtDataInicial" onBlur="return validaData(this); submit();" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataInicial%>">
&aacute;
<input name="txtDataFinal" type="text" class="text" id="txtDataFinal" onBlur="return validaData(this); submit();" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataFinal%>">
            </span></td>
          </tr>
          <tr>
            <td height="19"><span class="texto1">Enviar Programa&ccedil;&atilde;o Did&aacute;tica: </span></td>
            <td><!--#include file="../includes/inc_cmbMes.asp"--></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2" class="texto1" ><div align="center">ATEN&Ccedil;&Atilde;O! Caso seja informado o m&ecirc;s na op&ccedil;&atilde;o <strong>&lt; Enviar Programa&ccedil;&atilde;o Did&aacute;tica &gt;</strong>, o mesmo per&iacute;odo e a disciplina ser&aacute; Bloqueado confirmando o <strong>Envio</strong> a Secretaria. </div></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td class="texto1">Conte&uacute;do:              </td>
            <td class="texto1"><label> 
              <textarea class="text" cols="100" rows="4" name="txtDescricao"><%=strDescricao%></textarea>
			              
            </label></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr><tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
          <tr>
            <td colspan="2"><br>
<%
			cont =0
			if intSemestre = "" then intSemestre = session("strSemestre")
			sql = "SELECT c.*, t.nometurma, d.Desc_Disciplina"
			sql = sql & " FROM SCA_Conteudo c"
			sql = sql & " inner join sca_turma t on t.cod_turma = c.cod_turma and t.cod_empresa = c.cod_empresa"
			sql = sql & " inner join sca_disciplina d on d.Cod_Disciplina = c.Cod_Disciplina and d.cod_empresa = c.cod_empresa"
			sql = sql & " where c.cod_empresa = " & Session("CodEmpresa")			
			sql = sql & " and c.anoletivo = " & strAnoLetivo		
			sql = sql & " and c.semestre in (" & intSemestre & ")"
			sql = sql & " and c.cod_colaborador = " & intCodColaboradorProfessor
			if intCodDisciplina <> "0" then
			   sql = sql & " and c.Cod_Disciplina = " & intCodDisciplina
			end if   
			sql = sql & " Order by c.anoletivo, c.semestre, t.nometurma, d.Desc_Disciplina, c.datainicial desc"
			rs.open sql, cnn
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="8%" class="celula"><strong>Turma</strong></td>
                    <td width="17%" class="celula"><strong><strong>Disciplina</strong></strong></td>
                    <td width="21%" height="21" class="celula"><strong>Data<span class="TextoForm">/Per&iacute;odo</span></strong></td>
                    <td width="41%" class="celula"><strong>Conte&uacute;do</strong></td>
                    <td width="8%" class="celula"><strong>Status</strong></td>
                  </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					if trim(rs("Fechamento")) <> "S" then
					   %>
                       <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
                       <td class="celula"><%=rs("nometurma")%></td>
                       <td class="celula"><%=rs("Desc_Disciplina")%></td>
                       <td height="20" class="celula"><%=trim(formatadataAP(rs("datainicial")))%> &aacute; <%=trim(formatadataAP(rs("datafinal")))%></td>
                       <td height="20" class="celula"><%=trim(rs("conteudo"))%></td>
					   <%
				   	   if trim(rs("Fechamento")) = "S" then
					      %>
                          <td height="20" class="celula"><strong><font color='#FF0000'>Enviada</font></strong></td>
					      <%
					   else
					      %>
                          <td width="5%" height="20" class="celula"><strong>Edi&ccedil;&atilde;o</strong></td>
					      <%
					   end if 
					   %>  
                       </tr>
					   <%
					else
					   %>
                       <tr>
                       <td class="celula"><%=rs("nometurma")%></td>
                       <td class="celula"><%=rs("Desc_Disciplina")%></td>
                       <td height="20" class="celula"><%=trim(formatadataAP(rs("datainicial")))%> &aacute; <%=trim(formatadataAP(rs("datafinal")))%></td>
                       <td height="20" class="celula"><%=trim(rs("conteudo"))%></td>
					   <%
				   	   if trim(rs("Fechamento")) = "S" then
					      %>
                          <td height="20" class="celula"><strong><font color='#FF0000'>Enviada</font></strong></td>
					      <%
					   else
					      %>
                          <td height="20" class="celula"><strong>Edi&ccedil;&atilde;o</strong></td>
					      <%
					   end if 
					   %>  
                       </tr>
					   <%
					end if   
 					rs.movenext
					wend
				  %>
                  <tr>
                    <td height="21" colspan="4" class="celula">Total Registros : <%=cont%></td>
                  </table>
              <%
			  end if
			  rs.close%></td>
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