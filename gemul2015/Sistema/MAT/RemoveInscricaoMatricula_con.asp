<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 2/04/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Cadastro de Ata
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css">
</head>
<body>
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script>

	function ConsultaMat(){
	
		var frm = document.getElementById("frm");
		
		if (frm.txtCodAluno.value=='' && frm.txtMatricula.value=='' && frm.txtAluno.value=='' && frm.txtMae.value==''){
			alert("Deve ser informado pelo menos um dos campos para a consulta ser efetuada.")
			return false;
		}
		else
		{
			frm.submit();		
			}
		
	}
	
	function remover(codInscricao,codEmpresa){
		
		var frm = document.getElementById("frm");
		
		if (!confirm('Deseja cancelar essa solicitação?'))
			return false;
		else{
			frm.action="RemoveInscricaoMatricula_cod.asp?txtCodigoEmpresa="+codEmpresa+"&txtCodigoInscricao="+codInscricao;
			frm.submit();
			return true;
		}
 	}
</script>
<%
	strPaginaTitulo 		= "RemoveInscricaoMatricula_con.asp"
	strPagina				= "RemoveInscricaoMatricula_con.asp"

	strCodAluno 			= Trim(Request.Form("txtCodAluno"))
	
	strMatricula 			= Trim(Request.Form("txtMatricula"))
	strAluno 				= Trim(Request.Form("txtAluno"))
	strMae 					= Trim(Request.Form("txtMae"))
	strConsultar			= Trim(Request.Form("strConsultar"))
