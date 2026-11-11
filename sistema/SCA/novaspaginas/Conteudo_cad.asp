<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 29/07/2008
	::	Desenvolvedores...: Sergio Borges - Sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de horario 
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
<script>
	function resultadoConsulta(intCodigo){
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}
	
	function salvar(acao){
		
		if (frm.txtData.value == "") {
			alert("O Data deve ser informada !");
			frm.txtData.focus();
			return false;
		}

		frm.action="Conteudo_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

</script>
<%
	strExecutarSubmitCurso	  				= "S"
	strExecutarSubmitPeriodo  				= "S"
	strExecutarSubmitSemestre 				= "S"
	strExecutarSubmitTurno	  				= "S"
	strExecutarSubmitProfessor				= "S"
	strExecutarSubmitTurma	  				= "S"
	strExecutarSubmitDisciplinaDoProfessor  = "S"
	strPaginaTitulo = "Conteudo_cad.asp"
	strExecutarSubmitSemestre = "S"
	strSemestre 		      = session("strSemestre")
	
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request.Form("txtAnoLetivo")
	end if

    intCodColaboradorProfessor 	= Trim(Request("cmbProfessor"))
	intCodProfessor 	        = Trim(Request("cmbProfessor"))
	intCodTurmaProfessor 	    = Trim(Request("cmbTurmaProfessor"))
	intCodCurso	 			    = Trim(Request("cmbCurso"))
	intCodPeriodo 			    = Trim(Request("cmbPeriodo"))
	intSemestre 			    = Trim(Request("cmbSemestre"))
	intCodGrade				    = Trim(Request("cmbGrade"))

	intCodTurno		 		    = Trim(Request("cmbTurno"))
	intCodPlanoPagamento	    = Trim(Request("cmbPlanoPagamento"))
	strSala		 			    = Trim(Request("txtSala"))
	intAno		 			    = Trim(Request("txtAno"))
	intAnoLetivo 			    = Trim(Request("txtAnoLetivo"))
	intCodDisciplina            = trim(request("cmbDisciplinaDoProfessor"))
	strData                     = formatadataAP(date)'Trim(Request("txtData"))
    strMes		 		        = Trim(Request("cmbMes"))


	strFiltroSerie = "0"
	strFiltroTurno = "0"

	if intCodComp = "" then intCodComp = "0"
	if intCodSerie = "" then intCodSerie = "0"
	if intCodTurno = "" then intCodTurno = "0"
	if intCodColaboradorProfessor = "" then intCodColaboradorProfessor = "0"
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
	END IF
	rs.close
	
	intCodigo 		    = Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
		
	if trim(intCodigo) <> "" then
	
		sql = "SELECT *"
		sql = sql & " FROM sca_conteudo"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodHorario	 		  = rs("codigo")
			strDescricao			  = rs("conteudo")
			strAnoLetivo	 		  = rs("anoletivo")
			intSemestre				  = rs("semestre")
			intCodColaboradorProfessor= rs("Cod_Colaborador")
			intCodTurmaProfessor	  = rs("cod_turma")
			intCodDisciplina		  = rs("cod_disciplina")
			strData					  = rs("data")
			strDesabilitaIncluir	  = "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	  = "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	  = "" 'Desabilita o botão Excluir

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
		<form id="frm" method="post" action="conteudo_cad.asp">
		<input name="txtCodigo" value="<%=intCodigo%>" type="hidden">
		  <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="texto1">Ano Letivo:</td>
            <td><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
          </tr>
          <tr>
            <td class="texto1">Semestre:</td>
            <td><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
          </tr>
          <tr>
            <td class="texto1">Professor:</td>
            <td><!--#include file="../includes/inc_cmdProfessor.asp" --></td>
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
            <td width="146" class="texto1">Data:</td>
            <td width="832"><input name="txtData" type="text" class="text" id="txtData" onBlur="return validaData(this); submit();" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strData%>"></td>
          </tr>
          <tr>
            <td><span class="texto1">Libera&ccedil;&atilde;o de envio: </span></td>
            <td><!--#include file="../includes/inc_cmbMes.asp"--></td>
          </tr>
          <tr>
            <td colspan="2"  class="texto1">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"  class="texto1"><div align="center">ATEN&Ccedil;&Atilde;O! Caso seja informado o m&ecirc;s na libera&ccedil;&atilde;o de envio, o mesmo per&iacute;odo e a disciplina ter&aacute; sua confirma&ccedil;&atilde;o de envio cancelada.</div></td>
          </tr>
          <tr>
            <td colspan="2"  class="texto1">&nbsp;</td>
          </tr>
          <tr>
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
			sql = sql & " and c.Cod_Disciplina = " & intCodDisciplina
			sql = sql & " and c.Fechamento = 'S' "
			sql = sql & " Order by c.anoletivo, c.semestre, c.data desc"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="18%" class="celula"><strong>Turma</strong></td>
                    <td width="22%" class="celula"><strong><strong>Disciplina</strong></strong></td>
                    <td width="15%" height="21" class="celula"><strong>Data<span class="TextoForm"></span></strong></td>
                    <td width="37%" class="celula"><strong>Conteudo</strong></td>
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
                       <td height="20" class="celula"><%=trim(formatadataAP(rs("data")))%></td>
                       <td height="20" class="celula"><%=trim(rs("conteudo"))%></td>
					   <%
				   	   if trim(rs("Fechamento")) = "S" then
					      %>
                          <td height="20" class="celula"><strong><font color='#FF0000'>Enviada</font></strong></td>
					      <%
					   else
					      %>
                          <td height="20" class="celula"><strong>Edicao</strong></td>
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
                       <td height="20" class="celula"><%=trim(formatadataAP(rs("data")))%></td>
                       <td height="20" class="celula"><%=trim(rs("conteudo"))%></td>
					   <%
				   	   if trim(rs("Fechamento")) = "S" then
					      %>
                          <td height="20" class="celula"><strong><font color='#FF0000'>Enviada</font></strong></td>
					      <%
					   else
					      %>
                          <td height="20" class="celula"><strong>Edicao</strong></td>
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
                    <td height="21" colspan="5" class="celula">Total Registros : <%=cont%></td>
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