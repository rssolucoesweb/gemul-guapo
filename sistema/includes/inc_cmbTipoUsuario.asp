<!--
	::	DESENVOLVIDO POR "RS SOLUÇÕES WEB - www.rssolucoesweb.com.br"
	::	Data de Criação...: 10/07/2010
	::	Desenvolvedores...: Roberto Barbosa Silva - roberto@rssolucoesweb.com.br
	::	Objetivo Pagina...: Tipo de Usuario Biblioteca
-->
<select name="cmbTipoUsuario" class="form-control" id="cmbTipoUsuario"  style="width:150pt" onchange="submit()">
  <option value="0">Selecione...</option>
  <option value="1" <%if strTipoUsuario = "1" then response.Write("selected") %>>Aluno</option>
  <option value="2" <%if strTipoUsuario = "2" then response.Write("selected") %>>Colaborador</option>
  <option value="3" <%if strTipoUsuario = "3" then response.Write("selected") %>>Comunidade</option>
</select>
