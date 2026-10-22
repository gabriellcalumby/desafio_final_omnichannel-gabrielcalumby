# desafio_final_omnichannel-gabrielcalumby
# Sistema de Gestão de Dados OmniChannel

**SENAI — Técnico em Desenvolvimento de Sistemas**

## Identificação do estudante

- **Aluno:** Gabriel Henrique Calumby Moura
- **Turma:** Técnico em Desenvolvimento de Sistemas
- **Unidade Curricular:** Banco de Dados
- **Docente:** [Nome do professor]

## 1. Descrição do projeto

Este projeto implementa uma infraestrutura de dados para a VarejoOmni S.A., uma empresa varejista que integra vendas realizadas em lojas físicas e no comércio eletrônico.

A solução utiliza um banco de dados relacional MySQL para armazenar clientes, lojas, produtos, pedidos, itens de pedidos e auditorias de preços. Também utiliza o MongoDB Atlas para armazenar logs de navegação dos clientes.

## 2. Objetivos

- Organizar e relacionar os dados comerciais.
- Garantir a integridade referencial por meio de chaves primárias e estrangeiras.
- Controlar as permissões de acesso ao banco de dados.
- Automatizar o registro de vendas e a baixa de estoque.
- Registrar alterações de preços por meio de uma trigger de auditoria.
- Demonstrar o armazenamento de logs em um banco NoSQL.
- Gerar um backup e publicar o projeto no GitHub.

## 3. Tecnologias utilizadas

- MySQL Server
- MySQL Workbench
- brModelo
- MongoDB Atlas
- Visual Studio Code
- Git e GitHub

## 4. Estrutura do repositório

```text
desafio-final-omnichannel/
├── docs/
│   ├── der_omnichannel.png
│   └── modelo_logico.brModelo
├── scripts/
│   ├── 01_ddl_estrutura_e_seguranca.sql
│   ├── 02_dml_povoamento.sql
│   ├── 03_automacao_plsql.sql
│   ├── 04_nosql_poc.js
│   └── backup_omnichannel.sql
└── README.md
```

## 5. Modelo relacional

O banco `omnichannel_db` contém as seguintes tabelas:

- `clientes`: cadastro dos clientes.
- `lojas`: unidades físicas e operação de e-commerce.
- `produtos`: catálogo, preços e estoque.
- `pedidos`: registro das vendas.
- `itens_pedido`: produtos e quantidades de cada pedido.
- `auditoria_preco`: histórico de alterações de preços.

As tabelas utilizam InnoDB, chaves primárias e chaves estrangeiras para garantir a integridade referencial.

## 6. Segurança

Foi criado o usuário `atendente_omni`, com permissão de consulta (`SELECT`) exclusivamente nas tabelas `clientes` e `produtos`.

## 7. Automação

### Stored Procedure

A rotina `sp_registrar_venda` registra pedidos e itens, verifica a disponibilidade do produto e atualiza o estoque. Também retorna um alerta quando o estoque restante fica abaixo de cinco unidades.

### Trigger

A rotina `trg_auditoria_preco` registra automaticamente o preço anterior, o preço novo, a data e hora da alteração e o usuário responsável.

### Relatório

A view `vw_relatorio_vendas` consolida a quantidade comercializada e a receita por produto.

## 8. Banco NoSQL

O database `omnichannel_nosql`, no MongoDB Atlas, utiliza a coleção `logs_navegacao` para armazenar documentos com:

- Identificador do cliente.
- Data e hora do acesso.
- Página visitada.
- Dispositivo utilizado.
- Ações realizadas durante a navegação.

O script `04_nosql_poc.js` insere três documentos de exemplo e apresenta consultas de validação.

## 9. Como executar

### MySQL Workbench

1. Conecte-se ao servidor MySQL.
2. Execute `01_ddl_estrutura_e_seguranca.sql`.
3. Execute `02_dml_povoamento.sql`.
4. Execute `03_automacao_plsql.sql`.
5. Confira os pedidos, o estoque e a tabela de auditoria.
6. Exporte o banco pelo recurso **Server > Data Export** e salve o arquivo `backup_omnichannel.sql`.

### MongoDB Atlas

1. Crie o cluster e o usuário de banco de dados.
2. Configure o acesso de rede.
3. Conecte o VS Code ao cluster.
4. Execute `04_nosql_poc.js` no MongoDB Playground.
5. Confira os documentos na coleção `logs_navegacao`.

### GitHub

1. Crie um repositório público chamado `desafio-final-omnichannel`.
2. Adicione as pastas `docs` e `scripts`.
3. Inclua os arquivos de documentação e os scripts.
4. Gere o backup real do banco e coloque-o em `scripts`.
5. Envie os arquivos e commits ao repositório.

## 10. Evidências de funcionamento

Adicionar capturas de tela de:

- Estrutura das tabelas no MySQL Workbench.
- Execução da stored procedure.
- Estoque atualizado após a venda.
- Auditoria de alteração de preços.
- Documentos armazenados no MongoDB Atlas.
- Repositório público no GitHub.

## 11. Segurança das credenciais

Não publicar senhas reais, strings de conexão completas ou outros segredos no GitHub. Utilizar credenciais de laboratório e exemplos fictícios na documentação.

## 12. Conclusão

O projeto demonstra a integração entre banco de dados relacional e não relacional, com modelagem, integridade referencial, controle de acesso, automação de vendas, auditoria, consultas e documentação técnica.

O funcionamento final deve ser comprovado pela execução dos scripts e pelas evidências registradas durante os testes.
