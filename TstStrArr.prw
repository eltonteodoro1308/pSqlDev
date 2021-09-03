#include "TOTVS.CH"

User Function TstStrArr()


	local oDlg := nil

	RpcSetEnv( '99', '01',,,,,{'SX5','CT1'} )


	DEFINE DIALOG oDlg TITLE "Exemplo BrGetDDB" FROM 180, 180 TO 550, 700 PIXEL

	dbSelectArea('SA1')
	oBrowse := BrGetDDB():new( 1,1,260,184,,,,oDlg,,,,,,, TFont():New( 'Consolas',,-14, ),,,,,.F.,'SX3',.T.,,.F.,,, )

	//Avaliar a documentação http://tdn.totvs.com.br/display/tec/bCustomEditCol
	oBrowse:bCustomEditCol := {|x,y,z| u_editLine(x,y,z) }
	oBrowse:bDelete := { || conOut( "bDelete" ) }

	oBrowse:addColumn( TCColumn():new( 'Arquivo', { || SX3->X3_ARQUIVO  },,,, 'LEFT',, .F., .F.,,,, .F. ) )
	oBrowse:addColumn( TCColumn():new( 'Ordem',   { || SX3->X3_ORDEM },,,, 'LEFT',, .F., .F.,,,, .F. ) )
	oBrowse:addColumn( TCColumn():new( 'Campo',   { || SX3->X3_CAMPO },,,, 'LEFT',, .F., .F.,,,, .F. ) )

    SX3->(DbGoTop())

	ACTIVATE DIALOG oDlg CENTERED

	RpcClearEnv()

Return

User Function editLine(x,y,z)

	ApMsgStop("editLine")

Return .T.
