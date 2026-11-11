<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
   <meta http-equiv="Content-Type" content="text/html; charset=utf-8">

	<%  

	id		= Trim(Request("id"))
	sql = "select e.razaosocial as empresa, a.Descricao as area, t.Descricao as tipo_servico, r.resumo, (select top 1 t.descricao + '&nbsp;' +  CONVERT(VARCHAR(10), a.data_hora_incl, 103) + ' ' + CONVERT(VARCHAR(8), a.data_hora_incl, 108)  + ' por ' + a.usuario_incl  from SOS_REQUISICAO_andamento a inner join sos_tipo_andamento t on t.codigo = a.cod_tipo_andamento where a.cod_requisicao=r.codigo order by a.data_hora_incl desc) as situacao, i.imagem "
	sql = sql & " from SOS_REQUISICAO r"
	sql = sql & " inner join seg_empresa e on e.codigo = r.cod_empresa"
	sql = sql & " inner join SOS_TIPO_servico t on t.codigo = r.cod_tipo_servico"
	sql = sql & " inner join SOS_area a on a.codigo = t.cod_area"
	sql = sql & " inner join SOS_REQUISICAO_imagem i on i.cod_requisicao = r.codigo"
	sql = sql & " where r.codigo=" & id
	rs.open sql, cnn
	if not rs.eof then	
		strNome 	 = rs("empresa")
		imagem 		 = rs("imagem")
		resumo 		 = rs("resumo")
		area 		 = rs("area")
		tipo_servico = rs("tipo_servico")
		situacao = rs("situacao")
	end if
	rs.close
	%>
   <body>
   <!--=== Breadcrumbs ===-->
	<div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo OS - Ordem de Serviço número <%=id%> </h1>
            <ul class="pull-right breadcrumb">
                
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
        <div class="container">
            <h1 class="pull-left"><strong><%=strNome%><br><%=periodo%></strong></h1>
            <ul class="pull-right breadcrumb">
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
    
                      <%=imagem%>                                       
    </div>


</body>
</html> 



