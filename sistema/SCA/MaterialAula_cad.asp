<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br" 
	::	Data de Criação...: 13/02/2008
	::	Desenvolvedores...: Sergio Borges - Sergiob76@gmail.com
	::	Objetivo Pagina...: Cadastro de Turma 
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
			
			if (frm.txtCategoria.value == "Nao") {
				
				if (frm.cmbTurma.value == "0") {
					alert("A Turma deve ser informada !");
					frm.cmbTurma.focus();
					return false;
				}
			
			}else{
			
				if (frm.cmbTurmaProfessor.value == "0") {
					alert("A Turma Professor deve ser informada !");
					frm.cmbTurmaProfessor.focus();
					return false;
				}
			
			}
			
			if (frm.txtCategoria.value == "Nao") {
				
				if (frm.cmbDisciplinaTurma.value == "0") {
					alert("A Disciplina deve ser informada !");
					frm.cmbDisciplinaTurma.focus();
					return false;
				}
				
			}else{
			
				if (frm.cmbDisciplinaDoProfessor.value == "0") {
					alert("A Disciplina Professor deve ser informada !");
					frm.cmbDisciplinaDoProfessor.focus();
					return false;
				}
			
			}
			
			if (frm.txtDescricao.value == "") {
				alert("A Descrição do PDF deve ser informada !");
				frm.txtDescricao.focus();
				return false;
			}
			
			if((frm.Arq1.value.lastIndexOf(".pdf")==-1) && (frm.Arq1.value.lastIndexOf(".PDF")==-1) && (frm.Arq1.value.lastIndexOf(".doc")==-1)){  
					alert("Só é permitido fazer Upload de PDF ou DOC!"); 
					frm.Arq1.focus();  
					return false  
			} 
			
			frm.action="MaterialAula_cod.asp?acao=" + acao;
			frm.submit();
			return true;

		}
		
		if (acao=="E"){
			
			var parametro = "MaterialAula_cod_e.asp?txtCodigo=" + frm.txtCodigo.value + "&txtNomeArquivo=" + frm.txtNomeArquivo.							value;
			frm.action=parametro;
			frm.submit();
			return true;

		}	
}
</script>
<%

	strReloadDisciplinaQuadro	= "N"
	strSubmitTurmaMaterial		= "S"
	strSubmitDisciplinaMaterial = "S"
	strPaginaTitulo				= "MaterialAula_cad.asp"
	strPagina					= "MaterialAula_cad.asp"
	
	intCodEmp					= Session("CodEmpresa")
	intCodigo 					= Trim(Request("txtCodigo"))
	strData						= Trim(Request("txtData"))
	strDescricao 				= Trim(Request("txtDescricao"))
	strNomeArquivo				= Trim(Request("txtNomeArquivo"))
	
	if intCodTurma = "" then intCodTurma  = "0"
	if intCodDisciplina = "" then intCodDisciplina  = "0"
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma  = "0"
	

	' Consulta a Categoria	
	sql = "select codigo "
	sql = sql & " from SRH_COLABORADOR"
	sql = sql & " where codigo_SEG_USUARIOS_SISTEMA = '" & trim(session("usuarioWeb")) & "'"
	sql = sql & " and codLotacao = " & Session("CodEmpresa")
	sql = sql & " and CodCategoria = 1 "'professor
	sql = sql & " and Situacao = 'A'" 'Ativo
	rs.open sql, cnn
	
	if rs.EOF = false then	
		strVerificaCategoria 		= "Professor"
		intCodColaboradorProfessor 	= trim(rs("codigo"))
	else
		strVerificaCategoria 		= "Nao"
	end if
	rs.close
	
	if strVerificaCategoria <> "Professor" then
		intCodDisciplina		= Trim(Request("cmbDisciplinaTurma"))
		intCodDisciplinaTurma	= Trim(Request("cmbDisciplinaTurma"))
		intCodTurma 			= Trim(Request("cmbTurma"))
		intCodTurmaProfessor	= Trim(Request("cmbTurma"))
	else
		intCodDisciplina		= Trim(Request("cmbDisciplinaDoProfessor"))
		intCodDisciplinaTurma	= Trim(Request("cmbDisciplinaDoProfessor"))
		intCodTurma 			= Trim(Request("cmbTurmaProfessor"))
		intCodTurmaProfessor	= Trim(Request("cmbTurmaProfessor"))
	end if   

 	if intCodTurma = "" then intCodTurma = "0" 
	if intCodDisciplina = "" then intCodDisciplina = "0" 
	if intCodDisciplinaTurma = "" then intCodDisciplinaTurma = "0" 


	if trim(intCodigo) <> "" then
	
		sql = "SELECT  Codigo, CodTurma, CodDisciplinaTurma, Data, Descricao, NomeArquivo"
		sql = sql & " FROM SCA_MaterialAluno"
		sql = sql & " where cod_empresa = " & Session("CodEmpresa")	
		sql = sql & " And Codigo = " & intCodigo
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodigo	 			= rs("Codigo")
			
			if strVerificaCategoria <> "Professor" then
			   intCodDisciplina			= rs("CodDisciplinaTurma")
			   intCodDisciplinaTurma	= rs("CodDisciplinaTurma")
			else
			   intCodDisciplina		    = rs("CodDisciplinaTurma")
			   intCodDisciplinaTurma	= rs("CodDisciplinaTurma")
			end if   
		
			if strVerificaCategoria <> "Professor" then
				intCodTurma 			= rs("CodTurma")
				intCodTurmaProfessor	= rs("CodTurma")
			else   
				intCodTurma				= rs("CodTurma")
				intCodTurmaProfessor	= rs("CodTurma")
			end if   

	
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
		      <td><input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
		        <input name="txtCategoria" type="hidden" id="txtCategoria" class="text" size="10" value="<%=strVerificaCategoria%>" maxlength="10"></td>
		      </tr>
		    <tr>
		      <td class="texto">Turma:</td>
		      <td><% 
			
			  if trim(strVerificaCategoria) <> "Professor" then %>
                 <!--#include file="../includes/inc_cmdTurma.asp"-->
			  <% else %>	 
                 <!--#include file="../includes/inc_cmdTurmaProfessor.asp"-->
			  <% end if %>
		      </td>
		      </tr>
		    <tr>
		      <td height="27" class="texto">Disciplina:</td>
		      <td><% if strVerificaCategoria <> "Professor" then %>
			        <!--#include file="../includes/inc_cmbDisciplinaTurma.asp"-->
			  <% else %>
                    <!--#include file="../includes/inc_cmdDisciplinaDoProfessor.asp"-->			  
			  <% end if %></td>
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
		      <td colspan="2" class="texto">Aviso: Envie apenas arquivo PDF ou DOC.</td>
		      </tr>
		    <tr>
		      <td colspan="2" class="texto">&nbsp;</td>
		      </tr>
		    <tr>
		      <td colspan="2" class="texto">
			  <%
			  
			  
				cont =0
				sql = " SELECT Codigo, Descricao, NomeArquivo"
				sql = sql & " FROM SCA_MaterialAluno"
				sql = sql & " where cod_empresa = " & Session("CodEmpresa")	
				sql = sql & " And CodTurma = " & intCodTurma	
				if trim(intCodDisciplina) <> "" then
					sql = sql & " And CodDisciplinaTurma = " & intCodDisciplina	
				end if
				if trim(intCodDisciplinaTurma) <> "" then
					sql = sql & " And CodDisciplinaTurma = " & intCodDisciplinaTurma	
				end if
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
                    <td height="21" class="celula">&nbsp;<a href="../../MaterialAluno/<%=intCodEmp%>/<%=trim(rs("NomeArquivo"))%>" target="_blank"><%=trim(rs("NomeArquivo"))%></a></td>
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