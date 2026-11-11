<!--#include file="../../includes/inc_cnn.asp"-->
<%
response.CacheControl = "no-cache"
Response.expires = 0
Response.expiresabsolute = Now() - 1
Response.addHeader "pragma", "no-cache"         'não armazena no cache os dados gerados
Response.addHeader "cache-control", "private"   'não armazena no cache os dados gerados
response.ContentType = "text/html; charset=ISO-8859-1"

sub Pesquisar()
 %>
 		<div class="panel panel-grey margin-bottom-40">
        <div class="panel-heading">
            <h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Autores</h3>
        </div>
        <div class="panel-body">           
            <table class="table table-bordered">
            <thead>
                <tr bgcolor="#95A5A6">
                <td bgcolor="#95A5A6"><strong>C&oacute;digo</strong></td>
                <td bgcolor="#95A5A6"><strong>Nome </strong><strong class="TextoForm">&nbsp;</strong></td>
                </tr>
            </thead>
            <%
            cont =0
            
            sql = "SELECT Cod_Autor, Nome_Autor"
            sql = sql & " FROM SCB_AUTORES"
            sql = sql & " Where Cod_empresa = " & session("codEmpresa")
            sql = sql & " and Nome_Autor LIKE '%" & strAutores & "%'"
            sql = sql & " order by Nome_Autor"
            rs.open sql, cnn
                
            if rs.eof = false then
            
                while not rs.eof
                    cont = cont + 1	
                    selecionado = ""
                    
                    ' Consulta SCA_GRADECURRICULARDISCIPLINA
                    if intCodPublicacao <> "" then
                    
                        sql = " SELECT Cod_Autor "
                        sql = sql & " FROM SCB_PUBLICACAOAUTORES "
                        sql = sql & " WHERE Cod_Publicacao = " &  intCodPublicacao
                        sql = sql & " And Cod_Autor = " &  rs("Cod_Autor")
                        rsAux.open sql, cnn
                        
                        if rsAux.eof = false then
                            selecionado = "checked"
                        end if
                        rsAux.close
                    end if
                    %>
                      <tr>
                        <td width="5%" height="26" align="center" class="Texto"><input name="chkAutor" type="checkbox" value="<%=rs("Cod_Autor")%>" <%=selecionado%> onClick="AdicionaRegistro(this,'<%=trim(rs("Nome_Autor"))%>')" ></td>
                        <td class="Texto"><input type="hidden" name="txtDescAutor<%=rs("Cod_Autor")%>" value="<%=trim(rs("Nome_Autor"))%>">&nbsp;<%=trim(rs("Nome_Autor"))%></td>
                      </tr>
                    <%				
                rs.movenext
                wend
                %>
                <tr> 
                <td height="21" colspan="4" class="celula"><span class="texto">Total Registros :</span> <%=cont%></td>
                <%
            end if
            rs.close
            %>
            </table>
         	</div>                      
        </div>
    </div>
		<%
end sub

on error resume next
strAutores	= trim(replace(request("Autores"),"'",""))

Pesquisar()

if err.number <> 0 then
	descricaoErro = err.description
	response.Write("Ocorreu um erro na consulta " & vbCrlf & "Descrição: " & descricaoErro)
end if
%>

