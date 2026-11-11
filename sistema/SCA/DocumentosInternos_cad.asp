<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br" 
	::	Data de Criação...: 12/04/2012
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Documentos Internos 
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link href="../../estilo/css.css" rel="stylesheet" type="text/css"></head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script src="../../js/js_funcoes_gerais.js"></script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->
<script>

	function marcaTodos(){
	
	var frm = document.getElementById("frm");
	
	if(frm.chkTodos.checked == true){ 
	  for (var i = 0; i < frm.elements.length; i++) {
				//verifica todos os checkbox
				if (frm.elements[i].type == "checkbox"){				
					frm.elements[i].checked = true;				
				}
	  }
	}else{
	  for (var i = 0; i < frm.elements.length; i++) {
				//verifica todos os checkbox
				if (frm.elements[i].type == "checkbox"){				
					frm.elements[i].checked = false;				
				}
	  }
	}
	return true;
}

	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.action="MaterialAula_cad.asp?txtCodigo="+intCodigo;
		frm.submit();
	}
	
	function ConsultaTurma(CodTurma){
	
		var frm = document.getElementById("frm");
		
		if (frm.txtCategoria.value == "Nao") {
			frm.action="MaterialAula_cad.asp?cmbTurma=" + CodTurma;
		}else{	
			frm.action="MaterialAula_cad.asp?cmbTurmaProfessor=" + CodTurma;	
		}	
		frm.submit();
	}
		
	function ConsultaDisciplina(CodDisciplina){
			
		var frm = document.getElementById("frm");
		 
		if (frm.txtCategoria.value == "Nao") { 
			frm.action="MaterialAula_cad.asp?cmbDisciplinaTurma=" + CodDisciplina + "&cmbTurma=" + frm.cmbTurma.value;
		}else{	
			frm.action="MaterialAula_cad.asp?cmbDisciplinaDoProfessor=" + CodDisciplina + "&cmbTurmaProfessor=" + frm.cmbTurmaProfessor.value;
		}
		frm.submit();
	}

	function salvar(acao){
		
		var frm = document.getElementById("frm");
		
		if ((acao=="I") || (acao=="A")){
			
						
			if (frm.txtDescricao.value == "") {
				alert("A Descrição do PDF deve ser informada !");
				frm.txtDescricao.focus();
				return false;
			}
			
			if((frm.Arq1.value.lastIndexOf(".pdf")==-1) && (frm.Arq1.value.lastIndexOf(".PDF")==-1)){  
					alert("Só é permitido fazer Upload de PDF ou DOC!"); 
					frm.Arq1.focus();  
					return false  
			} 
			
			frm.action="DocumentosInternos_cod.asp?acao=" + acao;
			frm.submit();
			return true;

		}
		
		if (acao=="E"){
			
			var parametro = "DocumentosInternos_cod_e.asp?txtCodigo=" + frm.txtCodigo.value + "&txtNomeArquivo=" + frm.txtNomeArquivo.							value;
			frm.action=parametro;
			frm.submit();
			return true;
		}	
}
</script>
<%
	strPaginaTitulo				= "DocumentosInternos_cad.asp"
	strPagina					= "DocumentosInternos_cad.asp"
	
	intCodEmp					= Session("CodEmpresa")
	intCodigo 					= Trim(Request("txtCodigo"))
	strUsuarioPortal 			= Session("UsuarioWeb")
	
	intCodEmpMarcada 			= Trim(Request.Form("chkEmp"))
	strData						= Trim(Request("txtData"))
	strDescricao 				= Trim(Request("txtDescricao"))
	strNomeArquivo				= Trim(Request("txtNomeArquivo"))
	
	if trim(intCodigo) <> "" then
	
		sql = "SELECT Codigo, CodDepartamento, Data, Descricao, NomeArquivo"
		sql = sql & " FROM SCA_DocumentosInternos"
		sql = sql & " where Cod_empresa = " & Session("CodEmpresa")	
		sql = sql & " And Codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 			= rs("Codigo")
			intCodDepartamento		= rs("CodDepartamento")
			strData					= rs("Data")
			strDescricao			= rs("Descricao")
			strNomeArquivo			= rs("NomeArquivo")
		
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
		
		end if 
		rs.close
	else
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		BotaoPDF   				= "disabled"
	end if 
	
	if strData = "" then strData = formataDataAP(date)
	
