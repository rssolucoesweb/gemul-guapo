<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<%
Response.AddHeader "Content-Type", "text/html; charset=utf-8"
Response.AddHeader "Pragma", "no-cache"
response.Charset="utf-8"
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 15/03/2010
	::	Objetivo Pagina...: Ficha Individual do Colaborador
-->
<html>
<head>
<title><%=session("Titulo")%> - Modulação</title>
<meta http-equiv="Content-Type" content="text/html">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<script src="../../js/js_funcoes_gerais.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<%
	strorigem				= Trim(Request.QueryString("origem"))
	strCodEmpDestino		= Trim(Request.QueryString("codEmp"))
	strTipo					= Trim(Request.QueryString("Tipo"))
	strTipoModSub			= Trim(Request.QueryString("TipoModSub")) 'C - contrato | P - periodo | S - Substituicao
	
	if strTipoModSub = "P" then strTituloRelatorio  	= "SUBSTITUIÇÃO DIRETRIZ OU DÉFICIT"
	if strTipoModSub = "S" then strTituloRelatorio  	= "SUBSTITUIÇÃO"
	if strTipoModSub = "C" then strTituloRelatorio  	= "MODULAÇÃO CONTRATUAL"

	%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<%
	
	strCod_empresa 			= Session("CodEmpresa")
	strCodColaborador		= Trim(Request.QueryString("CodColaborador"))
	strCodigo				= Trim(Request.QueryString("Codigo"))
	strAnoLetivo			= Trim(Request.QueryString("AnoLetivo"))
	strStatus				= Trim(Request.QueryString("Status"))
	intSemestre 			= Session("strSemestre")
	
	'sql = "select c.nome, f.Desc_Funcao "
'	sql = sql & " from srh_colaborador c "
'	sql = sql & " inner join SRH_FUNCAOCOLABORADOR f on f.Cod_Funcao = c.CodFuncao "
'	sql = sql & " where c.codFuncao = 199 "
'	sql = sql & " and f.cod_grupo = " & session("codGrupo")
'	rsAux.open sql, cnn
'	if rsAux.eof = false then
'		strGerenteRH = trim(rsAux("nome"))
'		strFuncaoGerenteRH = trim(rsAux("Desc_Funcao"))
'	end if
'	rsAux.close
	
	sql = " select l.razaosocial as lotacao, p.Descricao as periodo, dd.situacao_disciplinar, SC.NOME as colaborador, SC.Codigo as Matricula, sc.CodFuncional,cl.desc_cargo as cargo, f.Desc_Funcao as funcao, ff.Desc_FormaNomeacao as nomeacao, t.desc_turno as turno, "
	sql = sql & " dd.periodo_inicial, dd.periodo_final, dd.DataInicial, dd.DataFinal, e.RAZAOSOCIAL as unidade, e.endereco, e.bairro, e.municipio, e.uf, e.cep, e.telefone, e.contato, e.contato1, sc.foneResidencial, sc.foneCelular, e.diretor, "
	sql = sql & " dd.tipo_contratacao, dd.Ano_letivo, dd.Semestre, dd.Cod_empresa, isnull(dd.Cod_Substituicao,'0') as Cod_Substituicao, d.Desc_Disciplina as disciplina, sum(dd.Total_Aulas) as total "
	sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE dd "
	sql = sql & " inner join SEG_EMPRESA e on e.CODIGO = dd.Cod_empresa "
	sql = sql & " left join SRH_FUNCAOCOLABORADOR f on f.cod_funcao = dd.cod_funcao"
	sql = sql & " left join SCA_disciplina d on d.cod_disciplina = dd.cod_disciplina"
	sql = sql & " left join SCA_periodo p on p.cod_periodo = dd.cod_periodo"
	sql = sql & " left join SRH_TURNO t on t.cod_turno = dd.cod_turno"
	sql = sql & " left join SRH_TURNO tur on tur.cod_turno = dd.cod_turno_opcional "
	sql = sql & " LEFT JOIN SRH_COLABORADOR sc ON SC.codigo = DD.Cod_Colaborador"
	sql = sql & " left join SEG_EMPRESA l on l.CODIGO = sc.Codlotacao"
	sql = sql & " LEFT JOIN SRH_CARGOCOLABORADOR cl ON cl.Cod_Cargo = sc.codcargo"
	sql = sql & " LEFT JOIN SRH_FORMANOMEACAOCOLABORADOR ff on ff.Cod_FormaNomeacao = sc.codFormaNomeacao"
	sql = sql & " where dd.Cod_Colaborador = " & strCodColaborador
	sql = sql & " and dd.Cod_empresa = " & strCodEmpDestino
	sql = sql & " and dd.ano_letivo = " & strAnoLetivo
	if strStatus = "A" then
		sql = sql & " and dd.tipo_contratacao = '" & strOrigem & "'"
	end if
	sql = sql & " and dd.status = '" & strStatus & "'"
	sql = sql & " group by l.razaosocial, p.Descricao, dd.situacao_disciplinar, SC.NOME, SC.Codigo, sc.CodFuncional, cl.desc_cargo, f.Desc_Funcao, ff.Desc_FormaNomeacao, t.desc_turno,  "
	sql = sql & " dd.periodo_inicial, dd.periodo_final, dd.DataInicial, dd.DataFinal, e.RAZAOSOCIAL, e.endereco, e.bairro, e.municipio, e.uf, e.cep, e.telefone, e.contato, e.contato1, sc.foneResidencial, sc.foneCelular, e.diretor, "
	sql = sql & " dd.tipo_contratacao, dd.Ano_letivo, dd.Semestre, dd.Cod_empresa, isnull(dd.Cod_Substituicao,'0'), d.Desc_Disciplina"
	sql = sql & " order by dd.tipo_contratacao desc"
