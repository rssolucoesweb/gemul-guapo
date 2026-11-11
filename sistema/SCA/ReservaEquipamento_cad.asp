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
<!--#include file="../../js/Calendario/Calendario.asp"-->
<script>
	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
	
		var frm = document.getElementById("frm");
		
		if (acao=="I") {
			if (frm.optOpcao[0].checked==false && frm.optOpcao[1].checked==false) {
				alert("Atenção! A Atividade deverá ser informada.");
				frm.optOpcao[0].focus();
				return false;
			}
			if (frm.txtDataReserva.value == ""){
				alert("A Data deve ser informada.");
				frm.txtDataReserva.focus();
				return false;
			}
			
		   if (frm.optOpcao.value =="S") { 
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
				
			}
			
		    if (frm.optOpcao.value =="E") { 
				if (frm.cmbColaboradorAtivos.value == 0){
					alert("Colaborador deve ser informado.");
					frm.cmbColaboradorAtivos.focus();
					return false;
				}
				
				if (frm.cmbHorario.value == 0){
					alert("Horário deve ser informado.");
					frm.cmbHorario.focus();
					return false;
				}
				
			}
				
			frm.action="ReservaEquipamento_cod.asp?acao="+acao;
			frm.submit();
			return true;
		}else{
			frm.action="ReservaEquipamento_cod.asp?acao="+acao;
			frm.submit();
			return true;
		}
 	}
