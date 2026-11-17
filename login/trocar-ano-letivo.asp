<%@ Language="VBScript" CodePage="65001" %>
<% Response.CodePage = 65001 %>
<% Response.Charset  = "UTF-8" %>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Desenvolvedores...: Sergio Borges - sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Trocar o ano letivo da sessão (Session("strAnoLetivo"))
	::	Lista os anos ATIVOS do grupo (SEG_ANO_LETIVO). Ao escolher, guarda em
	::	Session("strAnoLetivoEscolhido") e volta para selecionar_escola.asp,
	::	que recarrega ano, semestre e regime da unidade para o ano escolhido
	::	(se a unidade não tiver SEG_ENCERRAMENTOATIVIDADES do ano, usa a configuração do ano mais recente).
-->
<!--#include file="../includes/inc_verificaSession.asp"-->
<!--#include file="../includes/inc_cnn.asp"-->
<!--#include file="../includes/inc_carregaAnoLetivoSessao.asp"-->
<%
	function anoNumero(ByVal valor)
		anoNumero = 0
		if isnull(valor) then exit function
		valor = trim(cstr(valor))
		if valor <> "" and isnumeric(valor) then anoNumero = clng(valor)
	end function

	intCodGrupo		= anoNumero(Session("CodGrupo"))
	intCodEmpresa	= anoNumero(Session("CodEmpresa"))
	intAnoAtual		= anoNumero(Session("strAnoLetivo"))
	strMensagem		= ""

	'Anos disponíveis para a unidade
	vetAnos = ""
	if intCodGrupo > 0 and intCodEmpresa > 0 then
		sql = "SELECT A.ANO_LETIVO, A.PADRAO"
		sql = sql & " FROM SEG_ANO_LETIVO A"
		sql = sql & " WHERE A.COD_GRUPO = " & intCodGrupo
		sql = sql & " AND A.SITUACAO = 'A'"
		sql = sql & " ORDER BY A.ANO_LETIVO DESC"
		Rs.open sql, cnn
		if not Rs.eof then vetAnos = Rs.getRows
		Rs.close
	end if

	'Troca: confere se o ano está na lista e volta para a seleção de escola (que recarrega a sessão)
	'página de retorno (troca feita de dentro de um módulo); só endereços do próprio sistema
	strVoltaParam = Trim(Request("volta"))
	if not (left(strVoltaParam, 1) = "/" and left(strVoltaParam, 2) <> "//" and instr(strVoltaParam, "\") = 0 and instr(lcase(strVoltaParam), "trocar-ano-letivo") = 0) then strVoltaParam = ""
	strLinkVolta = ""
	if strVoltaParam <> "" then strLinkVolta = "&volta=" & Server.URLEncode(strVoltaParam)

	intAnoEscolhido = anoNumero(Request("ano"))
	if intAnoEscolhido > 0 then
		blnValido = false
		if isArray(vetAnos) then
			for i = 0 to ubound(vetAnos, 2)
				if anoNumero(vetAnos(0, i)) = intAnoEscolhido then blnValido = true
			next
		end if
		if blnValido then
			Session("strAnoLetivoEscolhido") = intAnoEscolhido
			'atualiza já a sessão (o topo da seleção de escola é montado antes de recarregar os dados da unidade)
			Session("strAnoLetivo") = intAnoEscolhido
			'Troca feita de dentro de um módulo (?volta=/app/pagina.asp): recarrega o ano da unidade e volta para a página
			strVolta = Trim(Request("volta"))
			if strVolta <> "" and left(strVolta, 1) = "/" and left(strVolta, 2) <> "//" and instr(strVolta, "\") = 0 and instr(lcase(strVolta), "trocar-ano-letivo") = 0 then
				carregaAnoLetivoSessao Session("CodEmpresa")
				Response.Redirect strVolta
				Response.End
			end if
			Response.Redirect "selecionar_escola.asp"
			Response.End
		else
			strMensagem = "O ano letivo " & intAnoEscolhido & " não está disponível para esta unidade."
		end if
	end if
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Trocar Ano Letivo – GEMUL</title>
	<link rel="stylesheet" href="css/styles.css"> <!-- usa o mesmo CSS do login -->
	<style>
		#logo-login { width: 100% !important; max-width: 500px !important; }
		.logo-rodape { width: 85px !important; }
		.ano-lista { display: flex; flex-direction: column; gap: 10px; margin: 18px 0 8px 0; }
		.ano-item {
			display: flex; align-items: center; justify-content: space-between;
			padding: 14px 18px; border: 1px solid #d6dbe4; border-radius: 10px;
			text-decoration: none; color: #1f2a44; font-size: 18px; font-weight: 600;
			background: #ffffff; transition: background .15s, border-color .15s;
		}
		.ano-item:hover { background: #f1f5fb; border-color: #1a5ea8; }
		.ano-item.atual { border-color: #1a5ea8; background: #eaf2fb; cursor: default; }
		.ano-tag { font-size: 12px; font-weight: 600; padding: 3px 10px; border-radius: 12px; }
		.ano-tag.atual { background: #1a5ea8; color: #ffffff; }
		.ano-tag.padrao { background: #e8f5e9; color: #2e7d32; }
		.ano-aviso { color: #b00020; margin: 10px 0; }
	</style>
</head>
<body>

<div class="container">

  <!-- LADO ESQUERDO -->
  <!-- LADO ESQUERDO -------------------------------------------------------->
    <div class="left">
        <div class="left-content">
            <h2>Secretaria Municipal de<br><strong>Educação</strong></h2>
            <div class="logo">
                <img src="/matricula/img/logomarca-topo-guapo.png" alt="Prefeitura de Guapó">
            </div>
        </div>
    </div>

  <!-- LADO DIREITO -->
  <div class="right">
    <div class="login-box">
	  <h1>Trocar Ano Letivo</h1>
      <p class="subtitle">
		<%if intAnoAtual > 0 then%>
        Ano letivo atual: <strong><%=intAnoAtual%></strong>. Escolha o ano em que deseja trabalhar.
		<%else%>
		Escolha o ano letivo em que deseja trabalhar.
		<%end if%>
      </p>

	  <%if strMensagem <> "" then%>
		<p class="ano-aviso"><%=Server.HTMLEncode(strMensagem)%></p>
	  <%end if%>

	  <%if intCodEmpresa = 0 then%>
		<p class="ano-aviso">Selecione primeiro a unidade escolar.</p>
	  <%elseif not isArray(vetAnos) then%>
		<p class="ano-aviso">Nenhum ano letivo disponível para esta unidade.</p>
	  <%else%>
		<div class="ano-lista">
		<%
		for i = 0 to ubound(vetAnos, 2)
			intAno = anoNumero(vetAnos(0, i))
			if intAno = intAnoAtual then
		%>
			<div class="ano-item atual">
				<span><%=intAno%></span>
				<span class="ano-tag atual">Ano atual</span>
			</div>
		<%	else %>
			<a class="ano-item" href="trocar-ano-letivo.asp?ano=<%=intAno%><%=strLinkVolta%>">
				<span><%=intAno%></span>
				<%if trim(vetAnos(1, i) & "") = "S" then%><span class="ano-tag padrao">Padrão</span><%end if%>
			</a>
		<%
			end if
		next
		%>
		</div>
	  <%end if%>

		<br>
      <a href="<%if strVoltaParam <> "" then response.write Server.HTMLEncode(strVoltaParam) else response.write "selecionar_escola.asp"%>" class="forgot">← Voltar ao Sistema</a>

	  <p class="login-rodape">
		<img class="logo-rodape" src="img/logo-login.png" alt="GEMUL">
	  </p>
    </div>
  </div>

</div>
</body>
</html>
