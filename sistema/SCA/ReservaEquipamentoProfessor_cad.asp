<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/07/2008
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: reserva equipamento
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
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<script>
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
	
		var frm = document.getElementById("frm");
		
		if (acao=="I") {
			if (frm.cmbProfessorComHorario.value == 0){
				alert("Professor deve ser informado.");
				frm.cmbProfessorComHorario.focus();
				return false;
			}
			if (frm.cmbHorarioProfessor.value == 0){
				alert("Horário deve ser informado.");
				frm.cmbHorarioProfessor.focus();
				return false;
			}
			frm.action="ReservaEquipamentoProfessor_cod.asp?acao="+acao;
			frm.submit();
			return true;
		}else{
			frm.action="ReservaEquipamentoProfessor_cod.asp?acao="+acao;
			frm.submit();
			return true;
		}
 	}
</script>
<%
	strPaginaTitulo = "ReservaEquipamentoProfessor_cad.asp"

	strExecutarSubmitEquipamento = "S"
	strExecutarSubmitProfessor = "S"
	strExecutarSubmitHorarioProfessor = "S"

	intSemestre 			= session("strSemestre")
	strAnoLetivo 			= session("strAnoLetivo")
	
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strDataReserva 			= Trim(Request.Form("txtDataReserva"))
	if strDataReserva = "" then strDataReserva = formatadataAP(date)
	intCodProfessor		 	= Trim(Request("cmbProfessorComHorario"))
	if intCodProfessor = "" then intCodProfessor = 0

	intCodHorarioAula		= Trim(Request.Form("cmbHorarioProfessor"))
	if intCodHorarioAula = "" then intCodHorarioAula = 0
	strSala		 			= Trim(Request.Form("txtSala"))
	intCodEquipamento		= Trim(Request.Form("cmbEquipamento"))
		
	if trim(intCodigo) <> "" then
		sql = "select	P.COD_CURSO, P.COD_PERIODO, HA.SEQUENCIA, R.Cod_Colaborador, G.COD_GRADECURRICULAR, "
		sql = sql & " 		R.data_utilizacao, HA.COD_DISCIPLINA, HA.CODIGO AS COD_HORARIO_AULA, "
		sql = sql & " 		R.Cod_horario, SEQUENCIA_AULAS, R.NUM_SALA, HA.TEMPO"
		sql = sql & " from SCA_EQUIPAMENTO_RESERVA R"
		sql = sql & " inner JOIN SCA_EQUIPAMENTO E ON E.COD_EMPRESA= R.COD_EMPRESA AND R.COD_EQUIPAMENTO = E.COD_EQUIPAMENTO"
		sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.LOTACAO = R.COD_EMPRESA AND C.codigo = R.Cod_Colaborador "
		sql = sql & " INNER JOIN SCA_HORARIO H ON C.COD_EMPRESA = R.COD_EMPRESA AND H.codigo = R.Cod_horario "
		sql = sql & " INNER JOIN SCA_HORARIO_AULA HA ON C.COD_EMPRESA = R.COD_EMPRESA AND HA.codigo = R.Cod_horario_aula "
		sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_EMPRESA = R.COD_EMPRESA AND T.COD_TURMA = HA.COD_TURMA"
		sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_EMPRESA=T.COD_EMPRESA AND G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR"
		sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_EMPRESA=T.COD_EMPRESA AND P.COD_PERIODO=G.COD_PERIODO"
		sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_EMPRESA=HA.COD_EMPRESA AND D.COD_DISCIPLINA=HA.COD_DISCIPLINA"
		sql = sql & " AND	R.CODIGO		= " & intCodigo
		rs.open sql, cnn
		if rs.eof = false then
			
			intCodCurso	 			= Trim(rs("cod_Curso"))
			intCodPeriodo 			= Trim(rs("cod_Periodo"))
			intCodProfessor		 	= Trim(rs("COD_COLABORADOR"))
			intCodSequenciaAula	 	= Trim(rs("Sequencia"))
			intCodGrade				= Trim(rs("COD_GRADECURRICULAR"))
			intCodDisciplina		= Trim(rs("COD_DISCIPLINA"))
			intCodTempoAula			= Trim(rs("Tempo"))
			intCodHorario			= Trim(rs("COD_HORARIO"))
			intCodSequenciaAulas	= Trim(rs("SEQUENCIA_AULAS"))
			intCodHorarioAula		= Trim(rs("COD_HORARIO_AULA"))
			strDataReserva			= Trim(rs("DATA_UTILIZACAO"))
			strSala					= Trim(rs("NUM_SALA"))		
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
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

	if intCodHorarioAula<>"0" then
		sql = "SELECT COD_HORARIO"
		sql = sql & " FROM SCA_HORARIO_AULA "	
		sql = sql & " WHERE CODIGO = " & intCodHorarioAula
		sql = sql & " AND 	COD_EMPRESA = " & Session("CodEmpresa")
		rs.open sql, cnn
		if rs.eof = false then
			intCodHorario					= Trim(rs("COD_HORARIO"))
		end if
		rs.close	
	end if
	
	strFiltroSerie 			= "0"
	strFiltroTurno 			= "0"

	if intCodCurso 			= "" then intCodCurso 		= "0"
	if intCodSerie 			= "" then intCodSerie 		= "0"
	if intCodTurno 			= "" then intCodTurno 		= "0"
	if intCodTurma 			= "" then intCodTurma 		= "0"
	if intCodProfessor 		= "" then intCodProfessor 	= "0"
	if intCodGrade 			= "" then intCodGrade 		= "0"
	if intCodHorario 		= "" then intCodHorario 	= "0"
	if intCodSequenciaAulas = "" then intCodSequenciaAulas = "0"

