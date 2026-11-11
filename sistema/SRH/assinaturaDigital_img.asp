<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
   <meta http-equiv="Content-Type" content="text/html; charset=utf-8">

	<%  

	id		= Trim(Request("id"))
	
	if id <> "" and id <> "0"  then
	
		cont =0
		sql = " SELECT c.nome as colaborador, FI.IMAGEM "
		sql = sql & " from SRH_COLABORADOR C  "
		sql = sql & " left JOIN SRH_COLABORADOR_ASSINATURA_DIGITAL FI ON FI.codcolaborador = C.CODIGO"
		sql = sql & " WHERE FI.CODIGO = " & id
		rs.open sql, cnn
		if rs.eof = false then
			colaborador				 					= trim(rs("colaborador"))
			imagem										= trim(rs("imagem"))
		end if	
		rs.close
		
		
	end if	
	
	
	%>
   <body>
   <!--=== Breadcrumbs ===-->
	<div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo RH - Assinatura digital - <%=id%> </h1>
            <ul class="pull-right breadcrumb">
                
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
        <div class="container">
            <h1 class="pull-left"><strong><%=colaborador%></strong></h1>
            <ul class="pull-right breadcrumb">
            </ul>
       </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
        <!--=== Content Part ===-->
    <div align="center">	
    
                      <%=imagem%>                                       
    </div>


</body>
</html> 



