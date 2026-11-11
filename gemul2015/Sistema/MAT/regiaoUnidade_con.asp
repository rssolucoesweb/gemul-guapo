<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 06/12/2017
	::	Desenvolvedores...: Sergio sergio@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de setores / unidade
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<%
	strPaginaTitulo 	= "regiaoUnidade_cad.asp"
	intCodRegiao		= Trim(Request("txtCodRegiao"))
	strRegiao 		= Trim(Request("txtRegiao"))
	
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table width="100%"  height="325" border="0" cellspacing="0" cellpadding="0">
      <tr valign="top">
        <td colspan="2" align="center">
		<form id="frm" method="post">
		  <table width="100%" border="0" cellpadding="0" cellspacing="0">

            <tr valign="top">
              <td width="100%" align="center" class="tituloSistema">Região/Unidade </td>
            </tr>
          </table>
		  <br>
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="3%" class="texto1">Região:</td>
            <td width="97%" >&nbsp;
            <input name="txtCodigo" type="hidden" id="txtCodigo"  value="<%=intCodRegiao%>">
            <input name="txtRegiao" type="hidden" id="txtRegiao"  value="<%=strRegiao%>">
            <font size="+1"><strong><%=strRegiao%></strong></font></td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2"><%
			cont =0
			sql = " SELECT distinct E.RAZAOSOCIAL, R.COD_empresa, r.cod_regiao, E.CODIGO AS COD_EMPRESA "
			sql = sql & " FROM SEG_EMPRESA E "
			sql = sql & " INNER JOIN MAT_regiao_empresa R ON R.COD_empresa = E.codigo and r.cod_regiao =" & intCodRegiao
			sql = sql & " WHERE E.BLOQUEIO='N' "
			sql = sql & " AND E.COD_GRUPO = " & Session("CodGrupo")
			sql = sql & " Order by E.RAZAOSOCIAL	"	
			rs.open sql, cnn
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td height="21" align="center" class="celula"><strong>Unidade Escolar<span class="TextoForm"></span></strong></td>
                    </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					%>

                  <tr >
                    <td height="20" class="celula" ><%=trim(rs("RAZAOSOCIAL"))%></td>
                    </tr>
                  <%				
					rs.movenext
					wend
				  %>
                  <tr>
                    <td height="21" class="celula"><strong>Total Registros: <%=cont%></strong></td>
                  </table>
              <%
			  end if
			  rs.close%></td>
          </tr>
        </table>
		</form>
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
</body>
</html>