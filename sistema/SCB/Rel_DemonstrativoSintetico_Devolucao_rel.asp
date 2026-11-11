<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
SESSION.Timeout = 1200
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 28/01/2009
	::	Desenvolvedores...: Roberto Barbosa Silva - robertobs7@hotmail.com
-->
<html>
<head>
<title><%=session("Titulo")%> - Alunos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
	strDataDia			  	= formataDataAP(date)
	strPaginaTitulo 	    = "Rel_DemonstrativoSintetico_Emprestimo_con.asp"
	
	strAnoLetivo			= Trim(Request("txtAnoLetivo"))
	intSemestre				= Trim(Request("cmbSemestre"))
	intCodCurso				= Trim(Request("cmbCurso"))
	intCodTurma				= Trim(Request("cmbTurma"))
	intTipoUsuario			= Trim(Request("cmbTipoUsuario"))
	intCodAutoria			= Trim(Request("cmbAutoria"))
	strTitulo				= Trim(Request("txtTitulo"))
	strCdu					= Trim(Request("txtCodCDU"))
	strDataInicial			= Trim(Request("txtDataInicial"))
	strDataFinal			= Trim(Request("txtDataFinal"))
	strAutor				= Trim(Request("txtAutor"))
	strPalavraChave			= Trim(Request("txtPalavraChave"))
	
	if intTipoUsuario = 1 then strTipoUsuario = "Aluno"
	if intTipoUsuario = 2 then strTipoUsuario = "Colaborador"
	if intTipoUsuario = 3 then strTipoUsuario = "Comunidade"
	
	strTituloRelatorio  = "Demonstrativo Sint&eacute;tico de Devolu&ccedil;&atilde;o " & strTipoUsuario
	
	if trim(strDataInicial) <> "" or trim(strDataFinal) <> "" then
		strTituloRelatorio =  strTituloRelatorio & " - Período: " & FormataDataAP(trim(strDataInicial)) & " a " &  FormataDataAP(trim(strDataFinal))
	end if

	sub mostraCabecalho()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
    
    <%
	
	strSubTitulo		=  "Parâmetro de Consulta: "
	intSubTituloExiste 	= "False"
	
	if intCodAutoria <> 0 then
		strSubTitulo =  strSubTitulo & " Autoria ;"
		intSubTituloExiste = "True"
	end if
	
	if strTitulo <> "" then
		strSubTitulo =  strSubTitulo & " Título ;"
		intSubTituloExiste = "True"
	end if
	
	if strCdu <> "" then
		strSubTitulo =  strSubTitulo & " CDU ;"
		intSubTituloExiste = "True"
	end if

	if trim(strAutor) <> "" then
		strSubTitulo =  strSubTitulo & " Autor ;"
		intSubTituloExiste = "True"
	end if
	
	if trim(strPalavraChave) <> "" then
		strSubTitulo =  strSubTitulo & " Palavra Chave ;"
		intSubTituloExiste = "True"
	end if
	
	
	strSubTitulo =  mid(strSubTitulo,1,len(strSubTitulo) - 1)
	
	%>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <%
		if intSubTituloExiste = "True" then
		%>
      	<tr bgcolor="#CCCCCC">
	    	<td colspan="2" class="celula"><%=strSubTitulo%>&nbsp;</td>
      	</tr>
       <%
		end if
		%>
	  <tr bgcolor="#CCCCCC">
        <%
		' Aluno
		if intTipoUsuario = 1 then
		%>
			<td width="22%" class="celula"><strong>Curso</strong></td>
         <%
		end if
		%>
        <td width="28%" align="center" class="celula"><strong>Total de Empr&eacute;stimo </strong></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	cont = 0
	
	if intTipoUsuario = 1 then
		sql = " SELECT SCA_Curso.Cod_curso, SCA_Curso.Desc_Abreviada, Count(SCB_Emprestimo.Cod_Emprestimo) as TotalEmprestimo"
	else
		sql = " SELECT Count(SCB_Emprestimo.Cod_Emprestimo) as TotalEmprestimo "
	end if
	
	sql = sql & " FROM SCB_Emprestimo  "
	sql = sql & " left Join SCB_EmprestimoItens on SCB_EmprestimoItens.Cod_Emprestimo = SCB_Emprestimo.Cod_Emprestimo "
	
	if intTipoUsuario = 1 then
		sql = sql & " left join SCA_Turma on SCA_Turma.Cod_Turma = SCB_Emprestimo.Cod_Turma and SCA_Turma.Cod_Empresa = SCB_Emprestimo.Cod_Empresa"
	end if
	
	sql = sql & " left Join SCB_PUBLICACAO on SCB_PUBLICACAO.Cod_Publicacao = SCB_EmprestimoItens.Cod_PublicacaoExemplares "
	
	if intTipoUsuario = 1 then
		sql = sql & " inner join SCA_ALUNO ON SCB_Emprestimo.Cod_aluno = SCA_ALUNO.Codigo "
		sql = sql & " inner join SCA_GradeCurricular on SCA_GradeCurricular.Cod_GradeCurricular = SCA_Turma.Cod_GradeCurricular "
		sql = sql & " inner join SCA_Periodo on SCA_Periodo.Cod_Periodo = SCA_GradeCurricular.Cod_Periodo "
		sql = sql & " inner join SCA_Curso on SCA_Curso.Cod_curso = SCA_Periodo.Cod_Curso"
	end if
	
	if intTipoUsuario = 2 then
		sql = sql & " inner JOIN SRH_COLABORADOR ON SCB_Emprestimo.Cod_Colaborador = SRH_COLABORADOR.Codigo " 
	end if
	
	if intTipoUsuario = 3 then
		sql = sql & " inner JOIN SCB_Comunidade ON SCB_Emprestimo.Cod_Comunidade = SCB_Comunidade.Codigo "
	end if
	
   	sql = sql & "  WHERE SCB_Emprestimo.Situacao = 'D' "
	
	' Aluno
	if intTipoUsuario = 1 then
				
		if strAnoLetivo <> 0 then
			sql = sql & " and SCA_Turma.AnoLetivo = " & strAnoLetivo 
		end if
		
		if intSemestre <> 0 then
			sql = sql & " and SCA_Turma.Cod_Semestre = " & intSemestre 
		end if

		if intCodCurso <> 0 then
			sql = sql & " and SCA_Periodo.Cod_curso = " & intCodCurso 
		end if
	
		if intCodTurma <> 0 then
			sql = sql & " and SCB_Emprestimo.Cod_Turma = " & intCodTurma 
		end if
	
	end if
	
	if intTipoUsuario <> 0 then
		sql = sql & " and SCB_Emprestimo.Cod_TipoUsuario = " & intTipoUsuario
	end if
	
	if intCodAutoria <> 0 then
		sql = sql & " and  SCB_PUBLICACAO.Cod_Autoria = " & intCodAutoria
	end if
	
	if strTitulo <> "" then
		sql = sql & " and SCB_PUBLICACAO.Titulo LIKE '%" & strTitulo & "%'"
	end if
	
	if strCdu <> "" then
		sql = sql & " AND SUBSTRING(SCB_PUBLICACAO.Cod_Cdu,1," & len(strCdu) & " ) = '" & strCdu & "'" 
	end if
	
	if trim(strDataInicial) <> "" or trim(strDataFinal) <> "" then
		sql = sql & " and convert(datetime,convert(varchar, SCB_Emprestimo.DataEmprestimo, 103),103) >=  convert(datetime, ' " & strDataInicial & "',103)"
		sql = sql & " and convert(datetime,convert(varchar,  SCB_Emprestimo.DataEmprestimo, 103),103) <=  convert(datetime, ' " & strDataFinal & "',103)"
	end if
	
	if trim(strAutor) <> "" or trim(strPalavraChave) <> "" then
	
		sql = sql & " and SCB_EmprestimoItens.Cod_PublicacaoExemplares in "
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
	
	if intTipoUsuario = 1 then
		sql = sql & " Group by SCA_Curso.Cod_curso, SCA_Curso.Desc_Abreviada"
	end if
	
	rs.open sql, cnn

	if not rs.eof then
	 
	While not rs.eof
		  
		   intTotalEmprestado = rs("TotalEmprestimo")
		  
		   %>
           <tr>
			<%
            ' Aluno
            if intTipoUsuario = 1 then
            %>
            	<td class="celula"><%=rs("Desc_Abreviada")%>&nbsp;</td>
            <%
            end if
            %>
            <td class="celula" align="center"><%=intTotalEmprestado%>&nbsp;</td>
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
			<td colspan="4" class="celula">Quantidade: <%=cont%></td>
		  </tr>
		  </table>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>