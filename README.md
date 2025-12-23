// Criado por: Cleber Cisne Catão
// Projeto: Desafio Java
// Data: 19/11/2025

Desafio Técnico – Delphi + SQL Server
Descrição

Este projeto foi desenvolvido como solução para o Desafio Técnico Delphi, utilizando:

Delphi 11 (Console Application)

SQL Server 2016

FireDAC

Arquitetura em camadas (Services + Repositories)

Uso obrigatório de métodos fictícios, conforme solicitado no enunciado.

O sistema simula um sorteio promocional realizado pela empresa TAIF para clientes que adquiriram veículos, respeitando regras específicas de elegibilidade.

ProjetoConsoleDelphi
│
├── Domain
│   ├── Cliente.pas
│   ├── Modelo.pas
│   └── Venda.pas
│
├── Data
│   ├── Database.pas
│   └── Repositories
│       ├── ClienteRepository.pas
│       ├── ModeloRepository.pas
│       └── VendaRepository.pas
│
├── Services
│   ├── CadastroService.pas
│   └── SorteioService.pas
│
└── Program.dpr


Criação de classes para cada tabela
✔ Inserção de clientes, modelos e vendas
✔ Implementação do sorteio conforme critérios
✔ Exclusão das vendas não sorteadas sem uso de IN
✔ Uso dos métodos fictícios:

InserirDadosDB

ExecutarSQL
✔ Execução via console, com exibição dos resultados


Regras do Sorteio
São consideradas 15 vendas sorteadas, obedecendo aos critérios:
Apenas as 15 primeiras vendas, por ordem da data da venda
Clientes cujo CPF inicia com o dígito 0
Veículos com ano de lançamento 2021
Clientes que não tenham comprado mais de um veículo Marea
Após o sorteio, todas as vendas não sorteadas são excluídas
A exclusão não utiliza o comando IN

Criadas funções adicionais para randonizar datas e modelos dos veículos.