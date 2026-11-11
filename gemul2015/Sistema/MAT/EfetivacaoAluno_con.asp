<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css"></head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<script>
	function Confirmar(CodAluno){
		var form = document.getElementById("frm");
		frm.action = "ConfirmacaoAluno_con.asp?txtCodAluno="+CodAluno;
		frm.submit();
		return true;	
	}
	function Consultar(){
		var caminho;
		frm.submit();
		return true;	
	}
	//Comprovante da TIP em janela de impressão
	function imprimirTip(codigo){
		var janela = window.open("tip_rel.asp?txtCodTip=" + codigo, "comprovanteTip", "width=950,height=750,scrollbars=yes,resizable=yes");
		if (janela) janela.focus();
		return false;
	}
	
	function efetivarTip(codigo, nome, turma, anoDestino, unidadeOrigem){
					var frm = document.getElementById("frm");
			var anoOrigem = parseInt(anoDestino, 10) - 1;
			if (!confirm("Confirma a EFETIVAÇÃO da TIP de " + nome + "?\n\n"
				+ "O aluno será alocado para o ano letivo " + anoDestino + " nesta unidade, na turma " + turma + ".\n\n"
				+ "Na unidade de origem (" + unidadeOrigem + ") ele finalizará o ano letivo de " + anoOrigem + " normalmente, com notas, faltas e histórico do ano."))
				return false;
			frm.txtCodTip.value = codigo;
			frm.action = "tip_cod.asp?acao=F";
			frm.submit();
			return true;
		}
	
</script>



		<!--script>
			//alert("Confirmação da matrícula terá inicío dia 08/01/2018 às 8h.");
			//window.history.back();
		</script-->
		<%
		'response.End()
%>
<%

	pagina	= "EfetivacaoAluno_con.asp"
	Session("MatriculaInformatizada") =  "SIM"
	Session("MatriculaInformatizadaAnoEfetivacao") =  "2026"

	dinamico = "N"
	sql = "select PERIODO_DINAMICO, ano_matricula from MAT_configuracoes where cod_grupo=" & session("codGrupo")
	rs.open sql, cnn
	if not rs.eof then
		Session("MatriculaInformatizadaAnoEfetivacao")	= rs("ano_matricula") '***IMPORTANTE ANO DA MATRÍCULA DEVE SER INFORMADO NA TELA DE CONFIGURAÇÕES
	end if
	rs.close



	strCod_empresa 		= Session("CodEmpresa")
	intTipo		= Trim(Request("cmbTipo"))
	if intTipo = "" then intTipo = "1"
	'Função: NOVO = aluno novato (inscrição) | TIP = transferência por interesse próprio para esta unidade
	strFuncao = ucase(Trim(Request("cmbFuncao")))
	if strFuncao <> "TIP" then strFuncao = "NOVO"
	intAnoTipOrigem = 0
	if isnumeric(Session("strAnoLetivo") & "") and trim(Session("strAnoLetivo") & "") <> "" then intAnoTipOrigem = clng(Session("strAnoLetivo"))
	'Ano mostrado no título e usado nas listas: ano letivo da sessão (topo da tela)
	'novatos = inscrições de mat_reserva.ano | TIP = TIP com destino neste ano
	strAnoTitulo = intAnoTipOrigem
	intInscricao		= Trim(Request("txtInscricao"))
	strNomealuno 		= Trim(Request.Form("txtNomealuno"))
	strBotaoVoltaTelaAnterior = "N"

	
	strCod_empresa 		= Session("CodEmpresa")
	intInscricao		= Trim(Request("txtInscricao"))
	strNomealuno 		= Trim(Request.Form("txtNomealuno"))
