<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body>
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<script src="../../js/js_funcoes_gerais.js"></script>
<script>
	function gerar(ano,semestre){
		window.open('PortalAluno_Boletim_rel.asp?Ano='+ano+'&Semestre='+semestre,"popup","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=900, height=400, left=0, top=0");			
 	}
	
</script>
<%
	principal			= "principal.asp"
	
	strExecutarSubmitSemestre = "S"
	
	strAnoLetivo 			= Trim(Request.Form("txtAnoLetivo"))
	if strAnoLetivo = "" then 	strAnoLetivo = session("strAnoLetivo")
	intSemestre 	= Trim(Request.Form("cmbSemestre"))
	if intSemestre = "" then 	intSemestre  = session("strSemestre")
	
		'busca informações ano e semestre letivo
	sql = " SELECT top 1 ano_letivo, semestre, Bloqueia_NotasDocente "
	sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
	sql = sql & " Where cod_empresa = " & Session("CodEmpresa") 
	sql = sql & " order by ano_letivo desc"
	rs.Open SQL, cnn
	if rs.EOF = false then								
		strBloqueiaNotasDocente = rs("Bloqueia_NotasDocente")
	else
		%>
		<script>
			alert("ATENÇÃO: Período Letivo não Habilitado, procure a Secretaria Geral.");
			window.location='default.asp';
		</script>
		<%
		response.end
	end if
	rs.close


%>
<table width="100%" height="355" border="0" cellpadding="0" cellspacing="0"  bgcolor="#FFFFFF">
  <tr valign="top">
    <td width="746" align="center">
	<form method="post" id="frm">	
	  <table width="96%" border="0" cellpadding="0" cellspacing="0" >
        <tr valign="top">
          <td colspan="2" align="center" class="tituloPrincipal"><strong>BOLETIM DE NOTAS E FALTAS</strong></td>
        </tr>
        <tr valign="top">
          <td colspan="2" align="center" class="tituloPrincipal style2">&nbsp;</td>
        </tr>
        <tr valign="top">
          <td colspan="2" align="center" class="texto1">Obs: Informar o ANO e o SEMESTRE para consultar seu boletim de notas e faltas.</td>
          </tr>
        <tr valign="top">
          <td align="left" class="texto1">&nbsp;</td>
          <td align="center" class="tituloPrincipal style2">&nbsp;</td>
        </tr>
        <tr valign="top">
          <td align="left" class="texto1">Ano:</td>
          <td align="center" class="tituloPrincipal style2"><div align="left">
            <input  name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" onBlur="submit()"  value="<%=strAnoLetivo%>" size="5" maxlength="5" onKeyPress="return formataCampo(this,2,10)">
          </div></td>
        </tr>
        <tr valign="top">
          <td align="center" class="texto1"><div align="left">Semestre:</div></td>
          <td align="center" class="tituloPrincipal style2"><div align="left"><!--#include file="../includes/inc_cmdSemestre.asp" --></div></td>
        </tr>
        <tr valign="top">
          <td width="10%" align="center" class="tituloPrincipal style2">&nbsp;</td>
          <td width="90%" align="center" class="tituloPrincipal style2">&nbsp;</td>
        </tr>
        <tr valign="top">
          <td colspan="2" align="center" class="tituloPrincipal style2"><!--#include file="../../includes/inc_botoes_geraRelatorioBoletimPortal.asp"-->&nbsp;</td>
        </tr>
      </table>
	  </form>
	</td>
  </tr>
</table>
<!--#include file="../rodape.asp"-->
</body>
</html>