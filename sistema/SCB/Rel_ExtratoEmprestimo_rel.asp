<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/07/2010
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br 
	::	Objetivo Pagina...: Extrato Emprestimo
-->
<html>
<head>
<title><%=session("Titulo")%> - Alunos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script></head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<%
	strDataDia			  	= formataDataAP(date)
	strPaginaTitulo 	    = "Rel_EtiquetasAcervo_Rel.asp"
	intCodEmpresa			= Session("CodEmpresa")
	
	intCodAluno				= Trim(Request.Form("txtCodAluno"))
	intCodColaborador		= Trim(Request.Form("txtCodFuncionario"))
	intCodComunidade		= Trim(Request.Form("txtCodComunidade"))
	
	intTipoUsuario			= Trim(Request.Form("optTipoUsuario"))
	intCodAutoria			= Trim(Request.Form("cmbAutoria"))
	strAutor				= Trim(Request.Form("txtAutor"))
	strPalavraChave			= Trim(Request.Form("txtPalavraChave"))
	strTitulo				= Trim(Request.Form("txtTitulo"))
	strCdu					= Trim(Request.Form("txtCdu"))
	intCodExemplar			= Trim(Request.Form("txtCodExemplar"))
	strDataInicial			= Trim(Request.Form("txtDataInicial"))
	strDataFinal			= Trim(Request.Form("txtDataFinal"))
	strSituacaoEmprestimo	= Trim(Request("cmbSituacaoEmprestimo"))
	
	
	if intTipoUsuario = 1 then strTipoUsuario = "Aluno"
	if intTipoUsuario = 2 then strTipoUsuario = "Colaborador"
	if intTipoUsuario = 3 then strTipoUsuario = "Comunidade"
	
	strTituloRelatorio  = "Extrato Empr&eacute;stimo / Devolu&ccedil;&atilde;o - " & strTipoUsuario
	
	if trim(strDataInicial) <> "" or trim(strDataFinal) <> "" then
		strTituloRelatorio =  strTituloRelatorio & " Data Inicial " & FormataDataAP(trim(strDataInicial)) & " Data Final " &  strDataFinal(trim(strDataFinal))
	end if

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
    
    <%
	if intTipoUsuario = 1 then
		%>
		 <!--#include file="../includes/inc_sqlDadosEscolaresAluno.asp" -->
         <%
	end if
	
	if intTipoUsuario = 2 then
		%>
		 <!--#include file="../includes/inc_sqlDadosColaborador.asp" -->
