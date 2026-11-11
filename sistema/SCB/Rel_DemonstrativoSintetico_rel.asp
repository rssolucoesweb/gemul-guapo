<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/01/2009
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@hotmail.com
-->
<html>
<head>
<title><%=session("Titulo")%> - Alunos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<%
	
	strTituloRelatorio  	= "Demonstrativo Sintético de Atividades"
	strDataDia			  	= formataDataAP(date)
	
	strPaginaTitulo 	= "Rel_DemonstrativoSintetico_con.asp"
	
	strAnoLetivo		= Trim(Request("txtAnoLetivo"))
	intSemestre			= Trim(Request("cmbSemestre"))
	intCodCurso			= Trim(Request("cmbCurso"))
	intCodTurma			= Trim(Request("cmbTurma"))
	
	strTipoUsuario		= Trim(Request("cmbTipoUsuario"))
	intCodAutoria		= Trim(Request("cmbAutoria"))
	strTitulo			= Trim(Request("txtTitulo"))
	strCdu				= Trim(Request("txtCdu"))
	strDataInicial		= Trim(Request("txtDataInicial"))
	strDataFinal		= Trim(Request("txtDataFinal"))
	strAutor			= Trim(Request("txtAutor"))
	strPalavraChave		= Trim(Request("txtPalavraChave"))
	
	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="28%" align="center" class="celula"><div align="center"><strong>Total de Empr&eacute;stimo </strong></div></td>
		<td width="27%" class="celula"><div align="center"><strong>Total de Livros devolvidos </strong></div></td>
		<td width="22%" class="celula"><div align="center"><strong>Curso</strong></div></td>
		<td width="23%" class="celula"><div align="center"><strong>Tipo Usu&aacute;rio </strong> </div></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	
	sql = " SELECT Count(SCB_Emprestimo.Cod_Emprestimo) as TotalEmprestimo "
	sql = sql & " FROM SCB_Emprestimo " 
	sql = sql & " left JOIN SCA_ALUNO ON SCB_Emprestimo.Cod_aluno = SCA_ALUNO.Codigo "
	sql = sql & " left JOIN SRH_COLABORADOR ON SCB_Emprestimo.Cod_Colaborador = SRH_COLABORADOR.Codigo " 
	sql = sql & " left JOIN SCB_Comunidade ON SCB_Emprestimo.Cod_Comunidade = SCB_Comunidade.Codigo "
	sql = sql & " left Join SCB_EmprestimoItens on SCB_EmprestimoItens.Cod_Emprestimo = SCB_Emprestimo.Cod_Emprestimo "
	sql = sql & " left Join SCB_PUBLICACAO P on P.Cod_Publicacao = SCB_EmprestimoItens.Cod_PublicacaoExemplares "
	sql = sql & " inner join SCB_PublicacaoExemplares E on E.Cod_Publicacao = P.Cod_Publicacao"
	sql = sql & "  WHERE SCB_Emprestimo.Situacao = 'E' "
	
	if strTipoUsuario <> 0 then
		sql = sql & " and SCB_Emprestimo.Cod_TipoUsuario = " & strTipoUsuario
	end if
	
	if intCodAutoria <> 0 then
		sql = sql & " and  P.Cod_Autoria = " & intCodAutoria
	end if
	
	if strTitulo <> "" then
		sql = sql & " and P.Titulo LIKE '%" & strTitulo & "%'"
	end if
	
	if strCdu <> "" then
		sql = sql & " AND SUBSTRING(P.COD_CDU,1," & len(strCdu) & " ) = '" & strCdu & "'" 
	end if
	
	if trim(strDataInicial) <> "" or trim(strDataFinal) <> "" then
		sql = sql & " and convert(datetime,convert(varchar, DataEmprestimo, 103),103) >=  convert(datetime, ' " & strDataInicial & "',103)"
		sql = sql & " and convert(datetime,convert(varchar, DataEmprestimo, 103),103) <=  convert(datetime, ' " & strDataFinal & "',103)"
	end if
	
	if trim(strAutor) <> "" or trim(strPalavraChave) <> "" then
	
		sql = sql & " and E.Cod_PublicacaoExemplares in "
		sql = sql & " ("
		sql = sql & " 	select	distinct E.Cod_PublicacaoExemplares "
		sql = sql & " 	from	SCB_PUBLICACAO P"
		sql = sql & " 	inner	join SCB_PUBLICACAOAUTORES PA		on P.cod_publicacao		= PA.cod_publicacao"
		sql = sql & " 	inner	join SCB_Autores A					on A.Cod_Autor			= PA.Cod_Autor and A.cod_empresa = P.cod_empresa"
		sql = sql & " 	inner	join SCB_PUBLICACAOEXEMPLARES E		on P.Cod_Publicacao		= E.Cod_Publicacao"
		sql = sql & " 	inner	join SCB_PUBLICACAOPALAVRACHAVE PPC on PPC.Cod_Publicacao	= P.Cod_Publicacao "
		sql = sql & " 	inner	join SCB_PALAVRACHAVE PC			on PC.Cod_Palavra		= PPC.Cod_PalavraChave and PC.cod_empresa = P.cod_empresa"
		sql = sql & " 	where	1=1"
		sql = sql & " 	and		P.cod_empresa		= " & Session("CodEmpresa")
		sql = sql & " 	and		E.Cod_TipoUsuario is null "
		
		if strAutor <> "" then
			sql = sql & " and A.Nome_Autor LIKE '%" & strAutor & "%'"
		end if
		
		if strPalavraChave <> "" then
			sql = sql & " and PC.Nome_Palavra LIKE '%" & strPalavraChave & "%'"
		end if
		
		sql = sql & " )"
	
	end if
	
	rs.open sql, cnn

	if not rs.eof then 
		intTotal	= rs("TotalEmprestimo")
	end if
	rs.close
	
		   %>
		   <tr>
		   <td class="celula" align="center"><%=intTotal%>&nbsp;</td>
		   <td class="celula" align="center"><%=intTotal%>&nbsp;</td>
		   <td class="celula"><%=intTotal%>&nbsp;</td>
		   <td class="celula"><%=intTotal%></td>
		   </tr>
			   	
		  <tr>
			<td colspan="4" class="celula">Quantidade: <%=cont%></td>
		  </tr>
		  </table>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>