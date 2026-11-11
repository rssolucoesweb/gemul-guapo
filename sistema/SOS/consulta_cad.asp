<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
<!--#include file="../menuModulos.asp"-->
<!--#include file="../includes/inc_CompartilharDadosCadastrais.asp"-->
<script src="../../js/js_funcoes_gerais.js"></script>  
    <!--=== Breadcrumbs ===-->
    <div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">OS - Ordem de Serviço</h1>
            <ul class="pull-right breadcrumb">
                <li><a href="Default.asp">Home</a></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
	<%

	
        strPaginaTitulo = "area_cad.asp"
    
		strUsuarioPortal = trim(session("usuarioWeb"))
		strPerfilGestorArea = "N"
		sql = "select codigo "
		sql = sql & " from SOS_AREA"
		sql = sql & " where usua_codg = '"&strUsuarioPortal & "'"
		rs.open sql, cnn
		if not rs.eof then
			strPerfilGestorArea = "S"
		end if
		rs.close
		
		strPerfilExecutor = "N"
		sql = "select ACES_USUA_CODG "
		sql = sql & " from SEG_ACESSOS_USUARIO"
		sql = sql & " where ACES_USUA_CODG = '"&strUsuarioPortal & "' and ACES_PERF_CODG=69"
		rs.open sql, cnn
		if not rs.eof then
			strPerfilExecutor = "S"
		end if
		rs.close
		
		IF strPerfilExecutor = "S" THEN
			sql = "select CODIGO "
			sql = sql & " from SOS_FUNCIONARIO_EXTERNO"
			sql = sql & " where codigo_seg_usuarios_sistema = '"&strUsuarioPortal & "'"
			rs.open sql, cnn
			if not rs.eof then
				intCodExecutor = RS("CODIGO")
			end if
			rs.close
		END IF
		
		
		strPerfilSuperintendente = "N"
		sql = "select ACES_USUA_CODG "
		sql = sql & " from SEG_ACESSOS_USUARIO"
		sql = sql & " where ACES_USUA_CODG = '"&strUsuarioPortal & "' and ACES_PERF_CODG=70"
		rs.open sql, cnn
		if not rs.eof then
			strPerfilSuperintendente = "S"
		end if
		rs.close
		
		strPerfilMaster = "N"
		sql = "select usuario_master from [dbo].[SEG_USUARIOS_sistema] where usuario_master='S' and usua_codg='"&strUsuarioPortal & "'"	
		rs.open sql, cnn
		if not rs.eof then
			strPerfilMaster = "S"
			strPerfilExecutor = "N"
			strPerfilGestorArea = "N"
		end if
		rs.close
    %>
     <!--=== Content Part ===-->
    <div class="container content">		
    
      <!-- Grey Panel -->            
      <div class="panel panel-grey">
        <div class="panel-heading">
        	<h3 class="panel-title"><i class="fa fa-tasks"></i>Consulta de Requisições </h3>
        </div>
       
   	   
            <div class="panel-body">
            
          <%
				cont =0
				
				sql = "select i.CODIGO as tem_img,r.cod_tipo_andamento, e.razaosocial as unidade_solicitante,r.CODIGO, tp.item, p.descricao as prioridade, ex.codigo_seg_usuarios_sistema, ex.nome as para,  tp.descricao as tipo_servico,tp.cod_area, "
				sql = sql & " (select top 1 t.descricao + '<br>' +  CONVERT(VARCHAR(10), a.data_hora_incl, 103) + ' ' + CONVERT(VARCHAR(8), a.data_hora_incl, 108)  + ' por ' + u.USUA_NOME_COMPLETO from SOS_REQUISICAO_andamento a inner join sos_tipo_andamento t on t.codigo = a.cod_tipo_andamento inner join SEG_USUARIOS_SISTEMA u on u.usua_codg = a.usuario_incl where a.cod_requisicao=r.codigo order by a.data_hora_incl desc) as situacao, "
				SQL = SQL & " a.descricao as area, r.data, r.resumo"
				sql = sql & " from SOS_REQUISICAO r "
				sql = sql & " inner join SEG_EMPRESA e on e.codigo = r.cod_empresa"
				sql = sql & " inner join SOS_TIPO_SERVICO tp on tp.codigo = r.cod_tipo_servico "
				sql = sql & " inner join SOS_AREA a on a.codigo = tp.cod_area "
				sql = sql & " left join SOS_FUNCIONARIO_EXTERNO ex on ex.codigo = r.cod_funcionario_externo"
				sql = sql & " inner join SOS_PRIORIDADE p on p.codigo = r.cod_prioridade"
				sql = sql & " left join SOS_REQUISICAO_IMAGEM i on i.cod_requisicao = r.CODIGO  WHERE 1=1"
				if strPerfilMaster = "S" OR strPerfilSuperintendente = "S" then
					'VE TODO
				end if
				if strPerfilExecutor = "S" then
					if intCodExecutor = "" then intCodExecutor = 0
					sql = sql & " AND r.cod_funcionario_externo = " & intCodExecutor
				end if
				
				if strPerfilGestorArea = "S" then
					sql = sql & " AND a.usua_codg = '"&strUsuarioPortal & "'"
				end if		
										
				if strPerfilSuperintendente = "N" and strPerfilGestorArea = "N" and strPerfilMaster = "N" and strPerfilExecutor = "N" then
					sql = sql & " AND r.Cod_Usuario_Abertura = '"&strUsuarioPortal & "'"
				end if		
												
				sql = sql & " order by r.data DESC"
				rs.open sql, cnn
				if rs.eof = false then
				%>            
					<table class="table table-bordered">
						<thead>
							<tr>
							  <th width="1%" class="celula"><div align="center"><strong>OS</strong></div></th>
							  <th width="20%" class="celula"><div align="center"><strong>Unidade</strong></div></th>
								<th width="5%" height="21" class="celula"><div align="center"><strong>Data</strong></div></th>
								<th width="20%" class="celula"><div align="center"><strong>Departamento/Tipo Serviço</strong></div></th>
								<th width="20%" class="celula"><div align="center"><strong>Resumo do Serviço</strong></div></th>
								<th width="15%" align="center" class="celula"><div align="center"><strong>Situa&ccedil;&atilde;o</strong></div></th>
								<th width="15%" align="center" class="celula"><div align="center"><strong>Executor</strong></div></th>
								<th width="2%" align="center" class="celula"><strong>Consultar</strong></th>
								<th width="2%" align="center" class="celula"><strong>Foto</strong></th>
							</tr>
						</thead>
					<tbody>
					   <%
					   
                   while not rs.eof
                        cont = cont + 1	
						
						liberaAcesso = "N"
						if strPerfilSuperintendente = "S" or strPerfilGestorArea = "S" then
							liberaAcesso = "S"
						end if
		
						
						
						cod_tipo_andamento = rs("cod_tipo_andamento")
						if isnull(cod_tipo_andamento) then cod_tipo_andamento = "0"
						
						para = "GESTOR DA ÁREA"
						if not isnull(RS("para")) then para = RS("para")
                        %>	
                        <tr style="cursor:hand" onmouseover="return linhaMouseOver(this)" onmouseout="return linhaMouseOut(this)">
                          <td class="celula"><%=RS("codigo")%></td>
						    <td class="celula"><%=RS("unidade_solicitante")%></td>
                            <td class="celula"><%=RS("DATA")%></td>
                            <td class="celula"><%=RS("cod_area")%>. <%=RS("AREA")%><br><%=RS("cod_area")%>.<%=RS("item")%>. <%=RS("TIPO_SERVICO")%></td>
                            <td height="20" class="celula"><%=RS("RESUMO")%></td>
                            <td height="20" class="celula"><%=RS("SITUACAO")%></td>
                            <td class="celula"><%=RS("para")%></td>
                            <td align="center" class="celula"><a href="#" onclick="mostraOS('<%=rs("codigo")%>')"><img src="../../images/consultarAndamento.png" width="32" height="32" alt="Consultar OS."></a></td>
							<td align="center" class="celula">
							<%if not isnull(rs("tem_img")) then%>
							<a href="#" onclick="mostraImagem('<%=rs("codigo")%>','F')"><img src="../../images/consultarImagem.png" width="32" height="32" alt="Consultar Imagem da OS."></a>
							<%end if%>
							</td>
                        </tr>
                            <%
                            RS.MOVENEXT
                       wend
                       rs.close
                       %>
                      <tr>
                        <td height="32" colspan="9" class="celula">Total Registros : <%=cont%></td>
                       </tr>
                       </tbody>
                      </table>
                      
  <%
			
				else
					   %>
						<table class="table table-bordered">
							<thead>
								<tr>
								<th height="32" colspan="11" class="celula"><div align="center">N&atilde;o h&aacute; lan&ccedil;amentos</div></th>
								</tr>
							</tbody>
						</table>
					  <%
				end if  
				%>   
                    
            </div>                      
        </div>
        <!--End Table Bordered-->	
        <!-- Fecha o Painel do Formulario -->        
    </div>
    <!--/container-->		
	<script>
	function mostraImagem(id, tipo){
		if (tipo == 'A') {
			window.open("requisicao_andamento.asp?id=" + id,"abreConsultaImagem","top=5,left=5,height=600,width=1000,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		}
		if (tipo == 'F') {
			window.open("requisicao_img.asp?id=" + id,"abreConsultaImagem","top=5,left=5,height=600,width=1000,menubar=no,toolbar=no,scrollbars=yes,status=yes");
		}
	}
    function mostraOS(id){
		window.open("Recibo_servico_rel.asp?id=" + id,"abreConsultaImagem","top=5,left=5,height=600,width=1000,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}
    </script>
    <!--=== End Content Part ===-->
   	<!--#include file="../RodapeModulo.asp"-->
	<!--#include file="../jsModulo.asp"-->
</body>
</html> 