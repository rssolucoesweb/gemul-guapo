<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 20/12/2011
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Disponibilida deDocente
-->
<html>
<head>
<title><%=session("Titulo")%></title>
<link type="text/css" rel="stylesheet" href="../../Estilo/css.css">
</head>
<body>
<script src="../../js/js_funcoes_gerais.js"></script>
<script type="text/javascript" src="../../js/js_dragdrop.js"></script>
<script>
	function Descricao(tipo){
		
		if (document.all["mostraDescricao"+tipo].style.display =="none"){
			document.all["mostraDescricao"+tipo].style.display="block";
		}
		else{
			document.all["mostraDescricao"+tipo].style.display="none";
		}
	}
</script>
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file=topo.asp-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<script>

	function resultadoConsulta(intCodigo){
		
		var frm = document.getElementById("frm");
		frm.txtCodigo.value=intCodigo;
		frm.submit();
	}

	function salvar(acao){
	
		var frm = document.getElementById("frm");
		
		if (frm.cmbProfessor.value == "0") {
			alert("O Professor deve ser informado !");
			frm.cmbProfessor.focus();
			return false;
		}
				
		frm.action="DisponibilidadeDocente_cod.asp?acao="+acao;
		frm.submit();
		return true;
 	}
</script>
<%
	strPaginaTitulo 			= "DisponibilidadeDocente_cad.asp"
	strExecutarSubmitProfessor 	= "S"
 	strAnoLetivo 				= session("strAnoLetivo")
	intSemestre 				= session("strSemestre")
	intCodEmp					= Session("CodEmpresa")
	intCodProfessor				= Trim(Request.Form("cmbProfessor"))
	
	intDomingo = "0"
	intSegunda = "0"
	intTerca = "0"
	intQuarta = "0"
	intQuinta ="0"
	intSexta = "0"
	intSabado = "0"

	if intCodDiaSemana = "" then intCodDiaSemana = 0
	if intCodDisponibilidadeDocente = "" then intCodDisponibilidadeDocente = 0
	
	if trim(intCodProfessor) <> "" then
		
		sql = "SELECT Codigo, Cod_Empresa, CodColaborador"
		sql = sql & " FROM SCA_DISPONIBILIDADEDOCENTE"
		sql = sql & " Where Cod_Empresa = " & intCodEmp
		sql = sql & " And CodColaborador = " & intCodProfessor
		rs.open sql, cnn
		
		if rs.eof = false then
			
			intCodDisponibilidadeDocente	= rs("Codigo")
			intCodProfessor 				= rs("CodColaborador")
			
			strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
			strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
			strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
			BotaoSeguimento		 	= "" 'Desabilita o botão Excluir
			
		end if 
		rs.close
	else
	
		strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
		strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
		strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
		
	end if 
	%>
    <form method="post" id="frm" action="DisponibilidadeDocente_cad.asp">
    <input name="txtCodigo" type="hidden" id="txtCodigo" value="<%=intCodDisponibilidadeDocente%>">
  	<table width="100%" height="389" border="0"  class="CorFundo" cellpadding="0" cellspacing="0">
    <tr>
      <td height="20" colspan="2" align="center" class="texto1"><span class="tituloSistema"><%=carregaTituloPaginaASP(strPaginaTitulo)%></span></td>
        </tr>
        <tr>
          <td height="20" colspan="2" class="texto1">&nbsp;</td>
        </tr>
        <tr>
          <td width="16%" height="20" class="texto1"> Professor: </td>
          <td height="20" class="texto1"><!--#include file="../includes/inc_cmdProfessor.asp" --></td>
        </tr>
        <tr>
          <td height="20" colspan="2" class="texto1">&nbsp;</td>
        </tr>
        <tr>
          <td height="20" colspan="2" bgcolor="#CCCCCC" class="texto1">Quadro de Disponibiliadade Docente</td>
      </tr>
      <tr class="texto1">
        <td colspan="2" class="texto1"><br>
        
          <table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
                  
            <tr bgcolor="#CCCCCC" class="CabecalhoConsulta">
              <td width="27" align="center" class="celula">&nbsp;</td>
              <td width="1190" class="celula"><strong>Dia da Semana</strong></td>
            </tr>
            <% 
			  for i=1 to 7
				
				SQL = "SELECT CodDisponibilidadeDocente , DiaSemana, CodFaixaHorario"
				SQL = SQL & " FROM SCA_DISPONIBILIDADEDOCENTE_Horario"
				SQL = SQL & " WHERE	CodDisponibilidadeDocente = " & intCodDisponibilidadeDocente
				SQL = SQL & " AND	DiaSemana = " & i
				rsAux.open sql, cnn 
				if not rsaux.eof then  
					intCodDiaSemana = rsAux("DiaSemana")
					intCodFaixaHorario = rsAux("CodFaixaHorario")
				end if
				rsaux.close
				
				seleciona = "" 
				if cint(intCodDiaSemana) = cint(i) then
					seleciona = "checked"
				
					' Domingo
					if i = 1 then
						intDomingo = i
					end if
					
					' Segunda
					if i = 2 then
						intSegunda = i
					end if
					
					' Terça
					if i = 3 then
						intTerca = i
					end if
					
					' Quarta
					if i = 4 then
						intQuarta = i
					end if
					
					' Quinta
					if i = 5 then
						intQuinta = i
					end if
					
					' Sexta
					if i = 6 then
						intSexta = i
					end if
					
					' Sabado
					if i = 7 then
						intSabado = i
					end if
				
				else
					seleciona = "  "
				end if
			  %>		
            <tr>
              <td height="30" align="center" class="celula"><input  <%=seleciona%> name="chkDiaSemana"  onClick="return Descricao('<%=i%>')" type="checkbox" id="chkDiaSemana" value="<%=i%>" ></td>
              <td class="celula"><%=WeekDayName(i)%></td>
            </tr>
          	 <tr id="mostraDescricao<%=i%>" style="display:none">
              <td height="30" colspan="2" align="center" class="celula">
              <br>
              <table class="tabela" width="98%" align="center" border="1" cellpadding="0" cellspacing="0">
                <td width="1217" height="17" align="center" bgcolor="#CCCCCC" class="celula"><strong>Marque sua Disponibilidade</strong></td>
                </tr>
                </table>
                <%
                    ' o padrão aqui e strSemestre, foi alterado para atender o cadastramento da Fanap
                    sql = "SELECT Codigo, cod_empresa, anoLetivo, semestre, horario, Sequencia_Aulas "
                    sql = sql & " FROM SCA_HORARIO"
                    sql = sql & " where cod_empresa = " & Session("CodEmpresa")
                    sql = sql & " and anoLetivo = " & strAnoLetivo
                    sql = sql & " and Semestre = " & intSemestre
                    sql = sql & " Order by Codigo "
                    rs.open sql, cnn
                    
                    if not rs.eof then  
                    %>
                    <br>
                 	<table width="98%" height="10" border="0" class="texto" cellpadding="0" cellspacing="0">
                  	<%	
                        cont = 0
                        while not rs.eof
                         
						selecionaCaracteristica = ""
			
						SQL = "SELECT CodDisponibilidadeDocente , DiaSemana, CodFaixaHorario"
						SQL = SQL & " FROM SCA_DISPONIBILIDADEDOCENTE_Horario"
						SQL = SQL & " WHERE	CodFaixaHorario = " & rs("Codigo")
						SQL = SQL & " And	DiaSemana = " & i
						rsAux.open sql, cnn 
						if not rsaux.eof then  
							selecionaCaracteristica = " checked "						
						end if
						rsaux.close
                            
                            %>
                   			 <td width="33%"><input <%=selecionaCaracteristica%> name="chkFaixaHorario_<%=i%>" type="checkbox" value="<%=rs("Codigo")%>"><%=rs("Sequencia_Aulas") & " Aula" & " - " & rs("horario")%></td>
                    		<%
                            cont = cont + 1
                            if cint(cont) = 3 then 
                                %>
                              </tr>
                              <tr>
                                <%
                                cont  = 0
                            end if
                            rs.movenext
                        wend
                        %>
                  </tr>
                </table>
                <%
                    end if
                    rs.close				  
                    %>
                <br></td>
            </tr>
          	 <tr style="display:none">
          	   <td height="14" colspan="2" align="center" class="celula">&nbsp;</td>
       	    </tr>
            <% next
			%>
        </table></td>
    </tr>
    <tr class="texto1">
      <td colspan="2" class="texto1">&nbsp;</td>
    </tr>
    <tr bgcolor="#CCCCCC">
	  <td height="20" colspan="2" class="texto1">Disciplinas</td>
    </tr>
     <tr>
       <td colspan="2" align="center" class="texto1">&nbsp;</td>
     </tr>
     <tr>
       <td colspan="2" align="center" class="texto1">
         <%
				SQL = "SELECT Cod_Empresa, COD_Disciplina, DESC_Disciplina, Desc_Abreviada"
				SQL = SQL & " FROM SCA_DISCIPLINA"
				sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
				SQL = SQL & " Order by COD_Disciplina"
				rs.open sql, cnn
				if not rs.eof then  
				%>
                 <table width="98%" border="0" cellspacing="0" cellpadding="0">
                   <tr>
                     <%	
					cont = 0
					while not rs.eof
				 
					if cint(cont) = 3 then 
						%>
           				<tr>
             			<%
					end if
					
					selecionaCaracteristica = ""
					
					SQL = "SELECT CodDisponibilidadeDocente, COD_Disciplina"
					SQL = SQL & " FROM SCA_DISPONIBILIDADEDOCENTE_Disciplina"
					SQL = SQL & " WHERE	CodDisponibilidadeDocente = " & intCodDisponibilidadeDocente
					SQL = SQL & " AND COD_Disciplina = " & rs("COD_Disciplina")
					rsAux.open sql, cnn 
					if not rsaux.eof then  
						selecionaCaracteristica = " checked "						
					end if
					rsaux.close
					
					%>
             		<td width="33%" class="TextoForm"><input <%=selecionaCaracteristica%> name="chkDisciplina" type="checkbox" value="<%=rs("COD_Disciplina")%>"><%=rs("DESC_Disciplina")%></td>
             		<%
					cont = cont + 1
					if cint(cont) = 3 then 
						%>
                       </tr>
                       <tr>
                         <%
						cont  = 0
					end if
					rs.movenext
				wend
				%>
           </tr>
         </table>
       		<%
			end if
			rs.close				  
			%>
       </td>
     </tr>
     <tr>
  	   <td colspan="2" align="center" class="texto1"><label>&nbsp;</label></td>
    </tr>
    <tr>
      <td height="20" colspan="2" bgcolor="#CCCCCC" class="texto1">Cursos</td>
    </tr>
    <tr>
      <td colspan="2" align="center" class="texto1">&nbsp;</td>
    </tr>
    <tr>
	  <td colspan="2" align="center" class="texto1">
       	<%
			SQL = "SELECT Cod_Empresa, Cod_curso, Descricao, Desc_Abreviada, Sigla"
			SQL = SQL & " FROM SCA_CURSO"
			sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
			SQL = SQL & " Order by Cod_curso"
			rs.open sql, cnn
			
			if not rs.eof then  
			%>
	    <table width="98%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <%	
				cont = 0
				while not rs.eof
				 
					if cint(cont) = 3 then 
						%>
          				<tr>
						<%
					end if
					
					selecionaCaracteristica = ""
					
					SQL = "SELECT CodDisponibilidadeDocente, CodCurso"
					SQL = SQL & " FROM SCA_DISPONIBILIDADEDOCENTE_Curso"
					SQL = SQL & " WHERE	CodDisponibilidadeDocente = " & intCodDisponibilidadeDocente
					SQL = SQL & " AND	CodCurso = " & rs("Cod_curso")
					rsAux.open sql, cnn 
					if not rsaux.eof then  
						selecionaCaracteristica = " checked "						
					end if
					rsaux.close
					
					%>
            			<td width="33%" class="TextoForm"><input <%=selecionaCaracteristica%> name="chkCurso" type="checkbox" value="<%=rs("Cod_curso")%>"><%=rs("Desc_Abreviada")%></td>
           			 <%
					cont = cont + 1
					if cint(cont) = 3 then 
						%>
                          </tr>
                          <tr>
           				 <%
						cont  = 0
					end if
					rs.movenext
				wend
				%>
          </tr>
        </table>
	    <%
			end if
			rs.close				  
			%>
            </td>
    </tr>
    <tr>
      <td colspan="2" class="texto1">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2" class="texto1">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="2" class="texto1"></td>
    </tr>
    <tr> 
      <td colspan="2" class="texto1"><!--#include file="../../includes/inc_botoes_cadastro.asp"--></td>
    </tr>
    <tr> 
        <td colspan="2" class="texto1">&nbsp;</td>
    </tr>
  </table>  		  
</td>
</tr>
</table>
</form>
<%if intDomingo <> "0" then %>
	<script>Descricao('<%=intDomingo%>')</script>
<%end if %>
<%
if intSegunda <> "0" then %>
	<script>Descricao('<%=intSegunda%>')</script>
<%end if %>
<%
if intTerca <> "0" then %>
	<script>Descricao('<%=intTerca%>')</script>
<%end if %>
<%if intQuarta <> "0" then %>
	<script>Descricao('<%=intQuarta%>')</script>
<%end if %>
<%if intQuinta <> "0" then %>
	<script>Descricao('<%=intQuinta%>')</script>
<%end if %>
<%if intSexta <> "0" then %>
	<script>Descricao('<%=intSexta%>')</script>
<%end if %>
<%
if intSabado <> "0" then %>
	<script>Descricao('<%=intSabado%>')</script>
<%end if%>
<!--#include file="../rodape.asp"-->
</body>
</html>