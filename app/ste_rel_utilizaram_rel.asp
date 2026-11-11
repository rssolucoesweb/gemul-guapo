<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
response.Expires=0
Server.ScriptTimeOut = 5000
if request("exportar") = "" then
	Response.Buffer = false
end if


dim intPagina
paginaatual = request.ServerVariables("SCRIPT_NAME")

intCodGrupo				= Session("CodGrupo") 		
strRede		 			= Trim(Request("rede"))
intCodEmpresa 			= Trim(Request("cmbEmpresa"))
intCodEscolaEstadual	= Trim(Request("cmbEscolaEstadual"))

strTituloRelatorio  	= "Relatório dos Alunos que utilizam o Transporte Escolar "

if strRede = "M" then 
	strTituloRelatorio = strTituloRelatorio & " - Municipal"
elseif strRede = "E" then 
	strTituloRelatorio = strTituloRelatorio & " - Estadual"
end if

strExportarWord 	= paginaatual & "?exportar=w&cmbEmpresa=" & intCodEmpresa & "&cmbEscolaEstadual=" & intCodEscolaEstadual & "&rede=" & strRede
strExportarExcel 	= paginaatual & "?exportar=e&cmbEmpresa=" & intCodEmpresa & "&cmbEscolaEstadual=" & intCodEscolaEstadual & "&rede=" & strRede


%>
<html>
<head>
<title>Relatório dos Alunos que utilizam o Transporte Escolar</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
<script src="js/js_funcoes_gerais.js"></script>
<script src="js_app/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<%
if request("exportar") = "" then 
    %>
	<!--#include file="includes/inc_Botoes_relatorio_word_excel.asp"-->
	<!--#include file="includes/inc_aguarde.asp"-->
	<%
end if
%>

