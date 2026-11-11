<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>
<!--=== Breadcrumbs ===-->
<div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">EST - Controle Almoxarifado</h1>
            <ul class="pull-right breadcrumb">
                <li>Consulta de Atualiza&ccedil;&atilde;o de Estoque</li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	
    <!--=== Content Part ===-->
    <form id="frm" class="margin-bottom-10" method="post">
    <input name="cmbDepartamento" type="hidden" id="cmbDepartamento"  value="<%=strDepartamento%>" />
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
       
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Consulta de Atualiza&ccedil;&atilde;o de Estoque</h3>
            </div>
            <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th width="16%" bgcolor="#95A5A6">Código</th>
                          <th width="22%" bgcolor="#95A5A6">Data da Entrada</th>
                          <th width="24%" bgcolor="#95A5A6">Usu&aacute;rio Inclusão</th>
                          <th width="26%" bgcolor="#95A5A6">Situa&ccedil;&atilde;o </th>
                          <th width="12%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
 					<%
						cont =0
			
						sql = " select codigo as codAtualizacaoEstoque, dataentrada, usuario, codSituacao "
						sql = sql & " from EST_ATUALIZACAO_ESTOQUE "
						sql = sql & " where CodEmpresa = " & session("codEmpresa")
						sql = sql & " order by dataentrada desc"

						rs.open sql, cnn
						if rs.eof = false then
							while not rs.eof
							cont = cont + 1		
							strSituacao 		= "<font color='#FF0000'>Em Aberto</font>"
							intCodSituacao		= trim(rs("codSituacao"))
							if intCodSituacao = "2" then
								strSituacao = "<font color='#0000FF'>Atualizado</font>"
							end if
							usuarioInclusao			= UCASE(trim(Rs("usuario")))
							if isnull(usuarioInclusao) then usuarioInclusao = ""
							
								if usuarioInclusao<>"" then
									sql = "SELECT  nome "
									sql = sql & " FROM SEG_usuarios "
									sql = sql & " Where cpf = '" & usuarioInclusao & "'"
									rsAux.open sql, cnn
									if rsAux.eof = false then	
									usuarioInclusao = trim(ucase(rsAux("nome")))
									vetUsu			= split(usuarioInclusao," ")
									intPosicaoFinal	= ubound(vetUsu)
									if intPosicaoFinal>0 then
										usuarioInclusao = vetUsu(0) & " " & vetUsu(intPosicaoFinal)
									else
										usuarioInclusao = vetUsu(0)
									end if
								end if
								rsAux.close		
							end if				
 					%>
                    <tbody>
                        <tr>
                            <td><%=trim(rs("codAtualizacaoEstoque"))%></td>
                            <td><%=trim(rs("dataentrada"))%></td>
                            <td><%=usuarioInclusao%></td>
                            <td><%=strSituacao%></td>
                            <td><button class="btn-u btn-u-sea" onClick="resultadoConsulta('<%=rs("codAtualizacaoEstoque")%>')" type="button"><i class="fa fa-file-text-o"></i></button> 
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
         	<!-- Fecha o Form -->  
      </div>
	  <div id="divRetorno"></div>
       <!-- Fecha o Painel do Formulario -->        
    </div>
    </form>
    <!--/container-->		
	<script>
        function Consulta(){
            frm.submit();
        }
    
        function resultadoConsulta(intCodigoReq){
            window.opener.document.getElementById("txtCodRequisicao").value=intCodigoReq
            window.opener.document.getElementById("frm").submit();
            window.close();
        }
    </script>
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 