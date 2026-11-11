<!--#include file="../ConfigModulo.asp"-->
    <!--#include file="../../includes/inc_cnn.asp"-->
	<!--#include file="../menuModulos.asp"-->  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo Senso</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%
        intCodGrupo 		 	= session("CodGrupo")
        strPagina 				= "Registro00_con.asp"
        strPaginaTitulo 		= "Registro00_con.asp"
    
        strDesabilitaIncluir = "" ' Desabilita o botão Incluir
        strDesabilitaAlterar = "disabled" ' Desabilita o botão Alterar
        strDesabilitaExcluir = "disabled" ' Desabilita o botão Excluir
        strDesabilitaLimpar  = "" ' Habilita o Botão Limpar
        cont = 0
    %>
    <!--=== Content Part ===-->
    <div class="container content">		
    <form id="frm" name="frm" method="post">
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
       <!--Table Bordered-->
                <div class="panel panel-grey margin-bottom-40">
                    <div class="panel-heading">
                        <h3 class="panel-title"><i class="fa fa-globe"></i>Cadastro de Escola - Indentifica&ccedil;&atilde;o - Registro 00</h3>
                    </div>
                    <div class="panel-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th width="6%" bgcolor="#95A5A6">Empresa</th>
                                    <th width="60%" bgcolor="#95A5A6">Escola</th>
                                    <th width="28%" bgcolor="#95A5A6">Situação</th>
                                  <th width="6%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                                </tr>
                            </thead>
                            <%
							sql = "SELECT SEG_EMPRESA.RAZAOSOCIAL, SEG_GRUPO.DESCRICAO as GRUPO, SEG_EMPRESA.COD_GRUPO, SEG_EMPRESA.CODIGO AS COD_EMPRESA"
							sql = sql & " FROM SEG_EMPRESA"
							sql = sql & " LEFT JOIN SEG_GRUPO ON SEG_GRUPO.CODIGO = SEG_EMPRESA.COD_GRUPO"
							sql = sql & " WHERE SEG_EMPRESA.COD_GRUPO = " & intCodGrupo
							sql = sql & " Order by SEG_GRUPO.DESCRICAO, SEG_EMPRESA.RAZAOSOCIAL"
							rs.open sql, cnn
							if rs.eof = false then
								while not rs.eof
								
								' Consulta Escola
								sql = "SELECT * from REGISTRO00 "
								sql = sql & " Where Cod_Empresa = " & trim(rs("cod_empresa"))
								rsAux.open sql, cnn
								if rsAux.eof = false then
									strEscola = "OK"
									strCor = "#FFFFCC"
								else
									strEscola = "N&atilde;o Atualizada"
									strCor = ""
								end if
								rsAux.close
								cont = cont+1
							%>
                            <tbody>
                                <tr>
                                    <td><%=trim(rs("cod_empresa"))%></td>
                                    <td><%=trim(rs("RAZAOSOCIAL"))%></td>
                                    <td><%=strEscola%></td>
                                    <td align="center" >
                                    <button class="btn-u btn-u-sea" onClick="ChamaEscola(<%=trim(rs("COD_EMPRESA"))%>)" type="button"><i class="fa fa-file-text-o"></i></button> 
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
                <!--End Table Bordered-->	
       <!-- Fecha o Painel do Formulario -->        
    
    </div>
    </form>
    </div>
    <!--/container-->		
    <script>
		function ChamaEscola(intCodigo){
		frm.action="Registro00_cad.asp?CodEscola=" + intCodigo;
		frm.submit();
		return true;
	}
	</script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 