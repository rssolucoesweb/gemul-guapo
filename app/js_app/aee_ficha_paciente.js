(function () {
    "use strict";

    /*
     * =========================================================
     * FUNÇÕES AUXILIARES
     * =========================================================
     */

    function trimTexto(texto) {
        return (texto || "").replace(/^\s+|\s+$/g, "");
    }

    function valor(id) {
        var el = document.getElementById(id);

        return el
            ? trimTexto(el.value || "")
            : "";
    }

    function mostrar(id, mostrarElemento) {
        var el = document.getElementById(id);

        if (el) {
            el.style.display =
                mostrarElemento
                    ? ""
                    : "none";
        }
    }

    function somenteNumeros(texto) {
        return (texto || "").replace(/\D/g, "");
    }

    function obterCamposPorNome(nome) {
        return document.querySelectorAll(
            '[name="' + nome + '"]'
        );
    }


    /*
     * =========================================================
     * DATA
     * =========================================================
     */

    function mascararData(campo) {

        var numeros =
            somenteNumeros(
                campo.value
            ).substring(0, 8);

        if (
            numeros.length <= 2
        ) {

            campo.value =
                numeros;

        } else if (
            numeros.length <= 4
        ) {

            campo.value =
                numeros.substring(0, 2) +
                "/" +
                numeros.substring(2);

        } else {

            campo.value =
                numeros.substring(0, 2) +
                "/" +
                numeros.substring(2, 4) +
                "/" +
                numeros.substring(4, 8);
        }
    }


    function dataValida(valorData) {

        if (
            !/^\d{2}\/\d{2}\/\d{4}$/.test(
                valorData
            )
        ) {
            return false;
        }

        var partes =
            valorData.split("/");

        var dia =
            parseInt(
                partes[0],
                10
            );

        var mes =
            parseInt(
                partes[1],
                10
            );

        var ano =
            parseInt(
                partes[2],
                10
            );

        if (
            ano < 1900 ||
            mes < 1 ||
            mes > 12 ||
            dia < 1 ||
            dia > 31
        ) {
            return false;
        }

        var data =
            new Date(
                ano,
                mes - 1,
                dia
            );

        return (
            data.getFullYear() === ano &&
            data.getMonth() === mes - 1 &&
            data.getDate() === dia
        );
    }


    function validarCampoData(
        campo,
        mensagem
    ) {

        var data =
            trimTexto(
                campo.value
            );

        if (
            data === ""
        ) {
            return true;
        }

        if (
            !dataValida(data)
        ) {

            alert(
                mensagem ||
                "Data inválida. Informe uma data real no formato dd/mm/aaaa."
            );

            setTimeout(
                function () {

                    campo.focus();

                    if (
                        campo.select
                    ) {
                        campo.select();
                    }

                },
                100
            );

            return false;
        }

        return true;
    }


    /*
     * =========================================================
     * CPF
     * =========================================================
     */

    function mascararCPF(campo) {

        var cpf =
            somenteNumeros(
                campo.value
            ).substring(0, 11);

        if (
            cpf.length <= 3
        ) {

            campo.value =
                cpf;

        } else if (
            cpf.length <= 6
        ) {

            campo.value =
                cpf.substring(0, 3) +
                "." +
                cpf.substring(3);

        } else if (
            cpf.length <= 9
        ) {

            campo.value =
                cpf.substring(0, 3) +
                "." +
                cpf.substring(3, 6) +
                "." +
                cpf.substring(6);

        } else {

            campo.value =
                cpf.substring(0, 3) +
                "." +
                cpf.substring(3, 6) +
                "." +
                cpf.substring(6, 9) +
                "-" +
                cpf.substring(9, 11);
        }
    }


    function cpfValido(valorCPF) {

        var cpf =
            somenteNumeros(
                valorCPF
            );

        /*
         * CPF precisa possuir
         * exatamente 11 dígitos.
         */
        if (
            cpf.length !== 11
        ) {
            return false;
        }

        /*
         * Rejeita sequências iguais:
         *
         * 00000000000
         * 11111111111
         * etc.
         */
        if (
            /^(\d)\1{10}$/.test(cpf)
        ) {
            return false;
        }

        /*
         * Alguns números utilizados
         * como CPF de teste conseguem
         * passar matematicamente pela
         * validação dos dígitos.
         */
        var cpfsInvalidos = [
            "01234567890",
            "12345678909",
            "98765432100"
        ];

        var x;

        for (
            x = 0;
            x < cpfsInvalidos.length;
            x++
        ) {

            if (
                cpf ===
                cpfsInvalidos[x]
            ) {
                return false;
            }
        }

        /*
         * Primeiro dígito verificador.
         */
        var soma = 0;
        var i;

        for (
            i = 0;
            i < 9;
            i++
        ) {

            soma +=
                parseInt(
                    cpf.charAt(i),
                    10
                ) *
                (10 - i);
        }

        var resto =
            soma % 11;

        var digito1;

        if (
            resto < 2
        ) {

            digito1 = 0;

        } else {

            digito1 =
                11 - resto;
        }

        if (
            digito1 !==
            parseInt(
                cpf.charAt(9),
                10
            )
        ) {
            return false;
        }

        /*
         * Segundo dígito verificador.
         */
        soma = 0;

        for (
            i = 0;
            i < 10;
            i++
        ) {

            soma +=
                parseInt(
                    cpf.charAt(i),
                    10
                ) *
                (11 - i);
        }

        resto =
            soma % 11;

        var digito2;

        if (
            resto < 2
        ) {

            digito2 = 0;

        } else {

            digito2 =
                11 - resto;
        }

        if (
            digito2 !==
            parseInt(
                cpf.charAt(10),
                10
            )
        ) {
            return false;
        }

        return true;
    }


    function validarCampoCPF(
        campo,
        mensagem
    ) {

        var cpf =
            trimTexto(
                campo.value
            );

        if (
            cpf === ""
        ) {
            return true;
        }

        if (
            !cpfValido(cpf)
        ) {

            alert(
                mensagem ||
                "CPF inválido. Verifique o número informado."
            );

            setTimeout(
                function () {

                    campo.focus();

                    if (
                        campo.select
                    ) {
                        campo.select();
                    }

                },
                100
            );

            return false;
        }

        mascararCPF(campo);

        return true;
    }


    /*
     * =========================================================
     * CONFIGURAÇÃO DAS MÁSCARAS
     * =========================================================
     */

    function configurarCampoData(
        nomeCampo
    ) {

        var campos =
            obterCamposPorNome(
                nomeCampo
            );

        var i;

        for (
            i = 0;
            i < campos.length;
            i++
        ) {

            (function (campo) {

                campo.setAttribute(
                    "maxlength",
                    "10"
                );

                campo.setAttribute(
                    "inputmode",
                    "numeric"
                );

                /*
                 * Apenas aplica a máscara.
                 *
                 * NÃO valida no blur.
                 *
                 * Isso evita o loop
                 * de alert / focus.
                 */
                campo.addEventListener(
                    "input",
                    function () {

                        mascararData(
                            campo
                        );
                    }
                );

            })(campos[i]);
        }
    }


    function configurarCampoCPF(
        nomeCampo
    ) {

        var campos =
            obterCamposPorNome(
                nomeCampo
            );

        var i;

        for (
            i = 0;
            i < campos.length;
            i++
        ) {

            (function (campo) {

                campo.setAttribute(
                    "maxlength",
                    "14"
                );

                campo.setAttribute(
                    "inputmode",
                    "numeric"
                );

                /*
                 * Apenas máscara.
                 *
                 * Validação será feita
                 * somente ao salvar.
                 */
                campo.addEventListener(
                    "input",
                    function () {

                        mascararCPF(
                            campo
                        );
                    }
                );

            })(campos[i]);
        }
    }


    function configurarMascarasEValidacoes() {

        var camposData = [
            "txtDataNascimento",
            "txtDatamatricula",
            "txtPaidatanascimento",
            "txtMaedatanascimento",
            "txtResponsaveldatanascimento",
            "txtDataAfastamento"
        ];

        var i;

        for (
            i = 0;
            i < camposData.length;
            i++
        ) {

            configurarCampoData(
                camposData[i]
            );
        }

        var camposCPF = [
            "txtcpf",
            "txtCPFResponsavel"
        ];

        for (
            i = 0;
            i < camposCPF.length;
            i++
        ) {

            configurarCampoCPF(
                camposCPF[i]
            );
        }
    }


    /*
     * =========================================================
     * BLOQUEAR / LIBERAR CAMPOS
     * =========================================================
     */

    function bloquearOuLiberarBloco(
        seletor,
        bloquear
    ) {

        var bloco =
            document.querySelector(
                seletor
            );

        if (
            !bloco
        ) {
            return;
        }

        /*
         * Alguns includes do GEMUL
         * colocam os SELECTs dentro
         * de FIELDSET disabled.
         *
         * Precisamos liberar também
         * o próprio FIELDSET.
         */
        var fieldsets =
            bloco.querySelectorAll(
                "fieldset"
            );

        var i;

        for (
            i = 0;
            i < fieldsets.length;
            i++
        ) {

            fieldsets[i].disabled =
                bloquear;
        }

        var campos =
            bloco.querySelectorAll(
                "input, select, textarea"
            );

        for (
            i = 0;
            i < campos.length;
            i++
        ) {

            var campo =
                campos[i];

            /*
             * Hidden não precisa ser alterado.
             */
            if (
                campo.type === "hidden"
            ) {
                continue;
            }

            /*
             * Arquivo da foto será tratado
             * separadamente.
             */
            if (
                campo.id ===
                "txtFotoPaciente"
            ) {
                continue;
            }

            if (
                campo.tagName === "SELECT" ||
                campo.type === "checkbox" ||
                campo.type === "radio" ||
                campo.type === "file"
            ) {

                campo.disabled =
                    bloquear;

            } else {

                campo.readOnly =
                    bloquear;
            }
        }
    }


    /*
     * =========================================================
     * FOTO DO PACIENTE EXTERNO
     * =========================================================
     */

    function configurarFotoPaciente(
        tipo
    ) {

        var externo =
            (
                tipo === "E"
            );

        /*
         * Mostra o botão de selecionar
         * foto apenas para paciente externo.
         */
        mostrar(
            "blocoFotoPacienteExterno",
            externo
        );

        var campoFoto =
            document.getElementById(
                "txtFotoPaciente"
            );

        if (
            campoFoto
        ) {

            campoFoto.disabled =
                !externo;
        }
    }


    /*
     * =========================================================
     * OBJETO PRINCIPAL
     * =========================================================
     */

    window.AEEFichaPaciente = {


        /*
         * =====================================================
         * ALTERAÇÃO DO TIPO DE PACIENTE
         * =====================================================
         */

        trocarTipo: function (
            tipo
        ) {

            var hidden =
                document.getElementById(
                    "txtTipoPaciente"
                );

            if (
                hidden
            ) {

                hidden.value =
                    tipo;
            }


            /*
             * Localização de aluno da rede.
             */
            mostrar(
                "bloco-localizar-rede",
                tipo === "R"
            );


            /*
             * Avisos.
             */
            mostrar(
                "aviso-paciente-rede",
                tipo === "R"
            );

            mostrar(
                "aviso-paciente-externo",
                tipo === "E"
            );


            /*
             * Foto.
             */
            configurarFotoPaciente(
                tipo
            );


            /*
             * Aluno da rede:
             * campos apenas para consulta.
             *
             * Paciente externo:
             * campos editáveis.
             */
            var somenteLeitura =
                (
                    tipo === "R"
                );


            var blocos = [
                "#card_dados_pessoais",
                "#endereco",
                "#familia",
                "#responsavel",
                "#adicionais"
            ];


            var i;

            for (
                i = 0;
                i < blocos.length;
                i++
            ) {

                bloquearOuLiberarBloco(
                    blocos[i],
                    somenteLeitura
                );
            }


            /*
             * =================================================
             * NECESSIDADES ESPECIAIS
             * =================================================
             *
             * Aluno da Rede:
             * somente leitura.
             *
             * Paciente Externo:
             * permite marcar/desmarcar.
             */

            var blocoNecessidades =
                document.getElementById(
                    "card_necessidades"
                );

            if (
                blocoNecessidades
            ) {

                var necessidades =
                    blocoNecessidades
                        .querySelectorAll(
                            'input[name="chkNecessidade"]'
                        );

                for (
                    i = 0;
                    i < necessidades.length;
                    i++
                ) {

                    necessidades[i].disabled =
                        somenteLeitura;
                }
            }


            /*
             * Coloca o foco no nome
             * quando for paciente externo.
             */
            if (
                !somenteLeitura
            ) {

                var nome =
                    document.getElementById(
                        "txtNomealuno"
                    );

                if (
                    nome
                ) {

                    setTimeout(
                        function () {
                            nome.focus();
                        },
                        100
                    );
                }
            }
        },


        /*
         * =====================================================
         * VISUALIZAR FOTO
         * =====================================================
         */

        visualizarFoto: function (
            input
        ) {

            if (
                !input ||
                !input.files ||
                input.files.length === 0
            ) {
                return;
            }


            var arquivo =
                input.files[0];


            /*
             * Apenas JPG / JPEG / PNG.
             */
            var tipoValido =
                (
                    arquivo.type ===
                    "image/jpeg"
                ) ||
                (
                    arquivo.type ===
                    "image/png"
                );


            if (
                !tipoValido
            ) {

                alert(
                    "Selecione uma imagem no formato JPG ou PNG."
                );

                input.value =
                    "";

                return;
            }


            /*
             * Limite de 5 MB.
             */
            var tamanhoMaximo =
                5 *
                1024 *
                1024;


            if (
                arquivo.size >
                tamanhoMaximo
            ) {

                alert(
                    "A imagem deve possuir no máximo 5 MB."
                );

                input.value =
                    "";

                return;
            }


            /*
             * Pré-visualização da foto.
             */
            var reader =
                new FileReader();


            reader.onload =
                function (e) {

                    var img =
                        document.getElementById(
                            "imgFotoPaciente"
                        );


                    if (
                        img
                    ) {

                        img.src =
                            e.target.result;
                    }
                };


            reader.onerror =
                function () {

                    alert(
                        "Não foi possível carregar a imagem selecionada."
                    );

                    input.value =
                        "";
                };


            reader.readAsDataURL(
                arquivo
            );
        },


        /*
         * =====================================================
         * VALIDAÇÃO DO FORMULÁRIO
         * =====================================================
         */

        validar: function () {

            var tipo =
                valor(
                    "txtTipoPaciente"
                );


            /*
             * Tipo paciente.
             */
            if (
                tipo !== "R" &&
                tipo !== "E"
            ) {

                alert(
                    "Selecione o tipo de paciente."
                );

                return false;
            }


            /*
             * =================================================
             * ALUNO DA REDE
             * =================================================
             */

            if (
                tipo === "R"
            ) {

                if (
                    valor(
                        "txtCodAluno"
                    ) === ""
                ) {

                    alert(
                        "Localize um aluno da rede antes de salvar a ficha."
                    );

                    return false;
                }

                return true;
            }


            /*
             * =================================================
             * PACIENTE EXTERNO
             * =================================================
             */


            /*
             * Nome.
             */
            var nome =
                document.getElementById(
                    "txtNomealuno"
                );


            if (
                !nome ||
                trimTexto(
                    nome.value
                ) === ""
            ) {

                alert(
                    "Informe o nome completo do paciente."
                );


                if (
                    nome
                ) {

                    nome.focus();
                }

                return false;
            }


            /*
             * Data de nascimento.
             */
            var dataNascimento =
                document.getElementById(
                    "txtDataNascimento"
                );


            if (
                !dataNascimento ||
                trimTexto(
                    dataNascimento.value
                ) === ""
            ) {

                alert(
                    "Informe a data de nascimento do paciente."
                );


                if (
                    dataNascimento
                ) {

                    dataNascimento.focus();
                }

                return false;
            }


            if (
                !validarCampoData(
                    dataNascimento,
                    "Data de nascimento inválida. Informe uma data real no formato dd/mm/aaaa."
                )
            ) {

                return false;
            }


            /*
             * Data de matrícula.
             */
            var dataMatricula =
                document.getElementById(
                    "txtDatamatricula"
                );


            if (
                !dataMatricula ||
                trimTexto(
                    dataMatricula.value
                ) === ""
            ) {

                alert(
                    "Informe a data de matrícula do paciente."
                );


                if (
                    dataMatricula
                ) {

                    dataMatricula.focus();
                }

                return false;
            }


            if (
                !validarCampoData(
                    dataMatricula,
                    "Data de matrícula inválida. Informe uma data real no formato dd/mm/aaaa."
                )
            ) {

                return false;
            }


            /*
             * CPF do paciente.
             *
             * Não é obrigatório.
             *
             * Mas se informado,
             * precisa ser válido.
             */
            var cpf =
                document.getElementById(
                    "txtcpf"
                );


            if (
                cpf &&
                trimTexto(
                    cpf.value
                ) !== ""
            ) {

                if (
                    !validarCampoCPF(
                        cpf,
                        "CPF do paciente inválido. Verifique o número informado."
                    )
                ) {

                    return false;
                }
            }


            /*
             * Data nascimento do pai.
             */
            var dataPai =
                document.querySelector(
                    '[name="txtPaidatanascimento"]'
                );


            if (
                dataPai &&
                trimTexto(
                    dataPai.value
                ) !== ""
            ) {

                if (
                    !validarCampoData(
                        dataPai,
                        "Data de nascimento do pai inválida."
                    )
                ) {

                    return false;
                }
            }


            /*
             * Data nascimento da mãe.
             */
            var dataMae =
                document.querySelector(
                    '[name="txtMaedatanascimento"]'
                );


            if (
                dataMae &&
                trimTexto(
                    dataMae.value
                ) !== ""
            ) {

                if (
                    !validarCampoData(
                        dataMae,
                        "Data de nascimento da mãe inválida."
                    )
                ) {

                    return false;
                }
            }


            /*
             * Data nascimento responsável.
             */
            var dataResponsavel =
                document.querySelector(
                    '[name="txtResponsaveldatanascimento"]'
                );


            if (
                dataResponsavel &&
                trimTexto(
                    dataResponsavel.value
                ) !== ""
            ) {

                if (
                    !validarCampoData(
                        dataResponsavel,
                        "Data de nascimento do responsável inválida."
                    )
                ) {

                    return false;
                }
            }


            /*
             * CPF responsável.
             */
            var cpfResponsavel =
                document.querySelector(
                    '[name="txtCPFResponsavel"]'
                );


            if (
                cpfResponsavel &&
                trimTexto(
                    cpfResponsavel.value
                ) !== ""
            ) {

                if (
                    !validarCampoCPF(
                        cpfResponsavel,
                        "CPF do responsável inválido. Verifique o número informado."
                    )
                ) {

                    return false;
                }
            }


            /*
             * Data afastamento.
             */
            var dataAfastamento =
                document.querySelector(
                    '[name="txtDataAfastamento"]'
                );


            if (
                dataAfastamento &&
                trimTexto(
                    dataAfastamento.value
                ) !== ""
            ) {

                if (
                    !validarCampoData(
                        dataAfastamento,
                        "Data de afastamento inválida."
                    )
                ) {

                    return false;
                }
            }


            /*
             * Sexo.
             */
            var sexo =
                document.getElementById(
                    "cmbSexo"
                );


            if (
                sexo &&
                (
                    sexo.value === "" ||
                    sexo.value === "0"
                )
            ) {

                alert(
                    "Informe o sexo do paciente."
                );

                sexo.focus();

                return false;
            }


            return true;
        }
    };


    /*
     * =========================================================
     * MEDICAMENTO CONTROLADO
     * =========================================================
     */

    window.verificaMedicamento =
        function () {

            mostrar(
                "linha_medicamento_qual",
                valor(
                    "MEDICAMENTO_CONTROLADO"
                ) === "S"
            );
        };


    /*
     * =========================================================
     * RESTRIÇÃO ALIMENTAR
     * =========================================================
     */

    window.verificaRestricao =
        function () {

            mostrar(
                "linha_restricao_qual",
                valor(
                    "RESTRICAO_ALIMENTAR"
                ) === "S"
            );
        };


    /*
     * =========================================================
     * ALERGIA
     * =========================================================
     */

    window.verificaAlergia =
        function () {

            mostrar(
                "linha_alergia_qual",
                valor(
                    "ALERGIA"
                ) === "S"
            );
        };


    /*
     * =========================================================
     * RESPONSÁVEL
     * =========================================================
     */

    window.verificaOutroResponsavel =
        function () {

            mostrar(
                "coluna_outro_responsavel",
                valor(
                    "RESPONSAVEL_QUEM"
                ) === "OUTRO"
            );
        };


    /*
     * =========================================================
     * CONDIÇÃO ESPECIAL
     * =========================================================
     */

    window.verificaCondicaoEspecial =
        function () {

            return true;
        };


    /*
     * =========================================================
     * INICIALIZAÇÃO
     * =========================================================
     */

    document.addEventListener(
        "DOMContentLoaded",
        function () {

            /*
             * Máscaras.
             */
            configurarMascarasEValidacoes();


            /*
             * Tipo inicial do paciente.
             */
            AEEFichaPaciente.trocarTipo(
                valor(
                    "txtTipoPaciente"
                ) || "R"
            );


            /*
             * Campos condicionais.
             */
            verificaMedicamento();

            verificaRestricao();

            verificaAlergia();

            verificaOutroResponsavel();
        }
    );

})();