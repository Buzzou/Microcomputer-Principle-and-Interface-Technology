;=================================================================
; SOUND.asm
; ���ӷ������ʵ��
;=================================================================

; �˿ڶ���
IOY0			EQU 0600H
MY8254_COUNT0	EQU IOY0+00H*2   		;8254������0�˿ڵ�ַ
MY8254_COUNT1	EQU IOY0+01H*2   		;8254������1�˿ڵ�ַ
MY8254_COUNT2	EQU IOY0+02H*2   		;8254������2�˿ڵ�ַ
MY8254_MODE		EQU IOY0+03H*2   		;8254���ƼĴ����˿ڵ�ַ
STACK1	SEGMENT STACK
		DW 256 DUP(?)
STACK1	ENDS
DATA	SEGMENT 
FREQ_LIST	DW  262,294,330,262,262,294,330,262,330       		;Ƶ�ʱ�
			DW  350,393,330,350,393,393,441,393,350
			DW  330,262,393,441,393,350,330,262,294,196
			DW  262,294,196,262,262,294,330,262,262,294
			DW  330,262,330,350,393,330,350,393,393,441
			DW  393,350,330,262,393,441,393,350,330,262,0
TIME_LIST	DB    4,   4,  4,   4,  4,  4,   4,  4,  4       	;ʱ���
			DB    4,   8,  4,   4, 8,  2,  2,   2,  2
			DB    4,   4,  2,   2,  2,  2,  4,   4,  4,  4
			DB   8,   4,  4,   8,  4,  4,  4,   4,  4,  4
			DB    4,   4,  4,   4, 8,  4,  4,   8,  2,  2
			DB    2,   2,  4,   4,  2,  2,  2,   2,  4, 4
DATA		ENDS

CODE	SEGMENT
		ASSUME  CS:CODE, DS:DATA
START:	MOV AX, DATA
		MOV DS, AX
		MOV DX, MY8254_MODE			;��ʼ��8254������ʽ
		MOV AL, 36H					;��ʱ��0����ʽ3
		OUT DX, AL
BEGIN:	MOV SI,OFFSET FREQ_LIST		;װ��Ƶ�ʱ���ʼ��ַ
		MOV DI,OFFSET TIME_LIST		;װ��ʱ�����ʼ��ַ
PLAY:	MOV DX,0FH					;����ʱ��Ϊ1MHz��1M = 0F4240H  
		MOV AX,4240H 
		DIV WORD PTR [SI]			;ȡ��Ƶ��ֵ���������ֵ��0F4240H / ���Ƶ��
		MOV DX,MY8254_COUNT0
		OUT DX,AL					;װ�������ֵ
		MOV AL,AH
		OUT DX,AL
		MOV DL,[DI]					;ȡ���������ʱ�䣬������ʱ�ӳ��� 
		CALL DALLY
		ADD SI,2
		INC DI
		CMP WORD PTR [SI],0			;�ж��Ƿ���ĩ��
		JE  BEGIN
		JMP  PLAY
DALLY	PROC						;��ʱ�ӳ���
D0:		MOV CX,0010H
D1:		MOV AX,0F00H
D2:		DEC AX
		JNZ D2
		LOOP D1
		DEC DL
		JNZ D0
		RET
DALLY	ENDP
CODE	ENDS
		END START
