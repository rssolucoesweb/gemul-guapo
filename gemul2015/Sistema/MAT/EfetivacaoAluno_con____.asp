<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<script>
	function DadosDoAluno(CodAluno){
		var form = document.getElementById("frm");
		frm.action = "../SCA/Aluno_cad.asp?txtCodAluno="+CodAluno;
		frm.submit();
		return true;	
	}
	
	function Consultar(){
		var caminho;
		frm.submit();
		return true;	
	}
	
</script>
<%
	pagina	= "EfetivacaoAluno_con.asp"
	Session("MatriculaInformatizada") =  "SIM"
	strCod_empresa 		= Session("CodEmpresa")
	intInscricao		= Trim(Request("txtInscricao"))
	strNomealuno 		= Trim(Request.Form("txtNomealuno"))
%>
<form method="post" id="frm" action="#">
<table width="100%" height="266" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
<tr valign="top">
		  <td height="22" colspan="2" align="center" class="tituloSistema">Rela&ccedil;&atilde;o de Inscrito na Matricula <%=year(date)%></td>
		</tr>
		<tr valign="top">
		  <td height="15" colspan="2" align="left" valign="middle" bgcolor="#CCCCCC"  class="texto"><strong>Dados para Consulta</strong></td>
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
<table width="98%" border="1" cellspacing="0" cellpadding="0" class="tabela">
  <tr bgcolor="#CCCCCC">
    <td width="5%" class="celula"><strong>Inscri&ccedil;&atilde;o</strong></td>
    <td width="5%" class="celula"><strong>Matricula</strong></td>
    <td width="13%" class="celula"><strong>Nome Aluno</strong></td>
    <td width="6%" class="celula"><strong>Data Nasc.</strong></td>
    <td width="14%" class="celula"><strong>M&atilde;e</strong></td>
    <td width="8%" class="celula"><strong>Ser&iacute;e</strong></td>
    <td width="7%" class="celula"><strong>Turno</strong></td>
    <td width="16%" class="celula"><strong>Curso</strong></td>
    <td width="26%" class="celula"><strong>Escola</strong></td>
  </tr>
  <%
	intPagina = 1
	intQtdeRegistroPorPagina = 1
	cont = 0
	
	sql = "SELECT MT.Codigo, MT.Cod_Aluno, MT.matricula, MT.nome, MT.data_nascimento, MT.mae, MT.cep, MT.Logradouro, "
	sql = sql & " MT.bairro, MT.cidade, MT.email, MT.Cod_periodo, MT.Cod_turno, MT.Cod_empresa, "
	sql = sql & " PE.Descricao, T.DESC_TURNO, SEG_EMPRESA.RAZAOSOCIAL, C.Descricao as Curso"
	sql = sql & " FROM MAT_inscricao  MT "
	sql = sql & " inner join SCA_PERIODO PE on PE.Cod_Periodo = MT.Cod_periodo"
	sql = sql & " inner join SCA_CURSO C on C.Cod_curso = PE.Cod_Curso"
	sql = sql & " inner join SCA_TURNO T on T.COD_TURNO = MT.Cod_turno"
	SQL = SQL & " INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = MT.COD_EMPRESA"
	sql = sql & " where  MT.Cod_empresa = " & strCod_empresa
	sql = sql & " And  MT.Situacao = 'S'"
	sql = sql & " And  isnull(MT.Efetivacao,'N') = 'N'"

	if intInscricao <> "" then
		sql = sql & " And  MT.Cod_Aluno = " & intInscricao
	end if
	
	if strNomealuno <> "" then
		sql = sql & " And  MT.nome like '%" & strNomealuno & "%'"
	end if
	
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			%>
  <tr style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return DadosDoAluno('<%=rs("Cod_Aluno")%>')">
    <td height="25" align="left" class="celula"><%=rs("Cod_Aluno")%>&nbsp;</td>
    <td align="left" class="celula"><%=rs("matricula")%>&nbsp;</td>
    <td align="left" class="celula"><%=rs("nome")%>&nbsp;</td>
    <td align="left" class="celula"><%=formatadataAP(rs("data_nascimento"))%>&nbsp;</td>
    <td align="left" class="celula"><%=rs("mae")%></td>
    <td align="left" class="celula"><%=rs("Descricao")%></td>
    <td align="left" class="celula"><%=rs("DESC_TURNO")%></td>
    <td align="left" class="celula"><%=rs("Curso")%></td>
    <td align="left" class="celula"><%=rs("RAZAOSOCIAL")%></td>
  </tr>
  <%
			cont = cont + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend
		%>
  <tr bgcolor="#CCCCCC">
    <td colspan="9" class="celula">Quantidade de Candidatos: <%=cont%></td>
  </tr>
  <%
	else
		%>
  <tr>
    <td height="48" colspan="9" align="center" class="celula"><p><br>
            <font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></p></td>
  </tr>
  <%
	end if
	rs.close
%>
</table>
<br>
<br>		  </td>
	</tr>
  </table>

</form>
<!--#include file="../rodape.asp"-->
</body>
</html>
