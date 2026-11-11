<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">SRH - Recurso Humano</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strSimouNaoDocumentacaoColaboradores = ""
        sql = " SELECT top 1 DocumentacaoColaboradores "
        sql = sql & " FROM SEG_ENCERRAMENTOATIVIDADES "
        sql = sql & " Where cod_empresa = " & Session("CodEmpresa")
        rs.Open SQL, cnn
        if rs.EOF = false then								
            strSimouNaoDocumentacaoColaboradores= trim(rs("DocumentacaoColaboradores"))
        end if
        rs.close
    
        strPaginaTitulo 	= "Funcionario_Documentacoes_cad.asp"
        strCodFunc			= Trim(Request("txtCodFuncionario"))
        strNome 			= Trim(Request("txtNomeFuncionario"))
        if trim(strCodFunc) <> "" then
        
            sql = "Select Codigo, nome, situacao, CodGrauInstrucao "
            sql = sql & " from SRH_colaborador"
            sql = sql & " where cod_empresa = " & session("CodEmpresa")
            sql = sql & " and codigo = " & strCodFunc
            rs.open sql, cnn
            if rs.eof = false then
                strCodFunc						= Trim(rs("codigo"))
                strNome 						= Trim(rs("Nome"))
                intCodGrauInstrucao 			= Trim(rs("CodGrauInstrucao"))
                
                if Trim(rs("situacao")) = "I" then
                    %>
                    <script>
                        alert("ATENÇÃO: Colaborador está inativo no cadastro.");
                    </script>
                    <%
                    strCodFunc			= ""
                    strNome 		= ""
                end if
            else
                strCodFunc			= ""
                strNome 		= ""
                %>
                <script>
                    alert("ATENÇÃO: Colaborador não foi encontrado.");
                </script>
                <%
            end if
            rs.close	
        
        else
            strCodFunc			= ""
            strNome 			= ""
        end if
        
        if intCodGrauInstrucao = "" then intCodGrauInstrucao = 0
        strDesabilitaIncluir = "" 'Desabilita o botão Incluir'
        strDesabilitaAlterar = "disabled" 'Habilita o botão Alterar
        strDesabilitaExcluir = "disabled" 'Desabilita o botão Excluir
        strDesabilitaLimpar  = "" 'Habilita o Botão Limpar'
    %>
    <!--=== Content Part ===-->
    <form method="post" id="frm" action="Funcionario_Documentacoes_cad.asp">
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Documentações</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
  
                  <div class="form-group">
                  <label class="form-label">Empresa</label>
                   <input name="txtCodFuncionario" type="text" class="form-control" id="txtCodFuncionario" size="20" maxlength="20" value="<%=strCodFunc%>"  onKeyPress="return formataCampo(this, 2, 9)" onBlur="submit()">
                  	<button class="btn-u btn-u-green" onClick="return abreConsulta('Colaborador_con.asp')" type="button"><i class="fa fa-search"></i></button>
                    <input readonly name="txtNomeFuncionario" type="text" class="form-control" id="txtNomeFuncionario" size="50" maxlength="50" value="<%=strNome%>" >
                  </div>
                  
                  <legend></legend>
                  <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                    
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
       <%if strCodFunc <> "" and strCodFunc <> "0" then	%> 
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Documentos Exigidos ao Colaborador</h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="5%" bgcolor="#95A5A6"></th>
                          <th width="5%" bgcolor="#95A5A6">C&oacute;digo</th>
                          <th width="59%" bgcolor="#95A5A6">Descrição</th>
                          <th width="11%" bgcolor="#95A5A6">Situação</th>
                          <th width="11%" bgcolor="#95A5A6">Data de Prorroga&ccedil;&atilde;o</th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
                    cont =0

					sql = "SELECT Cod_Empresa, Codigo, Descricao, cod_grauinstrucao"
					sql = sql & " FROM SRH_DOCUMENTACOES"
					sql = sql & " where Cod_Empresa = " & Session("CodEmpresa")	
					if strSimouNaoDocumentacaoColaboradores = "S" then
						sql = sql & " AND cod_grauinstrucao = " & intCodGrauInstrucao
					end if	
					sql = sql & " Order by Codigo"
					rs.open sql, cnn
					if rs.eof = false then
						
						while not rs.eof
							
							sql = "Select Cod_Colaborador, Cod_documentacoes, data_prorrogacao, situacao "
							sql = sql & " From SRH_COLABORADOR_DOCUMENTACOES "
							sql = sql & " Where Cod_documentacoes = " & trim(rs("Codigo"))
							sql = sql & " and 	Cod_Colaborador = " & strCodFunc
							rsAux.open sql, cnn
							if rsAux.eof = false then
								if trim(rsAux("situacao")) = "R" then
									strChecked			= "checked"
									strBloqData			= "disabled"
								else
									strChecked			= ""
									strBloqData			= ""
								end if
								strDataProrrogacao 	= formatadataAP(rsAux("data_prorrogacao"))
							else
								strBloqData			= ""
								strChecked  		= ""
								strDataProrrogacao 	= ""
							end if
							rsAux.close	
				
                    	%>
                        <tr>
                            <td><input name="chkDocumentacoes<%=rs("Codigo")%>" type="checkbox" id="chkDocumentacoes<%=rs("Codigo")%>" value="S" <%=strChecked%> onClick="return validaDocumentoData(this.checked,'<%=rs("Codigo")%>')"></td>
                            <td><input name="txtCodDocumento<%=rs("Codigo")%>" type="hidden" id="txtCodDocumento<%=rs("Codigo")%>" value="<%=rs("Codigo")%>"><%=rs("Codigo")%></td>
                            <td><%=rs("Descricao")%></td>
                            <td><input <%=strBloqData%> name="txtDataProrrogacao<%=rs("Codigo")%>" type="text" class="text" id="txtDataProrrogacao<%=rs("Codigo")%>" onBlur="return validaData(this)" onKeyPress="return formataCampo(this, 3, 10)" size="11" maxlength="10" value="<%=strDataProrrogacao%>"></td>
                        </tr>
                    	<%				
                        rs.movenext
                        wend
                    end if
                    rs.close
                	%>
                    <tr>
                        <td colspan="5">Total Registros : <%=cont%></td>
                    </tr>
                    </tbody>
                </table>
            </div>                      
        </div>
        <%end if%>
        <%if strCodFunc <> "" and strCodFunc <> "0" then	%> 
		<table class="table table-bordered">
		  <tr>
			<td align="center" bgcolor="#E4E4E4"><strong>Legenda</strong></td>
		  </tr>
		  <tr>
			<td><input disabled="disabled" type="checkbox" name="chk" checked="checked">Documenta&ccedil;&atilde;o Regular.</td>
		  </tr>
		  <tr>
		    <td><input disabled="disabled" type="checkbox" name="chk2">Documenta&ccedil;&atilde;o Irregular. </td>
		  </tr>
		</table>
		<br>
		<%end if%>		
        
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    </form>
    <!--/container-->		
	<script>
        function salvar(acao){
            
            var frm = document.getElementById("frm");
            
            if (frm.txtCodFuncionario.value == "") {
                alert("O colaborador deve ser informado!");
                frm.txtCodFuncionario.focus();
                return false;
            }
            if (frm.txtNomeFuncionario.value == "") {
                alert("Colaborador deve ser informado!");
                frm.txtCodFuncionario.focus();
                return false;
            }
    
            frm.action="Funcionario_Documentacoes_cod.asp?acao=" + acao;
            frm.submit();
            return true;
        }
        
        function validaDocumentoData(valor, cod){
            if (valor==true){
                document.all["txtDataProrrogacao"+cod].value="";
                document.all["txtDataProrrogacao"+cod].disabled=true;
            }else{
                document.all["txtDataProrrogacao"+cod].value="";
                document.all["txtDataProrrogacao"+cod].disabled=false;
            }
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 