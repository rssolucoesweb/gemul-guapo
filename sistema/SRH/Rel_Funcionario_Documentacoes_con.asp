<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_sqlAlunoTurma.asp"-->
<!--#include file="../../js/Calendario/Calendario.asp"-->
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
        strPaginaTitulo 		= "Rel_Funcionario_Documentacoes_con.asp"
    %>
    <!--=== Content Part ===-->
    <form method="post" id="frm" action="#">
    <div class="container content">		
      	
        
         
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i>Comunicado - Documentação em Débito</h3>
            </div>
            
            <div class="panel-body"> 
				<!--#include file="../../includes/inc_botoes_geraRelatorio.asp"-->
            </div>
            
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="4%" bgcolor="#95A5A6"><input type="checkbox" name="chkTodos" onClick="return MarcaTodos(this.checked)"></th>
                          <th width="7%" bgcolor="#95A5A6">Código</th>
                          <th width="89%" bgcolor="#95A5A6">Nome</th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
                    cont =0
					SQL="SELECT CODIGO, NOME "
					SQL=SQL & " FROM SRH_COLABORADOR "
					SQL=SQL & " WHERE cod_empresa=" & Session("CodEmpresa")
					SQL=SQL & " AND SITUACAO='A'"
					sql=sql & " Order By NOME"
                    rs.open sql, cnn
                    if rs.eof = false then
                    
                    while not rs.eof
                        cont = cont + 1
				    	%>
                        <tr>
                            <td><input type="checkbox" id="chkFunc" name="chkFunc" <%=strDesabilitaAluno%> value="<%=rs("codigo")%>"></td>
                            <td><%=trim(rs("codigo"))%></td>
                            <td><%=rs("NOME")%></td>
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
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    </form>
    <!--/container-->		
	<script>
        function gerar(){
            
            var frm = document.getElementById("frm");
            var form = window.document.forms[0];
            var intContMarcado=0;
    
            //*****verifica se um aluno foi selecionado
            intContMarcado=0;
            for (var i = 0; i < form.elements.length; i++) {
                //verifica todos os checkbox
                if (form.elements[i].type == "checkbox"){
                    if (form.elements[i].name == "chkFunc"){
                        //verifica se o checkbox está marcado
                        if (form.elements[i].checked){
                            intContMarcado = intContMarcado + 1;
                        }
                    }
                }
            }	
            
            if (intContMarcado==0){
                alert("Colaborador deve ser selecionado!");
                return false;
            }
            
            frm.action = "Rel_Funcionario_Documentacoes_rel.asp";
            frm.submit();
            return true;	
        }
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 