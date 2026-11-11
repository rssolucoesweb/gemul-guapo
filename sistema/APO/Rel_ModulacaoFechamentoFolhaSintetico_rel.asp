<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<html>
<head>
<title><%=session("Titulo")%></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
<script>
	function abrePaginaTeste(codColaborador, dataInicial, datafinal){
		var caminho = "mostraModulacaoDias.asp?codColaborador="+codColaborador+"&dataInicial="+dataInicial+"&datafinal="+datafinal;
		window.open(caminho,"abreConsulta","top=5,left=5,height=510,width=819,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}
	function abrePaginaTesteAulas(codColaborador, dataInicial, datafinal){
		var caminho = "mostraModulacaoAulas.asp?codColaborador="+codColaborador+"&dataInicial="+dataInicial+"&datafinal="+datafinal;
		window.open(caminho,"abreConsulta","top=5,left=5,height=510,width=819,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}
</script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file=../../includes/inc_aguarde.asp-->
<br>
<%
	dim intPagina
	mostraContratoModulacao			= Trim(Request.form("chkCHContratoModulacao"))
	intCodModulacaoReferencia 		= Trim(Request.form("cmbModulacaoReferencia"))
	intCodFuncional  				= Trim(Request.Form("txtCodigoFuncional"))
	intCodColaborador				= Trim(Request.form("txtCodFuncionario"))
	strnome 						= Trim(Request.Form("txtNomeFuncionario"))
	intCodEmpresa 					= Session("CodEmpresa")
	intCodEmpresaGrupo				= Trim(Request.Form("cmbEmpresaGrupo"))
	intCodCargoCategoria 			= Trim(Request.Form("cmbCargoCategoria"))
	strDataInicialModulacao	= request.Form("txtDataInicial")
	strDataFinalModulacao	= request.Form("txtDataFinal")
	strClassificacao 				= Trim(Request.Form("cmbClassificacao"))
	if intCodEmpresaGrupo = "" then
		intCodEmpresaGrupo				= Session("CodEmpresa")
	end if
	
   colSpan = 14
   if mostraContratoModulacao = "S" then colSpan = 16

	' Inativa todas as Modulacoes Vencidas vencidas
	sql = " Update SRH_MODULACAO_DISCIPLINAR_DOCENTE "
	sql = sql & " set status = 'I' "
	sql = sql & " where convert(datetime,convert(varchar, DataFinal, 103),103) < convert(datetime, ' " & date & "',103) "
	cnn.execute sql

	' Inativa todas as substituicoes vencidas
	sql = " Update SRH_COLABORADOR_SUBSTITUTO "
	sql = sql & " set SITUACAO = 'I' "
	sql = sql & " where Cod_Grupo = " & Session("CodGrupo")
	sql = sql & " and convert(datetime,convert(varchar, DataFinal, 103),103) < convert(datetime, ' " & date & "',103) "
	sql = sql & " and SITUACAO = 'A' "
	cnn.execute sql
	
	if intCodModulacaoReferencia <> "" then
		sql = "select AnoReferencia, SemestreReferencia, Data_inicial, Data_Final  from SRH_MODULACAO_REFERENCIA WHERE CODIGO = " & intCodModulacaoReferencia
		rs.open sql, cnn
		if rs.eof = false then
			strAnoLetivoReferencia  	= rs("AnoReferencia")
			intSemestreReferencia 		= rs("SemestreReferencia")
			strAnoLetivo 				= rs("AnoReferencia")
			strSemestre 				= rs("SemestreReferencia")			
			strDataInicialModulacao  	= rs("Data_inicial")
			strDataFinalModulacao  		= rs("Data_Final")
		end if
		rs.close
		
	end if

	sql = "select descricao from SRH_CARGOCATEGORIA where Codigo=" & intCodCargoCategoria
	rs.open sql, cnn
	if rs.eof = false then
		strDescricaoCargoCategoria  	= " - " & rs("Descricao")
	end if
	rs.close

	if request.Form("txtDataInicial")<>"" then strDataInicialModulacao=request.Form("txtDataInicial")
	if request.Form("txtDataFinal")<>"" then strDataFinalModulacao=request.Form("txtDataFinal")

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table align="center" width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
	    <td height="21" colspan="16" align="center" class="celulaFonte9">
        	<font size="2"><strong>Relat&oacute;rio Sint&eacute;tico Modula&ccedil;&atilde;o - Fechamento <%=strDescricaoCargoCategoria%></strong></font>
            <strong><br>(<%=strDataInicialModulacao%> a <%=strDataFinalModulacao%>)<br>
            <font size="2"><%=rs("Razaosocial")%></font></strong></td>
      </tr>
	  <tr bgcolor="#CCCCCC">
	    <td width="4%" height="19" rowspan="2" align="center" class="celulaFonte9">Matr&iacute;cula</td>
	    <td width="11%" rowspan="2" align="center" class="celulaFonte9">Colaborador</td>
	    <td width="10%" rowspan="2" align="center" class="celulaFonte9">Cargo</td>
		<td width="11%" rowspan="2" align="center" class="celulaFonte9">Função</td>
	    <td width="1%" rowspan="2" align="center" class="celulaFonte9">Turno</td>
        <%if mostraContratoModulacao = "S" then%>
	    <td width="3%" rowspan="2" class="celulaFonte9"><div align="center">Ch. Contratada<br>(Aulas)</div></td>
	    <td width="3%" rowspan="2" align="center" class="celulaFonte9">Total Modulado<br>
        (Aulas)</td>
        <%end if%>
	    <td width="3%" rowspan="2" align="center" class="celulaFonte9">Ch. Modulada<br>(Horas)</td>
	    <td colspan="2" align="center" class="celulaFonte9">Excedentes</td>
	    <td colspan="2" class="celulaFonte9"><div align="center">Faltas </div></td>
      </tr>
	  <tr bgcolor="#CCCCCC">
	    <td width="2%" align="center" class="celulaFonte9">Aulas</td>
	    <td width="2%" align="center" class="celulaFonte9">Dias</td>
	    <td width="2%" align="center" class="celulaFonte9">Aulas</td>
	    <td width="2%" align="center" class="celulaFonte9">Dias</td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
	intPagina = 1
	
	sql = " execute [dbo].[SP_Rel_FechamentoFolha_sintetico] '" & formatadataBD(strDataInicialModulacao) & "','" & formatadataBD(strDataFinalModulacao) & "'," & intCodEmpresaGrupo & ",'0'," & strAnoLetivo & "," & strSemestre & "," & intCodCargoCategoria
	strCodFuncional = ""
	imprimiu = ""
    rs.open sql, cnn
	if not rs.eof then 
	   strNome = ""
	   mostraCabecalho
	   cont = 0
	   intTotalModuladoSoma = 0
	   While not rs.eof

			cont = cont + 1			
			strCargo			= Trim(rs("Desc_Cargo"))
			strNivel			= Trim(rs("Nivel"))
			strFuncao			= Trim(rs("Funcao"))
			strRazaosocial		= Trim(rs("Razaosocial"))
			strTurno			= Trim(rs("turno"))
			strNome			= Trim(rs("nome"))
			
			intTotalModulado	= Trim(rs("TotalModulado"))
			total_aulas_contratada	= Trim(rs("total_aulas_contratada"))
			
			ch_modulada_horas			= Trim(rs("ch_modulada_horas"))
			IF ch_modulada_horas = "0" THEN ch_modulada_horas = "&nbsp;"
			
			dias_excedido_contratual	= Trim(rs("dias_excedido_contratual"))
			IF dias_excedido_contratual = "" THEN dias_excedido_contratual = "0"	
				
			aulas_excedido_contratual	= Trim(rs("aulas_excedido_contratual"))
			IF aulas_excedido_contratual = "" THEN aulas_excedido_contratual = "0"	
				
			dias_excedido_adicional		= Trim(rs("dias_excedido_adicional"))
			IF dias_excedido_adicional = "" THEN dias_excedido_adicional = "0"	
				
			aulas_excedido_adicional		= Trim(rs("aulas_excedido_adicional"))
			IF aulas_excedido_adicional = "" THEN aulas_excedido_adicional = "0"
			
			intTotalfaltasDias		= Trim(rs("total_faltas_dias"))
			IF intTotalfaltasDias = "0" THEN intTotalfaltasDias = "&nbsp;"	
				
			intTotalfaltasAulas		= Trim(rs("total_faltas_aulas"))
			IF intTotalfaltasAulas = "0" THEN intTotalfaltasAulas = "&nbsp;"		
			if cor = "" then
				cor = "#EFEFEF"
			else
				cor = ""
			end if
			%>
                <tr bgcolor="<%=cor%>" >
                    <td height="20" align="left" class="celulaFonte9">&nbsp;<%= Trim(rs("codFuncional"))%></td>
                    <td class="celulaFonte9" align="left">&nbsp;<%=trim(strNome)%>&nbsp;<%=trim(msgStatusModulacao)%></td>
                    <td align="left" class="celulaFonte9">&nbsp;<%=trim(strCargo)%></td>
					<td align="left" class="celulaFonte9">&nbsp;<%=trim(strFuncao)%></td>
                    <td align="CENTER" class="celulaFonte9">&nbsp;<%=LEFT(trim(strTurno),1)%></td>
                    <%if mostraContratoModulacao = "S" then%>
                    <td align="center" class="celulaFonte9" ><%=total_aulas_contratada%>&nbsp;</td>
                    <td align="center" class="celulaFonte9"><%=intTotalModulado%>&nbsp;</td>
                    <%end if%>
                    <td align="center" class="celulaFonte9"><%=ch_modulada_horas%>&nbsp;</td>
                    <td align="center" class="celulaFonte9"  style="cursor:hand" onClick="return abrePaginaTesteAulas('<%=rs("codColaborador")%>','<%=formatadataBD(strDataInicialModulacao)%>','<%=formatadataBD(strDataFinalModulacao)%>')" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"><%if cInt(aulas_excedido_contratual)+cInt(aulas_excedido_adicional) > 0 then%><%=cInt(aulas_excedido_contratual)+cInt(aulas_excedido_adicional)%><%end if%>&nbsp;</td>
                    <td align="center" class="celulaFonte9"  style="cursor:hand" onClick="return abrePaginaTeste('<%=rs("codColaborador")%>','<%=formatadataBD(strDataInicialModulacao)%>','<%=formatadataBD(strDataFinalModulacao)%>')" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"><%if cInt(dias_excedido_contratual)+cInt(dias_excedido_adicional) > 0 then%><%=cInt(dias_excedido_contratual)+cInt(dias_excedido_adicional)%><%end if%>&nbsp;</td>
                    <td align="left" class="celulaFonte9"><div align="center"><%=trim(intTotalfaltasAulas)%>&nbsp;</div></td>
                    <td align="left" class="celulaFonte9"><div align="center"><%=trim(intTotalfaltasDias)%>&nbsp;</div></td>

			 	</tr>
			<% 
			contLinhas = contLinhas + 1
			rs.movenext
			if contLinhas >= 25 then
				contLinhas = 0
				fimTabela
				%><pre>&nbsp;</pre><%
				mostraCabecalho	
			end if
	   wend
	   %>
        
	   <tr>
	   <td colspan="<%=colSpan%>" bgcolor="#CCCCCC" class="celulaFonte9">Total Registros :<%=cont%></td>
      </tr>
	   <%
	else
		%>
		  <tr>
			<td height="12" colspan="<%=colSpan%>" align="center" class="celulaFonte9"><font color="#993300"><br><br><br><br><br><br><strong><%=session("strMensagemRelatorioNaoEncontrado")%></strong></font></td>
	  </tr>
		<%
		
	end if
	rs.close
%>
</table>
<br>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