<%
	end if
	
	%>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
	    <td width="11%" class="celula"><strong>C.D.U</strong></td>
	    <td width="45%" class="celula"><strong>T&iacute;tulo</strong></td>
        <% if intTipoUsuario = 1 then %>
			<td width="26%" class="celula"><strong>Aluno</strong></td>
         <% end if %>       
         <% if intTipoUsuario = 2 then %>  
			<td width="26%" class="celula"><strong>Colaborador</strong></td>
        <% end if %>    
		<td width="9%" class="celula"><strong>D. Empr&eacute;stimo</strong></td>
		<td width="9%" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	
	sql = " select PE.Cod_Publicacao, E.Cod_Emprestimo,  I.cod_item, I.DataDevolucao, P.Titulo, " 
	sql = sql & " P.SubTitulo, P.Cod_CDU, PE.Cod_PublicacaoExemplares, I.Status, E.DataEmprestimo, A.NOMEALUNO, C.nome "
	sql = sql & " From scb_emprestimo E "
	sql = sql & " Inner join SCB_EmprestimoItens I on I.Cod_Emprestimo = E.Cod_Emprestimo "
	sql = sql & " inner join SCB_PUBLICACAOEXEMPLARES PE on PE.Cod_PublicacaoExemplares = I.Cod_PublicacaoExemplares "
	sql = sql & " inner join SCB_PUBLICACAO P on P.Cod_Publicacao = PE.Cod_Publicacao "
	sql = sql & " left join SCA_ALUNO A on A.CODIGO = E.Cod_aluno "
	sql = sql & " left join SRH_COLABORADOR C on C.codigo = E.Cod_Colaborador "
	sql = sql & " WHERE E.cod_empresa = " & intCodEmpresa
	if strSituacaoEmprestimo = "E" then
   		sql = sql & "  and  E.Situacao = 'E' "
	end if

	if strSituacaoEmprestimo = "D" then
   		sql = sql & "  and  E.Situacao = 'D' "
	end if
	
	if intTipoUsuario = 1 then
		if intCodAluno <> "" then
			sql = sql & " AND E.Cod_aluno =  " & intCodAluno
		end if	
	end if
	
	if intTipoUsuario = 2 then
		if intCodColaborador <> "" then
			sql = sql & " AND E.Cod_Colaborador =  " & intCodColaborador
		end if	
	end if
	
	if intTipoUsuario = 3 then
		if intCodComunidade <> "" then
			sql = sql & " AND E.Cod_Comunidade =  " & intCodComunidade
		end if	
	end if
	
	if intCodAutoria <> 0 then
		sql = sql & " and  P.Cod_Autoria = " & intCodAutoria
	end if
	
	if strTitulo <> "" then
		sql = sql & " and P.Titulo LIKE '%" & strTitulo & "%'"
	end if
	
	if strCdu <> "" then
		sql = sql & " AND SUBSTRING(P.Cod_Cdu,1," & len(strCdu) & " ) = '" & strCdu & "'" 
	end if

	if intCodExemplar <> "" then
		sql = sql & " and  PE.Cod_PublicacaoExemplares = " & intCodExemplar
	end if
	
	if trim(strDataInicial) <> "" or trim(strDataFinal) <> "" then
		sql = sql & " and convert(datetime,convert(varchar, E.DataEmprestimo, 103),103) >=  convert(datetime, ' " & strDataInicial & "',103)"
		sql = sql & " and convert(datetime,convert(varchar,  E.DataEmprestimo, 103),103) <=  convert(datetime, ' " & strDataFinal & "',103)"
	end if
	
	if trim(strAutor) <> "" or trim(strPalavraChave) <> "" then
	
		sql = sql & " and I.Cod_PublicacaoExemplares in "
		sql = sql & " ("
		sql = sql & " 	select	distinct E.Cod_PublicacaoExemplares "
		sql = sql & " 	from	SCB_PUBLICACAO PP"
		sql = sql & " 	inner	join SCB_PUBLICACAOAUTORES PA		on PP.cod_publicacao		= PA.cod_publicacao"
		sql = sql & " 	inner	join SCB_Autores A					on A.Cod_Autor			= PA.Cod_Autor and A.cod_empresa = P.cod_empresa"
		sql = sql & " 	inner	join SCB_PUBLICACAOEXEMPLARES E		on P.Cod_Publicacao		= E.Cod_Publicacao"
		sql = sql & " 	inner	join SCB_PUBLICACAOPALAVRACHAVE PPC on PPC.Cod_Publicacao	= PP.Cod_Publicacao "
		sql = sql & " 	inner	join SCB_PALAVRACHAVE PC			on PC.Cod_Palavra		= PPC.Cod_PalavraChave and PC.cod_empresa = P.cod_empresa"
		sql = sql & " 	where	1=1"
		sql = sql & " 	and		PP.cod_empresa		= " & Session("CodEmpresa")
		sql = sql & " 	and		E.Cod_TipoUsuario is null "
		
		if strAutor <> "" then
			sql = sql & " and A.Nome_Autor LIKE '%" & strAutor & "%'"
		end if
		
		if strPalavraChave <> "" then
			sql = sql & " and PC.Nome_Palavra LIKE '%" & strPalavraChave & "%'"
		end if
		
		sql = sql & " )"
	
	end if
	sql = sql & " order by E.DataEmprestimo desc"
	rs.open sql, cnn

	if not rs.eof then
	 
	While not rs.eof
		  	
		  	if trim(rs("Status")) = "I" then
				strStatus = "Devolvido"
			else
				strStatus = "Emprestado"
			end if
		  
		   %>
           <tr>
             <td class="celula"><%=rs("Cod_CDU")%>&nbsp;</td>
             <td class="celula"><%=rs("Titulo")%>&nbsp;</td>
             <% if intTipoUsuario = 1 then %>
		  	 	<td class="celula"><%=rs("Nomealuno")%>&nbsp;</td>
             <% end if %>   
             <% if intTipoUsuario = 2 then %>
		  	 	<td class="celula"><%=rs("Nome")%>&nbsp;</td>
             <% end if %>   
		  	 <td class="celula"><%=formatadataAP(rs("DataEmprestimo"))%>&nbsp;</td>
             <td class="celula"><%=strStatus%></td>
           </tr>
           	<%
			'quantidade de registros da página
			if int(intQtdeRegistroPorPagina) = 50 then
				 intPagina = intPagina + 1
				 intQtdeRegistroPorPagina = 1
				 fimTabela
				%>
				<pre></pre>				
				<%			
				mostraCabecalho
			end if	
			cont = cont + 1
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend
		end if
		rs.close
		%>
		  <tr>
			<td colspan="7" class="celula"><strong>Total:</strong> <%=cont%></td>
		  </tr>
		  </table>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>