</script>
<%
	strPaginaTitulo = "ReservaEquipamento_cad.asp"
	strExecutarSubmitHorario = "S"
	strExecutarSubmitEquipamento = "S"
	strExecutarSubmitProfessor = "S"
	strExecutarSubmitHorarioProfessor = "S"
	strExecutarSubmitColaborador = "S" 

	intSemestre 			= session("strSemestre")
	strAnoLetivo 			= session("strAnoLetivo")
	
	intCodigo	 			= Trim(Request.Form("txtCodigo"))
	strData	 				= Trim(Request.Form("txtDataReserva"))
	strDataReserva			= Trim(Request.Form("txtDataReserva"))
	if strData = "" then strData = formatadataAP(date)
	
	intCodHorarioAula		= Trim(Request.Form("cmbHorarioProfessor"))
	if intCodHorarioAula = "" then intCodHorarioAula = "0"
	
	strSala		 			= Trim(Request.Form("txtSala"))
	intCodEquipamento		= Trim(Request.Form("cmbEquipamento"))
	
	strTipoAtividade		= Trim(Request("optOpcao"))
	if strTipoAtividade = "" then strTipoAtividade = "S"

	if strTipoAtividade = "S" then
		intCodProfessor		 	= Trim(Request.Form("cmbProfessor"))
		if intCodProfessor = "" then intCodProfessor = 0
	elseif strTipoAtividade = "E" then
		intCodColaborador	 	= Trim(Request.Form("cmbColaboradorAtivos"))
		intCodHorario			= Trim(Request.Form("cmbHorario"))
	end if		

	if trim(intCodigo) <> "" then
	
		if strTipoAtividade = "S" then
			sql = "select	P.COD_CURSO, P.COD_PERIODO, HA.SEQUENCIA, R.Cod_Colaborador, G.COD_GRADECURRICULAR, "
			sql = sql & " 		R.data_utilizacao, HA.COD_DISCIPLINA, HA.CODIGO AS COD_HORARIO_AULA, "
			sql = sql & " 		R.Cod_horario, SEQUENCIA_AULAS, R.NUM_SALA, HA.TEMPO, R.TIPO_EVENTO, E.COD_EQUIPAMENTO"
			sql = sql & " from SCA_EQUIPAMENTO_RESERVA R"
			sql = sql & " inner JOIN SCA_EQUIPAMENTO E ON E.COD_EMPRESA= R.COD_EMPRESA AND R.COD_EQUIPAMENTO = E.COD_EQUIPAMENTO"
			sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.codigo = R.Cod_Colaborador "
			sql = sql & " INNER JOIN SCA_HORARIO H ON C.COD_EMPRESA = R.COD_EMPRESA AND H.codigo = R.Cod_horario "
			sql = sql & " INNER JOIN SCA_HORARIO_AULA HA ON C.COD_EMPRESA = R.COD_EMPRESA AND HA.codigo = R.Cod_horario_aula "
			sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_EMPRESA = R.COD_EMPRESA AND T.COD_TURMA = HA.COD_TURMA"
			sql = sql & " INNER JOIN SCA_GRADECURRICULAR G ON G.COD_EMPRESA=T.COD_EMPRESA AND G.COD_GRADECURRICULAR=T.COD_GRADECURRICULAR"
			sql = sql & " INNER JOIN SCA_PERIODO P ON P.COD_EMPRESA=T.COD_EMPRESA AND P.COD_PERIODO=G.COD_PERIODO"
			sql = sql & " INNER JOIN SCA_DISCIPLINA D ON D.COD_EMPRESA=HA.COD_EMPRESA AND D.COD_DISCIPLINA=HA.COD_DISCIPLINA"
			sql = sql & " AND	R.CODIGO		= " & intCodigo

		elseif strTipoAtividade = "E" then
			sql = "select	'' as COD_CURSO, '' AS COD_PERIODO, '' AS SEQUENCIA, R.Cod_Colaborador, '' AS COD_GRADECURRICULAR, "
			sql = sql & " 		R.data_utilizacao, '' AS COD_DISCIPLINA, '' AS COD_HORARIO_AULA, "
			sql = sql & " 		R.Cod_horario, SEQUENCIA_AULAS, R.NUM_SALA, '' AS TEMPO, R.TIPO_EVENTO, E.COD_EQUIPAMENTO"
			sql = sql & " from SCA_EQUIPAMENTO_RESERVA R"
			sql = sql & " inner JOIN SCA_EQUIPAMENTO E ON E.COD_EMPRESA= R.COD_EMPRESA AND R.COD_EQUIPAMENTO = E.COD_EQUIPAMENTO"
			sql = sql & " INNER JOIN SCA_HORARIO H ON H.COD_EMPRESA = R.COD_EMPRESA AND H.codigo = R.Cod_horario "
			sql = sql & " AND	R.CODIGO		= " & intCodigo
			sql = sql & " AND 	R.tipo_evento = 'E'"
		
		end if
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
			if trim(rs("COD_HORARIO_AULA")) <> "" then 
				intCodHorarioAula		= Trim(rs("COD_HORARIO_AULA"))
			else	
				intCodHorarioAula		= "0"
			end if
			strData			= formatadataAP(Trim(rs("DATA_UTILIZACAO")))
			strSala					= Trim(rs("NUM_SALA"))		
			strTipoAtividade        = Trim(rs("TIPO_EVENTO"))		
			if strTipoAtividade = "S" then
				intCodProfessor		 	= Trim(rs("COD_COLABORADOR"))
			elseif strTipoAtividade = "E" then
				intCodColaborador	 	= Trim(rs("COD_COLABORADOR"))
			end if			

			intCodEquipamento			= Trim(rs("COD_EQUIPAMENTO"))	

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
	if intCodHorarioAula <> "0" then
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
<form method="post" id="frm" action="ReservaEquipamento_cad.asp">
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
    <td height="12" class="texto1">Tipo de Atividade:</td>
    <td class="texto1">
      <input <% if strTipoAtividade = "S" then response.Write("checked")%> name="optOpcao" type="radio" value="S" onClick="submit()">
      Sala&nbsp;&nbsp;&nbsp;&nbsp; <br>
      <input <% if strTipoAtividade = "E" then response.Write("checked")%> name="optOpcao" type="radio" value="E" onClick="submit()">
      Eventos</td>
    </tr>
    <tr>
      <td class="texto1">Data da Reserva: </td>
      <td class="texto1"><input name="txtDataReserva" type="text" class="text" id="txtDataReserva" onBlur="validaData(this); submit()" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strData%>" title="Click aqui para visualizar o calend&aacute;rio"></td>
    </tr>

	  <%if strTipoAtividade = "S" then%>
          <tr> 
            <td class="texto1">Colaborador(a): </td>
            <td> 
              <!--#include file="../includes/inc_cmdProfessor.asp"-->             </td>
          </tr>
         <tr>
          <td class="texto1">Hor&aacute;rio: </td>
          <td class="texto1"><!--#include file="../includes/inc_cmdHorarioProfessor.asp"--></td>
        </tr>
          
      <%elseif strTipoAtividade = "E" then%>
          <tr> 
            <td class="texto1">Colaborador(a): </td>
            <td>   
              <!--#include file="../includes/inc_cmdColaboradorAtivosTodos.asp"-->            </td>
          </tr>
          <tr> 
            <td class="texto1">Hor&aacute;rio: </td>
            <td class="texto1"> 
              <!--#include file="../includes/inc_cmdHorario.asp"-->            </td>
          </tr>
      <%end if%>
      
         <input name="txtCodSequenciaAulas" type="hidden" id="txtCodSequenciaAulas" value="<%=intCodSequenciaAulas%>">
    <tr>
      <td class="texto1">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td class="texto1">Sala/Evento:</td>
      <td><input  name="txtSala" type="text" class="text" id="txtSala"  value="<%=strSala%>" size="70" maxlength="100" ></td>
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
			if strTipoAtividade = "S" then
				sql = "select	R.codigo, R.data_solicitacao, "
				sql = sql & " 		R.data_utilizacao,"
				sql = sql & " 		H.horario,"
				sql = sql & " 		C.nome,"
				sql = sql & " 		E.desc_equipamento, T.NOMETURMA, R.num_sala"
				sql = sql & " from SCA_EQUIPAMENTO_RESERVA R"
				sql = sql & " inner JOIN SCA_EQUIPAMENTO E ON E.COD_EMPRESA= R.COD_EMPRESA AND R.COD_EQUIPAMENTO = E.COD_EQUIPAMENTO"
				sql = sql & " INNER JOIN SRH_COLABORADOR C ON C.COD_EMPRESA = R.COD_EMPRESA AND C.codigo = R.Cod_Colaborador "
				sql = sql & " INNER JOIN SCA_HORARIO H ON C.COD_EMPRESA = R.COD_EMPRESA AND H.codigo = R.Cod_horario "
				sql = sql & " INNER JOIN SCA_HORARIO_AULA HA ON C.COD_EMPRESA = R.COD_EMPRESA AND HA.codigo = R.Cod_horario_aula "
				sql = sql & " INNER JOIN SCA_TURMA T ON T.COD_EMPRESA = R.COD_EMPRESA AND T.COD_TURMA = HA.COD_TURMA"
				sql = sql & " where	R.COD_EMPRESA = " & Session("CodEmpresa")	
				sql = sql & " AND		R.data_utilizacao >= '" & formatadataBD(DATE) & "'"
				sql = sql & " AND 	R.tipo_evento = 'S'"
				sql = sql & " Order by R.data_utilizacao DESC "
			elseif strTipoAtividade = "E" then
				sql = "select	R.codigo, R.data_solicitacao, "
				sql = sql & " 		R.data_utilizacao,"
				sql = sql & " 		H.horario,"
				sql = sql & " 		C.nome,"
				sql = sql & " 		E.desc_equipamento, '' as NOMETURMA, R.num_sala"
				sql = sql & " from SCA_EQUIPAMENTO_RESERVA R"
				sql = sql & " inner JOIN SCA_EQUIPAMENTO E 	ON E.COD_EMPRESA= R.COD_EMPRESA AND R.COD_EQUIPAMENTO = E.COD_EQUIPAMENTO"
				sql = sql & " INNER JOIN SRH_COLABORADOR C 	ON C.COD_EMPRESA = R.COD_EMPRESA AND C.codigo = R.Cod_Colaborador "
				sql = sql & " INNER JOIN SCA_HORARIO H 		ON C.COD_EMPRESA = R.COD_EMPRESA AND H.codigo = R.Cod_horario "
				sql = sql & " where	R.COD_EMPRESA = " & Session("CodEmpresa")	
				sql = sql & " AND		R.data_utilizacao >= '" & formatadataBD(DATE) & "'"
				sql = sql & " AND 	R.tipo_evento = 'E'"
				sql = sql & " Order by R.data_utilizacao DESC "			
			end if
			rs.open sql, cnn
			if rs.eof = false then
				%>
			  	<br> 
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
				<tr bgcolor="#E5E5E5"> 
				  <td height="21" colspan="7" class="celula"><div align="center"><strong>Reservas</strong></div></td>
				</tr>
				<tr bgcolor="#E5E5E5"> 
				  <td width="8%" class="celula"><strong>Utiliza&ccedil;&atilde;o</strong></td>
				  <td width="9%" class="celula"><strong><strong>Solicita&ccedil;&atilde;o</strong></strong></td>
				  <td width="13%" class="celula"><strong>Sala/Evento</strong></td>
				  <td width="13%" height="21" class="celula"><strong>Hor&aacute;rio<span class="TextoForm"></span></strong></td>
				  <td width="13%" class="celula"><strong>Turma<span class="TextoForm"></span></strong></td>
				  <td width="26%" class="celula"><strong>Colaborador(a)</strong></td>
				  <td width="31%" class="celula"><strong>Professor(a)<span class="TextoForm"></span></strong></td>
				</tr>
				<%
				while not rs.eof
					cont = cont + 1	
					%>
					<tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return resultadoConsulta('<%=rs("codigo")%>')"> 
				  		<td class="celula"><%=formatadataAP(rs("data_utilizacao"))%></td>
				  		<td class="celula"><%=formatadataAP(rs("data_solicitacao"))%></td>
					  	<td class="celula"><%=trim(rs("num_sala"))%>&nbsp;</td>
				  		<td height="20" class="celula"><%=trim(rs("horario"))%>&nbsp;</td>
				  		<td class="celula"><%=trim(rs("NOMETURMA"))%>&nbsp;</td>
				  		<td class="celula"><%=trim(rs("nome"))%></td>
				  		<td class="celula"><%=trim(rs("desc_equipamento"))%></td>
					</tr>
					<%				
					rs.movenext
					wend
					%>
					<tr> 
				  		<td height="21" colspan="7" class="celula">Total Registros : <%=cont%></td>
			    </table>
			  <%
			  end if
			 rs.close
			%>		
            </td>
    </tr>
  </table>
  		  </td>
		</tr>
  </table>
</form>
<!--#include file="../rodape.asp"-->
</body>
</html>