<select name="cmbRede" id="cmbRede" class="form-control" style="width: 200px" onchange="submit()">
  <option value="0">Todas...</option>
  <option value="M" <%if strRede = "M" then response.Write("selected") %>>Municipal</option>
  <option value="E" <%if strRede = "E" then response.Write("selected") %>>Estadual</option>
</select>