%>
<form method="post" id="frm" action="#">
<table width="100%" height="266" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
<tr valign="top">
		  <td height="22" colspan="2" align="center" class="tituloSistema">Rela&ccedil;&atilde;o de Inscrito na Matricula <%=Session("MatriculaInformatizadaAnoEfetivacao")%></td>
		</tr>
		<tr valign="top">
		  <td height="15" colspan="2" align="left" valign="middle" bgcolor="#CCCCCC"  class="texto"><strong>Dados para Consulta</strong></td>
    </tr>
		<tr valign="top">
		  <td height="12" colspan="2" align="right" valign="middle"  class="texto">&nbsp;</td>
    </tr>
	</tr>
		<tr valign="top">
		  <td height="12" align="right" valign="middle"  class="texto">Efetivação de:</td>
		  <td height="12" align="left" valign="middle"  class="texto">
		  <select name="cmbFuncao" id="cmbFuncao" class="combo" onchange="submit()">
			<option value="NOVO" <% if strFuncao = "NOVO" then response.Write("selected")%>>Alunos novatos (inscrição site)</option>
			<option value="TIP" <% if strFuncao = "TIP" then response.Write("selected")%>>TIP - Transferência por interesse próprio</option>
		</select>
		  
		  </td>
    </tr>
	</tr>
		<tr valign="top">
		  <td height="12" colspan="2" align="right" valign="middle"  class="texto">&nbsp;</td>
    </tr>
	
		<tr valign="top">
		  <td width="10%" height="24" align="right" valign="middle"  class="texto">Inscri&ccedil;&atilde;o:</td>
		  <td width="90%" align="left" valign="top"><span class="texto1">
		    <input name="txtInscricao" type="text" class="text" id="txtInscricao" size="20" maxlength="10" value="<%=intInscricao%>"  onKeyPress="return formataCampo(this, 2, 10)" onBlur="submit()">
		  </span></td>
    </tr>
		<tr valign="top">
		  <td height="12" align="right" class="texto" valign="middle">Nome do Aluno:</td>
		  <td align="left"><span class="texto1">
		    <input name="txtNomealuno" type="text" class="text" id="txtNomealuno" size="50" maxlength="50" value="<%=strNomealuno%>"  onKeyPress="return formataCampo(this, 1, 50)" onBlur="carregaAlunoSeJaExiste()">
		    <input type="button" name="cmdConsultar" id="cmdConsultar" style="cursor:hand"   value="Consultar" class="botao" <%=strDesabilitaIncluir%> onClick="return Consultar()">
		  <input type="button" name="cmdLimpar"  value="Limpar"  class="botao" <%=strDesabilitaLimpar%>  onclick="return limpar('<%=pagina%>')"></span></td>
    </tr>
		<tr valign="top">
		  <td height="12" colspan="2" align="center">&nbsp;</td>
    </tr>
		<tr valign="top">
		  <td height="15" colspan="2" align="left" bgcolor="#CCCCCC" class="texto"><strong>Rela&ccedil;&atilde;o de Alunos</strong></td>
    </tr>
		<tr valign="top">
		  <td height="48" colspan="2" align="center">
<br>

