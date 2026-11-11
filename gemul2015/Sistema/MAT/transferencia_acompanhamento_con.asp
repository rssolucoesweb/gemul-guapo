<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css"></head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<style>
.celula_acompanhamento {
    border-top: 0px solid #FFFFFF;
    border-left: 1px solid #FFFFFF;
    border-bottom: 1px solid #000000;
    border-right: 0px solid #000000;
    border-color: #B9B9B9;
    font-family: Verdana;
    font-size: 9px;
    color: #000000;
}
</style>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<script>
	function alterar(codTransferencia){
		var form = document.getElementById("frm");
		frm.action = "transferencia_cad.asp?cod_transferencia="+codTransferencia;
		frm.submit();
		return true;	
	}
	function Consultar(){
		var caminho;
		frm.submit();
		return true;	
	}
	function emitirComprovante(codigo){
		window.open("transferencia_rel.asp?id="+codigo,"Comprovantes","top=0,left=0,height=543,width=793,menubar=no,toolbar=no,scrollbars=yes,status=yes");
 	}
	
	function mostraMotivo(codTransferencia){
		window.open("transferencia_gerenciamento_motivo_cancelamento_con.asp?codTransferencia="+codTransferencia,"Motivo","top=0,left=0,height=500,width=500,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}
</script>
<%
	pagina						= "Transferencia_Acompanhamento_con.asp"
	strPaginaTitulo				= "Transferencia_Acompanhamento_con.asp"
	
	strCod_empresa 				= Session("CodEmpresa")
	strMatricula				= Trim(Request("txtMatricula"))
	strNomealuno 				= Trim(Request.Form("txtNomealuno"))
	situacao_transferencia 		= Trim(Request.Form("cmbSituacaoTransferencia"))
	if situacao_transferencia = "" then situacao_transferencia = "0"
%>
<form method="post" id="frm" action="#">
<table width="100%" height="266" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
<tr>
		  <td height="22" colspan="2" align="center" class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></td>
		</tr>
		<tr>
		  <td height="15" colspan="2" align="left" valign="middle" bgcolor="#CCCCCC"  class="texto"><strong>Dados para Consulta</strong></td>
    </tr>
		<tr>
		  <td height="12" colspan="2" align="right" valign="middle"  class="texto">&nbsp;</td>
    </tr>
	<tr >
		  <td height="24" align="right" class="texto" valign="middle">Situação:</td>
		  <td align="left"><!--#include file="../includes/inc_cmbSituacaoTransferencia.asp" --></td>
    </tr>
		<tr>
		  <td width="10%" height="24" align="right" valign="middle"  class="texto">Inscri&ccedil;&atilde;o:</td>
		  <td width="90%" align="left">
			  <span class="texto1">
				<input name="txtMatricula" type="text" class="text" id="txtMatricula" size="20" maxlength="10" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 15)" onBlur="submit()">
			  </span>
		  </td>
    </tr>
		<tr>
		  <td height="12" align="right" class="texto" valign="middle">Nome do Aluno:</td>
		  <td align="left"><span class="texto1">
		    <input name="txtNomealuno" type="text" class="text" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>"  onKeyPress="return formataCampo(this, 1, 50)" onBlur="carregaAlunoSeJaExiste()">
		    <input type="button" name="cmdConsultar" id="cmdConsultar" style="cursor:hand"   value="Consultar" class="botao" <%=strDesabilitaIncluir%> onClick="return Consultar()">
			<input type="button" name="cmdLimpar"  value="Limpar"  class="botao" onClick="window.location='Transferencia_Acompanhamento_con.asp'"></span></td>
    </tr>
		<tr>
		  <td height="12" colspan="2" align="center">&nbsp;</td>
    </tr>
		<tr>
		  <td height="15" colspan="2" align="left" bgcolor="#CCCCCC" class="texto"><strong>Rela&ccedil;&atilde;o de Alunos</strong></td>
    </tr>
		<tr>
		  <td height="48" colspan="2" align="center">
				<br>
				<table width="98%" border="1" cellspacing="0" cellpadding="0" class="tabela">
				  <tr bgcolor="#CCCCCC">
					<td width="4%" class="celula_acompanhamento"><strong>Data </strong></td>
					<td width="5%" class="celula_acompanhamento"><strong>Inclusão </strong></td>
					<td width="3%" class="celula_acompanhamento"><strong>Matricula</strong></td>
					<td width="20%" class="celula_acompanhamento"><strong>Nome Aluno</strong></td>
					<td width="15%" class="celula_acompanhamento"><strong>Curso</strong></td>
					<td width="5%" class="celula_acompanhamento"><strong>Ser&iacute;e</strong></td>
					<td width="5%" class="celula_acompanhamento"><strong>Turno</strong></td>
					<td width="16%" class="celula_acompanhamento"><strong>Escola 1ª opção</strong></td>
					<td width="16%" class="celula_acompanhamento"><strong>Escola 2ª opção</strong></td>
					<td width="16%" class="celula_acompanhamento"><strong>Escola 3ª opção</strong></td>
					<td width="8%" class="celula_acompanhamento"><strong>Situação</strong></td>
				  </tr>
				  <%
					intPagina = 1
					intQtdeRegistroPorPagina = 1
					cont = 0
					
					
					sql = " select t.codigo as Cod_transferencia,"
					sql = sql & " 		t.matricula,"
					sql = sql & " 		t.nome,"
					sql = sql & " 		replace(t.curso,'_',' ') as curso,"
					sql = sql & " 		replace(t.periodo,'_',' ') as periodo,"
					sql = sql & " 		replace(t.turno,'_',' ') as turno,"
					sql = sql & " 		e1.razaosocial as empresa1,"
					sql = sql & " 		e2.razaosocial as empresa2,"
					sql = sql & " 		e3.razaosocial as empresa3,"
					sql = sql & " 		t.usuario_incl,"
					sql = sql & " 		t.data_hora_incl,"
					sql = sql & " 		t.situacao as sit,"
					sql = sql & " 		case"	
					sql = sql & " 			when t.situacao = 'A' then 'Aguardando atendimento'"
					sql = sql & " 			when t.situacao = 'F' then 'Concluída'"
					sql = sql & " 			when t.situacao = 'C' then 'Cancelada'"
					sql = sql & " 			else"
					sql = sql & " 				'---'"
					sql = sql & " 		end as situacao, c.descricao as motivo"
					sql = sql & " from mat_transferencia t"
					sql = sql & " inner join seg_empresa e1 on e1.codigo = t.cod_empresa_1opcao"
					sql = sql & " left  join seg_empresa e2 on e2.codigo = t.cod_empresa_2opcao"
					sql = sql & " left  join seg_empresa e3 on e3.codigo = t.cod_empresa_3opcao"
					sql = sql & " left  join mat_transferencia_cancelamento c on c.cod_transferencia = t.codigo"

					sql = sql & " where  t.Cod_empresa = " & strCod_empresa
					if situacao_transferencia <> "0" then
						sql = sql & " and t.Situacao = '" & situacao_transferencia & "'"
					end if
					if strMatricula <> "" then
						sql = sql & " and t.matricula = '" & strMatricula & "'"
					end if
					
					if strNomealuno <> "" then
						sql = sql & " And  t.nome like '%" & strNomealuno & "%'"
					end if
					rs.open sql, cnn
					if not rs.eof then 
						While not rs.eof
							'cor letra
							cor = "#0000FF"
							if rs("sit") = "F" then
								cor = "#red"
							elseif rs("sit") = "C" then
								cor = "#DF0101"
							end if
							
							motivo = ""
							if not isnull(rs("motivo")) then
								motivo = " Motivo"
							end if
							
							%>
						  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)">
							<td  onClick="return alterar('<%=rs("Cod_transferencia")%>')" align="left" class="celula_acompanhamento"><%=rs("data_hora_incl")%></td>
							<td  onClick="return alterar('<%=rs("Cod_transferencia")%>')" align="left" class="celula_acompanhamento"><%=rs("usuario_incl")%></td>
							<td  onClick="return alterar('<%=rs("Cod_transferencia")%>')" align="left" class="celula_acompanhamento"><%=rs("matricula")%>&nbsp;</td>
							<td  onClick="return alterar('<%=rs("Cod_transferencia")%>')" align="left" class="celula_acompanhamento"><%=rs("nome")%></td>
							<td  onClick="return alterar('<%=rs("Cod_transferencia")%>')" align="left" class="celula_acompanhamento"><%=rs("curso")%></td>
							<td  onClick="return alterar('<%=rs("Cod_transferencia")%>')" align="left" class="celula_acompanhamento"><%=rs("periodo")%></td>
							<td  onClick="return alterar('<%=rs("Cod_transferencia")%>')" align="left" class="celula_acompanhamento"><%=rs("turno")%></td>
							<td  onClick="return alterar('<%=rs("Cod_transferencia")%>')" align="left" class="celula_acompanhamento"><%=rs("empresa1")%></td>
							<td  onClick="return alterar('<%=rs("Cod_transferencia")%>')" align="left" class="celula_acompanhamento"><%=rs("empresa2")%></td>
							<td  onClick="return alterar('<%=rs("Cod_transferencia")%>')" align="left" class="celula_acompanhamento"><%=rs("empresa3")%></td>
							<td  align="center" class="celula_acompanhamento"><font color="<%=cor%>"><%=rs("situacao")%><%=motivo%></font>
							<%if rs("sit") = "C" then%>
								<a href="#" onClick="mostraMotivo('<%=rs("Cod_transferencia")%>')" ><img style="width:20px; height:20px" src="../../../images/botao_verde_normal.gif" alt="Mostrar o motivo do cancelamento"></a>
							<%elseif rs("sit") = "F" then%>
								<a href="#" onClick="emitirComprovante('<%=rs("Cod_transferencia")%>')" ><img style="width:20px; height:20px" src="../../../images/impressora_on.gif" alt="Emitir comprovante de transferência"></a>
							<%end if%>
							</td>
						  </tr>
						  <%
							cont = cont + 1
							intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
							rs.movenext
						wend
						%>
				  <tr bgcolor="#CCCCCC">
					<td colspan="11" class="celula_acompanhamento">Quantidade de registros: <%=cont%></td>
				  </tr>
				  <%
					else
						%>
				  <tr>
					<td height="48" colspan="11" align="center" class="celula_acompanhamento"><p><br>
							<font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></p></td>
				  </tr>
				  <%
					end if
					rs.close
				%>
				</table>
				<br>
				<br>		  
		</td>
	</tr>
  </table>

</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
