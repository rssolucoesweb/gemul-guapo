<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 26/07/2012
	::	Desenvolvedores...: Sergio@rssolucoesweb.com.br
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link type="text/css" rel="stylesheet" href="../../Estilo/Estilo_Impressao.css">
<style>
.celulaTotal
{ 
	FONT-SIZE: 14pt;
	border-top: 1px solid #FFFFFF; 
	border-left: 1px solid #FFFFFF; 
	border-bottom: 1px solid #000000; 
	border-right: 1px solid #000000;
}
</style>
<script src="../../js/js_funcoes_gerais.js"></script>
<script src="../../js/js_barra_movel.js"></script></head>
<body>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../includes/inc_Botoes_relatorio.asp"-->
<!--#include file=../../includes/inc_aguarde.asp-->
<br>
<%
	dim intPagina
	strCod_empresa 			= Session("CodEmpresa")
	intOrdenacao 			= request.Form("cmbOrdenacao")
	strOpcao	 			= request.Form("cmbOpcao")
	strCurso 				= request("cmbCurso")
	strPeriodo 				= request("cmbPeriodo")

	intCodSetor 			= request("cmbSetor")
	if intCodSetor = "" then intCodSetor = "0"
	intCodRegiao 			= request("cmbRegiao")
	if intCodRegiao = "" then intCodRegiao = "0"

	strDataInicio 	= request("data_inicio")
	strDataFim 		= request("data_fim")
	
	
	strTituloRelatorio  	= "Rela&ccedil;&atilde;o de Cadastro de Reservas da <br> Matrícula " & year(date)
	if strDataInicio<>"" and strDataFim<>"" then
		strTituloRelatorio = strTituloRelatorio & " - Período: " & formatadataAP(strDataInicio) & " a " & formatadataAP(strDataFim)
	end if
	if strCurso <> "0" then
		strTituloRelatorio  	= "Rela&ccedil;&atilde;o Totais de Cadastro de Reservas do <strong>" & strCurso & "</strong> <br> Matrícula " & year(date)
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
	if strSetor <> "" then
		strTituloRelatorio  	= "Rela&ccedil;&atilde;o Totais de Cadastro de Reservas do <strong>" & strSetor & "</strong> <br> Matrícula " & year(date)
		if strDataInicio<>"" and strDataFim<>"" then
			strTituloRelatorio = strTituloRelatorio & " - Período: " & formatadataAP(strDataInicio) & " a " & formatadataAP(strDataFim)
		end if
	end if
	sub mostraCabecalhoLogo()
%>
	<!--#include file="../../includes/inc_cabecalhoRelatorio.asp"-->
	<br>
	<%
	end Sub

	sub mostraCabecalhoTotal()
%>
	<table width="60%" border="0" align="center" cellpadding="0" cellspacing="0" class="tabela">
	  <tr bgcolor="#CCCCCC">
		<td height="31" colspan="2"  align="center" class="celulaTotal"><strong>RESUMO DAS RESERVAS POR PERÍODO</strong></td>
	  </tr>
      <%
      
      	sql = "SELECT periodo, count(*) as qtde "
		sql = sql & " FROM MAT_Reserva "		
		sql = sql & " where Situacao = 'R'"
		if strOpcao = "C" then
			sql = sql & " AND ISNULL(ATUALIZADO,'N') = 'N'"
		end if
		if strOpcao = "E" then
			sql = sql & " AND ATUALIZADO = 'S'"
		end if
		if bolsa = "C" then
			sql = sql & " AND bolsa_familia is not null"
			msn = " com bolsa família"
		end if
		if bolsa = "S" then
			sql = sql & " AND bolsa_familia is null"
			msn = " sem bolsa família"
		end if
		
		if strPeriodo <> "0" then
			SQL = SQL & " AND periodo = '" & replace(strPeriodo,"_"," ") & "'"
		end if
		if strCurso <> "0" then
			SQL = SQL & " AND curso = '" & replace(strCurso,"_"," ") & "'"
		end if

		if strSetor <> "" then
			SQL = SQL & " AND bairro = '" & strSetor & "'"
		end if
		
		if strDataInicio<>"" and strDataFim<>"" then
			SQL = SQL & " AND data_efetivacao between '" & formatadataBD(strDataInicio) & "' and '" & formatadataBD(strDataFim) & "'"
		end if
	
		
		if intCodRegiao <> "0" then
			'inicio regra nova para buscar pelo setor(bairro)
			SQL = SQL & " and bairro in "
			SQL = SQL & " ("
			SQL = SQL & " 	select s.descricao"
			SQL = SQL & " 	from MAT_regiao_setores  rs"
			SQL = SQL & " 	inner join mat_setores s on s.codigo =  rs.cod_setores"
			SQL = SQL & " 	where rs.cod_regiao = " & intCodRegiao & ""
			SQL = SQL & " )			"
		end if
				
		sql = sql & " group by periodo order by periodo	"
		'RESPONSE.WRITE SQL
		rs.open sql, cnn
		if not rs.eof then 
			While not rs.eof
				%>
				<tr>
					<td width="57%" height="48" class="celulaTotal">&nbsp;<%=rs("periodo")%></td>
					<td width="43%" align="center" class="celulaTotal"><%=rs("qtde")%></td>
				</tr>
				<%
				total = total + rs("qtde")
				rs.movenext
			wend
		end if
		rs.close
	%>
        <tr bgcolor="#EEEEEE">
       		<td height="40" class="celulaTotal"><strong>&nbsp;TOTAL</strong></td>
       		<td height="40" align="center" class="celulaTotal"><strong><%=total%></strong></td>
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
%>
</table>
<script>
	aguarde.style.display="none";
</script>
</body>
</html>