<%if strFuncao = "TIP" then
	'=====================================================================
	' TIP - transferência por interesse próprio PARA esta unidade
	'	Não efetivados: TIP pendente (aluno ainda ativo na origem) -> Efetivar
	'	Efetivados: TIP efetivada -> Desfazer (SP_MAT_TipDesfaz) e Imprimir
	'=====================================================================
	vetTipEfet = ""
	sql = "SELECT TIP.CODIGO, A.MATRICULA, A.NOMEALUNO, A.DATANASCIMENTO, A.MAE,"
	sql = sql & " EO.RAZAOSOCIAL AS UNIDADE_ORIGEM,"
	sql = sql & " LTRIM(RTRIM(ISNULL(PO.Descricao,'') + ' ' + ISNULL(TOR.TurmaAluno,'') + ' ' + ISNULL(TOR.NomeTurma,''))) AS TURMA_ORIGEM,"
	sql = sql & " LTRIM(RTRIM(ISNULL(PD.Descricao,'') + ' ' + ISNULL(TDE.TurmaAluno,'') + ' ' + ISNULL(TDE.NomeTurma,''))) AS TURMA_DESTINO,"
	sql = sql & " TUD.Desc_Turno AS TURNO_DESTINO, TIP.USUARIO_INCL, TIP.DATA_HORA_INCL, TIP.USUARIO_EFETIVACAO, TIP.DATA_HORA_EFETIVACAO,"
	sql = sql & " ISNULL(TIP.ANO_LETIVO_DESTINO, TIP.ANO_LETIVO + 1) AS ANO_DESTINO"
	sql = sql & " FROM SCA_TRANSFERENCIA_INTERESSE_PROPRIO TIP"
	sql = sql & " INNER JOIN SCA_ALUNO A ON A.CODIGO = TIP.COD_ALUNO"
	sql = sql & " LEFT JOIN SEG_EMPRESA EO ON EO.CODIGO = TIP.COD_EMPRESA"
	sql = sql & " LEFT JOIN SCA_TURMA TOR ON TOR.Cod_Turma = TIP.COD_TURMA"
	sql = sql & " LEFT JOIN SCA_PERIODO PO ON PO.Cod_Periodo = TOR.Cod_periodo"
	sql = sql & " LEFT JOIN SCA_TURMA TDE ON TDE.Cod_Turma = TIP.COD_TURMA_DESTINO"
	sql = sql & " LEFT JOIN SCA_PERIODO PD ON PD.Cod_Periodo = TDE.Cod_periodo"
	sql = sql & " LEFT JOIN SCA_TURNO TUD ON TUD.Cod_Turno = TIP.COD_TURNO_DESTINO"
	sql = sql & " WHERE TIP.COD_EMPRESA_DESTINO = " & clng("0" & strCod_empresa)
	'Só as TIP com destino no ano letivo da sessão (ex.: sessão 2027 = TIP feitas em 2026 para 2027)
	sql = sql & " AND ISNULL(TIP.ANO_LETIVO_DESTINO, TIP.ANO_LETIVO + 1) = " & intAnoTipOrigem
	sql = sql & " AND TIP.SITUACAO = 'P'"
	if strNomealuno <> "" then
		sql = sql & " AND A.NOMEALUNO COLLATE Latin1_General_CI_AI LIKE '%" & replace(strNomealuno, "'", "''") & "%'"
	end if
	sql = sql & " ORDER BY A.NOMEALUNO"
	rs.open sql, cnn
	if not rs.eof then vetTipEfet = rs.getRows
	rs.close
	'Colunas: 0 CODIGO | 1 MATRICULA | 2 NOMEALUNO | 3 DATANASCIMENTO | 4 MAE | 5 UNIDADE_ORIGEM | 6 TURMA_ORIGEM
	'         7 TURMA_DESTINO | 8 TURNO_DESTINO | 9 USUARIO_INCL | 10 DATA_HORA_INCL | 11 USUARIO_EFETIVACAO
	'         12 DATA_HORA_EFETIVACAO | 13 ANO_DESTINO
	%>
	<input type="hidden" name="txtCodTip" id="txtCodTip" value="">

	<%if not isArray(vetTipEfet) then%>
	<table width="98%" border="1" cellspacing="0" cellpadding="0" class="tabela">
	<tr>
		<td height="48" colspan="11" align="center" class="celula"><p><br>
            <font color="#993300">Nenhuma TIP aguardando efetivação para esta unidade em <%=intAnoTipOrigem%><br><br></font></p></td>
	</tr>	
	</table>
	<%else%>
	
	<table width="98%" border="1" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
			<td><strong>Matrícula</strong></td>
			<td><strong>Nome Aluno</strong></td>
			<td><strong>Data Nasc.</strong></td>
			<td><strong>M&atilde;e</strong></td>
			<td><strong>Unidade de origem</strong></td>
			<td><strong>Turma de origem</strong></td>
			<td><strong>Turma de destino</strong></td>
			<td><strong>Solicitada por / em</td>
			<td class="text-center"><strong>Efetivar</strong></td>
			<td class="text-center"><strong>Imprimir</strong></t>
		</tr>
			<%
			for i = 0 to ubound(vetTipEfet, 2)
				strNomeTip = replace(replace(vetTipEfet(2, i) & "", "\", ""), "'", "\'")
				strMotivoBloqueio = ""
				if intTipo <> "1" then
					'Mesma validação do Desfazer: se já tem nota, falta ou avaliação na turma de destino, fica o cadeado
					set rsBloqueio = Server.CreateObject("adodb.recordset")
					rsBloqueio.open "EXEC SP_MAT_TipDesfaz " & clng(vetTipEfet(0, i)) & ", 1", cnn
					if not rsBloqueio.eof then strMotivoBloqueio = trim(rsBloqueio("MOTIVO") & "")
					rsBloqueio.close
					set rsBloqueio = nothing
				end if
			%>
				<tr>
					<td><%=vetTipEfet(1, i)%></td>
					<td><%=vetTipEfet(2, i)%></td>
					<td><%=formatadataAP(vetTipEfet(3, i))%></td>
					<td><%=vetTipEfet(4, i)%></td>
					<td><%=vetTipEfet(5, i)%></td>
					<td><%=vetTipEfet(6, i)%></td>
					<td><%=vetTipEfet(7, i)%><%if trim(vetTipEfet(8, i) & "") <> "" then%><br><small><%=vetTipEfet(8, i)%> - <%=vetTipEfet(13, i)%></small><%end if%></td>
					<%if intTipo = "1" then%>
					<td><%=vetTipEfet(9, i)%><br><small><%=vetTipEfet(10, i)%></small></td>
					<td class="text-center">
						<input type="button" name="cmdCancelar" style="cursor:hand"   value="Efetivar" class="botao" onClick="efetivarTip('<%=vetTipEfet(0, i)%>', '<%=strNomeTip%>', '<%=replace(replace(vetTipEfet(7, i) & "", "\", ""), "'", "\'")%>', '<%=vetTipEfet(13, i)%>', '<%=replace(replace(vetTipEfet(5, i) & "", "\", ""), "'", "\'")%>')"> 
					</td>
					<%else%>
					<td><%=vetTipEfet(11, i)%><br><small><%=vetTipEfet(12, i)%></small></td>
					<td class="text-center">
					<%if strMotivoBloqueio <> "" then%>
						<%=server.htmlEncode(strMotivoBloqueio)%>
					<%else%>
					<input type="button" name="cmdCancelar" style="cursor:hand"   value="Defazer" class="botao" onClick="desfazerTip('<%=vetTipEfet(0, i)%>', '<%=strNomeTip%>')"> 
					<%end if%>
					</td>
					<%end if%>
					<td class="text-center">
					<input type="button" name="cmdCancelar" style="cursor:hand"   value="Imprimir" class="botao" onClick="imprimirTip('<%=vetTipEfet(0, i)%>')"> 
					</td>
				</tr>
			<%next%>
				<tr>
					<td colspan="10"><strong><%if intTipo = "1" then%>Total de TIP para efetivar<%else%>Total de TIP efetivadas<%end if%>: <%=ubound(vetTipEfet, 2) + 1%></strong></td>
				</tr>
			
		</table>
		<%end if%>
	<%else%>


<table width="98%" border="1" cellspacing="0" cellpadding="0" class="tabela">
  <tr bgcolor="#CCCCCC">
    <td width="2%" height="16" class="celula"><strong>Insc.</strong></td>
    <td width="5%" class="celula"><strong>Data </strong></td>
    <td width="3%" class="celula"><strong>Matricula</strong></td>
	 <td width="4%" class="celula"><strong>Bolsa</strong></td>
    <td width="18%" class="celula"><strong>Nome Aluno</strong></td>
    <td width="4%" class="celula"><strong>Data Nasc.</strong></td>
    <td width="16%" class="celula"><strong>M&atilde;e</strong></td>
    <td width="3%" class="celula"><strong>Ser&iacute;e</strong></td>
    <td width="3%" class="celula"><strong>Turno</strong></td>
    <td width="15%" class="celula"><strong>Telefone</strong></td>
    <td width="16%" class="celula"><strong>Escola</strong></td>
  </tr>
  <%
	intPagina = 1
	intQtdeRegistroPorPagina = 1
	cont = 0
	
	sql = "SELECT MT.Codigo, MT.Cod_Aluno, MT.matricula, MT.nome, MT.data_nascimento, MT.mae, MT.cep, MT.Logradouro, MT.CONTATO, MT.CELULAR ,"
	sql = sql & " MT.bairro, MT.cidade, MT.email, MT.Cod_periodo, MT.Cod_turno, MT.Cod_empresa, "
	sql = sql & " PE.Descricao, T.DESC_TURNO, SEG_EMPRESA.RAZAOSOCIAL, C.Descricao as Curso, MT.Data_hora_Incl as DataInclusao, MT.usuario_incl, MT.bolsa_Familia"
	sql = sql & " FROM MAT_inscricao  MT "
	sql = sql & " inner join SCA_PERIODO PE on PE.Cod_Periodo = MT.Cod_periodo"
	sql = sql & " inner join SCA_CURSO C on C.Cod_curso = PE.Cod_Curso"
	sql = sql & " inner join SCA_TURNO T on T.COD_TURNO = MT.Cod_turno"
	SQL = SQL & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = MT.COD_EMPRESA"
	sql = sql & " where  MT.Cod_empresa = " & strCod_empresa
	sql = sql & " And  MT.Situacao = 'S'"
	sql = sql & " And  isnull(MT.Efetivacao,'N') = 'N'"
	sql = sql & " And 	isnull(mt.excluido,'N') = 'N'"


	if intInscricao <> "" then
		sql = sql & " And  MT.Cod_Aluno = " & intInscricao
	end if
	
	if strNomealuno <> "" then
		sql = sql & " And  MT.nome like '%" & strNomealuno & "%'"
	end if
	
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			TELEFONES = ""
			IF NOT ISNULL(rs("CONTATO")) THEN
				TELEFONES = rs("CONTATO")
				IF NOT ISNULL(rs("CELULAR")) THEN
					TELEFONES = TELEFONES & "/" & rs("CELULAR")
				END IF
			ELSE
				IF NOT ISNULL(rs("CELULAR")) THEN
					TELEFONES = TELEFONES & "/" & rs("CELULAR")
				END IF
			END IF
			
			%>
  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return Confirmar('<%=rs("Cod_Aluno")%>')">
    <td height="25" align="left" class="celula"><%=rs("Cod_Aluno")%>&nbsp;</td>
    <td align="left" class="celula"><%=formatadataAP(rs("DataInclusao"))%></td>
    <td align="left" class="celula"><%=rs("matricula")%>&nbsp;</td>
	<td align="left" class="celula"><%=rs("bolsa_Familia")%></td>
    <td align="left" class="celula"><%=rs("nome")%></td>
    <td align="left" class="celula"><%=formatadataAP(rs("data_nascimento"))%>&nbsp;</td>
    <td align="left" class="celula"><%=rs("mae")%></td>
    <td align="left" class="celula"><%=rs("Descricao")%></td>
    <td align="left" class="celula"><%=rs("DESC_TURNO")%></td>
    <td align="left" class="celula"><%=TELEFONES%></td>
    <td align="left" class="celula"><%=rs("RAZAOSOCIAL")%></td>
  </tr>
  <%
			cont = cont + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend
		%>
  <tr bgcolor="#CCCCCC">
    <td colspan="11" class="celula">Quantidade de Candidatos: <%=cont%></td>
  </tr>
  <%
	else
		%>
  <tr>
    <td height="48" colspan="11" align="center" class="celula"><p><br>
            <font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></p></td>
  </tr>
  <%
	end if
	rs.close
%>
</table>

<%end if%>
<br>
<br>		  </td>
	</tr>
  </table>

</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
