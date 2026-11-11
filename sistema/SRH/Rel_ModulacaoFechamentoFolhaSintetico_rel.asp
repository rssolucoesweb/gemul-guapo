<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<html>
<head>
<title><%=session("Titulo")%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
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
	
	intCodModulacaoReferencia 		= Trim(Request.form("cmbModulacaoReferencia"))
	intCodFuncional  				= Trim(Request.Form("txtCodigoFuncional"))
	intCodColaborador				= Trim(Request.form("txtCodFuncionario"))
	strnome 						= Trim(Request.Form("txtNomeFuncionario"))
	intCodEmpresa 					= Session("CodEmpresa")
	intCodEmpresaGrupo				= Trim(Request.Form("cmbEmpresaGrupo"))
	strTipoModulacao 				= Trim(Request.Form("optTipoModulacao"))
	strClassificacao 				= Trim(Request.Form("cmbClassificacao"))
	if intCodEmpresaGrupo = "" then
		intCodEmpresaGrupo				= Session("CodEmpresa")
	end if
	

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
	
	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table align="center" width="98%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
	    <td height="21" colspan="17" align="center" class="celula"><font size="3"><strong>Relatório Sintético Modula&ccedil;&atilde;o - Fechamento</strong></font><strong><br>(<%=strDataInicialModulacao%> a <%=strDataFinalModulacao%>)<br><font size="3"><%=rs("Razaosocial")%></font></strong></td>
      </tr>
	  <tr bgcolor="#CCCCCC">
	    <td width="4%" height="19" rowspan="2" align="center" class="celula">Matr&iacute;cula</td>
	    <td width="11%" rowspan="2" align="center" class="celula">Colaborador</td>
	    <td width="10%" rowspan="2" align="center" class="celula">Cargo</td>
		<td width="10%" rowspan="2" align="center" class="celula">N&iacute;vel</td>
	    <td width="11%" rowspan="2" align="center" class="celula">Função</td>
	    <td width="5%" rowspan="2" align="center" class="celula">Turno</td>
	    <td width="3%" rowspan="2" class="celula"><div align="center">Ch. Contratada<br>(Aulas)</div></td>
	    <td width="3%" rowspan="2" align="center" class="celula">Total Modulado<br>
        (Aulas)</td>
	    <td width="3%" rowspan="2" align="center" class="celula">Ch. Modulada<br>(Horas)</td>
	    <td colspan="2" align="center" class="celula">Excedentes</td>
	    <td colspan="2" class="celula"><div align="center">Faltas </div></td>
      </tr>
	  <tr bgcolor="#CCCCCC">
	    <td width="2%" align="center" class="celula">Aulas</td>
	    <td width="2%" align="center" class="celula">Dias</td>
	    <td width="2%" align="center" class="celula">Aulas</td>
	    <td width="2%" align="center" class="celula">Dias</td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
	intPagina = 1
	
	sql = " execute [dbo].[SP_Rel_FechamentoFolha_sintetico] '" & formatadataBD(strDataInicialModulacao) & "','" & formatadataBD(strDataFinalModulacao) & "'," & intCodEmpresaGrupo & ",'0'," & strAnoLetivo & "," & strSemestre
	'response.Write(sql)
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
                    <td  height="20" align="left" class="celula">&nbsp;<%= Trim(rs("codFuncional"))%></td>
                    <td  class="celula" align="left">&nbsp;<%=trim(strNome)%>&nbsp;<%=trim(msgStatusModulacao)%></td>
                    <td  align="left" class="celula">&nbsp;<%=trim(strCargo)%></td>
					<td  align="left" class="celula">&nbsp;<%=trim(strNivel)%></td>
                    <td align="left" class="celula">&nbsp;<%=trim(strFuncao)%></td>
                    
                    <td align="left" class="celula">&nbsp;<%=trim(strTurno)%></td>
                    <td  align="center" class="celula" ><%=total_aulas_contratada%>&nbsp;</td>
                    <td align="center" class="celula"><%=intTotalModulado%>&nbsp;</td>
                    <td   align="center" class="celula"><%=ch_modulada_horas%>&nbsp;</td>
                    <td   align="center" class="celula"  style="cursor:hand" onClick="return abrePaginaTesteAulas('<%=rs("codColaborador")%>','<%=formatadataBD(strDataInicialModulacao)%>','<%=formatadataBD(strDataFinalModulacao)%>')" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"><%if cInt(aulas_excedido_contratual)+cInt(aulas_excedido_adicional) > 0 then%><%=cInt(aulas_excedido_contratual)+cInt(aulas_excedido_adicional)%><%end if%>&nbsp;</td>
                    <td   align="center" class="celula"  style="cursor:hand" onClick="return abrePaginaTeste('<%=rs("codColaborador")%>','<%=formatadataBD(strDataInicialModulacao)%>','<%=formatadataBD(strDataFinalModulacao)%>')" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)"><%if cInt(dias_excedido_contratual)+cInt(dias_excedido_adicional) > 0 then%><%=cInt(dias_excedido_contratual)+cInt(dias_excedido_adicional)%><%end if%>&nbsp;</td>
                    <td align="left" class="celula"><div align="center"><%=trim(intTotalfaltasAulas)%>&nbsp;</div></td>
                    <td align="left" class="celula"><div align="center"><%=trim(intTotalfaltasDias)%>&nbsp;</div></td>

			 	</tr>
			<% 

			rs.movenext
		
	
		  
	   wend
	   %>
        
	   <tr>
	   <td colspan="17" bgcolor="#CCCCCC" class="celula">Total Registros :<%=cont%></td>
      </tr>
	   <%
	else
		%>
		  <tr>
			<td height="12" colspan="17" align="center" class="celula"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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
