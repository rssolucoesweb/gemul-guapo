select distinct SEG_USUARIOS_EMPRESA.COD_EMPRESA, SEG_EMPRESA.RAZAOSOCIAL,SEG_EMPRESA.BAIRRO, SEG_GRUPO.codigo AS CodGrupo, 
SEG_GRUPO.DESCRICAO AS GRUPO 
FROM SEG_USUARIOS_EMPRESA 
INNER JOIN SEG_EMPRESA ON SEG_EMPRESA.CODIGO = SEG_USUARIOS_EMPRESA.COD_EMPRESA 
LEFT JOIN SEG_GRUPO  ON SEG_EMPRESA.COD_GRUPO = SEG_GRUPO.CODIGO 
WHERE SEG_GRUPO.codigo = 7
AND SEG_EMPRESA.codigo in ( 
						select distinct tu.Cod_Empresa 
						from SCA_TURMA TU 
						inner join SCA_GRADECURRICULAR GD on GD.Cod_GradeCurricular = TU.Cod_GradeCurricular AND GD.Cod_Empresa = TU.Cod_Empresa 
						inner join SCA_PERIODO PE ON PE.Cod_Periodo = GD.Cod_Periodo AND PE.Cod_Empresa = GD.Cod_Empresa 
						inner join SCA_TURNO TUR ON TUR.Cod_Turno = TU.Cod_Turno AND TUR.Cod_Empresa = TU.Cod_Empresa 
						where TU.Cod_Empresa in (select codigo from SEG_EMPRESA where COD_GRUPO=7) 
						and TU.Situacao = 'A' 
						and tu.AnoLetivo = 2015 
						and SUBSTRING(PE.Descricao,1,11) = 'AGRUPAMENTO' 
						and TUR.Desc_Turno = 'INTEGRAL'
						and isnull(TU.Capacidade,0) - isnull(TU.VagasReservadas,0) -  isnull(TU.VagasMatriculasUtilizadas,0) > 0 	
						AND (SELECT (SUM(CASE WHEN VagasMatriculaInicial<= 0 THEN 0 ELSE VagasMatriculaInicial END)* 30)/100 FROM SCA_TURMA 
						WHERE Cod_empresa = tu.Cod_Empresa ) >= (SELECT COUNT(CODIGO) FROM MAT_inscricao WHERE Cod_empresa = tu.Cod_Empresa ))
Order by SEG_GRUPO.DESCRICAO, SEG_EMPRESA.RAZAOSOCIAL 



SELECT (SUM(CASE WHEN VagasMatriculaInicial<= 0 THEN 0 ELSE VagasMatriculaInicial END)* 30)/100 FROM SCA_TURMA 
WHERE Cod_empresa = 136 


SELECT COUNT(CODIGO) FROM MAT_inscricao WHERE Cod_empresa = 136 

