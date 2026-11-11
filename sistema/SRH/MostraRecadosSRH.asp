<!--#include file="../../includes/inc_formatadata.asp"-->
<script>
	function ConsultaRecado(CodRecado){
		window.open("../Recado_con.asp?intCodRecado="+CodRecado,"consulta","top=0,left=0,height=450,width=580,menubar=no,toolbar=no,scrollbars=yes,status=yes");
	}
	function linhaMouseOver(linha){
		linha.style.backgroundColor="#FFE6E6";
		return true;
	}
	function linhaMouseOut(linha){
		linha.style.backgroundColor="";
		return true;
	}	
</script>
<%
	sql = "SELECT SEG_Recados.CodRecado, SEG_Recados.De, SEG_Recados.Para, SEG_Recados.Assunto, "
	sql = sql & " SEG_Recados.Recado, SEG_Recados.data, SEG_Recados.hora "
	sql = sql & " FROM SEG_Recados"
	sql = sql & " WHERE envio_sistema='SRH' "
	sql = sql & " AND SEG_Recados.Para = '" & trim(session("UsuarioWeb")) & "'"
	sql = sql & " AND SEG_Recados.Status = 1	"
	sql = sql & " ORDER BY SEG_Recados.data DESC"
	rs.open sql, cnn
	if rs.eof = false then
	%>
	  <div class="panel panel-grey">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-tasks"></i> Recado </h3>
            </div>
            <div class="panel-body">
            <table class="table table-bordered" >
		  		<thead>
            <tr >
              <th colspan="2" align="center" class="celula" >&nbsp;<strong>De</strong></td>
              <th class="celula" ><strong>Assunto</strong></td>
              <th width="13%" class="celula" >&nbsp;<strong>Data</strong></td>
              <th width="14%" class="celula" ><strong>Hora</strong></td>
            </tr>
        </thead>
		<%
			id = 0
			While not rs.eof 
				strDe					= trim(rs("De"))
				strAssunto 				= Trim(Rs("Assunto"))
				strData					= formataDataAP(Trim(Rs("data")))
				strHora 				= Trim(Rs("Hora"))
				%>
                    <tr  style="cursor:hand" onMouseOver="return linhaMouseOver(this)" onMouseOut="return linhaMouseOut(this)" onClick="return ConsultaRecado('<%=rs("CodRecado")%>')">
                        <td width="6%" height="20" align="center" class="celula" ><img src="../../images/v.gif" width="15" height="15"></td>
                        <td width="10%" class="celula" ><%=strDe%>&nbsp;</td>
                        <td width="60%" class="celula" ><%=strAssunto%></td>
                        <td class="celula" ><%=strData%></td>
                        <td class="celula" ><%=strHora%>&nbsp;</td>
                    </tr>
				<%
				rs.movenext
				wend
			%>
	  </table>
      </div>
    	</div>
	  <%
	end if
	rs.close	
%>
