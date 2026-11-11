<!--
	::	SIGE
	::	Data de Criação...: 17/08/2004
	::	Desenvolvedores...: Sérgio Dias BOrges
	::	Objetivo Pagina...: Inncluir os Tipo de Lançamentos existentes em um combobox 
	::	Data Atualizacao..: 
	::	Motivo Atualizacao: 
-->
<select name="cmbTipoLancamento" id="cmbTipoLancamento" class="combo"  style="width:130pt" <%=strDesabilitaTipoLancamento%>  onChange="return reload()">
	<option <% if intCodTipoLancamento = "0" then response.Write("selected") %> value="0">Notas e Faltas</option>
	<option <% if intCodTipoLancamento = "1" then response.Write("selected") %> value="1">Notas</option>
	<option <% if intCodTipoLancamento = "2" then response.Write("selected") %> value="2">Faltas</option>
</select>
