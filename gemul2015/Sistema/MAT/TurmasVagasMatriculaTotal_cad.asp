<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 08/09/2007
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@gmail.com
	::	Objetivo Pagina...: Cadastro de Turma 
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
	
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){	
		var frm = document.getElementById("frm");
		
		frm.action="TurmasVagasMatriculaTotal_cod.asp?acao=" + acao;
		frm.submit();
		return true;
 	}

	function AtualizaPeriodico(){	
		var frm = document.getElementById("frm");
		
		frm.action="TurmasVagasMatriculaAtualizaTotal_cod.asp?acao2=PERIODICA";
		frm.submit();
		return true;
 	}
	
	function AtualizaInicial(){	
		var frm = document.getElementById("frm");
		if (frm.cmdEmpresaUsuario.value == "0") {
			alert("A Empresa deve ser informada!");
			frm.cmdEmpresaUsuario.focus();
			return false;
		}
		frm.action="TurmasVagasMatriculaAtualizaTotal_cod.asp?acao2=INICIAL";
		frm.submit();
		return true;
 	}
</script>
<%
	strExecutarSubmitCurso	  = "S"
	strExecutarSubmitPeriodo  = "S"
	strExecutarSubmitSemestre = "S"

	intCodEmpresaUsuario 	= Trim(Request("cmdEmpresaUsuario"))
	strAnoLetivo 			= Trim(Request("txtAnoLetivo")) 
	intSemestre 			= Trim(Request.Form("cmbSemestre"))
	intCodTurma 			= Trim(Request.Form("txtCodigo"))
	strNomeTurma 			= Trim(Request.Form("txtNomeTurma"))
	intCodCurso	 			= Trim(Request.Form("cmbCurso"))
	intCodPeriodo 			= Trim(Request.Form("cmbPeriodo"))
	intCodGrade				= Trim(Request.Form("cmbGrade"))

	intCodTurno		 		= Trim(Request.Form("cmbTurno"))
	intCodPlano				= Trim(Request.Form("cmbPlano"))
	strSala		 			= Trim(Request.Form("txtSala"))
	intAno		 			= Trim(Request.Form("txtAno"))
	intAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	strAtualizaVagasOcupadas= Trim(Request.Form("AtualizaVagasOcupadas"))
	
	ckAtualizaVagasOcupadas = ""
    if strAtualizaVagasOcupadas = "S" then ckAtualizaVagasOcupadas = " checked "	
	if intSemestre = "" then 	intSemestre  = session("strSemestre")	
	if strAnoLetivo = "" then 	
		strAnoLetivo = session("strAnoLetivo")
		if session("strAnoLetivo")<=2013 then 	strAnoLetivo = session("strAnoLetivo") + 1
	end if
		
	strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
	strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="98%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post" action="TurmasVagasMatricula_cad.asp">
		  <table width="708" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="700" align="center" class="tituloSistema">Turmas Vagas Matricula</td>
            </tr>
          </table>
		  <br>
		  <table width="95%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="29" colspan="2" class="texto1">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td class="texto1">Unidade:</td>
                    <td><!--#include file="../includes/inc_cmdEmpresaUsuario.asp" --></td>
                  </tr>
                  <tr>
                    <td width="24%" height="23" class="texto1">Ano Letivo:</td>
                    <td width="76%"><input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)"></td>
                  </tr>
                  <tr>
                    <td class="texto1">Semestre:</td>
                    <td><!--#include file="../includes/inc_cmdSemestre.asp" --></td>
                  </tr>
                   <tr>
                    <td height="42" class="texto1">Atualizar Vagas e Reservas Ocupadas:</td>
                    <td class="texto1">
                    <input type="button" name="BtnAtualiza" value="Atualiza Vagas e Reserva do Ano Corrente" class="botao" onClick="AtualizaPeriodico()">
                    <input disabled type="button" name="BtnAtualizainicial" id="button" value="Atualiza Vagas e Reserva do Ano Anterior" class="botao" onClick="AtualizaInicial()"-->
