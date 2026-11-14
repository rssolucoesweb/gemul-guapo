/* =====================================================================
   GUAPÓ - Acadêmico de Anápolis: fase 1 (banco) - SÓ ESTRUTURA, sem dados
   Data: 14/11/2026

   Rodar no banco de GUAPÓ (não no de Anápolis). Só acrescenta: não apaga nem altera dado existente,
   exceto preencher valores padrão das colunas novas. Pode rodar mais de uma vez (cada parte confere antes).

   1) 14 tabelas novas do acadêmico (AEE, transferência de notas, atividade complementar, observações do diário,
      anexos/recursos do planejamento, remanejamento, vagas por turma, ano letivo, extensão de escola)
   2) colunas novas em tabelas existentes (SCA_TURMA, SCA_ALUNO_DISCIPLINA, SCA_SITUACAOALUNO, SCA_PERIODO,
      SEG_EMPRESA, CENSO_PAIS, SCA_GRADECURRICULARDISCIPLINA, SCA_PLANEJAMENTO_PROFESSOR)
   3) 6 procedures do acadêmico (SP_ListarAlunosTurma, notas de transferência, quantitativo mensal, replicar aula)

   Matrícula (MAT_*) fica para a última fase.
   ===================================================================== */
IF DB_NAME() = 'anapolis'
BEGIN
	RAISERROR('Este script é do GUAPÓ. Selecione o banco de Guapó.', 16, 1);
	SET NOEXEC ON;
END
GO

