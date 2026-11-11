<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%> 
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
response.Expires=0
Server.ScriptTimeOut = 5000
response.Buffer = false
strPaginaDestino = ""
%>
<%
strAnoCab = Trim(Request.QueryString("AnoLetivo"))
%>
<html>
<head>
<title><%=session("Titulo")%></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="css_rel/Estilo_Impressao.css">
</head>
<body>
<script src="js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="js/js_dragdrop.js"></script>

<!--#include file="includes/inc_verificaSessionApp.asp"-->
<!--#include file="includes/inc_cnn.asp"-->
<!--#include file="includes/inc_formatadata.asp"-->
<!--#include file="includes/inc_Botoes_relatorio.asp"-->
<!--#include file=includes/inc_aguarde.asp-->
<br>
<%
	dim intPagina

	
	strCod_empresa	 		= Trim(Request("txtCodEmpresa"))
	if strCod_empresa = "" then strCod_empresa 			= Session("CodEmpresa")

	strTituloRelatorio  	= "Comprovante de Autorização de Transporte Escolar - " & session("strAnoLetivo")	

	intCodigo				= Trim(Request("txtCodigo"))
	
	
	sub mostraCabecalho()
	%>
	<div  align="center">
	<img src="/app/img/logomarcas/logo.jpg" style="width:50pt"><br>
	<h2><%=strTituloRelatorio%></h2>
	</div>
	<br>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub	

	
	
	
	if trim(intCodigo) <> "" then

		
		sql = "select a.codigo, m.codigo as codInscricao, m.nome, a.MATRICULA, m.cpf, m.data_nascimento , m.MAE , m.EMAIL, m.contato, m.Celular, m.FonePai, m.FoneMae, m.sexo,"
		sql = sql & "case"
		sql = sql & "	when m.codigo_escola_estadual is null then e.ENDERECO"
		sql = sql & "	else ee.ENDERECO end as endereco,"
		sql = sql & "case"
		sql = sql & "	when m.codigo_escola_estadual is null then e.BAIRRO"
		sql = sql & "	else ee.BAIRRO end as BAIRRO,"
		sql = sql & "case"
		sql = sql & "	when m.codigo_escola_estadual is null then e.CEP"
		sql = sql & "	else ee.CEP end as CEP,"
		sql = sql & "case"
		sql = sql & "	when m.codigo_escola_estadual is null then e.MUNICIPIO"
		sql = sql & "	else ee.MUNICIPIO end as MUNICIPIO,	"	
		sql = sql & "case"
		sql = sql & "	when m.codigo_escola_estadual is null then e.RAZAOSOCIAL "
		sql = sql & "	else ee.NOME end as ESCOLA,	"			
		sql = sql & " e.UF, e.TELEFONE, M.usuario_incl, M.data_hora_incl, CONVERT(VARCHAR(5),CAST(M.data_hora_incl AS datetime), 108) as hora, m.cod_empresa, "
		sql = sql & " c.descricao as curso, p.descricao as serie, tu.Desc_Turno as turno, t.nometurma, t.TurmaAluno, "
		sql = sql & " m.Logradouro, m.unidade_consumidora_energia, m.NumeroEndereco, m.ComplementoEndereco, m.bairro as bairroAluno, m.cidade, m.uf as ufAluno, m.cep as cepAluno, m.Situacao, r.Descricao as rota, m.obs"
		sql = sql & " from ste_solicitacao_transporte m"
		sql = sql & " left join sca_aluno a on m.cod_aluno = a.codigo"
		sql = sql & " left join seg_empresa e on e.codigo = m.cod_empresa"
		sql = sql & " left join ste_escola_estadual ee on ee.codigo_escola_estadual = m.codigo_escola_estadual"
		sql = sql & " left join sca_turma t on t.cod_turma = m.cod_turma"
		sql = sql & " left join sca_periodo p on p.cod_periodo = t.cod_periodo"
		sql = sql & " left join sca_curso c on c.cod_curso = p.cod_curso"
		sql = sql & " left join sca_turno tu on tu.cod_turno = t.cod_turno"
		sql = sql & " left join STE_ROTA r on r.Cod_rota = m.cod_rota"
		sql = sql & " WHERE m.codigo = " & intCodigo
		rs.open sql, cnn
		if rs.eof = false then
			while not rs.eof
				strCodigo			= TRIM(rs("Codigo"))
				strMatricula 		= TRIM(rs("Matricula"))
				strNomealuno 		= TRIM(rs("nome"))
				strDatanascimento 	= formataDataAP(TRIM(rs("data_nascimento")))
				strRota = Rs("rota")
				strTurno = Rs("turno")
				strEmpresaAtual = rs("ESCOLA")
				
				strEndereco = rs("ENDERECO")
				strBairro = rs("BAIRRO")
				strCep  = rs("CEP")
				unidade_consumidora_energia  = rs("unidade_consumidora_energia")
				
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
				
				
				mostraCabecalho
				
				%>
				  <tr valign="top">
					<td>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr valign="top">
						<td colspan="2" align="center">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td colspan="2"><hr size="1" color="#999999"><input name="txtCodAluno" type="hidden" id="txtCodAluno" class="text" size="10" value="<%=strCodigo%>" maxlength="10"></td>
						  </tr>
						  
						  <tr>
							<td colspan="2" class="textoCabecalho" >
								<div  align="center"><strong>DADOS DO ALUNO</strong></div>
								<br>
								<!-- INICIO CAMPO - DADOS PESSOAIS-->
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
								  <tr>
									<td class="textoCabecalho">&nbsp;Nome: </td>
									<td class="textoCabecalho"><strong><%=strNomealuno%></strong></td>
								  </tr>
								  <tr>
									<td width="15%" class="textoCabecalho">&nbsp;Matr&iacute;cula: </td>
									<td width="47%" class="textoCabecalho"><strong><%=strMatricula%></strong></td>
								  </tr>
								  <tr>
									<td class="textoCabecalho">&nbsp;Data Nascimento: </td>
									<td class="textoCabecalho"><strong><%=strDatanascimento%></strong></td>
								  </tr>
								   <tr>
									<td class="textoCabecalho">&nbsp;Telefone: </td>
									<td class="textoCabecalho"><strong><%=telefone%></strong></td>
								  </tr>
								  <tr>
									<td class="textoCabecalho">&nbsp;Endereço: </td>
									<td class="textoCabecalho"><strong><%=strEndereco%></strong></td>
								  </tr>
								  
								  <tr>
									<td class="textoCabecalho">&nbsp;Bairro: </td>
									<td class="textoCabecalho"><strong><%=strBairro%></strong></td>
								  </tr>
								  
								  <tr>
									<td class="textoCabecalho">&nbsp;Cep: </td>
									<td class="textoCabecalho"><strong><%=strCep%></strong></td>
								  </tr>
								  
								   <tr>
									<td class="textoCabecalho">&nbsp;Unidade Consumidora: </td>
									<td class="textoCabecalho"><strong><%=unidade_consumidora_energia%></strong></td>
								  </tr>
								  
								  <tr>
									<td class="textoCabecalho">&nbsp;Escola: </td>
									<td class="textoCabecalho"><strong><%=strEmpresaAtual%></strong></td>
								  </tr>
								</table>
								<!-- FIM CAMPO - DADOS PESSOAIS-->			</td>
						  </tr>
						  <tr>
							<td colspan="2"><hr size="1" color="#999999"></td>
						  </tr>
						  
						 
							<td colspan="2" class="textoCabecalho" >
							
								<div  align="center"><strong>DADOS DA ROTA</strong></div>
								<br>
								<!-- INICIO CAMPO - DADOS ESCOLARES-->
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
								  <tr>
									<td width="15%" class="textoCabecalho">&nbsp;Rota:</td>
									<td width="47%" colspan="3" class="textoCabecalho"><strong><%=strRota%></strong></td>
								  </tr>
								  <tr>
									<td width="15%" class="textoCabecalho">&nbsp;Turno:</td>
									<td width="47%" colspan="3" class="textoCabecalho"><strong><%=strTurno%></strong></td>
								  </tr>
								</table>
								<!-- FIM CAMPO - DADOS ESCOLARES-->			
								
								</td>
						  </tr>
						</table>
						 <tr>
							<td colspan="2"><hr size="1" color="#999999"></td>
						  </tr>
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
								  <tr>
									<td class="textoCabecalho">
									
									<div  align="center"><strong>OUTRAS INFORMAÇÕES IMPORTANTES</strong></div>

									<br>•	Comparecer ao local e no horário indicado para o embarque;
									<br>•	Acatar todas as orientações e determinações passadas pelo(a) monitor(a), motorista;
									<br>•	Ocupar um único assento e permanecer sentado durante todo o tempo em que o veículo estiver em movimento;
									<br>•	Embarcar e desembarcar exclusivamente nos pontos determinados;
									<br>•	Cooperar com a limpeza do veículo, colocando qualquer tipo de lixo, no lugar correto;
									<br>•	Apresentar conduta de urbanidade e respeito com os demais usuários e profissionais que atuam no transporte escolar, bem como com as pessoas que estão transitando nas vias;
									<br>•	É proibido: colocar pernas, braços e cabeça para fora das janelas, jogar qualquer tipo de objeto/lixo para fora do veículo e falar com o motorista, enquanto ele estiver dirigindo;
									<br>•	Usar linguagem adequada ao ambiente, não sendo permitido o uso de palavrões, xingamentos, ofensas, humilhações, gestos obscenos e agressões físicas, sejam de qualquer tipo;
									<br>
									<br>É de responsabilidade dos pais/responsáveis:
									<br>
									<br>I - Acompanhar a criança/estudante até o embarque e recebê-la no desembarque.
									<br>II - Orientar e exigir que seu(sua) filho(a) cumpra com os itens citados acima.


									
									</td>
								  </tr>
								</table>
						<br>
						<br>
						<div class="textoCabecalho" align="center">
						Guapó-GO, <%=day(date)%> de <%=monthName(month(date))%> de <%=year(date)%>.
						</div>
						<br>
						<br>
						<br>
						<div class="textoCabecalho" align="center">_____________________________________<br>Assinatura</div>
                        <%
				rs.movenext
				if not rs.eof then
					fimTabela
					%>
					<pre></pre>				
					<%			
				end if
			wend
		end if 
		rs.close
	end if 
	%>
	<script>
		aguarde.style.display="none";
	</script>
</body>
</html>