<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_verificaSession.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">SCA - Controle Acadêmico</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
    <%
	strMostraBotaoCalendarioEvento = "S"
	strDesabilitaBotaoCalendarioEvento = "disabled"
    strExecutarSubmitSemestre 	= "S"
    strPaginaTitulo 			= "CalendarioUE_cad.asp"
    intCodigo	 				= Trim(Request("txtCodigo"))
	if intCodigo = "" then  intCodigo = Trim(Request("txtCodigoRetorno"))
	
    strAno	 					= Trim(Request("txtAno"))

    if Trim(Request("cmbSemestre")) <> "0" then
        intSemestre 		= Trim(Request("cmbSemestre"))
    else	
        intSemestre 		=  Session("strSemestre")
    end if	
  
    
    if trim(intCodigo) <> "" then
    
        sql = "SELECT *"
        sql = sql & " FROM SCA_CALENDARIO_UE"
        sql = sql & " Where cod_calendario_UE = " & intCodigo
        rs.open sql, cnn
        
        if rs.eof = false then
            
            intCodigo	 		= rs("cod_calendario_ue")
            strNome		 		= rs("nome_calendario")
            strDataInicio 			= formataDataAP(rs("data_inicio"))
            strDataFim 				= formataDataAP(rs("data_fim"))
            strSituacao				= rs("situacao")
            
            strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
            strDesabilitaAlterar 	= "" 'Desabilita o botão Excluir
            strDesabilitaExcluir	= "" 'Desabilita o botão Excluir
            BotaoSeguimento		 	= "" 'Desabilita o botão Excluir
			strDesabilitaBotaoCalendarioEvento = ""
            
        end if 
        rs.close
    else
        strDesabilitaIncluir	= "" 'Desabilita o botão Incluir
        strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
        strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
        BotaoSeguimento		 	= "disabled" 'Desabilita o botão Excluir
    end if 
    if strAno = "" then strAno = session("strAnoLetivo")
    if intSemestre = "" then intSemestre = Session("strSemestre")	
	if strAno <> "" then
		Incluir = "N"
		sql = "SELECT ano_letivo"
		sql = sql & " FROM SCA_CALENDARIO_UE"
		sql = sql & " Where ano_letivo = " & strAno & " and cod_Empresa = " & session("CodEmpresa")
		rs.open sql, cnn
		if rs.eof then
			Incluir = "S"
		end if
		rs.close
		
		if Incluir = "S" then
			sql = "SELECT cod_calendario"
			sql = sql & " FROM SCA_CALENDARIO"
			sql = sql & " Where ano_letivo = " & strAno & " and cod_Grupo = " & session("CodGrupo")
			rs.open sql, cnn
			if not rs.eof then
				intCodCalendarioGeral = rs("cod_calendario")
			else
				intCodCalendarioGeral = "0"
			end if
			rs.close
			
			sql = "SET NoCount ON insert [dbo].[SCA_CALENDARIO_UE] "
			sql = sql & " select "
			sql = sql & " " & session("CodEmpresa") & ","
			sql = sql & " 'UE - ' + nome_calendario,"
			sql = sql & " ano_letivo,"
			sql = sql & " situacao,"
			sql = sql & " data_inicio,"
			sql = sql & " data_fim,"
			sql = sql & "" & intCodCalendarioGeral
			sql = sql & " from [dbo].[SCA_CALENDARIO]"
			sql = sql & " where ano_letivo = " & strAno		
			sql = sql & "  ;SELECT @@IDENTITY "
			'response.write sql & "<hr>"
			Set rs = cnn.Execute(sql)
			intCodCalendario = rs(0)
			rs.close
			
			sql = "  insert [SCA_CALENDARIO_DIA_UE]"
			sql = sql & "  select "
			sql = sql & "  " & intCodCalendario & ""
			sql = sql & "  ,cod_calendario_evento"
			sql = sql & "  ,dia_mes"
			sql = sql & "  ,dia_semana"
			sql = sql & "  ,detalhes"
			sql = sql & "  ,mes"
			sql = sql & "  ,ano "
			sql = sql & "  from [dbo].[SCA_CALENDARIO_DIA] where cod_calendario=" & intCodCalendarioGeral
			'response.write sql & "<hr>"
			cnn.Execute(sql)
				
			
		end if
	end if
	strDesabilitaIncluir	= "disabled" 'Desabilita o botão Incluir
    strDesabilitaAlterar 	= "disabled" 'Desabilita o botão Excluir
    strDesabilitaExcluir	= "disabled" 'Desabilita o botão Excluir
    %>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Calendário Escolar da ESCOLA</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                	<input name="txtCodigo" type="hidden" id="txtCodigo" class="text" size="10" value="<%=intCodigo%>" maxlength="10">
                    <div class="form-group">
                        <label class="form-label">Ano</label>
                         <input  name="txtAno" type="text" class="form-control" id="txtAno" value="<%=strAno%>" size="5" maxlength="5" onkeypress="return formataCampo(this,2,10)" onchange="submit()">
                    </div>
                   
                    <div class="form-group">
                        <label class="form-label">Nome</label>
                        <input  name="txtNome" type="text" class="form-control" id="txtNome" value="<%=strNome%>" size="70" maxlength="100">
                    </div>
                                        				
					<div class="form-group">
                        <label class="form-label" >Situação</label>
                         <select name="cmbSituacao" class="form-control" id="cmbSituacao"  style="width:90pt">
						  <option value="0">Selecione...</option>
						  <option value="A" <%if strSituacao = "A" then response.Write("selected") %>>ATIVO</option>
						  <option value="I" <%if strSituacao = "I" then response.Write("selected") %>>INATIVO</option>
						</select>
                    </div>
                    
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_cadastro.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
                <div class="panel panel-grey margin-bottom-40">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fa fa-globe"></i> Lista Calendário da Escola</h3>
                    </div>
                    <div class="panel-body">
                    	<div class="table-responsive">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="4%" bgcolor="#95A5A6">C&oacute;d</th>
                                    <th width="73%" bgcolor="#95A5A6">Nome</th>
                                    <th width="6%" bgcolor="#95A5A6">Ano</th>
                                    <th width="8%" bgcolor="#95A5A6">Situa&ccedil;&atilde;o</th>
                                  <th width="9%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                              </tr>
                            </thead>
                            <%
							cont = 0
		
							sql = "SELECT *"
							sql = sql & " FROM sca_Calendario_UE"
							sql = sql & " where cod_empresa = " & Session("CodEmpresa")			
							sql = sql & " ORDER BY cod_calendario_ue desc "
							rs.open sql, cnn
							if rs.eof = false then
							
							while not rs.eof
								
								cont = cont + 1	
								situacao = rs("situacao")
								if situacao = "A" then situacao = "ATIVO"
								if situacao = "I" then situacao = "INATIVO"
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("Cod_calendario_ue"))%></td>
                                    <td><%=rs("nome_calendario")%></td>
                                    <td align="center"><%=trim(rs("ano_letivo"))%></td>
                                    <td align="center"><%=situacao%></td>
                                    <td align="center" >
                                    <button class="btn-u btn-u-sea" onclick="resultadoConsulta(<%=trim(rs("Cod_calendario_ue"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
                                    </td> 
                                </tr>
                            </tbody>
                            <%				
								rs.movenext
								wend
							end if
							rs.close
						%>
                        </table>
                        </div>
                    </div>                      
                </div>
                <!--End Table Bordered-->	
       <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    <!--=== End Content Part ===-->
	<script>
        function eventoCalendario(intCodigo){
            
            var frm = document.getElementById("frm");
            frm.action="EventoCalendarioUE_cad.asp"
            frm.submit();
        }
		function resultadoConsulta(intCodigo){
            
            var frm = document.getElementById("frm");
            
            frm.txtCodigo.value=intCodigo
            frm.submit();
        }
		function emitirCalendario(){
            var frm = document.getElementById("frm");
 			var intCodigo = document.getElementById("txtCodigo").value;
            frm.action="EventoCalendarioUE_rel.asp?txtCodigo="+intCodigo;
            frm.submit();
        }
        function salvar(acao){
                
			var frm = document.getElementById("frm");
			
			if (frm.txtAno.value == "") {
				alert("O ano deve ser informado!");
				frm.txtAno.focus();
				return false;
			}
		
			if (frm.txtNome.value == "") {
				alert("O nome deve ser informado!");
				frm.txtNome.focus();
				return false;
			}
			
			if (frm.cmbSituacao.value == "0") {
				alert("Situação deve ser informada!");
				frm.cmbSituacao.focus();
				return false;
			}			
			frm.action="CalendarioUE_cod.asp?acao=" + acao;
			frm.submit();
			return true;
            
        }
    </script>
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 