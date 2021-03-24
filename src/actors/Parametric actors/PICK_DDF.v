`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.04.2020 20:25:51
// Design Name: 
// Module Name: Accumulatore DDF
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module PICK_DDF#(

    //PARAMETRI GENERALI
    parameter PORTS=2,
    parameter FLUX=2,
    parameter WIDTH=8
    
)(

    input ck,
    input rst,
    input out0_full,
    
    //ordine in base alla porta
    //ES 2 porte, 8 bit di dati -> 2 signals, signals[0->7] = porta 0, signals[8->15]= porta 1
    input [(WIDTH*PORTS)-1:0] in_data,
    //ordine in base ai flussi
    //ES 2 flux, 2 ports -> 4 signals, signals[0 (porta 0),1 (porta 1)]= flux 0, signals[2 (porta 0),3 (porta 1)]=flux 1 
    input [(PORTS*FLUX)-1:0] in_empty,
    //ordine in base ai flussi
    //ES 2 flux, 2 ports -> 4 signals, signals[0 (porta 0),1 (porta 1)]= flux 0, signals[2 (porta 0),3 (porta 1)]=flux 1 s
    output reg [(PORTS*FLUX)-1:0] in_read,
    
    output reg out0_wr,
    output reg [WIDTH-1:0] out0_data,
    
    //NDA
    input [FLUX-1:0] nda_empty,
    output reg [FLUX-1:0] nda_read,
    input [WIDTH-1:0] nda_data
    
);

    //PARAMETRI MACCHINA A STATI
    parameter PICK=0;
    parameter AZIONE=1;

    //PARAMETRI PER L'ELABORAZIONE
    parameter TAG_WIDTH = $clog2(FLUX);
    
    //DATI DEI FLUSSI
    reg [WIDTH-2:0] cnt [0:FLUX-1];
    reg [WIDTH-(TAG_WIDTH)-1:0] acc [0:FLUX-1];
    reg [FLUX-1:0] ready;  
    reg [FLUX-1:0] state;

    //EQUIVALENTI
    reg [WIDTH-2:0] eqv_cnt;
    reg [WIDTH-2:0] eqv_cntnxt;
    reg [WIDTH-(TAG_WIDTH)-1:0] eqv_acc;
    reg [WIDTH-(TAG_WIDTH)-1:0] eqv_accnxt;
    reg [PORTS-1:0] eqv_read;
    reg eqv_ready;
    reg eqv_readynxt;
    reg eqv_state;
    reg eqv_statenxt;
    
    //EQUIVALENTI NDA
    reg eqv_ndaread;

    //SUPPORTO
    reg [TAG_WIDTH-1:0] tag;
    reg [FLUX-1:0] status;
    reg [WIDTH-(TAG_WIDTH)-1:0] total_data;
    reg [(WIDTH*PORTS)-1:0] carrier1;
    reg [WIDTH-(TAG_WIDTH)-1:0] carrier2;

    //INTEGERS
    integer i,j,k;

//LOGICA COMBINATORIA 
always@(*)

    begin

        //DETERMINO QUALI FLUSSI SONO DISPONIBILI
        for(j=FLUX-1;j>=0;j=j-1)
            begin
                status[j]=0;
                    for(i=0;i<=PORTS-1;i=i+1) 
                        begin
                            status[j] = status[j] | in_empty[i+j*PORTS];
                        end
            end

        //SCELGO QUALE FLUSSO USARE
        i=FLUX-1;
        while(i>=1)
            if(
            ((cnt[i]==0 & out0_full==0 & ready[i]==1) | (status[i]==0 & ready[i]!=1) & state[i]!=PICK) 
            | (nda_empty[i]==0 & state[i]==PICK)
            ) //migliorabile?
                begin
                    tag=i; //se l'ho trovato, tag sarà il flusso
                    k=i;
                    i=0;
                end
            else
                begin
                    tag=i-1; //se non l'ho trovato, tag sarà di default a 0
                    k=i-1;
                    i=i-1;
                end
                
        //ASSEGNAMENTI VARIABILI EQUIVALENTI (INIZIO)	   
		eqv_cnt=cnt[tag];
		eqv_acc=acc[tag];	
		eqv_ready=ready[tag];
		eqv_state=state[tag];

        //PICK: SCOPRO QUANTE OPERAZIONI DEVO FARE
        if(eqv_state==PICK)
        
            begin
            
                //GESTIONE SOMMA DATI	
                carrier2 = 0;
                carrier1 = 0;
                total_data = 0;

        		//GESTIONE NDA
        		if(nda_empty[tag]==0) 
	          		eqv_ndaread=1; 
        		else 
	          		eqv_ndaread=0;

                //GESTIONE READ E READY
                for(j=0;j<=PORTS-1;j=j+1)
                    eqv_read[j]=0;
        		eqv_readynxt=0;
    		
                //GESTIONE WRITE
                out0_wr=0;

                //GESTIONE ACCUMULAZIONI E CONTEGGIO
                eqv_accnxt=0;
                if(nda_empty[tag]==0)
                    if(nda_data[WIDTH-(TAG_WIDTH)-1:0]==0) 
                        eqv_cntnxt=0;  
                    else 
                        eqv_cntnxt=nda_data[WIDTH-(TAG_WIDTH)-1:0]-1;
                else 
                    eqv_cntnxt=0;

        		//GESTIONE USCITA
    	       	out0_data={tag,eqv_acc};

        		//GESTIONE PASSAGGIO DI STATO
        		if(nda_data[WIDTH-(TAG_WIDTH)-1:0]!=0 & nda_empty[tag]==0) 
        			eqv_statenxt=AZIONE;
        		else 
    	       		eqv_statenxt=PICK;
			 				
        	end
 
        //AZIONE: FACCIO LE OPERAZIONI
        else
    
        	begin

                //GESTIONE SOMMA DATI
    	        total_data = 0;
                carrier1 = in_data;
                carrier2 = 0;
                for(i=0;i<=PORTS-1;i=i+1)
                    begin
                        carrier2=carrier1[WIDTH-(TAG_WIDTH)-1:0];
                        carrier1=carrier1>>(WIDTH);
                        total_data=total_data+carrier2;
                    end
                    
        		//GESTIONE NDA
        		eqv_ndaread=0;

        		//GESTIONE READ
        		if((status[tag]==0 & eqv_ready!=1) | (eqv_cnt==0 & status[tag]==0 & eqv_ready==0)) 
                    for(j=0;j<=PORTS-1;j=j+1)
                        eqv_read[j]=1; 
        		else
                    for(j=0;j<=PORTS-1;j=j+1)
                        eqv_read[j]=0;
	   	   
	       		//GESTIONE WRITE, ACCUMULAZIONI, CONTEGGIO, USCITA E READY 
        		if(eqv_cnt==0 & out0_full==0 & eqv_ready==1)
        			begin 
        				out0_data={tag,eqv_acc}; 
        				out0_wr=1; 
        				eqv_cntnxt=0;
        				eqv_accnxt=0;
        				eqv_readynxt=0;
        			end
        		else if(status[tag]==0 & eqv_ready!=1)
        			begin 
        				out0_data={tag,eqv_acc+total_data}; 
        				out0_wr=0;
        				if(eqv_cnt==0)
        				    eqv_cntnxt=eqv_cnt;
        				else 
        				    eqv_cntnxt=eqv_cnt-1; 
        				eqv_accnxt=eqv_acc+total_data;
        				if(eqv_cnt==0)
        				    eqv_readynxt=1;
        				else
        				    eqv_readynxt=0;
        			end
        		else 
        			begin 
        				out0_data={tag,eqv_acc}; 
        				out0_wr=0;
        				eqv_cntnxt=eqv_cnt; 
    		      		eqv_accnxt=eqv_acc; 
                        eqv_readynxt=eqv_ready;
        			end 
			
        		//GESTIONE PASSAGGIO DI STATO
        		if(eqv_cnt==0 & out0_full==0 & eqv_ready==1) 
        			eqv_statenxt=PICK; 		
        		else
        			eqv_statenxt=AZIONE;
        			
            end

        //ASSEGNAMENTI VARIABILI EQUIVALENTI (FINE)
        for(i=0;i<=PORTS*FLUX-1;i=i+1)
            begin
                in_read[i] = 0;
            end

        for(i=0;i<=PORTS-1;i=i+1)
            begin
                in_read[i+tag*PORTS] = eqv_read[i];
            end
    	  
        for(i=0;i<=FLUX-1;i=i+1)
            begin
                nda_read[i] = 0;
            end
	    
        nda_read[tag]=eqv_ndaread;

    end
 
//LOGICA SEQUENZIALE 
always@(posedge ck or posedge rst)
    if(rst==1) 
    	begin
            for(i=0;i<=FLUX-1;i=i+1)
                begin
                    ready[i]<=0;
                    cnt[i]<=0;
                    acc[i]<=0;
                    state[i]<=PICK;
                end
    	end
    else 
    	begin
            ready[tag]<=eqv_readynxt;
            cnt[tag]<=eqv_cntnxt;
            acc[tag]<=eqv_accnxt;
            state[tag]<=eqv_statenxt;
    	end
	
endmodule