</td>
                  </tr>
                 <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                  </tr>
                </table>

            <%
			cont =0
			if intSemestre = "" then intSemestre = 0
			if intCodEmpresaUsuario = "" then intCodEmpresaUsuario = 0
		
			sql = "SELECT T.Cod_Turma, T.Cod_GradeCurricular, T.Cod_Semestre, T.Cod_Turno, sca_Turno.Desc_Turno, isnull(T.Capacidade,'0') as Capacidade,"
			sql = sql & " T.Cod_PlanoPagamento, T.Cod_ContaCorrente, T.nomeTurma, T.Sala, T.Ano, T.AnoLetivo, T.TurmaAluno, isnull(T.VagasMatriculas,0) as VagasMatriculas, isnull(T.VagasMatriculasUtilizadas,0) as VagasMatriculasUtilizadas, "
			sql = sql & " isnull(T.VagasReservadas,0) as VagasReservadas" 
			sql = sql & " FROM SCA_TURMA T"
			sql = sql & " Inner join sca_Turno on sca_Turno.Cod_Turno = T.Cod_Turno "
			sql = sql & " where T.Cod_empresa = " & intCodEmpresaUsuario		
			
			if strAnoLetivo <> "" then
				sql = sql & " and T.AnoLetivo = " & strAnoLetivo
			end if
			
			if intSemestre <> "0" then
				sql = sql & " and  T.Cod_Semestre = " & intSemestre
			end if
			
			sql = sql & " Order by AnoLetivo, Cod_Turno, Nometurma"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
            <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
              <tr bgcolor="#E5E5E5">
                <td width="9%" align="center" bgcolor="#E5E5E5" class="celula"><strong>Marca&ccedil;&atilde;o para confer&ecirc;ncia</strong></td>
                <td width="9%" align="center" bgcolor="#E5E5E5" class="celula"><strong>Ano Letivo <span class="TextoForm"></span></strong></td>
                <td width="4%" align="center" bgcolor="#E5E5E5" class="celula"><strong>Sala</strong></td>
                <td width="7%" align="center" bgcolor="#E5E5E5" class="celula"><strong>Turma</strong></td>
                <td width="7%" align="center" bgcolor="#E5E5E5" class="celula"><strong>Capacidade<br>da Sala</strong></td>
                <td width="13%" align="center" bgcolor="#E5E5E5" class="celula"><strong>Vagas <br>Preenchidas</strong></td>
                <td width="12%" align="center" bgcolor="#E5E5E5" class="celula"><strong>Vagas <br>Existentes</strong></td>
                <td width="13%" align="center" bgcolor="#E5E5E5" class="celula"><strong>Vagas <br>Reservadas</strong></td>
                <td width="11%" align="center" bgcolor="#E5E5E5" class="celula"><strong>Vagas <br>Liberadas</strong></td>
                <td width="28%" height="21" bgcolor="#E5E5E5" class="celula"><strong>Turno </strong></td>
                </tr>
              <%
				while not rs.eof

					strVagasNaoAutorizadas = cint(rs("Capacidade")) - cint(rs("VagasMatriculasUtilizadas")) 
     				%>
              <tr>
                <td align="center" class="celula"> <input type="checkbox" name="marcacao<%=rs("cod_turma")%>" value="S"></td>
                <td align="center" class="celula"><%=trim(rs("AnoLetivo"))%></td>
                <td align="center" class="celula"><%=trim(rs("Sala"))%></td>
                <td align="center" class="celula"><input value="<%=rs("cod_turma")%>" type="hidden" name="txtCodTurma_<%=rs("cod_turma")%>" ><%=trim(rs("NomeTurma"))%></td>
                <td align="center" class="celula"><%=trim(rs("Capacidade"))%></td>
                <td align="center" class="celula"><strong><font color="#0000CC"><%=rs("VagasMatriculasUtilizadas")%></font></strong>&nbsp;</td>
                <td align="center" class="celula"><strong><font color="#0066FF"><%=strVagasNaoAutorizadas%></font></strong></td>
                <td align="center" class="celula"><input name="txtVagasMatriculasReservadas_<%=rs("Cod_Turma")%>" type="text" class="<%=strTipoFont%>" id="txtVagasMatriculasUtilizadas<%=rs("Cod_Turma")%>" value="<%=rs("VagasReservadas")%>" size="3" maxlength="3"></td>
                <td align="center" class="celula"><strong><font color="#009900"><%=strVagasNaoAutorizadas-rs("VagasReservadas")%></font></strong></td>
                <td height="27" colspan="2" class="celula" align="center"><%=trim(rs("Desc_Turno"))%>&nbsp;</td>
                </tr>
              <%				
					strDesabilitaAlterar 	= "" 
					rs.movenext
					wend
				  %>
            </table>
            <%
			  end if
			  rs.close%>           
            </tr>
          <tr>
            <td width="146" class="texto1">&nbsp;</td>
            <td width="557">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
          <td colspan="2">			</td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
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