/* ---------- 1) tabelas novas ---------- */
IF OBJECT_ID('dbo.SCA_ALUNO_TIPO_ATENDIMENTO') IS NULL
BEGIN
CREATE TABLE [dbo].[SCA_ALUNO_TIPO_ATENDIMENTO](
	[CODIGO] [int] IDENTITY(1,1) NOT NULL,
	[COD_EMPRESA] [int] NOT NULL,
	[ANO_LETIVO] [int] NOT NULL,
	[COD_ALUNO] [int] NOT NULL,
	[COD_TURMA] [int] NOT NULL,
	[TIPO_ATENDIMENTO] [varchar](3) NOT NULL,
	[COD_SITUACAO_ALUNO] [int] NOT NULL,
	[DATA_INGRESSO] [date] NOT NULL,
	[usuario_incl] [varchar](150) NOT NULL,
	[data_hora_incl] [datetime] NOT NULL,
 CONSTRAINT [PK_SCA_ALUNO_TIPO_ATENDIMENTO] PRIMARY KEY CLUSTERED 
(
	[CODIGO] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
PRINT 'Tabela SCA_ALUNO_TIPO_ATENDIMENTO criada.';
END
GO
IF OBJECT_ID('dbo.FK_SCA_ALUNO_TIPO_ATENDIMENTO_SCA_ALUNO') IS NULL
	ALTER TABLE [dbo].[SCA_ALUNO_TIPO_ATENDIMENTO]  WITH CHECK ADD  CONSTRAINT [FK_SCA_ALUNO_TIPO_ATENDIMENTO_SCA_ALUNO] FOREIGN KEY([COD_ALUNO])
	REFERENCES [dbo].[SCA_ALUNO] ([CODIGO]);
GO
IF OBJECT_ID('dbo.FK_SCA_ALUNO_TIPO_ATENDIMENTO_SCA_TURMA') IS NULL
	ALTER TABLE [dbo].[SCA_ALUNO_TIPO_ATENDIMENTO]  WITH CHECK ADD  CONSTRAINT [FK_SCA_ALUNO_TIPO_ATENDIMENTO_SCA_TURMA] FOREIGN KEY([COD_TURMA])
	REFERENCES [dbo].[SCA_TURMA] ([Cod_Turma]);
GO
IF OBJECT_ID('dbo.FK_SCA_ALUNO_TIPO_ATENDIMENTO_SEG_EMPRESA') IS NULL
	ALTER TABLE [dbo].[SCA_ALUNO_TIPO_ATENDIMENTO]  WITH CHECK ADD  CONSTRAINT [FK_SCA_ALUNO_TIPO_ATENDIMENTO_SEG_EMPRESA] FOREIGN KEY([COD_EMPRESA])
	REFERENCES [dbo].[SEG_EMPRESA] ([CODIGO]);
GO

IF OBJECT_ID('dbo.SCA_ALUNO_TRANSFERENCIA') IS NULL
BEGIN
CREATE TABLE [dbo].[SCA_ALUNO_TRANSFERENCIA](
	[CODIGO] [int] IDENTITY(1,1) NOT NULL,
	[COD_EMPRESA] [int] NOT NULL,
	[COD_ALUNO] [int] NOT NULL,
	[ANO_LETIVO] [int] NOT NULL,
	[ANO_LETIVO_TRANSFERENCIA] [int] NOT NULL,
	[SEMESTRE_TRANSFERENCIA] [int] NOT NULL,
	[COD_EMPRESA_TRANSFERENCIA] [int] NOT NULL,
	[USUARIO_INCL] [varchar](50) NOT NULL,
	[DATA_HORA_INCL] [datetime] NOT NULL,
	[EFETIVADO] [char](1) NOT NULL,
	[USUARIO_EFETIVACAO] [varchar](50) NULL,
	[DATA_HORA_EFETIVACAO] [datetime] NULL,
	[NOTAS_ATUALIZADAS] [char](1) NULL,
	[FALTAS_ATUALIZADAS] [char](1) NULL,
	[ATUALIZADO_TELA_AVALIACAO] [char](1) NULL,
 CONSTRAINT [PK_ALUNO_TRANSFERENCIA] PRIMARY KEY CLUSTERED 
(
	[CODIGO] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
PRINT 'Tabela SCA_ALUNO_TRANSFERENCIA criada.';
END
GO
IF OBJECT_ID('dbo.DF_SCA_ALUNO_TRANSFERENCIA_NOTAS_ATUALIZADAS') IS NULL
	ALTER TABLE [dbo].[SCA_ALUNO_TRANSFERENCIA] ADD  CONSTRAINT [DF_SCA_ALUNO_TRANSFERENCIA_NOTAS_ATUALIZADAS]  DEFAULT ('N') FOR [NOTAS_ATUALIZADAS];
GO
IF OBJECT_ID('dbo.DF_SCA_ALUNO_TRANSFERENCIA_NOTAS_ATUALIZADAS1') IS NULL
	ALTER TABLE [dbo].[SCA_ALUNO_TRANSFERENCIA] ADD  CONSTRAINT [DF_SCA_ALUNO_TRANSFERENCIA_NOTAS_ATUALIZADAS1]  DEFAULT ('N') FOR [FALTAS_ATUALIZADAS];
GO
IF OBJECT_ID('dbo.DF_SCA_ALUNO_TRANSFERENCIA_ATUALIZADO_TELA_AVALIACAO') IS NULL
	ALTER TABLE [dbo].[SCA_ALUNO_TRANSFERENCIA] ADD  CONSTRAINT [DF_SCA_ALUNO_TRANSFERENCIA_ATUALIZADO_TELA_AVALIACAO]  DEFAULT ('N') FOR [ATUALIZADO_TELA_AVALIACAO];
GO

IF OBJECT_ID('dbo.SCA_atividade_complementar_area') IS NULL
BEGIN
CREATE TABLE [dbo].[SCA_atividade_complementar_area](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[codigo] [int] NOT NULL,
	[descricao] [nvarchar](300) NOT NULL,
	[ativo] [bit] NOT NULL,
	[data_cadastro] [datetime2](0) NOT NULL,
 CONSTRAINT [PK_atividade_complementar_area] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
PRINT 'Tabela SCA_atividade_complementar_area criada.';
END
GO
IF OBJECT_ID('dbo.DF_atividade_complementar_area_ativo') IS NULL
	ALTER TABLE [dbo].[SCA_atividade_complementar_area] ADD  CONSTRAINT [DF_atividade_complementar_area_ativo]  DEFAULT ((1)) FOR [ativo];
GO
IF OBJECT_ID('dbo.DF_atividade_complementar_area_data_cadastro') IS NULL
	ALTER TABLE [dbo].[SCA_atividade_complementar_area] ADD  CONSTRAINT [DF_atividade_complementar_area_data_cadastro]  DEFAULT (sysdatetime()) FOR [data_cadastro];
GO

IF OBJECT_ID('dbo.SCA_atividade_complementar_subarea') IS NULL
BEGIN
CREATE TABLE [dbo].[SCA_atividade_complementar_subarea](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[area_id] [int] NOT NULL,
	[codigo] [int] NOT NULL,
	[descricao] [nvarchar](300) NOT NULL,
	[ativo] [bit] NOT NULL,
	[data_cadastro] [datetime2](0) NOT NULL,
 CONSTRAINT [PK_atividade_complementar_subarea] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
PRINT 'Tabela SCA_atividade_complementar_subarea criada.';
END
GO
IF OBJECT_ID('dbo.DF_atividade_complementar_subarea_ativo') IS NULL
	ALTER TABLE [dbo].[SCA_atividade_complementar_subarea] ADD  CONSTRAINT [DF_atividade_complementar_subarea_ativo]  DEFAULT ((1)) FOR [ativo];
GO
IF OBJECT_ID('dbo.DF_atividade_complementar_subarea_data_cadastro') IS NULL
	ALTER TABLE [dbo].[SCA_atividade_complementar_subarea] ADD  CONSTRAINT [DF_atividade_complementar_subarea_data_cadastro]  DEFAULT (sysdatetime()) FOR [data_cadastro];
GO
IF OBJECT_ID('dbo.FK_atividade_complementar_subarea_area') IS NULL
	ALTER TABLE [dbo].[SCA_atividade_complementar_subarea]  WITH CHECK ADD  CONSTRAINT [FK_atividade_complementar_subarea_area] FOREIGN KEY([area_id])
	REFERENCES [dbo].[SCA_atividade_complementar_area] ([id]);
GO

IF OBJECT_ID('dbo.SCA_atividade_complementar') IS NULL
BEGIN
CREATE TABLE [dbo].[SCA_atividade_complementar](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[subarea_id] [int] NOT NULL,
	[codigo] [int] NOT NULL,
	[descricao] [nvarchar](500) NOT NULL,
	[ativo] [bit] NOT NULL,
	[data_cadastro] [datetime2](0) NOT NULL,
 CONSTRAINT [PK_atividade_complementar] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
PRINT 'Tabela SCA_atividade_complementar criada.';
END
GO
IF OBJECT_ID('dbo.DF_atividade_complementar_ativo') IS NULL
	ALTER TABLE [dbo].[SCA_atividade_complementar] ADD  CONSTRAINT [DF_atividade_complementar_ativo]  DEFAULT ((1)) FOR [ativo];
GO
IF OBJECT_ID('dbo.DF_atividade_complementar_data_cadastro') IS NULL
	ALTER TABLE [dbo].[SCA_atividade_complementar] ADD  CONSTRAINT [DF_atividade_complementar_data_cadastro]  DEFAULT (sysdatetime()) FOR [data_cadastro];
GO
IF OBJECT_ID('dbo.FK_atividade_complementar_subarea') IS NULL
	ALTER TABLE [dbo].[SCA_atividade_complementar]  WITH CHECK ADD  CONSTRAINT [FK_atividade_complementar_subarea] FOREIGN KEY([subarea_id])
	REFERENCES [dbo].[SCA_atividade_complementar_subarea] ([id]);
GO

IF OBJECT_ID('dbo.SCA_CONTROLE_REMANEJAMENTO') IS NULL
BEGIN
CREATE TABLE [dbo].[SCA_CONTROLE_REMANEJAMENTO](
	[codigo] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[cod_aluno] [int] NOT NULL,
	[cod_empresa] [int] NOT NULL,
	[ano_letivo] [int] NOT NULL,
	[semestre] [int] NOT NULL,
	[cod_turma_atual] [int] NOT NULL,
	[cod_turma_origem] [int] NOT NULL,
	[situacao_id_aluno_turma] [char](1) NOT NULL,
	[data_remanejamento] [datetime] NOT NULL,
	[usuario_incl] [varchar](50) NOT NULL,
	[data_hora_incl] [datetime] NOT NULL,
 CONSTRAINT [PK_sca_controle_remanejamento] PRIMARY KEY CLUSTERED 
(
	[codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
PRINT 'Tabela SCA_CONTROLE_REMANEJAMENTO criada.';
END
GO
IF OBJECT_ID('dbo.FK_SCA_CONTROLE_REMANEJAMENTO_SCA_ALUNO') IS NULL
	ALTER TABLE [dbo].[SCA_CONTROLE_REMANEJAMENTO]  WITH CHECK ADD  CONSTRAINT [FK_SCA_CONTROLE_REMANEJAMENTO_SCA_ALUNO] FOREIGN KEY([cod_aluno])
	REFERENCES [dbo].[SCA_ALUNO] ([CODIGO]);
GO
-- (FK omitida: SCA_SITUACAO_ALUNO_TURMA não existe em Guapó)
IF OBJECT_ID('dbo.FK_SCA_CONTROLE_REMANEJAMENTO_SCA_TURMA') IS NULL
	ALTER TABLE [dbo].[SCA_CONTROLE_REMANEJAMENTO]  WITH CHECK ADD  CONSTRAINT [FK_SCA_CONTROLE_REMANEJAMENTO_SCA_TURMA] FOREIGN KEY([cod_turma_atual])
	REFERENCES [dbo].[SCA_TURMA] ([Cod_Turma]);
GO
IF OBJECT_ID('dbo.FK_SCA_CONTROLE_REMANEJAMENTO_SCA_TURMA1') IS NULL
	ALTER TABLE [dbo].[SCA_CONTROLE_REMANEJAMENTO]  WITH CHECK ADD  CONSTRAINT [FK_SCA_CONTROLE_REMANEJAMENTO_SCA_TURMA1] FOREIGN KEY([cod_turma_origem])
	REFERENCES [dbo].[SCA_TURMA] ([Cod_Turma]);
GO
IF OBJECT_ID('dbo.FK_SCA_CONTROLE_REMANEJAMENTO_SEG_EMPRESA') IS NULL
	ALTER TABLE [dbo].[SCA_CONTROLE_REMANEJAMENTO]  WITH CHECK ADD  CONSTRAINT [FK_SCA_CONTROLE_REMANEJAMENTO_SEG_EMPRESA] FOREIGN KEY([cod_empresa])
	REFERENCES [dbo].[SEG_EMPRESA] ([CODIGO]);
GO

IF OBJECT_ID('dbo.SCA_OBSERVACAO_DIARIO_TURMA') IS NULL
BEGIN
CREATE TABLE [dbo].[SCA_OBSERVACAO_DIARIO_TURMA](
	[CODIGO] [int] IDENTITY(1,1) NOT NULL,
	[COD_EMPRESA] [int] NULL,
	[COD_TURMA] [int] NULL,
	[ANO_LETIVO] [int] NULL,
	[SEMESTRE] [int] NULL,
	[DATA] [datetime] NULL,
	[OBSERVACAO] [varchar](max) NULL,
	[USUARIO_INCL] [varchar](50) NULL,
	[DATA_HORA_INCL] [datetime] NULL,
 CONSTRAINT [PK_SCA_OBSERVACAO_DIARIO_TURMA] PRIMARY KEY CLUSTERED 
(
	[CODIGO] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
PRINT 'Tabela SCA_OBSERVACAO_DIARIO_TURMA criada.';
END
GO

IF OBJECT_ID('dbo.SCA_OBSERVACAO_NOTAS_FALTAS_TURMA') IS NULL
BEGIN
CREATE TABLE [dbo].[SCA_OBSERVACAO_NOTAS_FALTAS_TURMA](
	[CODIGO] [int] IDENTITY(1,1) NOT NULL,
	[COD_EMPRESA] [int] NULL,
	[COD_TURMA] [int] NULL,
	[ANO_LETIVO] [int] NULL,
	[SEMESTRE] [int] NULL,
	[DATA] [datetime] NULL,
	[OBSERVACAO] [varchar](1000) NULL,
	[USUARIO_INCL] [varchar](50) NULL,
	[DATA_HORA_INCL] [datetime] NULL,
 CONSTRAINT [PK_SCA_OBSERVACAO_NOTAS_FALTAS_TURMA] PRIMARY KEY CLUSTERED 
(
	[CODIGO] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
PRINT 'Tabela SCA_OBSERVACAO_NOTAS_FALTAS_TURMA criada.';
END
GO

IF OBJECT_ID('dbo.sca_planejamento_arquivo') IS NULL
BEGIN
CREATE TABLE [dbo].[sca_planejamento_arquivo](
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[ano_letivo] [int] NOT NULL,
	[mes] [int] NOT NULL,
	[cod_turma] [int] NOT NULL,
	[cod_disciplina] [int] NOT NULL,
	[nome_arquivo] [varchar](255) NOT NULL,
	[tipo_arquivo] [varchar](100) NULL,
	[arquivo_base64] [nvarchar](max) NOT NULL,
	[usuario_incl] [varchar](100) NOT NULL,
	[data_hora_incl] [datetime] NOT NULL,
 CONSTRAINT [PK__sca_plan__40F9A20786F0DE59] PRIMARY KEY CLUSTERED 
(
	[codigo] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
PRINT 'Tabela sca_planejamento_arquivo criada.';
END
GO
IF OBJECT_ID('dbo.DF__sca_plane__data___07D70320') IS NULL
	ALTER TABLE [dbo].[sca_planejamento_arquivo] ADD  CONSTRAINT [DF__sca_plane__data___07D70320]  DEFAULT (getdate()) FOR [data_hora_incl];
GO

IF OBJECT_ID('dbo.SCA_PLANEJAMENTO_PROFESSOR_RECURSO') IS NULL
BEGIN
CREATE TABLE [dbo].[SCA_PLANEJAMENTO_PROFESSOR_RECURSO](
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[cod_planejamento_professor] [int] NOT NULL,
	[tipo] [char](1) NOT NULL,
	[descricao] [varchar](500) NULL,
	[nome_arquivo] [varchar](255) NULL,
	[tipo_arquivo] [varchar](100) NULL,
	[tamanho_arquivo] [int] NULL,
	[arquivo_base64] [varchar](max) NULL,
	[url] [varchar](2000) NULL,
	[usuario_incl] [varchar](100) NULL,
	[data_hora_incl] [datetime] NOT NULL,
 CONSTRAINT [PK_SCA_PLANEJAMENTO_PROFESSOR_RECURSO] PRIMARY KEY CLUSTERED 
(
	[codigo] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
PRINT 'Tabela SCA_PLANEJAMENTO_PROFESSOR_RECURSO criada.';
END
GO
IF OBJECT_ID('dbo.DF_SCA_PLAN_PROF_REC_DATA') IS NULL
	ALTER TABLE [dbo].[SCA_PLANEJAMENTO_PROFESSOR_RECURSO] ADD  CONSTRAINT [DF_SCA_PLAN_PROF_REC_DATA]  DEFAULT (getdate()) FOR [data_hora_incl];
GO
IF OBJECT_ID('dbo.CK_SCA_PLANEJAMENTO_PROFESSOR_RECURSO_TIPO') IS NULL
	ALTER TABLE [dbo].[SCA_PLANEJAMENTO_PROFESSOR_RECURSO]  WITH CHECK ADD  CONSTRAINT [CK_SCA_PLANEJAMENTO_PROFESSOR_RECURSO_TIPO] CHECK  (([tipo]='L' OR [tipo]='A'));
GO

IF OBJECT_ID('dbo.SCA_TURMA_atendimento_atividade') IS NULL
BEGIN
CREATE TABLE [dbo].[SCA_TURMA_atendimento_atividade](
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[cod_turma] [int] NOT NULL,
	[atividade_complementar_id] [int] NOT NULL,
	[usuario_incl] [varchar](150) NOT NULL,
	[data_hora_incl] [datetime] NOT NULL,
 CONSTRAINT [PK_SCA_TURMA_atendimento_atividade] PRIMARY KEY CLUSTERED 
(
	[codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
PRINT 'Tabela SCA_TURMA_atendimento_atividade criada.';
END
GO
IF OBJECT_ID('dbo.FK_SCA_TURMA_atendimento_atividade_SCA_atividade_complementar') IS NULL
	ALTER TABLE [dbo].[SCA_TURMA_atendimento_atividade]  WITH CHECK ADD  CONSTRAINT [FK_SCA_TURMA_atendimento_atividade_SCA_atividade_complementar] FOREIGN KEY([atividade_complementar_id])
	REFERENCES [dbo].[SCA_atividade_complementar] ([id]);
GO
IF OBJECT_ID('dbo.FK_SCA_TURMA_atendimento_atividade_SCA_TURMA') IS NULL
	ALTER TABLE [dbo].[SCA_TURMA_atendimento_atividade]  WITH CHECK ADD  CONSTRAINT [FK_SCA_TURMA_atendimento_atividade_SCA_TURMA] FOREIGN KEY([cod_turma])
	REFERENCES [dbo].[SCA_TURMA] ([Cod_Turma]);
GO

IF OBJECT_ID('dbo.SCA_TURMA_VAGAS') IS NULL
BEGIN
CREATE TABLE [dbo].[SCA_TURMA_VAGAS](
	[Codigo] [int] IDENTITY(1,1) NOT NULL,
	[Cod_Turma] [int] NOT NULL,
	[Cod_Empresa] [int] NOT NULL,
	[AnoLetivo] [int] NULL,
	[Vagas] [int] NULL,
	[Alocados] [int] NULL,
	[Reservas] [int] NULL,
	[Efetivados] [int] NULL,
 CONSTRAINT [PK_SCA_TURMA_VAGAS] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
PRINT 'Tabela SCA_TURMA_VAGAS criada.';
END
GO
IF OBJECT_ID('dbo.DF_SCA_TURMA_Vagas') IS NULL
	ALTER TABLE [dbo].[SCA_TURMA_VAGAS] ADD  CONSTRAINT [DF_SCA_TURMA_Vagas]  DEFAULT ((0)) FOR [Vagas];
GO
IF OBJECT_ID('dbo.DF_SCA_TURMA_VAGAS_Reservas') IS NULL
	ALTER TABLE [dbo].[SCA_TURMA_VAGAS] ADD  CONSTRAINT [DF_SCA_TURMA_VAGAS_Reservas]  DEFAULT ((0)) FOR [Reservas];
GO
IF OBJECT_ID('dbo.DF_SCA_TURMA_VAGAS_Efetivados') IS NULL
	ALTER TABLE [dbo].[SCA_TURMA_VAGAS] ADD  CONSTRAINT [DF_SCA_TURMA_VAGAS_Efetivados]  DEFAULT ((0)) FOR [Efetivados];
GO
IF OBJECT_ID('dbo.FK_SCA_TURMA_VAGAS_SCA_TURMA') IS NULL
	ALTER TABLE [dbo].[SCA_TURMA_VAGAS]  WITH CHECK ADD  CONSTRAINT [FK_SCA_TURMA_VAGAS_SCA_TURMA] FOREIGN KEY([Cod_Turma])
	REFERENCES [dbo].[SCA_TURMA] ([Cod_Turma]);
GO

IF OBJECT_ID('dbo.SEG_ANO_LETIVO') IS NULL
BEGIN
CREATE TABLE [dbo].[SEG_ANO_LETIVO](
	[CODIGO] [int] IDENTITY(1,1) NOT NULL,
	[COD_GRUPO] [int] NOT NULL,
	[ANO_LETIVO] [int] NOT NULL,
	[SITUACAO] [char](1) NOT NULL,
	[PADRAO] [char](1) NOT NULL,
	[USUARIO_INCL] [varchar](50) NULL,
	[DATA_HORA_INCL] [datetime] NOT NULL,
 CONSTRAINT [PK_SEG_ANO_LETIVO] PRIMARY KEY CLUSTERED 
(
	[CODIGO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
PRINT 'Tabela SEG_ANO_LETIVO criada.';
END
GO
IF OBJECT_ID('dbo.DF_SEG_ANO_LETIVO_SITUACAO') IS NULL
	ALTER TABLE [dbo].[SEG_ANO_LETIVO] ADD  CONSTRAINT [DF_SEG_ANO_LETIVO_SITUACAO]  DEFAULT ('A') FOR [SITUACAO];
GO
IF OBJECT_ID('dbo.DF_SEG_ANO_LETIVO_PADRAO') IS NULL
	ALTER TABLE [dbo].[SEG_ANO_LETIVO] ADD  CONSTRAINT [DF_SEG_ANO_LETIVO_PADRAO]  DEFAULT ('N') FOR [PADRAO];
GO
IF OBJECT_ID('dbo.DF_SEG_ANO_LETIVO_DATA') IS NULL
	ALTER TABLE [dbo].[SEG_ANO_LETIVO] ADD  CONSTRAINT [DF_SEG_ANO_LETIVO_DATA]  DEFAULT (getdate()) FOR [DATA_HORA_INCL];
GO

IF OBJECT_ID('dbo.SEG_EMPRESA_EXTENSAO') IS NULL
BEGIN
CREATE TABLE [dbo].[SEG_EMPRESA_EXTENSAO](
	[CODIGO] [int] IDENTITY(1,1) NOT NULL,
	[COD_EMPRESA] [int] NOT NULL,
	[NOME] [varchar](150) NOT NULL,
	[ENDERECO] [varchar](150) NULL,
	[BAIRRO] [varchar](50) NULL,
	[MUNICIPIO] [varchar](50) NULL,
	[UF] [varchar](2) NULL,
	[CEP] [varchar](10) NULL,
	[TELEFONE] [varchar](20) NULL,
	[COD_EMPRESA_INATIVA] [int] NULL,
 CONSTRAINT [PK_SEG_EMPRESA_EXTENSAO] PRIMARY KEY CLUSTERED 
(
	[CODIGO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
PRINT 'Tabela SEG_EMPRESA_EXTENSAO criada.';
END
GO

/* ---------- 2) colunas novas em tabelas existentes ---------- */
IF COL_LENGTH('dbo.SCA_TURMA', 'cod_diretrizes_estrutura_fisica') IS NULL
BEGIN
	ALTER TABLE dbo.SCA_TURMA ADD [cod_diretrizes_estrutura_fisica] [int] NULL;
	PRINT 'Coluna SCA_TURMA.cod_diretrizes_estrutura_fisica criada.';
END
GO
IF COL_LENGTH('dbo.SCA_TURMA', 'Cod_empresa_extensao') IS NULL
BEGIN
	ALTER TABLE dbo.SCA_TURMA ADD [Cod_empresa_extensao] [int] NULL;
	PRINT 'Coluna SCA_TURMA.Cod_empresa_extensao criada.';
END
GO
IF COL_LENGTH('dbo.SCA_TURMA', 'data_hora_altr') IS NULL
BEGIN
	ALTER TABLE dbo.SCA_TURMA ADD [data_hora_altr] [datetime] NULL;
	PRINT 'Coluna SCA_TURMA.data_hora_altr criada.';
END
GO
IF COL_LENGTH('dbo.SCA_TURMA', 'data_hora_incl') IS NULL
BEGIN
	ALTER TABLE dbo.SCA_TURMA ADD [data_hora_incl] [datetime] NULL CONSTRAINT [DF_SCA_TURMA_data_hora_incl] DEFAULT (getdate());
	PRINT 'Coluna SCA_TURMA.data_hora_incl criada.';
END
GO
IF COL_LENGTH('dbo.SCA_TURMA', 'tipo_turma') IS NULL
BEGIN
	ALTER TABLE dbo.SCA_TURMA ADD [tipo_turma] [varchar](3) NULL CONSTRAINT [DF_SCA_TURMA_tipo_turma] DEFAULT ('ESC') WITH VALUES;
	PRINT 'Coluna SCA_TURMA.tipo_turma criada.';
END
GO
IF COL_LENGTH('dbo.SCA_TURMA', 'usuario_altr') IS NULL
BEGIN
	ALTER TABLE dbo.SCA_TURMA ADD [usuario_altr] [varchar](50) NULL;
	PRINT 'Coluna SCA_TURMA.usuario_altr criada.';
END
GO
IF COL_LENGTH('dbo.SCA_TURMA', 'usuario_incl') IS NULL
BEGIN
	ALTER TABLE dbo.SCA_TURMA ADD [usuario_incl] [varchar](50) NULL;
	PRINT 'Coluna SCA_TURMA.usuario_incl criada.';
END
GO
IF COL_LENGTH('dbo.SCA_TURMA', 'VagasUtilizadasVeteranos') IS NULL
BEGIN
	ALTER TABLE dbo.SCA_TURMA ADD [VagasUtilizadasVeteranos] [int] NULL CONSTRAINT [DF_SCA_TURMA_VagasUtilizadasVeteranos] DEFAULT ((0)) WITH VALUES;
	PRINT 'Coluna SCA_TURMA.VagasUtilizadasVeteranos criada.';
END
GO
IF COL_LENGTH('dbo.SCA_ALUNO_DISCIPLINA', 'usuario_incl') IS NULL
BEGIN
	ALTER TABLE dbo.SCA_ALUNO_DISCIPLINA ADD [usuario_incl] [varchar](150) NULL;
	PRINT 'Coluna SCA_ALUNO_DISCIPLINA.usuario_incl criada.';
END
GO
IF COL_LENGTH('dbo.SCA_ALUNO_DISCIPLINA', 'data_hora_incl') IS NULL
BEGIN
	ALTER TABLE dbo.SCA_ALUNO_DISCIPLINA ADD [data_hora_incl] [datetime] NULL CONSTRAINT [DF_SCA_ALUNO_DISCIPLINA_data_hora_incl] DEFAULT (getdate());
	PRINT 'Coluna SCA_ALUNO_DISCIPLINA.data_hora_incl criada.';
END
GO
IF COL_LENGTH('dbo.SCA_ALUNO_DISCIPLINA', 'tela') IS NULL
BEGIN
	ALTER TABLE dbo.SCA_ALUNO_DISCIPLINA ADD [tela] [varchar](150) NULL;
	PRINT 'Coluna SCA_ALUNO_DISCIPLINA.tela criada.';
END
GO
IF COL_LENGTH('dbo.SCA_SITUACAOALUNO', 'mostrar') IS NULL
BEGIN
	ALTER TABLE dbo.SCA_SITUACAOALUNO ADD [mostrar] [char](1) NULL;
	PRINT 'Coluna SCA_SITUACAOALUNO.mostrar criada.';
END
GO
IF COL_LENGTH('dbo.SCA_PERIODO', 'ident_turma') IS NULL
BEGIN
	ALTER TABLE dbo.SCA_PERIODO ADD [ident_turma] [char](1) NULL;
	PRINT 'Coluna SCA_PERIODO.ident_turma criada.';
END
GO
IF COL_LENGTH('dbo.SEG_EMPRESA', 'NOME_ABREVIADO') IS NULL
BEGIN
	ALTER TABLE dbo.SEG_EMPRESA ADD [NOME_ABREVIADO] [varchar](100) NULL;
	PRINT 'Coluna SEG_EMPRESA.NOME_ABREVIADO criada.';
END
GO
IF COL_LENGTH('dbo.CENSO_PAIS', 'id') IS NULL
BEGIN
	ALTER TABLE dbo.CENSO_PAIS ADD [id] [int] IDENTITY(1,1) NOT NULL;
	PRINT 'Coluna CENSO_PAIS.id criada.';
END
GO
IF COL_LENGTH('dbo.SCA_GRADECURRICULARDISCIPLINA', 'Omitir_Documentacao') IS NULL
BEGIN
	ALTER TABLE dbo.SCA_GRADECURRICULARDISCIPLINA ADD [Omitir_Documentacao] [char](1) NULL CONSTRAINT [DF_SCA_GRADECURRICULARDISCIPLINA_Omitir_Documentacao] DEFAULT ('N') WITH VALUES;
	PRINT 'Coluna SCA_GRADECURRICULARDISCIPLINA.Omitir_Documentacao criada.';
END
GO
IF COL_LENGTH('dbo.SCA_PLANEJAMENTO_PROFESSOR', 'desc_RegistroReflexivo') IS NULL
BEGIN
	ALTER TABLE dbo.SCA_PLANEJAMENTO_PROFESSOR ADD [desc_RegistroReflexivo] [varchar](max) NULL;
	PRINT 'Coluna SCA_PLANEJAMENTO_PROFESSOR.desc_RegistroReflexivo criada.';
END
GO
-- valores padrão das colunas novas (iguais a Anápolis)
UPDATE dbo.SCA_SITUACAOALUNO SET mostrar = 'S' WHERE mostrar IS NULL;
UPDATE dbo.SCA_SITUACAOALUNO SET mostrar = 'N' WHERE Desc_SituacaoAluno IN ('PRÉ-MATRÍCULA', 'PRE-MATRICULA', 'NÃO ALOCADO', 'NAO ALOCADO');
UPDATE dbo.SEG_EMPRESA SET NOME_ABREVIADO = LEFT(LTRIM(RTRIM(RAZAOSOCIAL)), 100) WHERE NOME_ABREVIADO IS NULL;
GO

/* ---------- 3) procedures do acadêmico ---------- */
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[SP_ListarAlunosTurma]
(
    @CodEmpresa INT,
    @CodTurma INT,
    @AnoLetivo INT,
    @Semestre INT = 3,
    @cod_situacao_aluno INT = 0,
    @incluir_remanejados BIT = 0
)
AS
BEGIN
    SET NOCOUNT ON;

    

    /*
        Seleciona somente o último registro do aluno na turma
        para o ano letivo e semestre informados.
    */
    ;WITH ALUNO_TURMA AS
    (
        SELECT
            AT.CODIGO,
            AT.COD_EMPRESA,
            AT.COD_ALUNO,
            AT.COD_TURMA,
            AT.SEQUENCIA,
            AT.ANO_LETIVO,
            AT.SEMESTRE,
            AT.SITUACAO,
            AT.DATA_SITUACAO,
            ROW_NUMBER() OVER
            (
                PARTITION BY
                    AT.ANO_LETIVO,
                    AT.COD_ALUNO,
                    AT.COD_EMPRESA
                ORDER BY AT.CODIGO DESC
            ) AS RN
        FROM SCA_ALUNO_TURMA AT
        WHERE AT.COD_EMPRESA = @CodEmpresa
          AND AT.COD_TURMA = @CodTurma
          AND AT.ANO_LETIVO = @AnoLetivo
          AND AT.SEMESTRE = @Semestre
    )
    SELECT DISTINCT
        A.CODIGO,
        A.DATANASCIMENTO,
        A.MATRICULA,
        A.NOMEALUNO,
        AT.COD_TURMA,
        GC.Cod_Periodo,
        T.NomeTurma,
        T.TURMAALUNO,

        ISNULL(ST.Desc_SituacaoAluno, 'ATIVO') AS Desc_SituacaoAluno,

        ST.data_situacao AS data_SituacaoAluno,

        ISNULL(ST.Cod_SituacaoAluno, 1) AS COD_SITUACAOALUNOATUAL,

        T.Cod_FichaDescritiva,

        CASE
            WHEN A.NOMEALUNO IS NULL
              OR A.DATANASCIMENTO IS NULL
              OR A.DATAMATRICULA IS NULL
              OR A.SEXOALUNO IS NULL
              OR A.NACIONALIDADE IS NULL
              OR A.COD_TIPONACIONALIDADE IS NULL
              OR A.COD_PROFISSAO IS NULL
              OR A.COD_ETNIA IS NULL
              OR A.MAE IS NULL
              OR (
                    A.COD_TIPONACIONALIDADE <> 3
                    AND (
                        A.CIDADENASCIMENTO IS NULL
                        OR A.UFNASCIMENTO IS NULL
                    )
                 )
            THEN A.CODIGO
        END AS pendencias,

        TC.DESCRICAO AS TIPO_CRITERIO,
        C.DESCRICAO AS CURSO,
        P.DESCRICAO AS periodo,
        P.Cod_Curso,
        T.Cod_GradeCurricular,
        T.DesvincularCriterioAvaliacao

    FROM ALUNO_TURMA AT

    INNER JOIN SCA_ALUNO A
        ON A.CODIGO = AT.COD_ALUNO

    INNER JOIN SCA_TURMA T
        ON T.Cod_Turma = AT.COD_TURMA
       AND T.AnoLetivo = AT.ANO_LETIVO
       AND T.Cod_Semestre = AT.SEMESTRE
       AND T.COD_EMPRESA = AT.COD_EMPRESA
       AND T.SITUACAO = 'A'

    INNER JOIN SCA_GRADECURRICULAR GC
        ON GC.Cod_GradeCurricular = T.Cod_GradeCurricular

    LEFT JOIN SCA_PERIODO P
        ON P.Cod_Periodo = GC.Cod_Periodo

    LEFT JOIN SCA_CURSO C
        ON C.Cod_Curso = P.Cod_Curso

    LEFT JOIN SCA_TIPO_AVALIACAO_INDIVIDUAL_ALUNO TAI
        ON TAI.COD_ALUNO = AT.COD_ALUNO
       AND TAI.ANO_LETIVO = AT.ANO_LETIVO

    LEFT JOIN SCA_TIPO_CALCULO TC
        ON TC.CODIGO = TAI.COD_TIPO_CALCULO

    OUTER APPLY
    (
        SELECT TOP 1
            SS.Desc_SituacaoAluno,
            CS.data_situacao,
            SS.Cod_SituacaoAluno
        FROM SCA_CONTROLE_SITUACAO_ALUNO CS
        INNER JOIN SCA_SITUACAOALUNO SS
            ON SS.Cod_SituacaoAluno = CS.COD_SITUACAOALUNO
        WHERE CS.COD_EMPRESA = AT.COD_EMPRESA
          AND CS.COD_ALUNO = AT.COD_ALUNO
          AND CS.ANO_LETIVO = AT.ANO_LETIVO
        ORDER BY CS.CODIGO DESC
    ) ST

    WHERE AT.RN = 1

      AND (
            AT.SITUACAO IN ('A', 'T', 'D', 'C')

            /* Remanejados desta turma (somente quando @incluir_remanejados = 1) */
            OR (
                    @incluir_remanejados = 1
                AND AT.SITUACAO = 'R'
                AND EXISTS (
                        SELECT 1
                        FROM SCA_CONTROLE_REMANEJAMENTO RML
                        WHERE RML.cod_aluno = AT.COD_ALUNO
                          AND RML.cod_empresa = AT.COD_EMPRESA
                          AND RML.ano_letivo = AT.ANO_LETIVO
                          AND RML.cod_turma_origem = AT.COD_TURMA
                          AND RML.situacao_id_aluno_turma = 'R'
                    )
               )
          )

      AND (
            @cod_situacao_aluno = 0
            OR ISNULL(ST.Cod_SituacaoAluno, 1) = @cod_situacao_aluno
          )

    ORDER BY A.NOMEALUNO;

END;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[SP_SCA_Atualizar_Notas_Transferencia]
    @CodAluno INT,
    @AnoLetivo INT,
    @CodEmpresaDestino INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @Colunas NVARCHAR(MAX);
    DECLARE @Set NVARCHAR(MAX);
    DECLARE @Condicao NVARCHAR(MAX);
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @QtdPlanilha INT = 0;
    DECLARE @QtdFaltas INT = 0;
    DECLARE @QtdTransferencias INT = 0;

    BEGIN TRY
        BEGIN TRANSACTION;

        --------------------------------------------
        -- 1. VALIDAR TRANSFERÊNCIA
        --------------------------------------------

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.SCA_ALUNO_TRANSFERENCIA
                 WITH (UPDLOCK, HOLDLOCK)
            WHERE cod_aluno = @CodAluno
              AND ANO_LETIVO = @AnoLetivo
              AND EFETIVADO = 'S'
              AND ATUALIZADO_TELA_AVALIACAO = 'N'
        )
        BEGIN
            THROW 50001,
                'Transferencia nao encontrada ou ja atualizada.',
                1;
        END;

        --------------------------------------------
        -- 2. VALIDAR EXISTÊNCIA DE NOTAS
        --------------------------------------------

        DECLARE @Validacao TABLE (
            LiberarAtualizacao BIT
        );

        INSERT INTO @Validacao
        EXEC dbo.SP_SCA_Verificar_Notas_Transferencia
            @CodAluno,
            @AnoLetivo,
            @CodEmpresaDestino;

        IF NOT EXISTS (
            SELECT 1
            FROM @Validacao
            WHERE LiberarAtualizacao = 1
        )
        BEGIN
            THROW 50002,
                'Nenhuma nota encontrada na origem.',
                1;
        END;

        --------------------------------------------
        -- 3. IDENTIFICAR COLUNAS DA PLANILHA
        --------------------------------------------

        DECLARE @Campos TABLE (
            Nome SYSNAME,
            Ordem INT
        );

        INSERT INTO @Campos
        SELECT name, column_id
        FROM sys.columns
        WHERE object_id =
              OBJECT_ID('dbo.SCA_NOTAS_PLANILHA')
          AND (
              name LIKE 'nota[0-9][0-9]'
              OR name = 'media'
          );

        IF NOT EXISTS (SELECT 1 FROM @Campos)
            THROW 50003,
                'Colunas de notas nao encontradas.',
                1;

        --------------------------------------------
        -- 4. MONTAR ORIGEM DAS NOTAS
        --------------------------------------------

        SELECT @Colunas = STUFF((
            SELECT
                ', (SELECT TOP 1 O.' +
                QUOTENAME(Nome) + '
                   FROM dbo.SCA_NOTAS_PLANILHA O
                   WHERE O.cod_aluno = D.cod_aluno
                     AND O.cod_empresa <> @Empresa
                     AND O.ano_letivo = D.ano_letivo
                     AND O.semestre = D.semestre
                     AND (
                         O.cod_periodo = D.cod_periodo
                         OR (
                             O.cod_periodo IS NULL
                             AND D.cod_periodo IS NULL
                         )
                     )
                     AND O.cod_disciplina =
                         D.cod_disciplina
                     AND O.' + QUOTENAME(Nome) + '
                         IS NOT NULL
                     AND O.' + QUOTENAME(Nome) + ' <> 0
                   ORDER BY O.cod_empresa, O.codigo
                  ) AS ' + QUOTENAME(Nome)
            FROM @Campos
            ORDER BY Ordem
            FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, '');

        --------------------------------------------
        -- 5. MONTAR SET DO UPDATE
        --------------------------------------------

        SELECT @Set = STUFF((
            SELECT
                ', D.' + QUOTENAME(Nome) + ' =
                   CASE
                     WHEN D.' + QUOTENAME(Nome) + '
                          IS NULL
                       OR D.' + QUOTENAME(Nome) + ' = 0
                     THEN COALESCE(
                         ORIG.' + QUOTENAME(Nome) + ',
                         D.' + QUOTENAME(Nome) + '
                     )
                     ELSE D.' + QUOTENAME(Nome) + '
                   END'
            FROM @Campos
            ORDER BY Ordem
            FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, '');

        --------------------------------------------
        -- 6. CONDIÇÃO DE CAMPOS VAZIOS
        --------------------------------------------

        SELECT @Condicao = STUFF((
            SELECT
                ' OR (
                    (D.' + QUOTENAME(Nome) + '
                         IS NULL
                     OR D.' + QUOTENAME(Nome) + ' = 0)
                    AND ORIG.' + QUOTENAME(Nome) + '
                        IS NOT NULL
                )'
            FROM @Campos
            ORDER BY Ordem
            FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 4, '');

        --------------------------------------------
        -- 7. ATUALIZAR SCA_NOTAS_PLANILHA
        --------------------------------------------

        SET @SQL = N'
            UPDATE D
            SET ' + @Set + '
            FROM dbo.SCA_NOTAS_PLANILHA D
            CROSS APPLY (
                SELECT ' + @Colunas + '
            ) ORIG
            WHERE D.cod_aluno = @Aluno
              AND D.ano_letivo = @Ano
              AND D.cod_empresa = @Empresa
              AND (' + @Condicao + ');

            SET @Qtd = @@ROWCOUNT;
        ';

        EXEC sp_executesql
            @SQL,
            N'@Aluno INT,
              @Ano INT,
              @Empresa INT,
              @Qtd INT OUTPUT',
            @Aluno = @CodAluno,
            @Ano = @AnoLetivo,
            @Empresa = @CodEmpresaDestino,
            @Qtd = @QtdPlanilha OUTPUT;

        --------------------------------------------
        -- 8. VALIDAR DUPLICIDADES NO DESTINO
        --------------------------------------------

        IF EXISTS (
            SELECT 1
            FROM dbo.SCA_NOTAS_FALTAS F
            INNER JOIN dbo.SCA_NOTAS_PLANILHA P
                ON P.cod_empresa = F.cod_empresa
               AND P.cod_aluno = F.cod_aluno
               AND P.ano_letivo = F.ano_letivo
               AND P.semestre = F.semestre
               AND (
                   P.cod_periodo = F.cod_periodo
                   OR (
                       P.cod_periodo IS NULL
                       AND F.cod_periodo IS NULL
                   )
               )
               AND P.cod_disciplina = F.cod_disciplina
            WHERE F.cod_empresa = @CodEmpresaDestino
              AND F.cod_aluno = @CodAluno
              AND F.ano_letivo = @AnoLetivo
            GROUP BY F.codigo
            HAVING COUNT(*) > 1
        )
        BEGIN
            THROW 50004,
                'Duplicidade na correspondencia de notas.',
                1;
        END;

        --------------------------------------------
        -- 9. ATUALIZAR SCA_NOTAS_FALTAS
        --
        -- PLANILHA.nota04 -> FALTAS.nota01
        -- PLANILHA.nota09 -> FALTAS.nota02
        --------------------------------------------

        UPDATE F
        SET
            F.nota01 = CASE
                WHEN (
                    F.nota01 IS NULL OR F.nota01 = 0
                )
                AND P.nota04 IS NOT NULL
                AND P.nota04 <> 0
                THEN P.nota04
                ELSE F.nota01
            END,

            F.nota02 = CASE
                WHEN (
                    F.nota02 IS NULL OR F.nota02 = 0
                )
                AND P.nota09 IS NOT NULL
                AND P.nota09 <> 0
                THEN P.nota09
                ELSE F.nota02
            END

        FROM dbo.SCA_NOTAS_FALTAS F
        INNER JOIN dbo.SCA_NOTAS_PLANILHA P
            ON P.cod_empresa = F.cod_empresa
           AND P.cod_aluno = F.cod_aluno
           AND P.ano_letivo = F.ano_letivo
           AND P.semestre = F.semestre
           AND (
               P.cod_periodo = F.cod_periodo
               OR (
                   P.cod_periodo IS NULL
                   AND F.cod_periodo IS NULL
               )
           )
           AND P.cod_disciplina = F.cod_disciplina

        WHERE F.cod_empresa = @CodEmpresaDestino
          AND F.cod_aluno = @CodAluno
          AND F.ano_letivo = @AnoLetivo
          AND (
              (
                  (F.nota01 IS NULL OR F.nota01 = 0)
                  AND P.nota04 IS NOT NULL
                  AND P.nota04 <> 0
              )
              OR
              (
                  (F.nota02 IS NULL OR F.nota02 = 0)
                  AND P.nota09 IS NOT NULL
                  AND P.nota09 <> 0
              )
          );

        SET @QtdFaltas = @@ROWCOUNT;

        --------------------------------------------
        -- 10. MARCAR TRANSFERÊNCIA COMO ATUALIZADA
        --------------------------------------------

        UPDATE dbo.SCA_ALUNO_TRANSFERENCIA
        SET ATUALIZADO_TELA_AVALIACAO = 'S'
        WHERE cod_aluno = @CodAluno
          AND ANO_LETIVO = @AnoLetivo
          AND EFETIVADO = 'S'
          AND ATUALIZADO_TELA_AVALIACAO = 'N';

        SET @QtdTransferencias = @@ROWCOUNT;

        IF @QtdTransferencias = 0
            THROW 50005,
                'Nao foi possivel finalizar a transferencia.',
                1;

        --------------------------------------------
        -- 11. CONFIRMAR TRANSAÇÃO
        --------------------------------------------

        COMMIT TRANSACTION;

        SELECT
            1 AS Sucesso,
            'Notas atualizadas com sucesso.' AS Mensagem,
            @QtdPlanilha AS RegistrosPlanilha,
            @QtdFaltas AS RegistrosNotasFaltas,
            @QtdTransferencias AS TransferenciasAtualizadas;

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SELECT
            0 AS Sucesso,
            ERROR_MESSAGE() AS Mensagem,
            0 AS RegistrosPlanilha,
            0 AS RegistrosNotasFaltas,
            0 AS TransferenciasAtualizadas;

    END CATCH;
END;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[SP_SCA_QuantAlunoPorPeriodoMensal]
    @grupo int, 
    @anoLetivo varchar(4), 
    @mes int,
    @curso varchar(100),
    @cod_situacao_aluno int,
    @codEmpresa int,
    @cod_turno int
as

----teste
--declare @grupo int = 1
--declare @anoLetivo varchar(4) = '2026'
--declare @mes int = 4
--declare @curso varchar(100) = 'EDUCAÇÃO INFANTIL'
--declare @cod_situacao_aluno int = 1
--declare @codEmpresa int = 0
--declare @cod_turno int = 0


SET NOCOUNT ON

declare @situacao_aluno varchar(50)

select @situacao_aluno = desc_situacaoaluno
from SCA_SITUACAOALUNO
where Cod_SituacaoAluno = @cod_situacao_aluno

---------------------------------------------------
-- ESCOLAS
---------------------------------------------------
IF OBJECT_ID('tempdb..#escolas') IS NOT NULL
    DROP TABLE #escolas

CREATE TABLE #escolas
(
    cod_escola int
)

insert #escolas
select codigo
from SEG_EMPRESA
where COD_GRUPO = @grupo
  and BLOQUEIO = 'N'
  and (@codEmpresa = 0 or codigo = @codEmpresa)

---------------------------------------------------
-- VARIÁVEIS
---------------------------------------------------
DECLARE @cols NVARCHAR(MAX),
        @colsTotal NVARCHAR(MAX),
        @colsSomaLinha NVARCHAR(MAX),
        @sql NVARCHAR(MAX)

---------------------------------------------------
-- COLUNAS DINÂMICAS DO PIVOT
---------------------------------------------------
SELECT @cols = STUFF((
    SELECT DISTINCT
           ',' + QUOTENAME(periodo)
    FROM SCA_FECHAMENTO_MENSAL_ALUNO
    WHERE cod_empresa in (select cod_escola from #escolas)
      and ano_letivo = @anoLetivo
      and mes = @mes
      and SITUACAO_ALUNO = @situacao_aluno
      and curso = @curso
    FOR XML PATH(''), TYPE
).value('.', 'NVARCHAR(MAX)'),1,1,'')

---------------------------------------------------
-- COLUNAS PARA TOTAL DA ÚLTIMA LINHA
---------------------------------------------------
SELECT @colsTotal = STUFF((
    SELECT DISTINCT
           ',SUM(ISNULL(' + QUOTENAME(periodo) + ',0)) AS ' + QUOTENAME(periodo)
    FROM SCA_FECHAMENTO_MENSAL_ALUNO
    WHERE cod_empresa in (select cod_escola from #escolas)
      and ano_letivo = @anoLetivo
      and mes = @mes
      and SITUACAO_ALUNO = @situacao_aluno
      and curso = @curso
    FOR XML PATH(''), TYPE
).value('.', 'NVARCHAR(MAX)'),1,1,'')

---------------------------------------------------
-- SOMA DAS COLUNAS (TOTAL POR LINHA)
---------------------------------------------------
SELECT @colsSomaLinha = STUFF((
    SELECT DISTINCT
           ' + ISNULL(' + QUOTENAME(periodo) + ',0)'
    FROM SCA_FECHAMENTO_MENSAL_ALUNO
    WHERE cod_empresa in (select cod_escola from #escolas)
      and ano_letivo = @anoLetivo
      and mes = @mes
      and SITUACAO_ALUNO = @situacao_aluno
      and curso = @curso
    FOR XML PATH(''), TYPE
).value('.', 'NVARCHAR(MAX)'),1,3,'')

---------------------------------------------------
-- SQL DINÂMICO
---------------------------------------------------
SET @sql = '

;WITH dados AS
(
    SELECT
        cod_empresa,
        empresa,
        ' + @cols + '
    FROM
    (
        SELECT
            COD_EMPRESA AS cod_empresa,
            EMPRESA AS empresa,
            periodo,
            QUANTITATIVO_ALUNO
        FROM SCA_FECHAMENTO_MENSAL_ALUNO
        WHERE cod_empresa in (select cod_escola from #escolas)
          and ano_letivo = @anoLetivo
          and mes = @mes
          and SITUACAO_ALUNO = @situacao_aluno
          and curso = @curso
          and (@cod_turno = 0 or cod_turno = @cod_turno)
    ) src
    PIVOT
    (
        SUM(QUANTITATIVO_ALUNO)
        FOR periodo IN (' + @cols + ')
    ) p
)

SELECT *
FROM
(
    ---------------------------------------------------
    -- DADOS
    ---------------------------------------------------
    SELECT
        0 as ordem,
        cod_empresa,
        empresa,
        ' + @cols + ',
        ' + @colsSomaLinha + ' AS TOTAL_GERAL
    FROM dados

    UNION ALL

    ---------------------------------------------------
    -- TOTAL
    ---------------------------------------------------
    SELECT
        1 as ordem,
        NULL AS cod_empresa,
        ''TOTAL'' AS empresa,
        ' + @colsTotal + ',
        SUM(' + @colsSomaLinha + ') AS TOTAL_GERAL
    FROM dados
) x

---------------------------------------------------
-- ORDENAÇÃO
---------------------------------------------------
ORDER BY
    ordem,
    empresa
'

---------------------------------------------------
-- EXECUÇÃO
---------------------------------------------------
EXEC sp_executesql
    @sql,
    N'@anoLetivo varchar(4),
      @mes int,
      @situacao_aluno varchar(50),
      @curso varchar(100),
      @cod_turno int',
    @anoLetivo,
    @mes,
    @situacao_aluno,
    @curso,
    @cod_turno
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[SP_SCA_ReplicarAulaPlanejamentoProfessorDia]
(
    @codigoPlanejamentoOrigem INT,
    @dataAulaOrigem DATE,
    @dataAulaDestino DATE,
    @usuario VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE
        @codEmpresa INT,
        @anoLetivo INT,
        @semestre INT,
        @numeroAulaOrigem INT,
        @numeroAulaDestino INT,
        @codPeriodo INT,
        @codDisciplina INT,
        @codTurno INT,
        @codTurma INT,
        @codProfessor INT,
        @codCurso INT,
        @sequenciaOrigem INT,
        @codigoNovoPlanejamento INT;

    SELECT
        @codEmpresa       = cod_empresa,
        @anoLetivo        = anoLetivo,
        @semestre         = semestre,
        @numeroAulaOrigem = numero_aula,
        @codPeriodo       = cod_periodo,
        @codDisciplina    = cod_disciplina,
        @codTurno         = cod_turno,
        @codTurma         = cod_turma,
        @codProfessor     = cod_colaborador
    FROM dbo.SCA_PLANEJAMENTO_PROFESSOR
    WHERE cod_planejamento_professor = @codigoPlanejamentoOrigem;

    IF @codEmpresa IS NULL
        THROW 50001, 'Planejamento de origem não encontrado.', 1;

    IF @numeroAulaOrigem IS NULL
        THROW 50002, 'A replicação por dia está disponível somente para aulas regulares.', 1;

    IF @dataAulaDestino IS NULL
        THROW 50003, 'Informe a data para a qual o planejamento será replicado.', 1;

    IF @dataAulaDestino <= @dataAulaOrigem
        THROW 50004, 'A data de destino deve ser posterior à data da aula de origem.', 1;

    SELECT @codCurso = COD_CURSO
    FROM dbo.SCA_PERIODO
    WHERE COD_PERIODO = @codPeriodo;

    DECLARE @Aulas TABLE
    (
        numero_aula INT NOT NULL,
        data_aula DATE NOT NULL,
        sequencia INT NOT NULL,
        PRIMARY KEY (numero_aula)
    );

    ;WITH DiasAula AS
    (
        SELECT DISTINCT
            CONVERT(DATE, DATEFROMPARTS(d.ano, d.mes, d.dia_mes)) AS data_aula,
            ha.Sequencia AS sequencia
        FROM dbo.sca_calendario_dia_ue d
        INNER JOIN dbo.sca_calendario_ue c
            ON c.cod_calendario_ue = d.cod_calendario_ue
        INNER JOIN dbo.sca_calendario_evento e
            ON e.cod_calendario_evento = d.cod_calendario_evento
        INNER JOIN dbo.SCA_HORARIO_AULA ha
            ON ha.Cod_Empresa = c.cod_empresa
           AND ha.AnoLetivo = d.ano
           AND ha.DiaSemana = d.dia_semana
           AND ha.Cod_Colaborador = @codProfessor
           AND ha.Cod_Disciplina = @codDisciplina
           AND ha.Cod_Turma = @codTurma
        INNER JOIN dbo.SCA_HORARIO h
            ON h.codigo = ha.Cod_Horario
           AND h.cod_empresa = ha.Cod_Empresa
           AND h.CodTurno = @codTurno
        WHERE c.cod_empresa = @codEmpresa
          AND c.cod_curso = @codCurso
          AND d.ano = @anoLetivo
          AND e.letivo = 'S'
    ),
    AulasNumeradas AS
    (
        SELECT
            ROW_NUMBER() OVER (ORDER BY data_aula, sequencia) AS numero_aula,
            data_aula,
            sequencia
        FROM DiasAula
    )
    INSERT INTO @Aulas (numero_aula, data_aula, sequencia)
    SELECT numero_aula, data_aula, sequencia
    FROM AulasNumeradas;

    /*
       A tela numera as aulas durante todo o ano letivo e considera a sequência
       do horário. Recuperar a sequência também permite localizar o mesmo horário
       quando houver duas ou mais aulas da disciplina na data escolhida.
    */
    SELECT @sequenciaOrigem = sequencia
    FROM @Aulas
    WHERE numero_aula = @numeroAulaOrigem
      AND data_aula = @dataAulaOrigem;

    IF @sequenciaOrigem IS NULL
        THROW 50005, 'Não foi possível relacionar a aula de origem com o calendário/horário do professor.', 1;

    SELECT @numeroAulaDestino = numero_aula
    FROM @Aulas
    WHERE data_aula = @dataAulaDestino
      AND sequencia = @sequenciaOrigem;

    IF @numeroAulaDestino IS NULL
        THROW 50006, 'A data escolhida não é um dia letivo com aula desta disciplina para a turma.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.SCA_PLANEJAMENTO_PROFESSOR
        WHERE cod_empresa = @codEmpresa
          AND anoLetivo = @anoLetivo
          AND semestre = @semestre
          AND numero_aula = @numeroAulaDestino
          AND cod_periodo = @codPeriodo
          AND cod_disciplina = @codDisciplina
          AND cod_turno = @codTurno
          AND cod_turma = @codTurma
          AND cod_colaborador = @codProfessor
    )
        THROW 50007, 'A aula selecionada já possui planejamento cadastrado.', 1;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO dbo.SCA_PLANEJAMENTO_PROFESSOR
        (
            cod_planejamento_geral, cod_empresa, anoLetivo, semestre,
            numero_aula, data_aula_extra, cod_periodo, cod_disciplina,
            cod_turno, cod_turma, cod_colaborador, desc_metodologia,
            desc_avaliacao, observacao, validado, usuario_validado,
            data_hora_validado, usuario_incl, data_hora_incl,
            desc_conteudo_complementar
        )
        SELECT
            cod_planejamento_geral, cod_empresa, anoLetivo, semestre,
            @numeroAulaDestino, NULL, cod_periodo, cod_disciplina,
            cod_turno, cod_turma, cod_colaborador, desc_metodologia,
            desc_avaliacao, observacao, validado, usuario_validado,
            data_hora_validado, @usuario, GETDATE(),
            desc_conteudo_complementar
        FROM dbo.SCA_PLANEJAMENTO_PROFESSOR
        WHERE cod_planejamento_professor = @codigoPlanejamentoOrigem;

        SET @codigoNovoPlanejamento = CONVERT(INT, SCOPE_IDENTITY());

        INSERT INTO dbo.SCA_ITEM_PLANEJAMENTO_PROFESSOR
        (
            cod_planejamento_professor, cod_item_planejamento_geral,
            cod_tipo_planejamento, descricao, complemento,
            usuario_incl, data_hora_incl
        )
        SELECT
            @codigoNovoPlanejamento, cod_item_planejamento_geral,
            cod_tipo_planejamento, descricao, complemento,
            @usuario, GETDATE()
        FROM dbo.SCA_ITEM_PLANEJAMENTO_PROFESSOR
        WHERE cod_planejamento_professor = @codigoPlanejamentoOrigem;

        IF OBJECT_ID('dbo.SCA_PLANEJAMENTO_PROFESSOR_RECURSO', 'U') IS NOT NULL
        BEGIN
            INSERT INTO dbo.SCA_PLANEJAMENTO_PROFESSOR_RECURSO
            (
                cod_planejamento_professor, tipo, descricao, nome_arquivo,
                tipo_arquivo, tamanho_arquivo, arquivo_base64, url,
                usuario_incl, data_hora_incl
            )
            SELECT
                @codigoNovoPlanejamento, tipo, descricao, nome_arquivo,
                tipo_arquivo, tamanho_arquivo, arquivo_base64, url,
                @usuario, GETDATE()
            FROM dbo.SCA_PLANEJAMENTO_PROFESSOR_RECURSO
            WHERE cod_planejamento_professor = @codigoPlanejamentoOrigem;
        END;

        COMMIT TRANSACTION;

        SELECT
            @numeroAulaDestino AS numero_aula_destino,
            @dataAulaDestino AS data_aula_destino,
            @codigoNovoPlanejamento AS codigo_planejamento_destino,
            1 AS aulas_replicadas;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[SP_SCA_ReplicarAulaPlanejamentoProfessorSemana]
(
    @codigoPlanejamentoOrigem INT,
    @dataAulaOrigem DATE,
    @usuario VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE
        @codEmpresa INT,
        @anoLetivo INT,
        @semestre INT,
        @numeroAulaOrigem INT,
        @codPeriodo INT,
        @codDisciplina INT,
        @codTurno INT,
        @codTurma INT,
        @codProfessor INT,
        @codCurso INT,
        @dataFimSemana DATE,
        @numeroAulaDestino INT,
        @dataAulaDestino DATE,
        @codigoNovoPlanejamento INT,
        @qtdeEncontradas INT = 0,
        @qtdeReplicadas INT = 0,
        @qtdeIgnoradas INT = 0;

    SELECT
        @codEmpresa       = cod_empresa,
        @anoLetivo        = anoLetivo,
        @semestre         = semestre,
        @numeroAulaOrigem = numero_aula,
        @codPeriodo       = cod_periodo,
        @codDisciplina    = cod_disciplina,
        @codTurno         = cod_turno,
        @codTurma         = cod_turma,
        @codProfessor     = cod_colaborador
    FROM dbo.SCA_PLANEJAMENTO_PROFESSOR
    WHERE cod_planejamento_professor = @codigoPlanejamentoOrigem;

    IF @codEmpresa IS NULL
        THROW 50001, 'Planejamento de origem não encontrado.', 1;

    IF @numeroAulaOrigem IS NULL
        THROW 50002, 'A replicação semanal está disponível somente para aulas regulares.', 1;

    SELECT @codCurso = COD_CURSO
    FROM dbo.SCA_PERIODO
    WHERE COD_PERIODO = @codPeriodo;

    /*
       1900-01-01 foi uma segunda-feira.
       Índice da semana: segunda=0 ... domingo=6.
       O fim utilizado aqui é sexta-feira (índice 4).
    */
    DECLARE @indiceDiaSemana INT;
    SET @indiceDiaSemana = ((DATEDIFF(DAY, '19000101', @dataAulaOrigem) % 7) + 7) % 7;

    IF @indiceDiaSemana >= 4
        SET @dataFimSemana = @dataAulaOrigem;
    ELSE
        SET @dataFimSemana = DATEADD(DAY, 4 - @indiceDiaSemana, @dataAulaOrigem);

    DECLARE @Aulas TABLE
    (
        numero_aula INT NOT NULL,
        data_aula DATE NOT NULL PRIMARY KEY
    );

    ;WITH DiasAula AS
    (
        SELECT DISTINCT
            CONVERT(DATE, DATEFROMPARTS(d.ano, d.mes, d.dia_mes)) AS data_aula
        FROM dbo.sca_calendario_dia_ue d
        INNER JOIN dbo.sca_calendario_ue c
            ON c.cod_calendario_ue = d.cod_calendario_ue
        INNER JOIN dbo.sca_calendario_evento e
            ON e.cod_calendario_evento = d.cod_calendario_evento
        WHERE c.cod_empresa = @codEmpresa
          AND c.cod_curso = @codCurso
          AND d.ano = @anoLetivo
          AND e.letivo = 'S'
          AND EXISTS
          (
              SELECT 1
              FROM dbo.SCA_HORARIO_AULA ha
              INNER JOIN dbo.SCA_HORARIO h
                  ON h.codigo = ha.Cod_Horario
                 AND h.cod_empresa = ha.Cod_Empresa
              WHERE ha.Cod_Empresa = @codEmpresa
                AND ha.AnoLetivo = @anoLetivo
                AND ha.Semestre = @semestre
                AND ha.Cod_Colaborador = @codProfessor
                AND ha.Cod_Disciplina = @codDisciplina
                AND ha.Cod_Turma = @codTurma
                AND ha.DiaSemana = d.dia_semana
                AND h.CodTurno = @codTurno
          )
    ),
    AulasNumeradas AS
    (
        SELECT
            ROW_NUMBER() OVER (ORDER BY data_aula) AS numero_aula,
            data_aula
        FROM DiasAula
    )
    INSERT INTO @Aulas (numero_aula, data_aula)
    SELECT numero_aula, data_aula
    FROM AulasNumeradas;

    /*
       Validação de segurança: a data informada deve corresponder ao número da aula
       que está gravado no planejamento de origem.
    */
    IF NOT EXISTS
    (
        SELECT 1
        FROM @Aulas
        WHERE numero_aula = @numeroAulaOrigem
          AND data_aula = @dataAulaOrigem
    )
    BEGIN
        THROW 50003, 'Não foi possível relacionar a aula de origem com o calendário/horário do professor.', 1;
    END;

    DECLARE cursorAulas CURSOR LOCAL FAST_FORWARD FOR
        SELECT numero_aula, data_aula
        FROM @Aulas
        WHERE data_aula > @dataAulaOrigem
          AND data_aula <= @dataFimSemana
        ORDER BY data_aula;

    BEGIN TRY
        BEGIN TRANSACTION;

        OPEN cursorAulas;
        FETCH NEXT FROM cursorAulas INTO @numeroAulaDestino, @dataAulaDestino;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @qtdeEncontradas = @qtdeEncontradas + 1;

            IF EXISTS
            (
                SELECT 1
                FROM dbo.SCA_PLANEJAMENTO_PROFESSOR
                WHERE cod_empresa = @codEmpresa
                  AND anoLetivo = @anoLetivo
                  AND semestre = @semestre
                  AND numero_aula = @numeroAulaDestino
                  AND cod_periodo = @codPeriodo
                  AND cod_disciplina = @codDisciplina
                  AND cod_turno = @codTurno
                  AND cod_turma = @codTurma
                  AND cod_colaborador = @codProfessor
            )
            BEGIN
                SET @qtdeIgnoradas = @qtdeIgnoradas + 1;
            END
            ELSE
            BEGIN
                INSERT INTO dbo.SCA_PLANEJAMENTO_PROFESSOR
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
                SELECT
                    cod_planejamento_geral,
                    cod_empresa,
                    anoLetivo,
                    semestre,
                    @numeroAulaDestino,
                    NULL,
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
                    @usuario,
                    GETDATE(),
                    desc_conteudo_complementar
                FROM dbo.SCA_PLANEJAMENTO_PROFESSOR
                WHERE cod_planejamento_professor = @codigoPlanejamentoOrigem;

                SET @codigoNovoPlanejamento = CONVERT(INT, SCOPE_IDENTITY());

                INSERT INTO dbo.SCA_ITEM_PLANEJAMENTO_PROFESSOR
                (
                    cod_planejamento_professor,
                    cod_item_planejamento_geral,
                    cod_tipo_planejamento,
                    descricao,
                    complemento,
                    usuario_incl,
                    data_hora_incl
                )
                SELECT
                    @codigoNovoPlanejamento,
                    cod_item_planejamento_geral,
                    cod_tipo_planejamento,
                    descricao,
                    complemento,
                    @usuario,
                    GETDATE()
                FROM dbo.SCA_ITEM_PLANEJAMENTO_PROFESSOR
                WHERE cod_planejamento_professor = @codigoPlanejamentoOrigem;

                /* Materiais de apoio: arquivos Base64 e links. */
                IF OBJECT_ID('dbo.SCA_PLANEJAMENTO_PROFESSOR_RECURSO', 'U') IS NOT NULL
                BEGIN
                    INSERT INTO dbo.SCA_PLANEJAMENTO_PROFESSOR_RECURSO
                    (
                        cod_planejamento_professor,
                        tipo,
                        descricao,
                        nome_arquivo,
                        tipo_arquivo,
                        tamanho_arquivo,
                        arquivo_base64,
                        url,
                        usuario_incl,
                        data_hora_incl
                    )
                    SELECT
                        @codigoNovoPlanejamento,
                        tipo,
                        descricao,
                        nome_arquivo,
                        tipo_arquivo,
                        tamanho_arquivo,
                        arquivo_base64,
                        url,
                        @usuario,
                        GETDATE()
                    FROM dbo.SCA_PLANEJAMENTO_PROFESSOR_RECURSO
                    WHERE cod_planejamento_professor = @codigoPlanejamentoOrigem;
                END;

                SET @qtdeReplicadas = @qtdeReplicadas + 1;
            END;

            FETCH NEXT FROM cursorAulas INTO @numeroAulaDestino, @dataAulaDestino;
        END;

        CLOSE cursorAulas;
        DEALLOCATE cursorAulas;

        COMMIT TRANSACTION;

        SELECT
            @qtdeEncontradas AS aulas_encontradas,
            @qtdeReplicadas AS aulas_replicadas,
            @qtdeIgnoradas AS aulas_ignoradas;

    END TRY
    BEGIN CATCH
        IF CURSOR_STATUS('local', 'cursorAulas') >= 0
            CLOSE cursorAulas;

        IF CURSOR_STATUS('local', 'cursorAulas') >= -1
            DEALLOCATE cursorAulas;

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[SP_SCA_Verificar_Notas_Transferencia]
    @CodAluno INT,
    @AnoLetivo INT,
    @CodEmpresaDestino INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Liberar BIT = 0;

    IF EXISTS (
        SELECT 1
        FROM dbo.SCA_ALUNO_TRANSFERENCIA T
        WHERE T.cod_aluno = @CodAluno
          AND T.ANO_LETIVO = @AnoLetivo
          AND T.EFETIVADO = 'S'
          AND T.ATUALIZADO_TELA_AVALIACAO = 'N'
          and t.COD_EMPRESA_TRANSFERENCIA=@CodEmpresaDestino
    )
    AND (
        EXISTS (
            SELECT 1
            FROM dbo.SCA_NOTAS_PLANILHA P
            CROSS APPLY (
                VALUES
                    (P.nota01), (P.nota02), (P.nota03),
                    (P.nota04), (P.nota05), (P.nota06),
                    (P.nota07), (P.nota08), (P.nota09),
                    (P.nota10), (P.nota11), (P.nota12),
                    (P.nota13), (P.nota14), (P.nota15),
                    (P.nota16), (P.nota17), (P.nota18),
                    (P.nota19), (P.nota20), (P.nota21),
                    (P.nota22), (P.nota23), (P.nota24),
                    (P.nota25), (P.nota26), (P.nota27),
                    (P.nota28), (P.nota29), (P.nota30)
            ) N(Nota)
            WHERE P.cod_aluno = @CodAluno
              AND P.ano_letivo = @AnoLetivo
              AND P.cod_empresa <> @CodEmpresaDestino
              AND N.Nota IS NOT NULL
              AND N.Nota <> 0
        )
        OR EXISTS (
            SELECT 1
            FROM dbo.SCA_NOTAS_FALTAS F
            CROSS APPLY (
                VALUES
                    (F.nota01), (F.nota02), (F.nota03),
                    (F.nota04), (F.nota05), (F.nota06),
                    (F.nota07), (F.nota08), (F.nota09),
                    (F.nota10), (F.nota11), (F.nota12),
                    (F.nota13), (F.nota14), (F.nota15)
            ) N(Nota)
            WHERE F.cod_aluno = @CodAluno
              AND F.ano_letivo = @AnoLetivo
              AND F.cod_empresa <> @CodEmpresaDestino
              AND N.Nota IS NOT NULL
              AND N.Nota <> 0
        )
    )
    BEGIN
        SET @Liberar = 1;
    END;

    SELECT @Liberar AS LiberarAtualizacao;
END;
GO

SET NOEXEC OFF;
GO
PRINT 'Fase 1 do acadêmico concluída.';
GO