'response.write sql
	rs.open sql, cnn
	if rs.eof = false then
		strLotacao = rs("lotacao")
		while not rs.eof
		
			if strOrigem = "C" then 
				TipoContrato = "Contrato"
				if isnull(rs("periodo_inicial")) then 
					strDataInicio = formatadataAP(rs("DataInicial"))
				else
					strDataInicio = formatadataAP(rs("periodo_inicial"))
				end if
			end if
			if strOrigem = "A" then 
				TipoContrato = "Por Período"
				if isnull(rs("periodo_inicial")) then 
					strDataInicio = formatadataAP(rs("datainicial")) & " ate " & formatadataAP(rs("DataFinal"))
				else
					strDataInicio = formatadataAP(rs("periodo_inicial")) & " ate " & formatadataAP(rs("periodo_final"))
				end if
			end if
			
			strColaborador 	= rs("colaborador")
			strNomeacao 	= rs("nomeacao")
			strTurno 		= rs("turno")
			strCodFuncional = rs("CodFuncional")
			strCargo 		= rs("cargo")
			strDiretor 		= rs("diretor")
			strUnidade 		= rs("unidade")
			strEndereco		= rs("endereco") & ", CEP " & rs("cep")
			strMunicipio	= rs("municipio") & "/" & rs("uf")
			strtelefone 	= rs("telefone")
			
			contatos = ""
			if not isnull(rs("foneResidencial")) then
				contatos	 	= rs("foneResidencial") 
				if not isnull(rs("foneCelular")) then
					contatos	 	= contatos & " | " & rs("foneCelular") 
				end if				
			else
				if not isnull(rs("foneCelular")) then
					contatos	 	= rs("foneCelular") 
				end if				
			end if
			
			'if strFuncao = "" then
				if rs("situacao_disciplinar") = "D" then
					strFuncao 		= strFuncao & "<br>- " & rs("funcao") & " - " & rs("periodo") & " - " & rs("total") & " aula(s), a partir " & strDataInicio
				else
					strFuncao 		= strFuncao & "<br>- " & rs("funcao") & " - " & rs("periodo") & ", a patir " & strDataInicio
				end if
			'else
			'	if rs("situacao_disciplinar") = "D" then
			'		strFuncao 		= "<br>" & strFuncao & ", " & rs("funcao") & " - " & rs("periodo") & "(" & rs("total") & "), a patir " & strDataInicio
			'	else
			'		strFuncao 		= "<br>" & strFuncao & ", " & rs("funcao") & " - " & rs("periodo") & ", a patir " & strDataInicio
			'	end if
			'end if
			
			rs.movenext		
		wend
	
	end if
	rs.close
	
		%>
        <br>
        <br>
        <br>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td colspan="2"  class="textoRelatorio">
			
            <div align="center"><strong>Modulação - <%=TipoContrato%></strong></div>
            
			<br>
            <p align="justify">
            Senhor(a) Gestor(a),
			<br>
            <br>
            <br>
            Encaminhamos o(a) servidor(a) <strong><%=strColaborador%></strong>, lotado no(a) <strong><%=strLotacao%></strong>, vínculo <strong><%=strNomeacao%></strong>, turno <strong><%=strTurno%></strong>, matrícula <strong><%=strCodFuncional%></strong> cargo <strong><%=strCargo%></strong>, para assumir a(s) função(ões) de:<br> <strong><%=strFuncao%></strong> 
			<br>
            <br>
            <br>
            Solicitamos a confirmação, via ofício, do comparecimento do(a) servidor(a) na data marcada para o início.
			<br>
            <br>
            Informamos ainda que qualquer alteração na modulação do(a) servidor(a) supracitado(a), deverá ser solicitado previamente, via ofício, a Diretoria de Gestão de Pessoas e Modulação. 
			<br>
            <br>
            </p>
            
            <p align="right"><%=Session("CidadeEmpresaWeb")%>, <%=day(date)%> de <%=monthName(month(date))%> de <%=year(date)%>.</p>
            <br>

            <br>
            Ilmo/a Sr/a
            <br>
            <strong><%=strDiretor%></strong>
            <br>
            Gestor(a) do(a) <strong><%=strUnidade%></strong>
            <br>
            <strong><%=strEndereco%></strong>
            <br>
            Telefone: <strong><%=strtelefone%></strong>
            <br>
            Assinatura: _____________________________________________________________
            <br>
            Telefones para contato: <strong><%=contatos%></strong>
            <br>
            Data: ______/______/_______
            <br>
            
            <%
			sql = "select USUA_NOME_COMPLETO as nome from SEG_USUARIOS_SISTEMA where USUA_CODG = '" & session("usuarioWeb") & "'"
			rs.open sql, cnn
			if not rs.eof then
					strUsuarioLogado =  ucase(rs("nome"))
			end if
			rs.close

			%>
            Emissor: <%=strUsuarioLogado%>
		
			</td>
		  </tr>
		</table>
			
</body>
</html>