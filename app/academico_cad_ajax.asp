<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
    <ol class="breadcrumb page-breadcrumb">
        <li class="breadcrumb-item"><a href="javascript:void(0);"><%=sistema%></a></li>
        <li class="breadcrumb-item"><%=modulo%></li>
        <li class="breadcrumb-item active"><%=pagina%></li>
        <li class="position-absolute pos-top pos-right d-none d-sm-block"><%=session("data_hoje")%></li>
    </ol>

    <div class="subheader">
        <h1 class="subheader-title">
            <i class='subheader-icon fal fa-edit'></i> <%=pagina%>
            <small>
                <%=descricao_pagina%>
            </small>
        </h1>
    </div>

    <div class="row">
        <div class="col-xl-12">

            <!-- =============================================================== -->
            <!-- ALERTA DE FREQUÊNCIA - carregamento assíncrono                  -->
            <!-- A página NÃO consulta os alunos no carregamento inicial.        -->
            <!-- =============================================================== -->
            <div class="panel" id="panelAlertaFrequencia">

                <div class="panel-hdr"
                     id="cabecalhoAlertaFrequencia"
                     style="cursor:pointer;"
                     title="Clique para visualizar os alunos">

                    <h2>
                        <i class="fal fa-exclamation-triangle mr-2"></i>
                        Alerta de faltas
                    </h2>

                    <div class="panel-toolbar">

                        <span id="carregandoResumoFrequencia"
                              class="text-muted mr-3">
                            <i class="fal fa-spinner fa-spin mr-1"></i>
                            Verificando alertas...
                        </span>

                        <span id="badgeTotalFrequencia"
                              class="badge badge-warning p-2 mr-3"
                              style="display:none;">
                            <i class="fal fa-exclamation-circle mr-1"></i>
                            <span id="qtdTotalFrequencia">0</span>
                            aluno(s) com alerta
                        </span>

                        <i id="iconeAlertaFrequencia"
                           class="fal fa-chevron-down"></i>

                    </div>
                </div>

                <!--
                    IMPORTANTE:
                    O conteúdo abaixo começa fechado e vazio.
                    A consulta detalhada só é executada após o primeiro clique.
                -->
                <div id="conteudoAlertaFrequencia"
                     style="display:none;">

                    <div class="panel-content">

                        <div id="loadingDetalhesFrequencia"
                             class="text-center p-4"
                             style="display:none;">
                            <i class="fal fa-spinner fa-spin fa-2x"></i>
                            <div class="mt-2">
                                Consultando alunos com alerta de faltas...
                            </div>
                        </div>

                        <div id="resultadoDetalhesFrequencia"></div>

                    </div>
                </div>

            </div>

        </div>
    </div>

</main>

<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>

<script type="text/javascript">
    var detalhesFrequenciaCarregados = false;
    var detalhesFrequenciaCarregando = false;

    /*
     * O resumo é carregado via AJAX após a página já estar pronta.
     * Dessa forma a entrada do módulo não fica bloqueada pela consulta.
     */
    function carregarResumoAlertaFrequencia() {

        $.ajax({
            url: "academico_alerta_faltas_ajax.asp",
            type: "GET",
            dataType: "json",
            cache: false,
            data: {
                acao: "resumo",
                _: new Date().getTime()
            },
            success: function (retorno) {

                $("#carregandoResumoFrequencia").hide();

                var vermelho = parseInt(retorno.vermelho || 0);
                var amarelo = parseInt(retorno.amarelo || 0);

                var total = vermelho + amarelo;

                $("#qtdTotalFrequencia").text(total);
                $("#badgeTotalFrequencia").show();

                if (total === 0) {
                    $("#cabecalhoAlertaFrequencia")
                        .attr("title", "Nenhum aluno com alerta de frequência");
                } else {
                    $("#cabecalhoAlertaFrequencia")
                        .attr(
                            "title",
                            vermelho + " vermelho(s) e " +
                            amarelo + " amarelo(s). Clique para visualizar."
                        );
                }
            },
            error: function () {

                $("#carregandoResumoFrequencia")
                    .removeClass("text-muted")
                    .addClass("text-danger")
                    .html(
                        '<i class="fal fa-exclamation-circle mr-1"></i>' +
                        'Não foi possível consultar os quantitativos.'
                    );
            }
        });
    }

    /*
     * Só chama o banco para buscar os ALUNOS no primeiro clique.
     * Nos cliques seguintes apenas abre/fecha o conteúdo já carregado.
     */
    function alternarDetalhesAlertaFrequencia() {

        var $conteudo = $("#conteudoAlertaFrequencia");
        var $icone = $("#iconeAlertaFrequencia");

        if ($conteudo.is(":visible")) {
            $conteudo.slideUp(150);
            $icone.removeClass("fa-chevron-up").addClass("fa-chevron-down");
            return;
        }

        $conteudo.slideDown(150);
        $icone.removeClass("fa-chevron-down").addClass("fa-chevron-up");

        if (detalhesFrequenciaCarregados || detalhesFrequenciaCarregando) {
            return;
        }

        detalhesFrequenciaCarregando = true;

        $("#loadingDetalhesFrequencia").show();
        $("#resultadoDetalhesFrequencia").html("");

        $.ajax({
            url: "academico_alerta_faltas_ajax.asp",
            type: "GET",
            dataType: "html",
            cache: false,
            data: {
                acao: "detalhes",
                _: new Date().getTime()
            },
            success: function (html) {

                $("#resultadoDetalhesFrequencia").html(html);

                detalhesFrequenciaCarregados = true;
                detalhesFrequenciaCarregando = false;

                $("#loadingDetalhesFrequencia").hide();
            },
            error: function () {

                detalhesFrequenciaCarregando = false;

                $("#loadingDetalhesFrequencia").hide();

                $("#resultadoDetalhesFrequencia").html(
                    '<div class="alert alert-danger mb-0">' +
                    '<i class="fal fa-exclamation-circle mr-2"></i>' +
                    'Não foi possível carregar os alunos com alerta de frequência.' +
                    '</div>'
                );
            }
        });
    }

    /*
     * IMPORTANTE:
     * academico_cad.asp é incluído antes de vendors.bundle.js no academico.asp.
     * Portanto, neste ponto o jQuery ainda não existe.
     *
     * Usamos o evento nativo "load", que será executado somente depois que
     * todos os scripts do academico.asp (inclusive jQuery) forem carregados.
     */
    window.addEventListener("load", function () {

        if (typeof window.jQuery === "undefined") {
            document.getElementById("carregandoResumoFrequencia").innerHTML =
                '<span class="text-danger">' +
                '<i class="fal fa-exclamation-circle mr-1"></i>' +
                'Não foi possível inicializar o alerta.' +
                '</span>';
            return;
        }

        carregarResumoAlertaFrequencia();

        $("#cabecalhoAlertaFrequencia").on("click", function () {
            alternarDetalhesAlertaFrequencia();
        });

    });
</script>
