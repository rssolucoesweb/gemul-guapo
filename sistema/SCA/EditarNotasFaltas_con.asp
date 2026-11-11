
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 14/09/2007
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: Consulta de Aluno 
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
<script type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
//-->
</script></head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>
<script>
	function ExcluirNotasFaltas(Codigo){
		var men = 'ATENCAO: \nO Registro de Notas do Aluno sera exluido, deseja continuar?';
		if (confirm(men)) {
			window.open("ExcluirNotasFaltas_cod.asp?Codigo=" + Codigo,"disciplina", "top=0,left=0,height=10,width=10,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		}
	}

</script>
<%
	strCodAluno					= Trim(Request("cod_aluno"))
	
	strDesabilitaIncluir		= "disabled" 'Desabilita o botão Incluir
	strDesabilitaAlterar 		= "disabled" 'Desabilita o botão Excluir
	strDesabilitaExcluir		= "disabled" 'Desabilita o botão Excluir
	
%>
<form method="POST" id="frm" action="#">
<table width="1207" align="center" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="1196" height="45" colspan="2" align="center" class="tituloPrincipal" border="0">ARQUIVO DE NOTAS</td>
          </tr>
        </table>
		<br>
		<table width = "1207" border="1" align="center" cellpadding="0" cellspacing="0" class="tabela">
		  <tr bgcolor="#E5E5E5">
		    <td height="39" class="celula"><strong>Excluir </strong></td>
		    <td class="celula"><strong>C&oacute;digo</strong></td>
			<td width="2%" bgcolor="#E5E5E5" class="celula"><strong>Ano</strong></td>
			<td width="3%" bgcolor="#E5E5E5" class="celula"><strong>Sem</strong></td>
		    <td width="23%" bgcolor="#E5E5E5" class="celula"><strong>Disciplina</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>N01</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>N02</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>N03</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>N04</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>N05</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>N06</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>N07</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>N08</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>N09</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>N10</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>N11</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>N12</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>N13</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>N14</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>N15</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>F01</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>F02</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>F03</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>F04</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>F05</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>F06</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>F07</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>F08</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>F09</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>F10</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>F11</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>F12</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>F13</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>F14</strong></td>
		    <td width="2%" bgcolor="#E5E5E5" class="celula"><strong>F15</strong></td>
		    <td width="4%" bgcolor="#E5E5E5" class="celula"><strong>M&eacute;dia</strong></td>
	      </tr>
		  <%
			cont =0
			if trim(strCodAluno) <> "" then
			
				sql = " select "
				sql = sql & " nf.codigo, "
				sql = sql & " nf.cod_empresa, "
				sql = sql & " nf.cod_aluno, "
				sql = sql & " nf.cod_aluno_disciplina, "
				sql = sql & " nf.ano_letivo, "
				sql = sql & " nf.semestre, "
				sql = sql & " nf.cod_periodo, "
				sql = sql & " nf.cod_disciplina, "
				sql = sql & " nf.nota01, "
				sql = sql & " nf.falta01, "
				sql = sql & " nf.nota02, "
				sql = sql & " nf.falta02, "
				sql = sql & " nf.nota03, "
				sql = sql & " nf.falta03, "
				sql = sql & " nf.nota04, "
				sql = sql & " nf.falta04, "
				sql = sql & " nf.nota05, "
				sql = sql & " nf.falta05, "
				sql = sql & " nf.nota06, "
				sql = sql & " nf.falta06, "
				sql = sql & " nf.nota07, "
				sql = sql & " nf.falta07, "
				sql = sql & " nf.nota08, "
				sql = sql & " nf.falta08, "
				sql = sql & " nf.nota09, "
				sql = sql & " nf.falta09, "
				sql = sql & " nf.nota10, "
				sql = sql & " nf.falta10, "
				sql = sql & " nf.nota11, "
				sql = sql & " nf.falta11, "
				sql = sql & " nf.nota12, "
				sql = sql & " nf.falta12, "
				sql = sql & " nf.nota13, "
				sql = sql & " nf.falta13, "
				sql = sql & " nf.nota14, "
				sql = sql & " nf.falta14, "
				sql = sql & " nf.nota15, "
				sql = sql & " nf.falta15, "
				sql = sql & " nf.situacao, "
				sql = sql & " nf.media, d.Desc_Disciplina "
				sql = sql & " from SCA_NOTAS_FALTAS nf "
				sql = sql & " inner join SCA_DISCIPLINA d on d.Cod_Disciplina = nf.Cod_Disciplina"
				sql = sql & " where nf.cod_aluno = " & strCodAluno
				sql = sql & " order by d.desc_disciplina"
				rs.open sql, cnn
				if rs.eof = false then
					while not rs.eof
						cont = cont + 1
						%>
						  <tr bgcolor="#FFFFFF"  style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
						    <td width="4%" class="celula"><div align="center"><a href="#" onClick="ExcluirNotasFaltas('<%=rs("codigo")%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image<%=rs("codigo")%>','','<%=session("strCaminhoRaiz")%>/images/botao_vermelho_over.gif',1)"><img alt="Clique para excluir a disciplina da grade do aluno." align="absmiddle" src="<%=session("strCaminhoRaiz")%>/images/botao_vermelho_normal.gif" name="Image<%=rs("codigo")%>" width="26" height="26" border="0"></a></div></td>
						    <td width="4%" height="26" class="celula">&nbsp;<%=trim(rs("codigo"))%></td>
							<td class="celula"><%=trim(rs("ano_letivo"))%>&nbsp;</td>
							<td class="celula"><div align="left"><%=trim(rs("semestre"))%>&nbsp;</div></td>
						    <td class="celula"><%=trim(rs("Desc_Disciplina"))%></td>
						    <td class="celula"><div align="center"><%=trim(rs("nota01"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("nota02"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("nota03"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("nota04"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("nota05"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("nota06"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("nota07"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("nota08"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("nota09"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("nota10"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("nota11"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("nota12"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("nota13"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("nota14"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("nota15"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("falta01"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("falta02"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("falta03"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("falta04"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("falta05"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("falta06"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("falta07"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("falta08"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("falta09"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("falta10"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("falta11"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("falta12"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("falta13"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("falta14"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("falta15"))%>&nbsp;</div></td>
						    <td class="celula"><div align="center"><%=trim(rs("media"))%>&nbsp;</div></td>
					      </tr>
						<%				
						rs.movenext
					wend
					%>
					<tr> 
					<td height="21" colspan="36" class="celula"><span class="celula">Total Registros :</span> <%=cont%></td>
                    </tr>
					<%
				end if
				rs.close
			end if
			%>
	</table>
</form>
</body>
</html>