%>
<form method="post" id="frm" action="ReservaEquipamentoProfessor_cad.asp">
<input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodigo%>">
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
            <tr valign="top">
              <td  align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
            </tr>
		<tr valign="top">
		  <td align="center">
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="2" class="Formulario">
    <tr> 
      <td width="16%" height="12">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">Data da Reserva: </td>
      <td class="texto1">
	  <select name="txtDataReserva" id="txtDataReserva" class="combo" style="width:100pt" onChange="submit()">
 
 		<%for i=1 to 1
			strData = FormatadataAP(DateAdd("d", i, date))
		    %>
            <option <%if trim(strData)=trim(strDataReserva) then response.Write("selected") %> value="<%=strData%>"><%=strData%></option>
        <%next%>
        </select></td>
    </tr>
    <tr>
      <td height="25" class="texto1">Colaborador(a): </td>
      <td class="texto1">
      <%
      	sql = "select codigo, nome "
		sql = sql & " from SRH_COLABORADOR"
		sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
		sql = sql & " and codLotacao = " & Session("CodEmpresa")
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
			intCodProfessor = rs("codigo")
			txtNomeProfessor = rs("nome")
			response.Write "<strong>" & ucase(rs("nome")) & "</strong>"
		end if
		rs.close
      %>
			<input type="hidden" name="cmbProfessorComHorario" value="<%=intCodProfessor%>"></td>
    </tr>
    <tr>
      <td class="texto1">Hor&aacute;rio: </td>
      <td class="texto1"><!--#include file="../includes/inc_cmdHorarioProfessor.asp"--></td>
	  <input name="txtCodSequenciaAulas" type="hidden" id="txtCodSequenciaAulas" value="<%=intCodSequenciaAulas%>">

    </tr>
    <tr>
      <td class="texto1">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">Sala:</td>
      <td><input  name="txtSala" type="text" class="text" id="txtSala"  value="<%=strSala%>" size="12" maxlength="20" ></td>
    </tr>
    <tr>
      <td class="texto1">Equipamento Dispon&iacute;vel:</td>
      <td><!--#include file="../includes/inc_cmdEquipamentoDisponivel.asp"--></td>
    </tr>
    <tr> 
      <td class="texto1">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="2"><hr size="1" color="#CCCCCC"></td>
    </tr>
    <tr> 
      <td colspan="2"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
    </tr>
    <tr> 
       	<td colspan="2" class="texto1">
		
		<% 
			cont =0
			
			sql = "select	R.codigo, R.data_solicitacao, "
			sql = sql & " 		R.data_utilizacao,"
			sql = sql & " 		H.horario,"
			sql = sql & " 		C.nome,"
			sql = sql & " 		E.desc_equipamento, R.num_sala, T.NOMETURMA, ha.diasemana"
			sql = sql & " from SCA_EQUIPAMENTO_RESERVA R"
			sql = sql & " inner JOIN SCA_EQUIPAMENTO E ON E.COD_EMPRESA= R.COD_EMPRESA AND R.COD_EQUIPAMENTO = E.COD_EQUIPAMENTO"
			sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.CODLOTACAO = R.COD_EMPRESA AND C.codigo = R.Cod_Colaborador "
			sql = sql & " INNER JOIN SCA_HORARIO H ON C.COD_EMPRESA = R.COD_EMPRESA AND H.codigo = R.Cod_horario "
			sql = sql & " INNER JOIN SCA_HORARIO_AULA HA ON C.COD_EMPRESA = R.COD_EMPRESA AND HA.codigo = R.Cod_horario_aula "
			sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_EMPRESA = R.COD_EMPRESA AND T.COD_TURMA = HA.COD_TURMA"
			sql = sql & " where	R.COD_EMPRESA = " & Session("CodEmpresa")	
			sql = sql & " AND		R.data_utilizacao >= '" & formatadataBD(DATE) & "'"
			sql = sql & " Order by R.data_utilizacao, R.cod_Colaborador DESC "
			rs.open sql, cnn
							
			if rs.eof = false then
			%><br>

                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td height="21" colspan="8" class="celula"><div align="center"><strong>Rela&ccedil;&atilde;o de Equipamentos Reservados por </strong></div></td>
                  </tr>
                  <tr bgcolor="#E5E5E5">
                    <td width="8%" class="celula"><strong><strong>Solicita&ccedil;&atilde;o</strong></strong></td>
                    <td width="9%" class="celula"><strong>Utiliza&ccedil;&atilde;o</strong></td>
                    <td width="13%" class="celula"><strong>Dia da Semana</strong></td>
                    <td width="13%" height="21" class="celula"><strong>Hor&aacute;rio<span class="TextoForm"></span></strong></td>
                    <td width="13%" class="celula"><strong>Sala</strong></td>
                    <td width="13%" class="celula"><strong>Turma<span class="TextoForm"></span></strong></td>
                    <td width="26%" class="celula"><strong>Colaborador(a)</strong></td>
                    <td width="31%" class="celula"><strong>Equipamento</strong></td>
                  </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					strFuncao = ""
					if txtNomeProfessor = rs("nome") then	
						strFuncao = "style='cursor:hand' onMouseOver='return linhaMouseOver(this)' onMouseOut='return linhaMouseOut(this)' onClick='return resultadoConsulta(" & rs("codigo") & ")'"
					end if
					%>
                  <tr <%=strFuncao%>>
                    <td class="celula"><span class="TextoForm"><%=formatadataAP(rs("data_solicitacao"))%></span></td>
                    <td class="celula"><strong><%=formatadataAP(rs("data_utilizacao"))%></strong></td>
                    <td class="celula"><%=ucase(WeekDayName(WeekDay(rs("data_utilizacao"))))%></td>
                    <td height="20" class="celula"><%=trim(rs("horario"))%></td>
                    <td class="celula"><%=trim(rs("num_sala"))%>&nbsp;</td>
                    <td class="celula"><%=trim(rs("NOMETURMA"))%></td>
					<td class="celula">
					   <%
					    if txtNomeProfessor = rs("nome") then
					       response.write "<strong>" & trim(rs("nome")) & "</strong>"
						else
						   response.write trim(rs("nome"))
						end if   
					   %>					
					</td>
				 	<td class="celula"><%=trim(rs("desc_equipamento"))%></td>
                  </tr>
                  <%				
					rs.movenext
					wend
				  %>
                  <tr>
                    <td height="21" colspan="8" class="celula">Total Registros : <%=cont%></td>
                  </table>
            <%
			  end if
			  rs.close
			  
			%>		</td>
    </tr>
  </table>
  		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>