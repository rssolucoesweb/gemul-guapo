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
	id		= Trim(Request("id"))
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
              <td width="700" align="center" class="tituloSistema">Aluno Ativo</td>
            </tr>
          </table>
		  <br>
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td colspan="2">
			<%
			cont = 0
			sql = " select e.razaosocial as unidade, a.nomealuno"
			sql = sql & " from mat_reserva r"
			sql = sql & " inner join sca_aluno a on a.nomealuno = r.nome and a.DATANASCIMENTO = r.data_nascimento and a.MAE = r.mae"
			sql = sql & " inner join SCA_SITUACAOALUNO s on s.cod_situacaoaluno = a.cod_situacaoaluno"
			sql = sql & " inner join SCA_ALUNO_TURMA at on at.cod_aluno = a.codigo and at.situacao = 'A'"
			sql = sql & " inner join SEG_EMPRESA e on e.codigo = at.cod_empresa"
			sql = sql & " where r.cod_aluno is null "
			sql = sql & " and s.Desc_SituacaoAluno = 'ATIVO'"
			sql = sql & " and r.codigo = " & id
			sql = sql & " order by 1"
			'response.write sql
			rs.open sql, cnn
			if rs.eof = false then
			%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr>
                    <td width="72%" height="21" align="center" class="celula"><strong><font size="+1"><%=rs("nomealuno")%></font></strong></td>
                    </tr>
                  <tr bgcolor="#E5E5E5">
                    <td width="72%" height="21" align="center" class="celula"><strong>Unidades<span class="TextoForm"></span></strong></td>
                    </tr>
                  <%
				while not rs.eof
					cont = cont + 1	
					%>

                  <tr >
                    <td height="20" class="celula" ><%=trim(rs("unidade"))%></td>
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