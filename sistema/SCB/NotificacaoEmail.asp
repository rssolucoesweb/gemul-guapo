	<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--#include file="../../includes/inc_formatadata.asp"-->
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Biblioteca</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strPaginaTitulo  = "NotificacaoEmail.asp"
        strTextoBotaoRel = "Enviar Email"
        strTipoUsuario   = Trim(Request("cmbTipoUsuario"))
        strData			 = formataDataAP(DateAdd("d", 1, Date))
        
        if strTipoUsuario = "1" then
            TipoUsuario = "Aluno"
        end if	
        
        if strTipoUsuario = "2" then
            TipoUsuario = "Colaborador"
        end if	
        
        if strTipoUsuario = "3" then
            TipoUsuario = "Comunidade"
        end if		
        
        strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
        strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
        strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir	
        
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Notificação Por Email</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	
                    <div class="form-group">
                        <label class="form-label">Tipo Usu&aacute;rio: </label>
                         <!--#include file="../includes/inc_cmbTipoUsuario.asp"-->
                    </div>
                    
                    <div class="panel-body">
                        
                       		  <%
		  if strTipoUsuario <> "" then 
   			cont =0
			intTotal = 0
			
		
			' Pega o dia da Semana
			diaSemana = weekday(strData)
			
			' Domigo
			if diaSemana = 1 then
				strData = DateAdd("d", 1, strData)
			end if
			
			' Sabado
			if diaSemana = 7 then
				strData = DateAdd("d",2, strData)
			end if
		
			do while true
			
				' Consulta Tabela de Feriados
				sql = " Select Data"
				sql = sql & " FROM SCA_Feriado  "
				sql = sql & " Where Cod_Empresa = " & Session("CodEmpresa") 
				sql = sql & " And Ano_Letivo  = " & Session("strAnoLetivo") 
				sql = sql & " And Data = '" & formataDataBD(strData) & "'"
				rsAux.open sql, cnn
				
				IF rsAux.EOF = false THEN
					strData = DateAdd("d", 1, strData)
					
				    ' Pega o dia da Semana
					diaSemana = weekday(strData)
					
					' Domigo
					if diaSemana = 1 then
						strData = DateAdd("d", 1, strData)
					end if
					
					' Sabado
					if diaSemana = 7 then
						strData = DateAdd("d",2, strData)
					end if
				else
					exit do
				end if
				rsAux.close

			loop

			strData = formataDataAP(strData)
  
			sql = "  select distinct I.DataDevolucao, P.Titulo," 
            
            if strTipoUsuario = 1 then
				sql = sql & " SCA_ALUNO.codigo, SCA_ALUNO.NOMEALUNO, SCA_ALUNO.EMAIL "
            end if
			
            if strTipoUsuario = 2 then
				sql = sql & " SRH_COLABORADOR.Codigo, SRH_COLABORADOR.Nome as Colaborador, SRH_COLABORADOR.email"
            end if
			
			 if strTipoUsuario = 3 then
				sql = sql & "  SCB_Comunidade.Codigo, SCB_Comunidade.Nome, SCB_Comunidade.EMAIL "
            end if
			
			sql = sql & " From scb_emprestimo E "
            
            if strTipoUsuario = 1 then
				sql = sql & " Inner JOIN SCA_ALUNO ON E.Cod_aluno = SCA_ALUNO.Codigo "
            end if
			
			if strTipoUsuario = 2 then
            	sql = sql & " Inner JOIN SRH_COLABORADOR ON E.Cod_Colaborador = SRH_COLABORADOR.Codigo "
            end if
			
			if strTipoUsuario = 3 then
				sql = sql & " Inner JOIN SCB_Comunidade ON E.Cod_Comunidade = SCB_Comunidade.Codigo "
            end if
			
			sql = sql & " Inner join SCB_EmprestimoItens I on I.Cod_Emprestimo = E.Cod_Emprestimo"
			sql = sql & " inner join SCB_PUBLICACAOEXEMPLARES PE on PE.Cod_PublicacaoExemplares = I.Cod_PublicacaoExemplares"
			sql = sql & " inner join SCB_PUBLICACAO P on P.Cod_Publicacao = PE.Cod_Publicacao"
			sql = sql & " where e.cod_empresa = " & Session("CodEmpresa")	
			sql = sql & " and convert(datetime,convert(varchar, I.DataDevolucao, 103),103) = convert(datetime, '" & strData & "',103) "
			sql = sql & " and I.status = 'A'"
			rs.open sql, cnn
							
			if rs.eof = false then
			%>
                    <table class="table table-bordered">
                      <tr bgcolor="#CCCCCC">
                        <td width="4%" align="center" class="celula"><input type="checkbox" name="chkTodos" onClick="return MarcaTodos(this.checked)"></td>
                        <td width="14%" class="celula"><strong>Data Devolucao</strong></td>
                        <td width="28%" class="celula"><strong>Titulo<span class="TextoForm"></span></strong></td>
                        <td width="27%" class="celula"><strong>Nome<span class="TextoForm"></span></strong></td>
                        <td width="27%" height="21" colspan="2" class="celula"><strong>Email<span class="TextoForm"></span></strong></td>
                      </tr>
                      <%
				while not rs.eof
					cont = cont + 1	
					
					strBloqEmail = ""
					strCorSemEmail = ""
					  
					if strTipoUsuario = 1 then
						strNome = rs("NOMEALUNO")
						strEmail = trim(rs("EMAIL"))
					end if
					
					if strTipoUsuario = 2then
						strNome = rs("Colaborador")
						strEmail = trim(rs("email"))
					end if
					
					if isnull(strEmail) then
						strBloqEmail = "disabled"
						strCorSemEmail = " bgcolor='#FF9797' "
					end if
					
					%>
                      <tr <%=strCorSemEmail%>>
                        <td align="center" class="celula"><input type="checkbox"  id="chkEmail" name="chkEmail" <%=strBloqEmail%> value="<%=strEmail%>"></td>
                        <td class="celula"><%=formataDataAP(rs("DataDevolucao"))%></td>
                        <td class="celula"><%=rs("Titulo")%>&nbsp;</td>
                        <td class="celula"><%=strNome%>&nbsp;</td>
                        <td height="20" colspan="2" class="celula"><%=strEmail%>&nbsp;</td>
                      </tr>
                      <%				
					rs.movenext
					wend
				%>
                      <tr bgcolor="#CCCCCC">
                        <td height="21" colspan="6" class="celula"><strong>Total Registros: </strong><%=cont%></td>
                    </table>
            <%
			  end if
			  rs.close
			  
		end if%>
                    </div>
                 
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
      <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
	<script>
        
        function marcaTodos(valor){
            
            var form = window.document.forms[0];
            var i;
            for (var i = 0; i < form.elements.length; i++) {
                //verifica todos os checkbox
                if (form.elements[i].type == "checkbox"){
                    //verifica se o checkbox está marcado
                    form.elements[i].checked=valor;
                }
            }
        }
        
        function gerar(){
            
        var intContMarcado =0;
        var strEmail = "";
        var frm = document.getElementById("frm");
        
        for (var i = 0; i < frm.elements.length; i++) 
        {
            //verifica todos os checkbox
            if (frm.elements[i].name.substring(0,19) == "chkEmail"){				
                if (frm.elements[i].checked) {
                    intContMarcado = intContMarcado + 1;
                    strEmail = strEmail + "," + frm.elements[i].value;
                }
            }
        }
        
        if (intContMarcado==0){
            alert("ATENCAO: Pelo menos um Email deve ser selecionado, Verifique!");
            return false;
        }
        
            frm.action = "NotificacaoEmail_cod.asp";
            frm.submit();
            return true;	
        }	
        
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 