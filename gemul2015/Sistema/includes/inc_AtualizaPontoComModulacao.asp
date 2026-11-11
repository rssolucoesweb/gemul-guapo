<%
'parametros:
'	strAnoLetivo
'	intCodFuncional
if intCodFuncional <> "" and strAnoLetivo <>"" then
	sql = " DELETE GEMUL5.DBO.FUNC_COLETOR"
	sql = sql & " WHERE	CODI_FUNC = " & intCodFuncional
	sql = sql & " and   CODI_COLE <> 999" 'curinga
	'response.Write(sql) & "<br>"
	cnn.execute sql
	
	sql = "INSERT GEMUL5.DBO.FUNC_COLETOR "
	sql = sql & " select distinct 1, C.CODFUNCIONAL, DD.COD_EMPRESA, NULL, 0,0,0,0,0,0,1,NULL,NULL"
	sql = sql & " from SRH_MODULACAO_DISCIPLINAR_DOCENTE DD "
	sql = sql & " inner join srh_colaborador c on c.codigo=dd.cod_colaborador "
	sql = sql & " INNER join gemul5.dbo.FUNCIONARIOS FF ON FF.CODI_FUNC = c.codfuncional "
	sql = sql & " INNER JOIN SRH_FUNCAOCOLABORADOR F ON F.Cod_Funcao = C.CODFUNCAO "
	sql = sql & " inner join SEG_EMPRESA e on e.CODIGO = dd.Cod_empresa "
	sql = sql & " where	dd.ano_letivo = " & strAnoLetivo
	sql = sql & " and		dd.status = 'A' "
	sql = sql & " and		isnull(C.CODFUNCIONAL,0)<>0 "
	sql = sql & " AND		F.MODULAR = 'S' "
	sql = sql & " AND		C.CODFUNCIONAL = " & intCodFuncional
	'response.Write(sql) & "<br>"
	cnn.execute sql
	
	sql = "UPDATE gemul5.dbo.FUNCIONARIOS  set DATA_UPDATE = getdate() "
	sql = sql & " WHERE	codi_func=" & intCodFuncional
	'response.Write(sql) & "<br>"
	cnn.execute sql
end if
%>
