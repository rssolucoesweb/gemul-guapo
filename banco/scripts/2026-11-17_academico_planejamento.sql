/* =====================================================================
   GUAPÓ - Acadêmico fase 2: planejamento do professor
   Data: 17/11/2026

   Rodar no banco de GUAPÓ (não no de Anápolis). Só altera 2 procedures (CREATE OR ALTER),
   não mexe em dados. Pode rodar mais de uma vez.

   1) SP_AcompanhamentoPlanejamentoProfessor: passa a devolver a coluna qtde_arquivo
      (arquivo mensal anexado na tela de acompanhamento). Resto igual ao de Guapó.
   2) SP_SCA_ReplicarAulaPlanejamentoProfessor: ao replicar a aula, copia também o
      Registro Reflexivo (desc_RegistroReflexivo, coluna criada na fase 1).
   ===================================================================== */
IF DB_NAME() = 'anapolis'
BEGIN
	RAISERROR('Este script é do GUAPÓ. Selecione o banco de Guapó.', 16, 1);
	SET NOEXEC ON;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[SP_AcompanhamentoPlanejamentoProfessor]
	 @cod_empresa int,
	 @ano_letivo int,
	 @cod_colaborador int,
	 @cod_turno int
AS

SET NOCOUNT ON 

-------------------------------
--declare	
--	@cod_empresa int = 29,
--	@ano_letivo int = 2023,
--	@cod_colaborador int = 40170,
--	@cod_turno int = 65



IF OBJECT_ID('tempdb..#calendario_horario') IS NOT NULL DROP TABLE #calendario_horario
CREATE TABLE #calendario_horario (numero_aula int IDENTITY(1, 1), mes int, codProfessor int, ANOLETIVO int, Semestre int, cod_curso int, curso varchar(150), Cod_Periodo int, periodo varchar(150),cod_disciplina int, disciplina varchar(150), Cod_Turma int, turma varchar(50), ano int, dia_mes int, Sequencia int, liberadoClick char(1), cor varchar(10), cod_planejamento_professor int, qtde_arquivo int)

insert #calendario_horario
SELECT distinct	d.mes, HA.Cod_Colaborador as codProfessor, HA.ANOLETIVO, HA.Semestre, cu.cod_curso, CU.Descricao AS curso, P.Cod_Periodo, P.Descricao AS periodo, 
		di.cod_disciplina as cod_disciplina, di.desc_disciplina as disciplina, Tu.Cod_Turma, Tu.TurmaAluno as turma, d.ano, d.dia_mes, ha.Sequencia, 'N' as liberadoClick, 'amarelo' as cor, 0 as cod_planejamento_professor, 0 as qtde_arquivo
from sca_calendario_dia_ue d 
inner join sca_calendario_ue c on c.cod_calendario_ue = d.cod_calendario_ue 
inner join sca_calendario_evento e on e.cod_calendario_evento = d.cod_calendario_evento 
inner join SCA_HORARIO_AULA HA on ha.AnoLetivo = d.ano and ha.DiaSemana = d.dia_semana and HA.COD_EMPRESA = c.cod_empresa 
inner join SCA_HORARIO H ON H.codigo = HA.COD_HORARIO and h.cod_empresa = ha.Cod_Empresa 
inner join SCA_TURMA tu on tu.Cod_Turma = ha.Cod_turma 
inner join SCA_DISCIPLINA di on di.Cod_Disciplina = ha.Cod_Disciplina 
INNER JOIN SCA_GRADECURRICULAR G ON G.COD_GRADECURRICULAR=Tu.COD_GRADECURRICULAR 
INNER JOIN SCA_PERIODO P ON P.COD_PERIODO=G.COD_PERIODO 
INNER JOIN SCA_CURSO CU ON CU.COD_CURSO=P.COD_CURSO  --AND CU.Cod_curso = C.cod_curso
where c.cod_empresa = @cod_empresa 
AND HA.ANOLETIVO = @ano_letivo 
and d.ano = @ano_letivo 
and HA.Cod_Colaborador = @cod_colaborador 
and h.CodTurno = @cod_turno 
and e.letivo='S' 

update h set h.liberadoClick = 'S'
from SCA_PLANEJAMENTO_GERAL g
inner join #calendario_horario h on h.Cod_Periodo = g.cod_periodo and h.cod_disciplina = g.cod_disciplina and h.ANOLETIVO = g.anoLetivo
where g.cod_situacao_planejamento = 7 

