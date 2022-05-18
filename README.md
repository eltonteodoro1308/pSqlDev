# pSqlDev - Protheus Sql Developer

## Conteúdo

- [Introdução](#Introdução)
- [Funcionalidades](#Funcionalidades)
  - [Salva a última query executada.](###Salva-a-última-query-executada.)
  - [Utilização de comentártios.](#Utilização_de_comentártios.)
  - [Selecionar trecho da query a ser executada.](#Selecionar_trecho_da_query_a_ser_executada.)
  - [Executa update, delete e insert.](#Executa_update,_delete_e_insert.)
  - [Use Embedded Sql.](#Use_Embedded_Sql.)
  - [Processa o Embedded Sql e gera a query pura.](#Processa_o_Embedded_Sql_e_gera_a_query_pura.)
  - [Criação de variáveis advpl em tempo de execução.](#Criação_de_variáveis_advpl_em_tempo_de_execução.)
  - [Permite o uso de pergunta no execução.](#Permite_o_uso_de_pergunta_no_execução.)
  - [Permite a conversão de dados conforme Embedded Sql](#Permite_a_conversão_de_dados_conforme_Embedded_Sql)
  - [Utilização de index no order da consulta](#Utilização_de_index_no_order_da_consulta)

## Introdução

> Rotina que permite executar query´s diretamente no banco de dados do Protheus.

## Funcionalidades

### Salva a última query executada.

> Após executar 

### Utilização de comentártios.

### Selecionar trecho da query a ser executada.

### Executa update, delete e insert.

### Use Embedded Sql.

### Processa o Embedded Sql e gera a query pura.

### Criação de variável advpl em tempo de execução.

### Permite o uso de pergunta no execução.

### Permite a conversão de dados conforme Embedded Sql

### Utilização de index no order da consulta

| *nome* | *idade* |
| - | - |
| elton | 46 |
| italo | 15 |

```sql

SELECT * FROM %TABLE:SA1%

```

```json
{ "NOME": "ELTON",
	"IDADE": 46
}

```
