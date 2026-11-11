<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
   <meta http-equiv="Content-Type" content="text/html; charset=utf-8">

	<%  

	id		= Trim(Request("id"))
	sql = "select C.NOME, C.CODFUNCIONAL, CFI.imagem, j.DataLancamento, j.DataLancamentoFinal, j.justificativa "
	sql = sql & " from SRH_COLABORADOR_JUSTIFICATIVA J "
	sql = sql & " INNER JOIN SRH_COLABORADOR_JUSTIFICATIVA_IMAGEM CFI ON CFI.COD_COLABORADOR_JUSTIFICATIVA = J.CODIGO"
	sql = sql & " inner join SRH_COLABORADOR C ON C.CODIGO = J.COD_COLABORADOR "
	sql = sql & " WHERE J.CODIGO=" & id
	rs.open sql, cnn
	if not rs.eof then	
		strNome = rs("nome") & " - " & rs("CODFUNCIONAL")
		imagem = rs("imagem")
		justificativa = rs("justificativa")
		periodo = formatadataAP(rs("DataLancamento")) & " a " & formatadataAP(rs("DataLancamentoFinal"))
	end if
	rs.close
	%>
   <body>
   <!--=== Breadcrumbs ===-->
	<div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo RH </h1>
            <ul class="pull-right breadcrumb">
                <li>Consulta da Imagem do Documento de Justificativa</li>
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
        <div class="container">
            <h1 class="pull-left"><strong><%=strNome%><br><%=periodo%></strong></h1>
            <ul class="pull-right breadcrumb">
            <div><input type="button" name="cmdFechar" style="width:250px"   value="  Fechar  "  class="btn-u btn-u-brown float-shadow"  onClick="window.close();"></div>
            </ul>
       </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
    <div class="breadcrumbs">
	<div align="center">	
    <p align="justify"><strong>Justificativa:</strong> <%=justificativa%></p>
                      
    </div>
    </div>
        <!--=== Content Part ===-->
    <div align="center">	
    
                      <%=imagem%>                                       
    </div>


</body>
</html> 



