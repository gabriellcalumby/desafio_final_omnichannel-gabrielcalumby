// ============================================================
// PROJETO: SISTEMA DE GESTAO OMNICHANNEL
// ALUNO:GABRIEL HENRIQUE CALUMBY MOURA
// TURMA 307.008 NEM SESI
// Arquivo: 04_nosql_poc.js
// Banco: omnichannel_nosql
// Colecao: logs_navegacao
// ============================================================

use('omnichannel_nosql');

// Criar e inserir tres documentos de navegacao.
db.getCollection('logs_navegacao').insertMany([
    {
        cliente_id: 101,
        data_hora: ISODate('2026-10-20T14:30:00Z'),
        pagina_visitada: '/produtos/eletronicos/smartphone-s23',
        dispositivo: 'Mobile',
        acoes: [
            'visualizou_detalhes',
            'adicionou_carrinho'
        ]
    },
    {
        cliente_id: 102,
        data_hora: ISODate('2026-10-20T15:10:00Z'),
        pagina_visitada: '/produtos/acessorios/fone-bluetooth',
        dispositivo: 'Desktop',
        acoes: [
            'pesquisou_item',
            'visualizou_detalhes'
        ]
    },
    {
        cliente_id: 103,
        data_hora: ISODate('2026-10-20T16:45:00Z'),
        pagina_visitada: '/carrinho',
        dispositivo: 'Mobile',
        acoes: [
            'visualizou_carrinho',
            'iniciou_checkout'
        ]
    }
]);

// Consultar todos os logs inseridos.
db.getCollection('logs_navegacao').find({});

// Contar os documentos da colecao.
db.getCollection('logs_navegacao').countDocuments({});

// Consultar somente acessos realizados por dispositivos Mobile.
db.getCollection('logs_navegacao').find({
    dispositivo: 'Mobile'
});

// FIM DO ARQUIVO 04