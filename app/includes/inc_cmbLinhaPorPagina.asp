<select name="cmblpp" id="cmblpp"  class="form-control" >
  <option <%IF strlpp="0" THEN RESPONSE.Write("selected")%> value="0">Selecione...</option>
  	<%
	For i = 1 to 100 
		strLinhaPorPaginas = string(3-len(i),"0") & i
		%>
  		<option value="<%=i%>" <%if TRIM(i)=TRIM(strlpp) then%>selected<%end if%>><%=strLinhaPorPaginas%></option>
  		<%
	Next									
	%>
</select>
