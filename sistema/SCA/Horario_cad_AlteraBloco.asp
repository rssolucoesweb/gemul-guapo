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
<script src="../../js/js_funcoes_gerais.js"></script>
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
		
		if (acao != "D"){
			
			if (frm.cmbSemestre.value == "0") {
				alert("O Semestre deve ser informado !");
				frm.cmbSemestre.focus();
				return false;
			}
	
			if (frm.txtDescricao.value == "") {
				alert("O horario deve ser informada !");
				frm.txtDescricao.focus();
				return false;
			}
			
			if (frm.cmbSequenciaAula.value == "0") {
				alert("A Sequência de ordem do Horário deve ser informada !");
				frm.cmbSequenciaAula.focus();
				return false;
			}
			
			if (frm.cmbTempoAula.value == 0){
				alert("Tempo de Aula deve ser informado.");
				frm.cmbTempoAula.focus();
			return false;
			}
		
		}

		frm.action="Horario_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}
</script>
<%
	strPaginaTitulo = "Horario_cad.asp"
	strExecutarSubmitSemestre = "S"
	intSemestre 			= request("cmbSemestre")
	if trim(request("txtAnoLetivo")) = "" then 
		strAnoLetivo = session("strAnoLetivo")
	else
		strAnoLetivo = request("txtAnoLetivo")
	end if

	intCodHorario 		= Trim(Request.Form("txtCodigo"))
	strDescricao 		= Trim(Request.Form("txtDescricao"))
    strNumeroAula       = request("txtNumeroAula")
    strHoraRelogio      = request("txtHoraRelogio")
	intCodSequenciaAula	= Trim(Request.Form("cmbSequenciaAula"))
	intCodTempoAula		= Trim(Request.Form("cmbTempoAula"))

		
	if trim(intCodHorario) <> "" then
	
		sql = "SELECT codigo, horario, anoletivo, semestre, numero_aula, hora_relogio, Sequencia_Aulas, Tempo"
		sql = sql & " FROM SCA_horario"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
		sql = sql & " and codigo = " & intCodHorario
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodHorario	 		= rs("codigo")
			strAnoLetivo	 		= rs("anoletivo")
			intSemestre			    = rs("semestre")
			strDescricao			= rs("horario")
			strNumeroAula			= rs("numero_aula")
			strHoraRelogio			= rs("hora_relogio")
			intCodSequenciaAula		= rs("Sequencia_Aulas")
			intCodTempoAula			= rs("Tempo")
			
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
%><form id="frm" method="post">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table border="0" width="98%" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td height="36" colspan="2" align="center">
		
		  <table border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
          </table>
		  <br>
		 <table width="98%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td class="texto1">Ano Letivo:</td>
            <td><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
          </tr>
          <tr>
            <td class="texto1">Semestre:</td>
            <td><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
          </tr>
          <tr>
            <td width="90" class="texto1">Hor&aacute;rio:</td>
            <td width="613"><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodHorario%>" maxlength="10">
                <input name="txtDescricao" type="text" class="text" id="txtDescricao" size="40" maxlength="40" value="<%=strDescricao%>"></td>
          </tr>
          <tr>
            <td class="texto1">Sequ&ecirc;ncia:</td>
            <td class="texto1"><!--#include file="../includes/inc_cmdSequenciaAula.asp"--></td>
          </tr>
          <tr>
            <td class="texto1">Tempo: </td>
            <td class="texto1">
            <select name="cmbTempoAula" id="cmbTempoAula" class="combo" style="width:150pt">
              <option value="0">Selecione...</option>
              <option <%if intCodTempoAula="1" then response.Write("selected") %> value="1">1&deg; tempo (Antes do intervalo)</option>
              <option <%if intCodTempoAula="2" then response.Write("selected") %> value="2">2&deg; tempo (Depois do intervalo)</option>
            </select></td>
          </tr>
          <tr>
            <td class="texto1">Total Aulas: </td>
            <td class="texto1"><input  name="txtNumeroAula" type="text" class="text" id="txtNumeroAula" value="<%=strNumeroAula%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
          </tr>
          <tr>
            <td class="texto1">Total Minutos: </td>
            <td class="texto1"><input  name="txtHoraRelogio" type="text" class="text" id="txtHoraRelogio"  value="<%=strHoraRelogio%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
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
            <td colspan="2">
			<table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
			<%
			cont =0
			if intSemestre = "" then intSemestre = session("strSemestre")
			
			sql = "SELECT * FROM SCA_HORARIO"
			sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
			sql = sql & " and ANOletivo = " & strAnoLetivo		
			sql = sql & " and semestre in (" & intSemestre & ")"
			sql = sql & " Order by AnoLetivo, semestre, horario"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
                
                  <tr bgcolor="#E5E5E5">
                    <td width="8%" class="celula"><strong>Ano Letivo  </strong></td>
                    <td width="9%" class="celula"><strong><strong>Semestre</strong> </strong></td>
                    <td width="9%" class="celula"><strong><strong>Sequência</strong> </strong></td>
                   <td width="39%" height="21" class="celula"><strong>Hor&aacute;rio<span class="TextoForm"></span></strong></td>
                    <td width="13%" class="celula"><strong>Total de Aulas </strong></td>
                    <td width="10%" class="celula"><strong>Total de Minutos </strong></td>
                    <td width="12%" class="celula"><strong>Tempo </strong></td>
                  </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					%>
                  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("codigo")%>')">
                    <td class="celula">&nbsp;<%=rs("anoletivo")%></td>
                    <td class="celula">&nbsp;<%=rs("semestre")%></td>
                    <td class="celula">&nbsp;<%=rs("Sequencia_Aulas")%></td>
                    <td height="20" class="celula">&nbsp;<%=trim(rs("horario"))%></td>
                    <td height="20" class="celula">&nbsp;<%=rs("numero_aula")%></td>
                    <td class="celula"><%=rs("hora_relogio")%></td>
                    <td height="20" class="celula">&nbsp;<%=rs("Tempo")%>&deg; Tempo</td>
                  </tr>

                  <%				
					rs.movenext
					wend

              else
				  if intSemestre <> "" and intSemestre <> "0" then
					  %>
							<tr>
							<td height="30" colspan="7" align="center" class="celula">ATEN&Ccedil;&Atilde;O: Não existe Faixa de Hor&aacute;rio para ano e semestre informado, deseja copiar dados do ano anterior 
							  <input type="button" name="cmdSim" style="cursor:hand"   value="Sim" class="botao" onClick="return salvar('D')"></td>
							</tr>
						  <tr>
							<td height="21" colspan="5" class="celula">Total Registros : <%=cont%></td>
						  </table>
					  
					  <%
				   end if		  
			  end if
			  rs.close%></td>
          </tr>
        </table>
		
		</td>
      </tr>
      <tr valign="top">
        <td height="18" colspan="2" align="center">&nbsp;</td>
      </tr>
    </table>
	</td>
  </tr>
</table></form>
<!--#include file="../rodape.asp"-->
</body>
</html>