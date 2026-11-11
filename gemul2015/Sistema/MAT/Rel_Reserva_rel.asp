<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 26/07/2012
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script></head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	strCod_empresa 			= Session("CodEmpresa")
	intOrdenacao 			= request.Form("cmbOrdenacao")
	
	strCurso 				= request("cmbCurso")
	strPeriodo 				= request("cmbPeriodo")
	
	strOpcao	 			= request.Form("cmbOpcao")
	bolsa		 			= request.Form("cmbBolsa")
	intCodSetor 			= request("cmbSetor")
	if intCodSetor = "" then intCodSetor = "0"
	intCodRegiao 			= request("cmbRegiao")
	if intCodRegiao = "" then intCodRegiao = "0"
		
	if strOpcao = "E" then
		mensagemRel = "<br><strong>EFETIVADOS</strong>"
	end if
	
	intCodEmpresaGrupo	= request("cmbEmpresaGrupo")
	if intCodEmpresaGrupo = "" then intCodEmpresaGrupo = "0"
	strEmpresa = ""
	if intCodEmpresaGrupo <> "0" then
		sql = "select razaosocial as empresa from seg_empresa where codigo = " & intCodEmpresaGrupo
		RS.OPEN SQL, CNN
		IF RS.EOF = FALSE THEN
			strEmpresa 		= "&nbsp;<strong>no(a)&nbsp;" & rs("empresa") & "</strong>"
		END IF
		rs.close
	end if
	
	strDataInicio 	= request("data_inicio")
	strDataFim 		= request("data_fim")
	
	strTituloRelatorio  	= "Rela&ccedil;&atilde;o de Cadastro de Reservas da <br> Matrícula " & year(date) & mensagemRel& strEmpresa
	if strDataInicio<>"" and strDataFim<>"" then
		strTituloRelatorio = strTituloRelatorio & " - Período: " & formatadataAP(strDataInicio) & " a " & formatadataAP(strDataFim)
	end if

	if strCurso <> "0" then
		strTituloRelatorio  	= "Rela&ccedil;&atilde;o de Cadastro de Reservas <br> <strong>" & replace(strCurso,"_"," ") & "</strong> - Matrícula " & year(date) & strEmpresa
		if strDataInicio<>"" and strDataFim<>"" then
			strTituloRelatorio = strTituloRelatorio & " - Período: " & formatadataAP(strDataInicio) & " a " & formatadataAP(strDataFim)
		end if
	end if
	
	strSetor = ""
	if intCodSetor <> "0" then
		sql = "select descricao from mat_setores where codigo = " & intCodSetor
		RS.OPEN SQL, CNN
		IF RS.EOF = FALSE THEN
			strSetor 		= rs("descricao")
		END IF
		rs.close
	end if
	
	sub mostraCabecalhoLogo()
	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<%
	end Sub
	sub mostraCabecalho()
	%>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<%if strOpcao = "E" then%><td align="left" width="3%" class="celula"><strong>Inscrição</strong></td><%else%><td align="left" width="3%" class="celula"><strong>Ordem</strong></td><%end if%>
		<td width="3%" class="celula"><strong><%if strOpcao = "E" then%>Matrícula<%else%>Inscrição<%end if%></strong></td>
		<td width="17%" class="celula"><strong>Nome Aluno</strong></td>
		<td width="4%" class="celula"><strong>Data Nasc</strong></td>
		<td width="17%" class="celula"><strong>M&atilde;e</strong></td>
		<td width="6%" class="celula"><strong>Periodo</strong></td>
		<td width="6%" class="celula"><strong>Turno</strong></td>
        <td width="6%" class="celula"><strong>Telefone</strong></td>
		<td width="14%" class="celula"><strong>Bairro</strong></td>
			<%if strOpcao = "E" then%>
                    <td width="13%" class="celula"><strong>Usuário efetivação</strong></td>
                    <td width="7%" class="celula"><strong>Data efetivação</strong></td>
                    <%if intCodEmpresaGrupo = "0" then%>
                    <td width="13%" class="celula"><strong>Unidade efetivado</strong></td>
                    <%end if%>
            <%else%>
                <td width="13%" class="celula"><strong>Cidade</strong></td>
            <%end if%>
			<td align="left" class="celula"><strong>Inclusão</strong></td>
	  </tr>
	<%
	end Sub
	
	sub mostraCabecalhoTotal()
	%>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td colspan="11" align="center" class="celula"><strong>Totais</strong></td>
	  </tr>
      <%
      
      	sql = "SELECT r.periodo, count(*) as qtde "
		sql = sql & " FROM MAT_Reserva r"
		if strOpcao = "E" and intCodEmpresaGrupo <> "0" then
			sql = sql & " inner join sca_aluno a on a.codigo = r.cod_aluno"
		end if
		sql = sql & " where r.Situacao = 'R'"
		if strOpcao = "C" then
			sql = sql & " AND ISNULL(r.ATUALIZADO,'N') = 'N'"
		end if
		if strOpcao = "E" then
			sql = sql & " AND r.ATUALIZADO = 'S'"
			if intCodEmpresaGrupo <> "0" then
				sql = sql & " and a.cod_empresa = " & intCodEmpresaGrupo
			end if
		end if
		if bolsa = "C" then
			sql = sql & " AND r.bolsa_familia is not null"
			msn = " com bolsa família"
		end if
		if bolsa = "S" then
			sql = sql & " AND r.bolsa_familia is null"
			msn = " sem bolsa família"
		end if
		
		if strPeriodo <> "0" then
			SQL = SQL & " AND r.periodo = '" & replace(strPeriodo,"_"," ") & "'"
		end if
		if strCurso <> "0" then
			SQL = SQL & " AND r.curso = '" & replace(strCurso,"_"," ") & "'"
		end if

		if strSetor <> "" then
			SQL = SQL & " AND r.bairro = '" & strSetor & "'"
		end if

		if strDataInicio<>"" and strDataFim<>"" then
			SQL = SQL & " AND data_efetivacao between '" & formatadataBD(strDataInicio) & "' and '" & formatadataBD(strDataFim) & "'"
		end if
		
		if intCodRegiao <> "0" then
			'inicio regra nova para buscar pelo setor(bairro)
			SQL = SQL & " and r.bairro in "
			SQL = SQL & " ("
			SQL = SQL & " 	select s.descricao"
			SQL = SQL & " 	from MAT_regiao_setores  rs"
			SQL = SQL & " 	inner join mat_setores s on s.codigo =  rs.cod_setores"
			SQL = SQL & " 	where rs.cod_regiao = " & intCodRegiao & ""
			SQL = SQL & " )			"
		end if

		sql = sql & " group by r.periodo order by r.periodo	"
		rsAux.open sql, cnn
		if not rsAux.eof then 
			While not rsAux.eof
				%>
				<tr>
					<td colspan="11" class="celula">Total <%=rsAux("periodo")%>:<%=rsAux("qtde")%></td>
				</tr>
				<%
				total = total + rsAux("qtde")
				rsAux.movenext
			wend
		end if
		rsAux.close
	%>
        <tr>
       		<td height="40" colspan="11" class="celula">Quantidade de Candidatos: <%=total%><%=msn%></td>
        </tr>
      
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub
%>
<%
	intPagina = 1
	intQtdeRegistroPorPagina = 1
	mostraCabecalhoLogo
	mostraCabecalhoTotal
	mostraCabecalho

	cont = 0
	
	intTotal_AgrupamentoI = 0
	intTotal_AgrupamentoII = 0
	intTotal_AgrupamentoIII = 0
	intTotal_AgrupamentoIV = 0
	intTotal_AgrupamentoV = 0
	intTotal_BERCARIO = 0
	
	if strOpcao <> "E" then
		sql = "SELECT "
		sql = sql & " ROW_NUMBER() OVER ("
		sql = sql & "     PARTITION BY r.Curso, r.Periodo, r.Ano"
		sql = sql & "     ORDER BY r.Codigo"
		sql = sql & " ) AS Ordem_Chamada,r.Codigo, r.inscricao, r.nome, r.data_nascimento, r.mae, r.cep, r.Logradouro, "
	else
		sql = "SELECT r.Codigo, r.inscricao, r.nome, r.data_nascimento, r.mae, r.cep, r.Logradouro, "
	end if
	sql = sql & " r.bairro, r.data_hora_incl, r.cidade, r.email, r.Periodo, r.Turno, r.EMAIL, r.Contato, r.Celular, r.FonePai, r.FoneMae, u.USUA_NOME_COMPLETO as usuario_efetivacao, r.data_efetivacao  "
	if strOpcao = "E" then
		sql = sql & " ,e.razaosocial as unidade_efetivado, a.matricula"
	end if
	sql = sql & " FROM MAT_Reserva r"
	sql = sql & " left join seg_usuarios_sistema u on u.USUA_CODG = r.usuario_efetivacao"
	
	if strOpcao = "E" then
		sql = sql & " inner join sca_aluno a on a.codigo = r.cod_aluno"
		sql = sql & " inner join seg_empresa e on e.codigo = r.CodEmpresa"
	end if	
	sql = sql & " where r.Situacao = 'R'"
	
	if strOpcao = "C" then
		sql = sql & " AND ISNULL(r.ATUALIZADO,'N') = 'N'"
	end if
	
	if strOpcao = "E" then
		sql = sql & " AND r.ATUALIZADO = 'S'"
		if intCodEmpresaGrupo <> "0" then
			sql = sql & " and r.CodEmpresa = " & intCodEmpresaGrupo
		end if
	end if
	
	if bolsa = "C" then
		sql = sql & " AND r.bolsa_familia is not null"
		msn = " com bolsa família"
	end if
	
	if bolsa = "S" then
		sql = sql & " AND r.bolsa_familia is null"
		msn = " sem bolsa família"
	end if
	
	if strPeriodo <> "0" then
		SQL = SQL & " AND r.periodo = '" & replace(strPeriodo,"_"," ") & "'"
	end if
	if strCurso <> "0" then
		SQL = SQL & " AND r.curso = '" & replace(strCurso,"_"," ") & "'"
	end if

	if strSetor <> "" then
		SQL = SQL & " AND r.bairro = '" & strSetor & "'"
	end if

	if strDataInicio<>"" and strDataFim<>"" then
		SQL = SQL & " AND data_efetivacao between '" & formatadataBD(strDataInicio) & "' and '" & formatadataBD(strDataFim) & "'"
	end if
	
	if intCodRegiao <> "0" then
		'inicio regra nova para buscar pelo setor(bairro)
		SQL = SQL & " and r.bairro in "
		SQL = SQL & " ("
		SQL = SQL & " 	select s.descricao"
		SQL = SQL & " 	from MAT_regiao_setores  rs"
		SQL = SQL & " 	inner join mat_setores s on s.codigo =  rs.cod_setores"
		SQL = SQL & " 	where rs.cod_regiao = " & intCodRegiao & ""
		SQL = SQL & " )			"
	end if

	if strOpcao = "E" then
		if intOrdenacao = 1 then 
			sql = sql & " order by r.inscricao, e.razaosocial, r.nome"
		end if
		
		if intOrdenacao = 2 then 
			sql = sql & " order by r.nome"
		end if
		
		if intOrdenacao = 3 then 
			sql = sql & " order by r.Periodo, e.razaosocial, r.nome"
		end if
		
		if intOrdenacao = 4 then 
			sql = sql & " order by r.bairro, e.razaosocial, r.nome"
		end if		

		if intOrdenacao = 5 then 
			sql = sql & " order by r.data_efetivacao"
		end if		
	else
	
		if intOrdenacao = 1 then 
			sql = sql & " ORDER BY r.Curso, r.Periodo, r.Ano, r.Codigo"
		end if
		
		if intOrdenacao = 2 then 
			sql = sql & " order by r.nome"
		end if
		
		if intOrdenacao = 3 then 
			sql = sql & " order by r.Periodo"
		end if
		
		if intOrdenacao = 4 then 
			sql = sql & " order by r.bairro"
		end if
		
	end if