/*
update #calendario_horario set cor='cinza' where liberadoClick <> 'S'


IF OBJECT_ID('tempdb..#planejamento_professor') IS NOT NULL DROP TABLE #planejamento_professor
CREATE TABLE #planejamento_professor (cod_planejamento_professor int, anoLetivo int, cod_turma int, cod_turno int, numero_aula int, cod_disciplina int, observacao varchar(5000), validado char(1), qtde_conteudo_ministrado int)

insert #planejamento_professor
select distinct p.cod_planejamento_professor, p.anoLetivo, p.cod_turma, p.cod_turno, p.numero_aula, p.cod_disciplina, p.observacao, p.validado, (select COUNT(*) from SCA_CONTEUDO_MINISTRADO_PROFESSOR where cod_planejamento_professor = p.cod_planejamento_professor) as qtde_conteudo_ministrado
from SCA_PLANEJAMENTO_PROFESSOR p
inner join SCA_ITEM_PLANEJAMENTO_PROFESSOR ip on ip.cod_planejamento_professor = p.cod_planejamento_professor
where p.cod_disciplina in (select cod_disciplina from #calendario_horario)
and p.cod_turma in (select cod_turma from #calendario_horario)
and p.anoLetivo = @ano_letivo
and p.cod_turno = @cod_turno
and p.numero_aula is not null
and p.cod_planejamento_geral<>0


update c set c.cod_planejamento_professor = p.cod_planejamento_professor
from #calendario_horario c
inner join #planejamento_professor p on p.anoLetivo = c.ANOLETIVO 
									and p.cod_disciplina = c.cod_disciplina 
									and p.cod_turma = c.Cod_Turma 
									and p.cod_turno = @cod_turno 
									and c.numero_aula = p.numero_aula


update c set c.cor = 'laranja'
from #calendario_horario c
inner join #planejamento_professor p on p.anoLetivo = c.ANOLETIVO 
									and p.cod_disciplina = c.cod_disciplina 
									and p.cod_turma = c.Cod_Turma 
									and p.cod_turno = @cod_turno 
									and c.numero_aula = p.numero_aula
where c.cor = 'amarelo'
and p.qtde_conteudo_ministrado > 0


update c set c.cor = 'vermelho'
from #calendario_horario c
inner join #planejamento_professor p on p.anoLetivo = c.ANOLETIVO 
									and p.cod_disciplina = c.cod_disciplina 
									and p.cod_turma = c.Cod_Turma 
									and p.cod_turno = @cod_turno 
									and c.numero_aula = p.numero_aula
where c.cor = 'amarelo'
and p.qtde_conteudo_ministrado = 0
and p.validado = 'N'

update c set c.cor = 
			case
				when p.observacao is not null then 'azul'
				else 'verde'
			end
from #calendario_horario c
inner join #planejamento_professor p on p.anoLetivo = c.ANOLETIVO 
									and p.cod_disciplina = c.cod_disciplina 
									and p.cod_turma = c.Cod_Turma 
									and p.cod_turno = @cod_turno 
									and c.numero_aula = p.numero_aula
where c.cor = 'amarelo'
and p.qtde_conteudo_ministrado = 0
and p.validado = 'S'
*/
-- Guapó: marca o mês/turma/disciplina que tem arquivo anexado (botão "Arquivo" fica verde)
update h set h.qtde_arquivo = 1
from sca_planejamento_arquivo g
inner join #calendario_horario h on h.cod_turma = g.cod_turma and h.cod_disciplina = g.cod_disciplina and h.ANOLETIVO = g.ano_letivo and h.mes = g.mes
where g.ano_letivo = @ano_letivo

select * from #calendario_horario
order by disciplina, Cod_turma, ano, mes, dia_mes
GO

CREATE OR ALTER PROCEDURE [dbo].[SP_SCA_ReplicarAulaPlanejamentoProfessor] (
	@codigoPlanejamentoOrigem int,
	@codigoTurmaDestino int,
	@codigoTurnoDestino int = 0,
	@codigoProfessor int,
	@usuario varchar(50)
)
as

set nocount on

declare @codigoNovoPlanejamento int
declare @codigoTurnoTurmaDestino int

begin tran

if (@codigoTurnoDestino<>0)
	begin
		set @codigoTurnoTurmaDestino = @codigoTurnoDestino

	end
else
	begin
		select @codigoTurnoTurmaDestino = Cod_Turno from SCA_TURMA
		where Cod_Turma = @codigoTurmaDestino

		--para turma diferenciada "integral" vai pegar o turno do horario do professor
		if @codigoTurnoTurmaDestino = 4 
		begin
	
			select distinct @codigoTurnoTurmaDestino = h.CodTurno 
			from SCA_HORARIO_AULA a
			inner join SCA_HORARIO h on h.codigo = a.Cod_Horario
			inner join SCA_TURMA t on t.Cod_Turma = a.Cod_turma and a.AnoLetivo = t.AnoLetivo
			where a.Cod_Colaborador = @codigoProfessor
			and a.Cod_turma = @codigoTurmaDestino

		end
	

	end

insert into sca_PLANEJAMENTO_PROFESSOR
(
cod_planejamento_geral,
cod_empresa,
anoLetivo,
semestre,
numero_aula,
data_aula_extra,
cod_periodo,
cod_disciplina,
cod_turno,
cod_turma,
cod_colaborador,
desc_metodologia,
desc_avaliacao,
desc_RegistroReflexivo,
observacao,
validado,
usuario_validado,
data_hora_validado,
usuario_incl,
data_hora_incl,
desc_conteudo_complementar
) 
select 
	cod_planejamento_geral,
	cod_empresa,
	anoLetivo,
	semestre,
	numero_aula,
	data_aula_extra,
	cod_periodo,
	cod_disciplina,
	@codigoTurnoTurmaDestino,
	@codigoTurmaDestino,
	@codigoProfessor,
	desc_metodologia,
	desc_avaliacao,
	desc_RegistroReflexivo,
	observacao,
	validado,
	usuario_validado,
	data_hora_validado,
	@usuario,
	GETDATE(),
	desc_conteudo_complementar
from sca_PLANEJAMENTO_PROFESSOR 
where cod_planejamento_professor = @codigoPlanejamentoOrigem

select @codigoNovoPlanejamento =  @@identity

insert into SCA_ITEM_PLANEJAMENTO_PROFESSOR (
	cod_planejamento_professor,
	cod_item_planejamento_geral,
	cod_tipo_planejamento,
	descricao,
	complemento,
	usuario_incl,
	data_hora_incl
)
select
	@codigoNovoPlanejamento,
	cod_item_planejamento_geral,
	cod_tipo_planejamento,
	descricao,
	complemento,
	@usuario,
	GETDATE()
from SCA_ITEM_PLANEJAMENTO_PROFESSOR
where cod_planejamento_professor = @codigoPlanejamentoOrigem

commit
GO

SET NOEXEC OFF;
GO
PRINT 'Planejamento (fase 2) concluído.';
GO