<br>
<%
	sub mostraCabecalho(escola_cab, cont_cab)
	%>
	<%if request("exportar") = "" then %>
	<%if cont_cab = 0 then %>
	<!--#include file="includes/inc_cabecalhoRelatorioSemec.asp"-->
	
	<%end if%>
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td ><strong>Unidade de Ensino:</strong></td>
		<td width="80%"><strong><%=escola_cab%></strong></td>
	  </tr>
	</table>  
	<br>
	<%end if %>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<%if request("exportar") <> "" then %>
			<td width="30%" class="celula"><strong>Unidade Escolar</strong></td>
		<%end if %>
		<td width="2%" class="celula"><strong>Id</strong></td>
		<td width="12%" class="celula"><strong>Aluno</strong></td>
		<td width="2%" class="celula"><strong>Idade</strong></td>
		<td width="10%" class="celula"><strong>Endereço</strong></td>
		<td width="5%" class="celula"><strong>Número</strong></td>
		<td width="8%" class="celula"><strong>Complemento</strong></td>
		<td width="10%" class="celula"><strong>Bairro</strong></td>
		<td width="5%" class="celula"><strong>Nec. Especial</strong></td>
		<td width="5%" class="celula"><strong>Unidade Consumidora</strong></td>
		<td width="5%" class="celula"><strong>Telefone</strong></td>
		<td width="10%" class="celula"><strong>Curso</strong></td>
		<td width="5%" class="celula"><strong>Série</strong></td>
		<td width="5%" class="celula"><strong>Turno</strong></td>
		<td width="15%" class="celula"><strong>Rota</strong></td>
		
		<%if request("exportar") <> "" then %>
		<td width="5%" class="celula"><strong>Rede</strong></td>
		<%end if %>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	
	cont = 0
	sql = "select t.codigo, t.nome, r.Descricao as rota, t.bairro as setor, DATEDIFF(YEAR, t.data_nascimento, GETDATE()) - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, t.data_nascimento, GETDATE()), t.data_nascimento) > GETDATE() THEN 1 ELSE 0  END AS Idade, case when ne.Desc_NecEspecialNova = 'Nenhuma' then null else ne.Desc_NecEspecialNova end as necessidade_especial, t.NumeroEndereco, t.ComplementoEndereco, t.Logradouro as endereco, t.cep, t.unidade_consumidora_energia, " 
	sql = sql & " 	case"	
	sql = sql & " 		when t.codigo_escola_estadual is null then 'MUNICIPAL'"
	sql = sql & " 		else 'ESTADUAL'"
	sql = sql & " 		end as tipo,"
	sql = sql & " 	case"	
	sql = sql & " 		when t.codigo_escola_estadual is null then TUR.Desc_Turno"
	sql = sql & " 		else T.TURNO_ESTADUAL"
	sql = sql & " 		end as TURNO,"
	sql = sql & " 	case	"
	sql = sql & " 		when t.codigo_escola_estadual is null then em.RAZAOSOCIAL"
	sql = sql & " 		else ee.nome"
	sql = sql & " 		end as escola, t.Contato, t.Celular, t.FonePai, t.FoneMae, P.DESCRICAO AS PERIODO, C.DESCRICAO AS CURSO"
	sql = sql & " from ste_solicitacao_transporte t "
	sql = sql & " left join sca_aluno a on a.codigo = t.cod_aluno"
	sql = sql & " left join SCA_ROTA_VICULA_ALUNO v on v.cod_solicitacao_transporte = t.codigo "
	sql = sql & " left join SCA_TURMA tu on tu.cod_turma = v.codturma "
	sql = sql & " left join SCA_PERIODO P on P.COD_PERIODO = TU.COD_PERIODO"
	sql = sql & " left join SCA_CURSO C on C.COD_CURSO = P.COD_CURSO"
	sql = sql & " left join SCA_turno TUR on TUR.COD_TURNO = TU.COD_TURNO"
	sql = sql & " left join SEG_EMPRESA em on em.codigo = t.Cod_empresa "
	sql = sql & " left join MAT_setores se on se.descricao = t.bairro "
	sql = sql & " left join STE_ROTA r on r.Cod_rota = t.cod_rota "
	sql = sql & " left join ste_escola_estadual ee on ee.codigo_escola_estadual = t.codigo_escola_estadual"
	sql = sql & " left join SCA_NECESSIDADEESPECIAL ne on ne.Cod_NecEspecial = a.COD_NECESPECIAL"
	sql = sql & " where t.Situacao = 'D' "
	if strRede = "M" then
		if intCodEmpresa<>"0" then
			sql = sql & " and em.CODIGO = " & intCodEmpresa
			sql = sql & " and ee.codigo_escola_estadual is null "
		else
			sql = sql & " and ee.codigo_escola_estadual is null "
		end if
	elseif strRede = "E" then
		if intCodEscolaEstadual<>"0" then
			sql = sql & " and ee.codigo_escola_estadual = " & intCodEscolaEstadual
			sql = sql & " and ee.codigo_escola_estadual is not null "
		else
			sql = sql & " and ee.codigo_escola_estadual is not null "
		end if
	end if
	sql = sql & " order by escola, t.nome"
	
	if session("usuarioWeb") = "SERGIO" THEN
		'RESPONSE.WRITE strRede & "<hr>"
		'RESPONSE.WRITE SQL & "<hr>"
	end if	
	cont = 0
	rs.open sql, cnn
	if not rs.eof then 
		while not rs.eof
			
			if request("exportar") = "" then 
				if trim(escola) <> trim(rs("escola")) then
					if cont>0 then
						fimTabela
					end if
					mostraCabecalho rs("escola"), cont 
				end if
				
				rota = "<strong>---</strong>"
				if not isnull(rs("rota")) then
					rota = "<strong>" & rs("rota") & "</strong>"
				end if
			else
				if cont = 0 then
					mostraCabecalho rs("escola"), cont 
				end if
				rota = rs("rota")
			end if
			
			telefone = ""
			if not isnull(rs("Contato")) then
				telefone = rs("Contato")
			elseif not isnull(rs("Celular")) then
				telefone = rs("Celular")
			elseif not isnull(rs("FoneMae")) then
				telefone = rs("FoneMae")
			elseif not isnull(rs("FonePai")) then
				telefone = rs("FonePai")
			end if
			
			%>
			  <tr>
				<%if request("exportar") <> "" then %>
					<td class="celula"><%=rs("escola")%></td>
				<%end if %>
				<td class="celula"><%=rs("codigo")%></td>
				<td class="celula"><%=rs("nome")%></td>
				<td class="celula"><%=rs("idade")%></td>
				<td class="celula"><%=rs("endereco")%></td>
				<td class="celula"><%=rs("NumeroEndereco")%></td>
				<td class="celula"><%=rs("ComplementoEndereco")%></td>
				<td class="celula"><%=rs("setor")%></td>
				<td class="celula"><%=rs("necessidade_especial")%></td>
				<td class="celula"><%=rs("unidade_consumidora_energia")%></td>
				<td class="celula"><%=telefone%></td>
				<td class="celula"><%=rs("CURSO")%></td>
				<td class="celula"><%=rs("PERIODO")%></td>
				<td class="celula"><%=rs("TURNO")%></td>
				<td class="celula"><%=rota%></td>
				
				<%if request("exportar") <> "" then %>
				<td class="celula"><%=rs("tipo")%></td>
				<%end if%>
			  </tr>
			  <%
			cont = cont + 1	
			
			escola = rs("escola")		  
			rs.movenext
		wend
		%>
		  <tr>
			<td colspan="17" bgcolor="#CCCCCC" class="celula"><strong>Registros: <%=cont%></strong></td>
		  </tr>
		 <%
		else
		%>
		  <tr>
			<td height="11" colspan="3" align="center" class="celula"><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
	  </tr>
		<%
	end if
	rs.close
%>
</table>
<%if request("exportar") = "" then %>
<script>
	aguarde.style.display="none";
</script>
<%end if %>
<%
if request("exportar") = "w" then 
	Response.ContentType = "application/vnd.ms-word"
	Response.AddHeader "content-disposition","attachment;filename=relatorioUtilizam.doc"
elseif request("exportar") = "e" then 
	Response.ContentType = "application/vnd.ms-excel"
	Response.AddHeader "content-disposition","attachment;filename=relatorioUtilizam.xls"
end if
%>	
</body>
</html>	
