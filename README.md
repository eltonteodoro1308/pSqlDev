# pSqlDev

Protheus Sql Developer

1. Salva a última query executada.
2. Permite comentártios ( // ) ( /**/ ) ( * ).
3. Permite selecionar trecho da query a ser executada.
4. Executa update, delete, insert.
5. Executa usando Embedded Sql.
6. Processa o embedded sql e gera a query pura.
7. Criação de variável advpl em tempo de execução para ser utilizada como um %EXP:%
8. Permite o uso de pergunta no execução.
9. Permite a conversão de dados conforme embedded sql ( column [campo] as [tipo] )
10. Utilização de index no order da consulta


|*nome*|*idade*|
|-----|------|
|elton|46|
|italo|15|

```sql

SELECT * FROM %TABLE:SA1%

```

```json
{ "NOME": "ELTON",
	"IDADE": 46
}

```
