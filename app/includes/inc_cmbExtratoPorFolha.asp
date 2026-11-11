<select name="cmbTotalExtrato" id="cmbTotalExtrato" class="form-control">
	<option value="1" <%if intTotalExtrato = "1" then response.Write("selected") %>>01</option>
	<option value="2" <%if intTotalExtrato = "2" then response.Write("selected") %>>02</option>
	<option value="3" <%if intTotalExtrato = "3" then response.Write("selected") %>>03</option>
	<option value="4" <%if intTotalExtrato = "4" then response.Write("selected") %>>04</option>
	<option value="5" <%if intTotalExtrato = "5" then response.Write("selected") %>>05</option>
	 <%if strclasse = "celulaarial7" or strclasse = "celulaarial8" or strclasse = "celulaarial9" or strclasse = "celulaarial10" then%>
	<option value="6" <%if intTotalExtrato = "6" then response.Write("selected") %>>06</option>
	<%end if%>
	 <%if strclasse = "celulaarial7" or strclasse = "celulaarial8"  or strclasse = "celulaarial9" then%>
	<option value="7" <%if intTotalExtrato = "7" then response.Write("selected") %>>07</option>
	<%end if%>
	<%if strclasse = "celulaarial7"  then%>
	<option value="8" <%if intTotalExtrato = "8" then response.Write("selected") %>>08</option>
	<%end if%>
	<%if strclasse = "celulaarial7" then%>
	<option value="9" <%if intTotalExtrato = "9" then response.Write("selected") %>>09</option>
	<%end if%>
</select>
    	
