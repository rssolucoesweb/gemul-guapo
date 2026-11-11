<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%  
response.Charset = "utf-8" 
response.ContentType = "text/html" 
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 03/03/2009
	::	Desenvolvedores...: Sergio Borges - sergiob76@hotmail.com
	::	Objetivo Pagina...: feriados
-->
<html>
<head>
<title><%=session("Titulo")%> - resultados</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<style>
.celula15
{ 
	border-top: 1px solid #FFFFFF; 
	border-left: 1px solid #FFFFFF; 
	border-bottom: 1px solid #000000; 
	border-right: 1px solid #000000;
	font-size: 15;	
}
.celula20
{ 	border-top: 1px solid #FFFFFF; 
	border-left: 1px solid #FFFFFF; 
	border-bottom: 1px solid #000000; 
	border-right: 1px solid #000000;
	font-size: 20;	
}
</style>
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script>
</head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file="../../includes/inc_aguarde.asp"-->
<br>
<%
	dim intPagina
	
	cod_pesquisa = request("cod_pesquisa")
	cod_setor = request("cod_setor")
	if cod_setor = "" then cod_setor = "0"
	sql = "select s.codigo, s.nome, c.nome as cidade, e.nome as estado"
	sql = sql & " from PES_pesquisa s "
	sql = sql & " left join PES_cidade c on c.codigo = s.cod_cidade"
	sql = sql & " left join PES_estado e on e.codigo = c.cod_estado"
	sql = sql & " where s.codigo = " & cod_pesquisa
	sql = sql & " order by s.situacao, s.nome"
	rs.open sql, cnn
	if not rs.eof then
		pesquisa = rs("nome") & "<br>" & rs("cidade") & "-" & rs("estado")
	end if
	rs.close
	
	SQL = "UPDATE PES_resultado_respostas_texto SET RESPOSTA = replace(replace(replace(replace(replace(upper(resposta),'Ã','A'),'N?O','NAO'),'Ô','O'),'É','E'),'OPIMOU','OPINOU')"
	CNN.EXECUTE SQL
	
	setor = ""
	if cod_setor <> "0" then
		sql = "select nome"
		sql = sql & " from PES_setor s "
		sql = sql & " where codigo = " & cod_setor
		rs.open sql, cnn
		if not rs.eof then
			setor = "<br>" & rs("nome")
		end if
		rs.close
	end if
	strTituloRelatorio  	= "Quantitativo do Resultado da Pesquisa <br>" & pesquisa & setor

	sub mostraCabecalho()
	%>
	<div align="center" style="60%" class="titulo"><h1>Sistema Gemul</h1></div>
	<div align="center" style="60%" class="titulo"><h2><%=strTituloRelatorio%></h2></div>
    
	<br>
	<table align="center" width="60%" border="0" cellspacing="0" cellpadding="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td width="40%" class="celula"><div align="left"><strong>Resposta</strong></div></td>
		<td width="30%" class="celula" align="left"><strong>Quantitativo</strong></td>
		<td width="30%" class="celula" align="left"><strong>Percentual</strong></td>
	  </tr>
	<%
	end Sub
	
	sub fimTabela()
		response.Write("</table>")
	end Sub

	intPagina = 1
	mostraCabecalho
	intQtdeRegistro = 0
	sql = "select p.codigo as cod_pergunta, p.nome as pergunta, tr.nome as resposta, re.cod_tipo_resposta, count(*) as quantidade"
	sql = sql & " from pes_resultado r"
	sql = sql & " inner join PES_entrevistado ent on ent.codigo= r.cod_entrevistado"
	sql = sql & " inner join PES_resultado_respostas rr on rr.cod_resultado = r.codigo"
	sql = sql & " inner join PES_pergunta p on p.codigo = rr.cod_pergunta"
	sql = sql & " inner join PES_resposta re on re.codigo = rr.cod_resposta"
	sql = sql & " inner join PES_tipo_resposta tr on tr.codigo = re.cod_tipo_resposta"
	sql = sql & " inner join PES_pesquisa pes on pes.codigo = r.cod_pesquisa"
	sql = sql & " where p.cod_pesquisa = " & cod_pesquisa
	if cod_setor <>"0" then
	sql = sql & " and ent.cod_setor = " & cod_setor
	end if
	sql = sql & " group by p.codigo, p.nome, tr.nome, re.ordem, re.cod_tipo_resposta"
	sql = sql & " order by p.codigo, re.ordem"
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
			quant_respostas = 0
			sql = " select count(*) as quant_respostas from PES_resultado_respostas where cod_pergunta = " & rs("cod_pergunta")
			rsAux.open sql, cnn
			if not rsAux.eof then 
				quant_respostas = rsAux("quant_respostas")
			end if
			rsAux.close
			percentual  = (rs("quantidade")*100)/quant_respostas
			if cod_pergunta <> rs("cod_pergunta") then
				%>
				<tr> 
				  <td height="50" colspan="3" align="center" class="celula20"><strong><%=rs("pergunta")%></strong></td>
				</tr>
				<%	
			end if
			IF rs("cod_tipo_resposta") <> "1" THEN
				%>
				<tr> 
				  <td height="20" align="left" class="celula15"><strong><%=rs("resposta")%></strong></td>
				  <td height="20" align="left" class="celula15"><strong><%=rs("quantidade")%></strong></td>
				  <td height="20" align="left" class="celula15"><strong><%=formatNumber(percentual,1)%> %</strong></td>
				</tr>
				<%			
			ELSE
				sql = "select replace(replace(replace(replace(upper(rt.resposta),'Ã','A'),'N?O','NAO'),'Ô','O'),'É','E') as resposta, count(*) as quantidade"
				sql = sql & " from PES_resultado_respostas_texto rt"
				sql = sql & " inner join PES_resultado_respostas r on r.Codigo = rt.cod_resultado_respostas"
				sql = sql & " inner join PES_resultado re on re.Codigo = r.cod_resultado"
				sql = sql & " inner join PES_entrevistado ent on ent.codigo= re.cod_entrevistado"
				sql = sql & " where re.cod_pesquisa = " & cod_pesquisa
				sql = sql & " and r.cod_pergunta = " & rs("cod_pergunta")
				if cod_setor <>"0" then
					sql = sql & " and ent.cod_setor = " & cod_setor
				end if
				sql = sql & " group by replace(replace(replace(replace(upper(rt.resposta),'Ã','A'),'N?O','NAO'),'Ô','O'),'É','E')"
				sql = sql & " ORDER BY 1"
				rsAux.open sql, cnn
				if not rsAux.eof then 
					While not rsAux.eof
						quant_respostas_expontanea = 0
						sql = " select count(*) as quant_respostas_expontanea from PES_resultado_respostas_texto rt inner join PES_resultado_respostas r on r.Codigo = rt.cod_resultado_respostas"
						sql = sql & " inner join PES_resultado re on re.Codigo = r.cod_resultado"
						sql = sql & " where re.cod_pesquisa = " & cod_pesquisa
						sql = sql & " and r.cod_pergunta = " & rs("cod_pergunta")
						rsAux1.open sql, cnn
						if not rsAux1.eof then 
							quant_respostas_expontanea = rsAux1("quant_respostas_expontanea")
						end if
						rsAux1.close
						percentual  = (rsAux("quantidade")*100)/quant_respostas_expontanea
						%>
						<tr> 
						  <td height="20" align="left" class="celula15"><strong><%=rsAux("resposta")%></strong></td>
						  <td height="20" align="left" class="celula15"><strong><%=rsAux("quantidade")%></strong></td>
						  <td height="20" align="left" class="celula15"><strong><%=formatNumber(percentual,1)%> %</strong></td>
						</tr>
						<%	
						rsAux.movenext
					wend
				end if
				rsAux.close
			END IF
			cod_pergunta = rs("cod_pergunta")
			rs.movenext
		wend
	else
		%>
		  <tr>
			<td colspan="4" class="celula" align="center"><br><br><br><br><font color="#993300"><%=session("strMensagemRelatorioNaoEncontrado")%></font></td>
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