%>
<table width="100%" height="355" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td>
	<table border="0"  width="100%"  cellspacing="0" cellpadding="0" align="center">
      <tr valign="top">
        <td colspan="2" align="center">
		<form method="post" id="frm" ENCTYPE="multipart/form-data">
		  <table border="0" cellpadding="3" cellspacing="0" width="98%">
		    <tr>
		      <td colspan="2" align="center" class="texto"><span class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></span></td>
		      </tr>
		    <tr>
		      <td class="texto">&nbsp;</td>
		      <td><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">		        </td>
		      </tr>
		    <tr>
		      <td height="18" colspan="2" bgcolor="#CCCCCC" class="texto"><strong>Unidade/Empresa</strong></td>
		      </tr>
		    <tr>
		      <td height="10" colspan="2" class="texto"></td>
		      </tr>
		    <tr>
		      <td height="27" colspan="2" class="texto"><%IF strUsuarioPortal<>"" THEN%>
            
            
                <table width = "98%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="4%" align="center" class="celula">                        
                      <input name="chkTodos" type="checkbox" value="" onClick="return marcaTodos()">                  </td>
                    <td width="7%" class="celula"><strong>Empresa</strong></td>
                    <td width="89%" class="celula"><strong>Unidade/Empresa</strong></td>
                  </tr>
                  <%

			sql = "SELECT SEG_EMPRESA.RAZAOSOCIAL, SEG_GRUPO.DESCRICAO as GRUPO, SEG_EMPRESA.COD_GRUPO, SEG_EMPRESA.CODIGO AS COD_EMPRESA"
			sql = sql & " FROM SEG_EMPRESA"
			sql = sql & " INNER JOIN SEG_GRUPO ON SEG_GRUPO.CODIGO = SEG_EMPRESA.COD_GRUPO"
			sql = sql & " WHERE SEG_EMPRESA.COD_GRUPO = " & Session("CodGrupo") 
			sql = sql & " Order by SEG_GRUPO.DESCRICAO, SEG_EMPRESA.RAZAOSOCIAL"
			rs.open sql, cnn
			if rs.eof = false then
				while not rs.eof
					cont = cont + 1	
					strMarca 	= ""
					%>
                  <tr>
                    <td class="celula" align="center"><input name="chkEmp"  type="checkbox" value="<%=rs("cod_empresa")%>" <%=strMarca%>></td>
                    <td class="celula"><%=trim(rs("cod_empresa"))%></td>
                    <td class="celula"><%=trim(rs("RAZAOSOCIAL"))%></td>
                    </tr>
                  <%	
						rs.movenext
					wend
				  else
				  %>
                  <center>
                    <strong><%=strMensagemNaoEncontrado%></strong>
                    </center>
                <%		
					end if
					rs.close
				  %>
                    </table>
                <%END IF%>                &nbsp;</td>
		      </tr>
		    <tr>
		      <td height="27" class="texto">Data:</td>
		      <td><span class="texto">
		        <input readonly name="txtData" type="text" class="text" id="txtData" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strData%>" title="Click aqui para visualizar o calend&aacute;rio">
		      </span></td>
		      </tr>
		    <tr>
		      <td height="31" class="texto">Descri&ccedil;&atilde;o:</td>
		      <td>
              <input name="txtDescricao" type="text" class="text" id="txtDescricao" size="50" maxlength="50" value="<%=strDescricao%>"  onKeyPress="return formataCampo(this, 1, 50)">
		        <span class="texto">
		        <input name="txtNomeArquivo" type="hidden" class="text" id="txtNomeArquivo" size="40" maxlength="40" value="<%=strNomeArquivo%>" />
		        </span></td>
		      </tr>
		    <tr>
		      <td width="154" class="texto">Selecione a Arquivo:</td>
		      <td width="818"><input type="file" name="Arq1" id="Arq1" class="text" value="" style="width:400px;"></td>
		      </tr>
		    <tr>
		      <td colspan="2" class="texto">&nbsp;</td>
		      </tr>
		    <tr>
		      <td colspan="2" class="texto"><!--#include file="../../includes/inc_botoes_cadastro.asp"-->&nbsp;</td>
		      </tr>
		    <tr>
		      <td colspan="2" class="texto">&nbsp;</td>
		      </tr>
		    <tr>
		      <td colspan="2" class="texto">Para enviar fotos, selecione-a em seu computador clicando nos bot&otilde;es
		        &quot;Procurar&quot;.</td>
		      </tr>
		    <tr>
		      <td colspan="2" class="texto">Aviso: Envie apenas arquivo PDF.</td>
		      </tr>
		    <tr>
		      <td colspan="2" class="texto">&nbsp;</td>
		      </tr>
		    <tr>
		      <td colspan="2" class="texto">
			  <%
			  
			  
				cont =0
				sql = " SELECT Codigo, Data, Descricao, NomeArquivo"
				sql = sql & " FROM SCA_DocumentosInternos"
				sql = sql & " where cod_empresa = " & Session("CodEmpresa")	
				sql = sql & " ORDER BY Descricao"
				rs.open sql, cnn
				if rs.eof = false then
				%>
                <table width = "99%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" class="tabela">
                  <tr bgcolor="#E5E5E5">
                    <td width="48%" class="celula"><strong>Descri&ccedil;&atilde;o</strong></td>
                    <td width="45%" height="21" bgcolor="#E5E5E5" class="celula"><strong>Arquivo</strong></td>
                  </tr>
                  <%
			  while not rs.eof
			  cont = cont + 1	
							%>
                  <tr>
                    <td class="celula"><%=trim(rs("Descricao"))%></td>
                    <td height="21" class="celula">&nbsp;<a href="../../DocumentosInternos/<%=intCodEmp%>/<%=trim(rs("NomeArquivo"))%>" target="_blank"><%=trim(rs("NomeArquivo"))%></a></td>
                  </tr>
                  <%				
					rs.movenext
					wend
					%>
                  <tr>
                    <td height="21" colspan="2" class="celula">Total 
                      Registros : <%=cont%></td>
                  </table>
                <%
			  end if
			  rs.close
			  
			 %></td>
		      </tr>
		    <tr>
		      <td colspan="2" class="texto">&nbsp;</td>
		      </tr>
		    </table>
			<br>
		</form>
		</td>
      </tr>
    </table>
	</td>
  </tr>
</table>
<!--#include file="../rodape.asp"-->
</body>
</html>