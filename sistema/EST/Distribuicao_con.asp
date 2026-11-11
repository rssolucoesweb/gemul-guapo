<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>
<!--=== Breadcrumbs ===-->
<div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">EST - Controle Almoxarifado</h1>
            <ul class="pull-right breadcrumb">
                <li>Consulta de Distribuição de Material</li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
    <%
	strNome = Request.Form("txtNome")
	%>
    <!--=== Content Part ===-->
    <form method="POST" id="frm" name="frm" action="#">
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
       
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Consulta de Distribuição de Material</h3>
            </div>
            <div class="panel-body">
            	<div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="16%" bgcolor="#95A5A6">Codigo</th>
                          <th width="22%" bgcolor="#95A5A6">Entrada</th>
                          <th width="24%" bgcolor="#95A5A6">Unidade</th>
                          <th width="26%" bgcolor="#95A5A6">Usu&aacute;rio</th>
                          <th width="26%" bgcolor="#95A5A6">Situa&ccedil;&atilde;o</th>
                          <th width="12%" bgcolor="#95A5A6" align="center"><div align="center">Ação</div></th>
                      </tr>
                    </thead>
 					<%
						cont =0
						Session("CodSecao") = 0
					
						sql = "select _r.codigo as codrequisicao, _r.dataentrada, _r.solicitante, _d.descricao as depto, _s.descricao as situacao"
						sql = sql & " from est_requisicao _r "
						sql = sql & " inner join est_situacao _s on _s.codigo = _r.codsituacao"
						sql = sql & " inner join est_departamento _d on _d.codigo = _r.codDepartamento"
						sql = sql & " where _r.CodEmpresa = " & session("CodEmpresa")	
						if session("strNomeUsuario")<>"76143139172" then 'responsavel pela liberaçao do material
							sql = sql & " and 	_r.solicitante = '" & session("strNomeUsuario") & "'"
						end if
						sql = sql & " and _r.cod_secao in (10,18)"		
						if Session("CodSecao")<>"0" then
							sql = sql & " and _r.cod_secao = " & Session("CodSecao")
						end if
						sql = sql & " order by 1 desc"
						
						rs.open sql, cnn

						if rs.eof = false then
							while not rs.eof
							
							cont = cont + 1		
			
							usuarioInclusao			= UCASE(trim(Rs("solicitante")))
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
                            <td><%=rs("codrequisicao")%></td>
                            <td><%=rs("dataentrada")%></td>
                            <td><%=rs("depto")%></td>
                            <td><%=usuarioInclusao%></td>
                            <td><%=rs("situacao")%></td>
                            <td><button class="btn-u btn-u-sea" onClick="resultadoConsulta('<%=rs("codrequisicao")%>')" type="button"><i class="fa fa-file-text-o"></i></button> 
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