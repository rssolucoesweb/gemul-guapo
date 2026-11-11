<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=10, IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
		<meta name="format-detection" content="telephone=no">
    <link href="css/bootstrap.css" rel="stylesheet" />
    <link href="css/bootstrap-theme.min.css" rel="stylesheet" />
    <title>Matrícula de Senador Canedo</title>
<style>
.tabelaResumo
{ 
	border-top: 1px solid #000000; 
	border-left: 1px solid #000000; 
	border-bottom: 1px solid #FFFFFF; 
	border-right: 1px solid #FFFFFF 
}
.celulaResumo 
{ 
	border-top: 1px solid #000000; 
	border-left: 1px solid #000000; 
	border-bottom: 1px solid #000000; 
	border-right: 1px solid #000000;
}
</style>
</head>
<body>
<!--#include file="includes/inc_formatadata.asp"-->
<%
	   strAnoLetivo = YEAR(DATE)
	strTipoCurso 					= Trim(Request("tp"))
	if strTipoCurso = "EI" then strTipoCurso = "EDUCAÇÃO INFANTIL"
	if strTipoCurso = "EF" then strTipoCurso = "ENSINO FUNDAMENTAL"

%>
<!--#include file="../includes/inc_cnn.asp"-->

<div id="botoes_imprimir_1" style="text-align: center">
    <br />
                <!--input type="button" class="btn btn-success" style="width:150px" value="Imprimir" onClick="javascript: print();" -->
				<!--input type="button" class="btn btn-default" value="Voltar" onClick="window.location='principal.asp';" -->
    <input type="button" class="btn btn-default" value="<< Voltar" onClick="window.location='resumo@.asp';" >
    <input type="button" class="btn btn-warning" value="Atualizar Dados" onClick="window.location='rel_resumoGeralAlunoEI_EF_Gemul@.asp?tp=<%=strTipoCurso%>';" >
  <br /><br />
    
</div>

<div style="background: #fff; padding: 25px; border: #000 0px solid; width: 100%; margin: 0 auto; color: #000;">
    <table width="100%">
    <tr>
        <td align="center"><img src="img/logo-grafico.png" alt="Prefeitura de Senador Canedo" /></td>
      </tr>
  </table>
<br>
<div style="text-align: center;  font: bold 16px Arial, Helvetica, sans-serif;">
    	Quantitativos de Alunos (Matriculados) - <%=strAnoLetivo%><br />
    Resumo Geral - <%=strTipoCurso%><br /><br />
</div>

<%

	strDescTurno = "0"
	intCodEmpresa = "0"
    strTituloRelatorio  	= "QUANTITAVOS DE ALUNOS - DETALHADO<br><strong>" & strTipoCurso & "</strong>"
	strclasse = "celulaResumo"
	situacaoAluno = "ATIVO"

	%>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tabelaResumo">
      <tr bgcolor="#CCCCCC">
        <td height="41" align="center" class="<%=strclasse%>"><strong>Período</strong></td>
        <td width="10%" height="17" align="center" class="<%=strclasse%>"><strong>Masculino</strong></td>
        <td width="10%" align="center" class="<%=strclasse%>"><strong>Feminino</strong></td>
        <td width="10%" align="center" class="<%=strclasse%>"><strong>Total</strong></td>
      </tr>
	<%
	cont = 0
	empresa = ""
	turno = ""
	total_M_linha = 0
	total_F_linha = 0
	total_linha = 0
	cod_escola = 0

	sql = "exec [dbo].[SP_SCA_QuantAlunoPorPeriodoSexo_resultado_total_resumo] 1," & strAnoLetivo & ",'" & strTipoCurso & "','" & strDescTurno & "','" & situacaoAluno & "'," & intCodEmpresa
	total_geral_M_linha = 0
	total_geral_F_linha = 0
	total_geral_linha = 0
	rs.open sql, cnn
	if not rs.eof then 
		While not rs.eof
		%>
          <tr>
               <td height="41" align="center" class="<%=strclasse%>"><%=rs("periodo")%></td>
               <td width="1%" height="17" align="center" class="<%=strclasse%>"><%=rs("quant_aluno_M")%></td>
               <td width="1%" align="center" class="<%=strclasse%>"><%=rs("quant_aluno_F")%></td>
               <td align="center" class="<%=strclasse%>"><%=rs("total")%></td>
          </tr>

       <%
	   		quant_aluno_M = quant_aluno_M + rs("quant_aluno_M")
	   		quant_aluno_F = quant_aluno_F + rs("quant_aluno_F")
			rs.movenext
		wend
	end if
	rs.close
%>

      <tr bgcolor="#CCCCCC">
        <td height="41" align="center" class="<%=strclasse%>"><strong>Total Geral</strong></td>
        <td height="17" align="center" class="<%=strclasse%>"><strong><%=quant_aluno_M%></strong></td>
        <td align="center" class="<%=strclasse%>"><strong><%=quant_aluno_F%></strong></td>
        <td align="center" class="<%=strclasse%>"><strong><%=quant_aluno_M+quant_aluno_F%></strong></td>
      </tr>

</table>