%>
<table width="100%" border="0"  class="CorFundo" cellpadding="0" cellspacing="0" align="center">
  <tr>
    <td>
    <form id="frm" method="post" action="RemoveInscricaoMatricula_con.asp">
    	<input type="hidden" name="strConsultar" id="strConsultar" value="S">
		<table width="100%" height="502" align="left" class="CorFundo" >
    <tr>
      <td width="100%" height="85" align="center" valign="top">
	  <table width="60%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="49" colspan="2" align="center" class="tituloPrincipal">Consulta Solicitação de Matrícula para Cancelamento</td>
          </tr>
          <tr>
            <td width="146">&nbsp;</td>
            <td width="791">&nbsp;</td>
          </tr>
          <tr>
            <td height="28"><span class="TextoForm">Matr&iacute;cula: </span></td>
            <td><span class="texto1">
              <input name="txtMatricula" type="text" class="text" id="txtMatricula" size="15" maxlength="20" value="<%=strMatricula%>"  onKeyPress="return formataCampo(this, 2, 10)">
              </span></td>
          </tr>
          <tr>
            <td height="28"><span class="TextoForm">N. Inscri&ccedil;&atilde;o: </span></td>
            <td><span class="texto1">
              <input name="txtCodAluno" type="text" class="text" id="txtCodAluno" size="15" maxlength="20" value="<%=strCodAluno%>"  onKeyPress="return formataCampo(this, 2, 10)">
            </span></td>
          </tr>
          <tr>
            <td height="28"><span class="TextoForm">Nome do Aluno:   </span></td>
            <td><input name="txtAluno" type="text" class="text" id="txtAluno" size="50" maxlength="50" value="<%=strAluno%>" /></td>
          </tr>
          <tr>
            <td height="28"><span class="TextoForm">Nome da Mãe:   </span></td>
            <td><input name="txtMae" type="text" class="text" id="txtMae" size="50" maxlength="50" value="<%=strMae%>" /></td>
          </tr>
          <tr>
            <td height="28">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td colspan="2">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td>
                    <input class="botao" type="button" value="Consultar" <%=strDesabilitaConsultar%>  name="cmdConsultar" onClick="return ConsultaMat()">
                    <input type="button" name="cmdLimpar"  value="Limpar"  class="botao" <%=strDesabilitaLimpar%> onClick="return limpar('<%=strPagina%>')">&nbsp;
                    </td>
                </tr>
            </table>
            </td>
          </tr>
        </table>
		<br>
		<table width = "100%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
		  <tr bgcolor="#E5E5E5">
		    <td class="celula"><strong>N.Inscrição</strong></td>
			<td class="celula"><strong>Matr&iacute;cula</strong></td>
			<td width="16%" bgcolor="#E5E5E5" class="celula"><strong>Nom</strong><strong>e do Aluno </strong></td>
		 	<td width="22%" bgcolor="#E5E5E5" class="celula"><strong>Nome da Mãe</strong></td>
		 	<td width="31%" bgcolor="#E5E5E5" class="celula"><strong>Escola </strong></td>
		    <td width="10%" bgcolor="#E5E5E5" class="celula"><strong>Situa&ccedil;&atilde;o</strong></td>
		    <td width="5%" align="center" bgcolor="#E5E5E5" class="celula"><strong>Cancelar</strong></td>
		  </tr>
		  <%
			cont =0
			strCpf 		= replace(replace(strCpf,".",""),"-","")

			if strConsultar <> "" then
				sql = "SELECT A.CODIGO, A.MATRICULA, A.NOME, A.DATA_NASCIMENTO, A.MAE, A.COD_EMPRESA, A.COD_ALUNO, SA.DESC_SITUACAOALUNO, em.RAZAOSOCIAL AS ESCOLA, a.usuario_exc_cadastro, a.data_exc_cadastro, a.excluido, a.usuario_exc, a.data_exc "
				sql = sql & " FROM MAT_INSCRICAO A"
				sql = sql & " LEFT JOIN SCA_ALUNO AL ON AL.CODIGO = A.COD_ALUNO"
			    sql = sql & " LEFT JOIN SCA_SITUACAOALUNO SA ON SA.Cod_SituacaoAluno = AL.COD_SITUACAOALUNO "
			    sql = sql & " LEFT JOIN SEG_EMPRESA EM ON EM.codigo = A.COD_EMPRESA "
				sql = sql & " where A.Cod_Empresa in (select codigo from SEG_EMPRESA where COD_GRUPO=" & SESSION("codGrupo")& ")	"	
				if strCodAluno <> "" then
					sql = sql & " and A.COD_ALUNO = " & strCodAluno
				end if
				if strMatricula <> "" then
					sql = sql & " and A.MATRICULA = '" & strMatricula & "'"
				end if
				if strAluno <> "" then
					sql = sql & " and A.NOME LIKE '%" & strAluno & "%'"
				end if
				if strMae <> "" then
					sql = sql & " and A.MAE LIKE '%" & strMae & "%'"
				end if
				sql = sql & " order by em.RAZAOSOCIAL, A.NOME"
			
				rs.open sql, cnn
				if rs.eof = false then
					while not rs.eof
						cont = cont + 1
						excluido=rs("excluido")
						if excluido="S" then
							excluido = "Cancelado por&nbsp;" & rs("usuario_exc") & " " & rs("data_exc")
						else
							excluido = ""
						end if
						if not isnull(rs("usuario_exc_cadastro")) then excluido = "Excluído pelo cadastro por&nbsp;" & rs("usuario_exc_cadastro") & " " & rs("data_exc_cadastro")
						sit = rs("DESC_SITUACAOALUNO")
						%>
						<tr bgcolor="#FFFFFF" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" >
							<td width="7%" class="celula">&nbsp;<%=trim(rs("COD_ALUNO"))%></td>
							<td width="5%" height="40" class="celula">&nbsp;<%=trim(rs("MATRICULA"))%></td>
							<td class="celula">&nbsp;<%=trim(rs("NOME"))%>&nbsp;</td>
							<td class="celula">&nbsp;<%=trim(rs("MAE"))%>&nbsp;</td>
							<td class="celula">&nbsp;<%=trim(rs("escola"))%></td>
							<td class="celula"><%=trim(rs("DESC_SITUACAOALUNO"))%>&nbsp;<%=excluido%></td>
							<td align="center" class="celula"><%if UCASE(trim(sit))="PRÉ-MATRÍCULA" then%><a href="#" onClick="remover('<%=rs("codigo")%>','<%=rs("cod_empresa")%>')"><img src="../../images/botao_vermelho_normal.gif" width="26" height="26" alt="Excluir solicitação de matrícula."></a><%END IF%>&nbsp;</td>
						</tr>
						<%				
					rs.movenext
					wend
				end if
				rs.close
			end if	
			%>
		</table>
	</td> 
    </tr>
  </table>
    
    </form>
    </td>
  </tr>
</table>

<!--#include file="../rodape.asp"-->
</body>
</html>