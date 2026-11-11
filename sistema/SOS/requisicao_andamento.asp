<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
   <meta http-equiv="Content-Type" content="text/html; charset=utf-8">

	<%  


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
	end if
	rs.close
	
	strUsuarioAbertura = "N"
	id		= Trim(Request("id"))
	sql = "select r.cod_tipo_andamento, R.Cod_Usuario_Abertura, e.razaosocial as empresa, a.Descricao as area, t.Descricao as tipo_servico, r.resumo, (select top 1 t.descricao + '&nbsp;' +  CONVERT(VARCHAR(10), a.data_hora_incl, 103) + ' ' + CONVERT(VARCHAR(8), a.data_hora_incl, 108)  + ' por ' + a.usuario_incl  from SOS_REQUISICAO_andamento a inner join sos_tipo_andamento t on t.codigo = a.cod_tipo_andamento where a.cod_requisicao=r.codigo order by a.data_hora_incl desc) as situacao "
	sql = sql & " from SOS_REQUISICAO r"
	sql = sql & " inner join seg_empresa e on e.codigo = r.cod_empresa"
	sql = sql & " inner join SOS_TIPO_servico t on t.codigo = r.cod_tipo_servico"
	sql = sql & " inner join SOS_area a on a.codigo = t.cod_area"
	sql = sql & " left join SOS_REQUISICAO_imagem i on i.cod_requisicao = r.codigo"
	sql = sql & " where r.codigo=" & id
	rs.open sql, cnn
	if not rs.eof then	
		strNome 	 = rs("empresa")
		resumo 		 = rs("resumo")
		area 		 = rs("area")
		tipo_servico = rs("tipo_servico")
		situacao = rs("situacao")
		cod_tipo_andamento = rs("cod_tipo_andamento")
		if isnull(cod_tipo_andamento) then cod_tipo_andamento = "0"
		if ucase(strUsuarioPortal) = ucase(rs("Cod_Usuario_Abertura")) then strUsuarioAbertura = "S"
	end if
	rs.close
	
	FINALIZAR = "N"
	if strPerfilGestorArea = "S" or strPerfilSuperintendente = "S" or strPerfilMaster = "S" or strUsuarioAbertura = "S" then
		'pode finalizar
		FINALIZAR = "S"
	end if
	
	%>
   <body>
   <form id="frm" class="margin-bottom-10" method="post">
   <!--=== Breadcrumbs ===-->
	<div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo OS - Ordem de Serviço número <%=id%> </h1>
            <ul class="pull-right breadcrumb">
                <li></li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
        <div class="container">
            <h1 class="pull-left"><strong><%=strNome%><br><%=periodo%></strong></h1>
            <ul class="pull-right breadcrumb">
			<%if cod_tipo_andamento<>"7" AND FINALIZAR = "S" then%>
			Situação da OS:<br>
            <select name="cmbSituacaoFinal" id="cmbSituacaoFinal" style="width:180pt" class="form-control"  >
				<option value="0">Selecione...</option>
				<option value="Executada">Executada</option>
				<option value="Parcialmente Executada">Parcialmente Executada</option>
				<option value="Não Executada">Não Executada</option>
			</select>
			<div><input type="button" name="cmdFechar" style="width:250px"   value="  Finalizar OS  "  class="btn-u btn-u-brown float-shadow"  onClick="finalizar('<%=id%>');"></div>
			<%end if%>
			
            </ul>
       </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
    <div class="breadcrumbs">
	<div align="center">	
    <p align="justify"><strong>Situação:</strong> <%=situacao%></p>
    <p align="justify"><strong>Área/Tipo de Serviço:</strong> <%=area%>/<%=tipo_servico%></p>
    <p align="justify"><strong>Resumo:</strong> <%=resumo%></p>
                      
    </div>
    </div>
        <!--=== Content Part ===-->
    <div align="center">	
    				Andamento da OS número <%=id%>
                      <%
				sql = "select r.parecer, t.Descricao as tipo_andamento, r.data_hora_incl,u.USUA_NOME_COMPLETO as usuario_incl "
				sql = sql & " from SOS_REQUISICAO_ANDAMENTO r "
				sql = sql & " inner join SOS_TIPO_ANDAMENTO t on t.Codigo = r.cod_tipo_andamento "
				sql = sql & " inner join SEG_USUARIOS_SISTEMA u on u.usua_codg = r.usuario_incl"
				sql = sql & " where r.cod_requisicao = " & id
				sql = sql & " order by r.data_hora_incl desc"
				rs.open sql, cnn
				if rs.eof = false then
					%>            
					<table class="table table-bordered">
						<thead>
							<tr>
								<th width="27%" align="center" class="celula"><strong>Data Inclusão</strong></th>
								<th width="19%" class="celula"><div align="center"><strong>Andamento</strong></div></th>
								<th width="31%" class="celula"><div align="center"><strong>Parecer</strong></div></th>
								<th width="23%" align="center" class="celula"><strong>Servidor</strong></th>
								
							</tr>
						</thead>
					<tbody>
					<%
                   	while not rs.eof
						cont = cont + 1	
						%>	
						<tr>
							<td height="20" class="celula"><%=RS("data_hora_incl")%></td>
							<td class="celula"><%=RS("tipo_andamento")%></td>
							<td class="celula"><%=RS("parecer")%></td>
							<td height="20" class="celula"><%=RS("usuario_incl")%></td>
							
						</tr>
						<%
						RS.MOVENEXT
				   wend
				   rs.close
				   %>
				   </tbody>
				  </table>
                  <br>
				<%
				end if
				  %>                                  
    </div>
</form>

   <script>

	function finalizar(id){
		
		var frm = document.getElementById("frm");
		
		if (frm.cmbSituacaoFinal.value == "0") {
			alert("Situação deve ser informada!");
			frm.cmbSituacaoFinal.focus();
			return false
		}
		
		if (confirm("Deseja finalizar a OS?")) {
			frm.action="finalizarOS_cod.asp?id=" + id;
			frm.submit();
			return true;
		}
		
		
 	}
</script>

</body>
</html> 



