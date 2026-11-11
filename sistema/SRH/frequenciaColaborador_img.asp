<!--#include file="../ConfigModulo.asp"-->
<!--#include file="../../includes/inc_cnn.asp"-->
<!--#include file="../../includes/inc_formatadata.asp"-->
   <meta http-equiv="Content-Type" content="text/html; charset=utf-8">

	<%  

	id		= Trim(Request("id"))
	
	if id <> "" and id <> "0"  then
	
		cont =0
		sql = " SELECT c.nome as colaborador, f.DATALANCAMENTO, f.DATALANCAMENTOFINAL, f.OBSERVACAO, FI.IMAGEM "
		sql = sql & " from SRH_COLABORADOR_FREQUENCIA_FOLHA F "
		sql = sql & " inner join SRH_COLABORADOR C on c.codigo = f.cod_Colaborador "
		sql = sql & " left JOIN SRH_COLABORADOR_FREQUENCIA_FOLHA_IMAGEM FI ON FI.cod_colaborador_frequencia_folha = F.CODIGO"
		sql = sql & " WHERE F.CODIGO = " & id
		rs.open sql, cnn
		if rs.eof = false then
			colaborador				 					= trim(rs("colaborador"))
			strDataLancamento         					= trim(rs("DATALANCAMENTO"))
			strDataLancamentoFinal        				= trim(rs("DATALANCAMENTOFINAL"))
			if strDataLancamentoFinal = "" then strDataLancamentoFinal = strDataLancamento
			periodo = strDataLancamento & " - " & strDataLancamentoFinal
			strObservacao		    					= Trim(rs("OBSERVACAO"))
			imagem										= trim(rs("imagem"))
		end if	
		rs.close
		
		
	end if	
	
	
	%>
   <body>
   <!--=== Breadcrumbs ===-->
	<div class="breadcrumbs">
        <div class="container">
            <h1 class="pull-left">Modulo RH - Frequencia de Funcionários - <%=id%> </h1>
            <ul class="pull-right breadcrumb">
                
                <li class="active"><%=session("CodEmpresa")%> - <%=session("EmpresaWeb")%></li>
            </ul>
        </div><!--/container-->
        <div class="container">
            <h1 class="pull-left"><strong><%=colaborador%><br><%=periodo%></strong></h1>
            <ul class="pull-right breadcrumb">
            </ul>
       </div><!--/container-->
    </div><!--/breadcrumbs-->
    <!--=== End Breadcrumbs ===-->
    <div class="breadcrumbs">
	<div align="center">	
    <p align="justify"><strong>Observação:</strong> <%=strObservacao%></p>
                      
    </div>
    </div>
        <!--=== Content Part ===-->
    <div align="center">	
    
                      <%=imagem%>                                       
    </div>


</body>
</html> 



