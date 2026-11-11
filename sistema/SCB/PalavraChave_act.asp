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
            	<h3 class="panel-title"><i class="fa fa-globe"></i> Lista de Palavra Chave</h3>
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
                        
                        sql = "SELECT Cod_Palavra, Nome_Palavra"
                        sql = sql & " FROM SCB_PalavraChave"
                        sql = sql & " Where Cod_empresa = " & session("codEmpresa")
                        sql = sql & " and Nome_Palavra LIKE '%" & strPalavra & "%'"
                        sql = sql & " order by Nome_Palavra"
                        rs.open sql, cnn
                            
                        if rs.eof = false then
                        
                            while not rs.eof
                                cont = cont + 1	
                                selecionado = ""
                                
                                if intCodPublicacao <> "" then
                                    sql = " SELECT Cod_PalavraChave "
                                    sql = sql & " FROM SCB_PUBLICACAOPALAVRACHAVE "
                                    sql = sql & " WHERE Cod_Publicacao = " &  intCodPublicacao
                                    sql = sql & " And Cod_PalavraChave = " &  rs("Cod_Palavra")
                                    rsAux.open sql, cnn
                                    
                                    if rsAux.eof = false then
                                        selecionado = "checked"
                                    end if
                                    rsAux.close
                                end if
                                    
                                %>
                                  <tr>
                                    <td width="5%" height="26" align="center" class="Texto"><input name="chkPalavra" type="checkbox" value="<%=rs("Cod_Palavra")%>" <%=selecionado%> onClick="AdicionaRegistro(this,'<%=trim(rs("Nome_Palavra"))%>')" ></td>
                                    <td class="Texto"><input type="hidden" name="txtDescAutor<%=rs("Cod_Palavra")%>" value="<%=trim(rs("Nome_Palavra"))%>">&nbsp;<%=trim(rs("Nome_Palavra"))%></td>
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
		strPalavra	= trim(replace(request("Palavra"),"'",""))
		
		Pesquisar()
		
		if err.number <> 0 then
			descricaoErro = err.description
			response.Write("Ocorreu um erro na consulta " & vbCrlf & "Descrição: " & descricaoErro)
		end if
%>

