<%
response.Expires=0
'Não armazena a página em buffer antes de mostra-la na tela'
response.Buffer = false
%>
	<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--#include file="../../includes/inc_formataData.asp"-->
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Matrícula</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        strCod_empresa 			= Session("CodEmpresa")
        intCurso	 			= request.Form("cmbAgrupamento")
        intOrdenacao 			= request("cmbOrdenacao")
    
        strDataInicio = ""
        strDataFim = ""
        
        if intCurso = "" then intCurso = "0" 
        if intOrdenacao = "" then intOrdenacao = "1" 
        
        if intCurso <> "0" then
            sql = "select * from [dbo].[MAT_periodo_curso] where codigo = " & intCurso
            RS.OPEN SQL, CNN
            IF RS.EOF = FALSE THEN
                strDataInicio 	= formataDataBD(rs("dt_inicial"))
                strDataFim 		= formataDataBD(rs("dt_final"))
                strCurso 		= rs("curso")
                strTituloRelatorio  	= "Rela&ccedil;&atilde;o de Cadastro de Reservas do <strong>" & strCurso & "</strong> <br> Matrícula " & year(date)
            END IF
            rs.close
        end if
        
    %>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Remove Reserva</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post">
                    <div class="form-group">
                        <label class="form-label">Filtro</label>
                         <!--#include file="../includes/inc_cmbAgrupamento.asp"-->
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Situação</label>
                        <select name="cmbOrdenacao" class="form-control" id="cmbOrdenacao"  style="width:130pt">
                       <option value="0">Selecione...</option>
                        <option value="1" <%if intOrdenacao = "1" then response.Write("selected") %>>Nome Aluno</option>
                        <option value="2" <%if intOrdenacao = "2" then response.Write("selected") %>>Nome M&atilde;e</option>
                        </select>
                    </div>
                    <legend></legend>
                    <input class="btn-u float-shadow" type="button" value="Consultar" <%=strDesabilitaConsultar%>  name="cmdConsultar" onClick="return gerar()">
                    <input type="button" name="cmdLimpar"  style="cursor:hand"  value="Limpar"   class="btn-u btn-u-orange float-shadow" <%=strDesabilitaLimpar%> onClick="window.location='<%=strPagina%>'">
                    <input type="button" name="cmdExcluir" style="cursor:hand"  value="Excluir"  class="btn-u btn-u-red float-shadow" <%=strDesabilitaExcluir%> onClick="remover()">

                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
     	<!--Table Bordered-->
    	<div class="panel panel-grey margin-bottom-40">
        <div class="panel-heading">
            <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Reservas</h3>
        </div>
        <div class="panel-body">
            <table width="96%" class="table table-bordered">
                <thead>
                    <tr>
                    <th width="3%" bgcolor="#95A5A6">#</th>
                    <th width="5%" bgcolor="#95A5A6">Código</th>
                    <th width="14%" bgcolor="#95A5A6">Nome Aluno</th>
                    <th width="14%" bgcolor="#95A5A6">Data Nasc</th>
                    <th width="12%" bgcolor="#95A5A6" align="center">Contato</th>
                    <th width="10%" bgcolor="#95A5A6" align="center">M&atilde;e</th>
                    <th width="5%" bgcolor="#95A5A6" align="center">Ser&iacute;e</th>
                    <th width="12%" bgcolor="#95A5A6" align="center">Turno</th>
                   <!-- <th width="7%" bgcolor="#95A5A6" align="center">Endere&ccedil;o</th>
                    <th width="9%" bgcolor="#95A5A6" align="center">Bairro</th>
                    <th width="9%" bgcolor="#95A5A6" align="center">Cidade</th>-->
                  </tr>
                </thead>
                <%
                intPagina = 1
                intQtdeRegistroPorPagina = 1
                cont = 0
                
                intTotal_AgrupamentoI = 0
                intTotal_AgrupamentoII = 0
                intTotal_AgrupamentoIII = 0
                intTotal_AgrupamentoIV = 0
                intTotal_AgrupamentoV = 0
                
                sql = "SELECT Codigo, nome, data_nascimento, mae, cep, Logradouro, "
                sql = sql & " bairro, cidade, email, Periodo, Turno, EMAIL, Contato, Celular, FonePai, FoneMae  "
                sql = sql & " FROM MAT_Reserva "
                sql = sql & " where 1 = 1" 
                sql = sql & " and Situacao = 'R'"
                sql = sql & " AND ISNULL(ATUALIZADO,'N') = 'N'"
                
                if intCurso <> "0" then
                    sql = sql & " and data_nascimento between '" & strDataInicio & "' and '" & strDataFim & "'"
                    sql = sql & " and periodo = '" & strCurso & "'"
                end if
                
                if intOrdenacao = 1 then 
                    sql = sql & " order by nome"
                end if
                
                if intOrdenacao = 2 then 
                    sql = sql & " order by mae"
                end if

                rs.open sql, cnn
                cont=0
                if rs.eof = false then
                
                while not rs.eof

                    cont = cont + 1
        
                    if (cont MOD 2) = 0 then
                        strCor = "#CCCCCC"
                    else
                        strCor = "#FFFFCC"
                    end if
                 
                    if trim(rs("TURNO")) <> "0" then
                        strTurno = trim(rs("TURNO"))
                    else
                        strTurno =  ""
                    end if
                    
                    if trim(rs("Periodo")) = "AGRUPAMENTO I" then
                        intTotal_AgrupamentoI = intTotal_AgrupamentoI + 1
                    end if
                    
                    if trim(rs("Periodo")) = "AGRUPAMENTO II" then
                        intTotal_AgrupamentoII = intTotal_AgrupamentoII + 1
                    end if
                    
                    if trim(rs("Periodo")) = "AGRUPAMENTO III" then
                        intTotal_AgrupamentoIII = intTotal_AgrupamentoIII + 1
                    end if
                    
                    if trim(rs("Periodo")) = "AGRUPAMENTO IV" then
                        intTotal_AgrupamentoIV = intTotal_AgrupamentoIV + 1
                    end if
                    
                    if trim(rs("Periodo")) = "AGRUPAMENTO V" then
                        intTotal_AgrupamentoV = intTotal_AgrupamentoV + 1
                    end if
    
                %>
                <tbody>
                    <tr bgcolor="<%=strCor%>">
                        <td><input name="chkCodigo" type="checkbox" value="<%=rs("Codigo")%>"<%=strMarca%>></td>
                        <td><%=rs("Codigo")%></td>
                        <td><%=rs("nome")%></td>
                        <td align="center"><%=formataDataAP(rs("data_nascimento"))%></td>
                        <td align="center"><%=rs("Contato")%></td>
                        <td align="center"><%=rs("mae")%></td>
                        <td align="center"><%=rs("Periodo")%></td>
                        <td align="center"><%=strTurno%></td>
                         <!-- <td align="center"><%=rs("Logradouro")%></td>
                        <td align="center"><%=rs("bairro")%></td>
                        <td align="center"><%=rs("cidade")%></td>-->
                    </tr>
                </tbody>
                <%	
                    intQtdeRegistroPorPagina = intQtdeRegistroPorPagina + 1
                                
                    rs.movenext
                    wend
                end if
                rs.close
            %>
            <tr >
                <td colspan="11">Total Agrupamento I:<%=intTotal_AgrupamentoI%></td>
                <tr bgcolor="<%=strCor%>">
                <td colspan="11">Total Agrupamento II:<%=intTotal_AgrupamentoII%></td>
                <tr bgcolor="<%=strCor%>">
                <td colspan="11">Total Agrupamento III:<%=intTotal_AgrupamentoIII%></td>
                <tr bgcolor="<%=strCor%>">
                <td colspan="11">Total Agrupamento IV:<%=intTotal_AgrupamentoIV%></td>
                <tr bgcolor="<%=strCor%>">
                <td colspan="11">Total Agrupamento V:<%=intTotal_AgrupamentoV%></td>
                <tr bgcolor="<%=strCor%>">
                <td colspan="11">Quantidade de Candidatos: <%=cont%></td>
             </tr>
            </table>
        </div>                      
    </div>
    <!--End Table Bordered-->	
<!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
    <script>
	function gerar(){
		frm.submit();
		return true;	
	}

	function remover(){
		
		var frm = document.getElementById("frm");
		
		if (!confirm('Deseja excluir essa Reserva?'))
			return false;
		else{
			frm.action="RemoveReserva_cod.asp";
			frm.submit();
			return true;
		}
 	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 