'response.write sql
	intQtdeRegistroPorPagina = 10
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
		
			cont = cont + 1
		
			strTurno =  "INTEGRAL"
			
			if trim(rs("Periodo")) = "AGRUPAMENTO I" then
				intTotal_AgrupamentoI = intTotal_AgrupamentoI + 1
			end if
			
			if trim(rs("Periodo")) = "AGRUPAMENTO II" then
				intTotal_AgrupamentoII = intTotal_AgrupamentoII + 1
			end if
			
			if trim(rs("Periodo")) = "AGRUPAMENTO III" then
				intTotal_AgrupamentoIII = intTotal_AgrupamentoIII + 1
			end if
			
			if trim(rs("Periodo")) = "AGRUPAMENTO IV" then
				intTotal_AgrupamentoIV = intTotal_AgrupamentoIV + 1
			end if
			
			if trim(rs("Periodo")) = "AGRUPAMENTO V" then
				intTotal_AgrupamentoV = intTotal_AgrupamentoV + 1
			end if

			if trim(rs("Periodo")) = "BERCARIO" then
				intTotal_BERCARIO = intTotal_BERCARIO + 1
			end if
				
			%>
			  <tr>
				<%if strOpcao = "E" then%><td align="left" class="celula"><%=rs("inscricao")%></td><%else%><td align="left" class="celula"><%=rs("Ordem_Chamada")%></td><%end if%>
				<td align="left" class="celula"><%if strOpcao = "E" then%><%=rs("matricula")%><%else%><%=rs("inscricao")%><%end if%></td>
				<td align="left" class="celula"><%=rs("nome")%>&nbsp;</td>
				<td align="left" class="celula"><%=formataDataAP(rs("data_nascimento"))%></td>
             	<td align="left" class="celula"><%=rs("mae")%></td>
				<td align="left" class="celula"><%=rs("Periodo")%></td>
				<td align="left" class="celula"><%=rs("Turno")%></td>
                <td align="left" class="celula"><%=rs("Contato")%></td>
				<td align="left" class="celula"><%=rs("bairro")%></td>

				<%if strOpcao = "E" then%>
                        <td align="left" class="celula"><%=rs("usuario_efetivacao")%></td>
                        <td align="left" class="celula"><%=rs("data_efetivacao")%></td>
                         <%if intCodEmpresaGrupo = "0" then%>
                        <td align="left" class="celula"><%=rs("unidade_efetivado")%></td>
		                <%end if%>
                <%else%>
                    <td align="left" class="celula"><%=rs("cidade")%></td>
                <%end if%>
				<td align="left" class="celula"><%=rs("data_hora_incl")%></td>
				
			  </tr>
			<%
			
			
			intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
			rs.movenext
		wend
		mostraCabecalhoTotal
	else
		%>
		  <tr>
			<td height="48" colspan="11" align="center" class="celula"><p><br>
	          <br>
            <font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></p></td>
	  </tr>
		<%
	end if
	rs.close
%>
</table>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
