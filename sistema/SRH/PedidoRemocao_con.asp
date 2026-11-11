<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
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
		strBotaoIncluirNovaRemocao = "S"
        strSituacaoPedidoRemocao 			= Trim(Request("cmbSituacaoPedidoRemocao"))
		if strSituacaoPedidoRemocao = "" then strSituacaoPedidoRemocao = "A"
		strBotaoVoltaTelaAnterior = "pedidoRemocao_cad.asp"
		strAnoletivo = Trim(Request("txtAnoLetivo"))
		if strAnoletivo = "" then strAnoletivo = year(date)
    %>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Pedido de Remoção</h3>
        </div>
        <!-- Inicia o Painel do Formulario -->     
        <div class="panel-body">
             <!-- Inicia o Form -->     
            <div class="panel-body">                                                        
                <form id="frm" class="margin-bottom-10" method="post" action="PedidoRemocao_con.asp">
                <input name="txtCodigo" type="hidden" id="txtCodigo">
                    <div class="form-group">
                        <label class="form-label">Situação</label>
                          <!--#include file="../includes/inc_cmbSituacaoPedidoRemocao.asp" -->
                    </div>
                    <div class="form-group">
                        <label class="form-label">Ano do Pedido</label>
                          <input class="form-control" name="txtAnoLetivo" type="text" class="text" id="txtAnoLetivo" size="5" maxlength="4" value="<%=strAnoLetivo%>" >
                    </div>
              
                    <legend></legend>
                    <!--#include file="../../includes/inc_botoes_consulta.asp"-->
                </form>
            	</div>
       	 	</div>
         	<!-- Fecha o Form -->  
      </div>
   	   
       <!--Table Bordered-->
        <div class="panel panel-grey margin-bottom-40">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de pedidos no Ano Letivo de <%=strAnoLetivo%></h3>
            </div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                          <th width="1%" bgcolor="#95A5A6">Mat.</th>
                          <th width="20%" bgcolor="#95A5A6">Nome</th>
                          <th width="15%" bgcolor="#95A5A6">1ª Opção</th>
                          <th width="15%" bgcolor="#95A5A6">2ª Opção</th>
                          <th width="15%" bgcolor="#95A5A6">3ª Opção</th>
						  <th width="10%" bgcolor="#95A5A6">Dt. Pedido</th>
                          <th width="15%" bgcolor="#95A5A6">Situação</th>
                          <th width="1%" bgcolor="#95A5A6" align="center">Editar</th>
                          <th width="1%" bgcolor="#95A5A6" align="center"><div align="center">Enviar</div></th>
                      </tr>
                    </thead>
                     <tbody>
                    <%
                    cont =0
					sql = "select p.codigo, c.codFuncional,c.nome, "
					sql = sql & " case when p.COD_EMPRESA_1OPCAO is null then r1.descricao else e1.razaosocial end as opcao1,"
					sql = sql & " case when p.COD_EMPRESA_2OPCAO is null then r2.descricao else e2.razaosocial end as opcao2,"
					sql = sql & " case when p.COD_EMPRESA_3OPCAO is null then r3.descricao else e3.razaosocial end as opcao3,"
					sql = sql & " e4.razaosocial as escola_escolhida,"					
					sql = sql & " p.situacao, p.usuario_incl, p.data_hora_incl, p.usuario_altr, p.data_hora_altr"
					sql = sql & " from SRH_PEDIDO_REMOCAO P"
					sql = sql & " inner join SRH_COLABORADOR C ON C.CODIGO = P.COD_COLABORADOR"
					sql = sql & " left join MAT_REGIAO R1 ON R1.CODIGO = P.COD_REGIAO1"
					sql = sql & " left join MAT_REGIAO R2 ON R2.CODIGO = P.COD_REGIAO2"
					sql = sql & " left join MAT_REGIAO R3 ON R3.CODIGO = P.COD_REGIAO3"
					sql = sql & " left join SEG_EMPRESA E1 ON E1.CODIGO = P.COD_EMPRESA_1OPCAO"
					sql = sql & " left join SEG_EMPRESA E2 ON E2.CODIGO = P.COD_EMPRESA_2OPCAO"
					sql = sql & " left join SEG_EMPRESA E3 ON E3.CODIGO = P.COD_EMPRESA_3OPCAO"
					sql = sql & " left join SEG_EMPRESA E4 ON E4.CODIGO = P.COD_EMPRESA_ESCOLHIDA"
					sql = sql & " WHERE P.COD_GRUPO = " & Session("CodGrupo")
					if strSituacaoPedidoRemocao <> "0" then
						sql = sql & " AND P.situacao = '" & strSituacaoPedidoRemocao & "'"
					end if
					if strAnoLetivo <> "" then
						sql = sql & " AND p.ano_letivo = " & strAnoLetivo
					end if
					sql = sql & " order BY p.ano_letivo desc, P.DATA_hora_INCL desc "
                    rs.open sql, cnn
                    if rs.eof = false then
						while not rs.eof
							cont = cont + 1	
							escola_escolhida = rs("escola_escolhida")
							situacao = "<font size='-2'><strong>Solicitado</strong> por " & rs("usuario_incl") & "<br>Em " & rs("data_hora_incl") & "</font>"
							if rs("situacao") = "G" then 
								situacao = "<font size='-2'><strong>Aguardando Autorização</strong> <br>Enviado por " & rs("usuario_altr") & "<br>Em " & rs("data_hora_altr") & "</font>"
							elseif rs("situacao") = "F" then 
								situacao = "<font size='-2'><strong>Atendida</strong> por " & rs("usuario_altr") & "<br><font size='-2'>Em " & rs("data_hora_altr") & " <strong>" & escola_escolhida & "</strong></font>"
							elseif rs("situacao") = "N" then 
								situacao = "<font size='-2'><strong>Não Atendida</strong> por " & rs("usuario_altr") & "<br>Em " & rs("data_hora_altr") & "</font>"
							end if

							%>
							<tr>
								<td><%=trim(rs("codFuncional"))%></td>
								<td><%=trim(rs("nome"))%></td>
                                
								<td><%=trim(rs("opcao1"))%></td>
								<td><%=trim(rs("opcao2"))%></td>
								<td><%=trim(rs("opcao3"))%></td>
								
								<td><%=trim(rs("data_hora_incl"))%></td>
								
                                <td><%=trim(situacao)%></td>
                                <td align="center" >
                                <%if rs("situacao") = "A" then %>
                                	<button class="btn-u btn-u-sea" onclick="editar(<%=trim(rs("codigo"))%>)" type="button"><i class="fa fa-edit"></i></button>
                                <%end if%>
                                </td>
								<td align="center" >
                                <%if rs("situacao") = "A" then %>
								<button class="btn-u btn-u-blue" onclick="acaoExec('<%=trim(rs("codigo"))%>','G')" type="button"><i class="fa fa-check-circle-o"></i></button>
                                <%else %>
								 
                                <%end if%>
                                </td> 
							</tr>
							<%				
							rs.movenext
                        wend
                    end if
                    rs.close
                	%>
                    	<tr>
                    		<td colspan="9">Total Registros : <%=cont%></td>
                    	</tr>
                    </tbody>
                </table>
            </div>                      
        </div>
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
	<script>
	    function acaoExec(intCodigo,tipoAcao){
			var frm = document.getElementById("frm");
			if(confirm("Deseja enviar essa solicitação para autorização?")) {
				frm.action="PedidoRemocaoAutorizacao_cad.asp?txtCodigo=" + intCodigo;
				frm.submit();
				return true;
			}			

        }
		 function editar(intCodigo){
            
            var frm = document.getElementById("frm");
            frm.txtCodigo.value = intCodigo;
            frm.action="pedidoRemocao_cad.asp";
            frm.submit();
            return true;
        }
    
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 