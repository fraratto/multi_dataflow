`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2020 09:24:17
// Design Name: 
// Module Name: CSDF_2P
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

module CSDF#
(

    //PARAMETRI GENERALI
    parameter PORTS=2,
    parameter FLUX=2,
    parameter WIDTH=8,
    parameter NUM_OP=4
    
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
    output reg [WIDTH-1:0] out0_data
    
);

    //PARAMETRI PER L'ELABORAZIONE
    parameter TAG_WIDTH = $clog2(FLUX);
    parameter NUM=NUM_OP-1;
    parameter DIM_NUM=$clog2(NUM_OP);

    //MACCHINA A STATI
    parameter ATTESA=0;
    parameter AZIONE=1;

    //DATI DEI FLUSSI
    reg [DIM_NUM-1:0] cnt [0:FLUX-1];
    reg [WIDTH-(TAG_WIDTH)-1:0] acc [0:FLUX-1];
    reg [FLUX-1:0] state;

    //EQUIVALENTI
    reg [DIM_NUM-1:0] eqv_cnt;
    reg [DIM_NUM-1:0] eqv_cntnxt;
    reg [WIDTH-(TAG_WIDTH)-1:0] eqv_acc;
    reg [WIDTH-(TAG_WIDTH)-1:0] eqv_accnxt;
    reg [PORTS-1:0] eqv_read;
    reg eqv_state;
    reg eqv_statenxt;
    
    //SUPPORTO
    reg [TAG_WIDTH-1:0] tag;
    reg [TAG_WIDTH-1:0] old_tag;
    reg [FLUX-1:0] status;
    reg end_call;
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
            if((status[i]==0 & cnt[i]<NUM ) 
            | (status[i]==0 & cnt[i]==NUM & state[i]==ATTESA) 
            | (cnt[old_tag]==NUM & out0_full==0 & state[i]==AZIONE)) //migliorabile?
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
            
        //CHIUSURA FORZATA DELLE OPERAZIONI PRIMA DEL CAMBIO TAG         
        if(tag!=old_tag)
            if(state[old_tag]==AZIONE) 
                if(cnt[old_tag]==NUM & out0_full==1)
                    begin
                        end_call=0; 
                        tag=k;
                    end
                else
                    begin
                        end_call=1; 
                        tag=old_tag;
                    end
            else
                begin
                    end_call=0; 
                    tag=k;
                end
        else
            begin
                end_call=0; 
                tag=old_tag;
            end

        //ASSEGNAMENTI VARIABILI EQUIVALENTI (INIZIO)    
		eqv_state=state[tag];
		eqv_cnt=cnt[tag];
		eqv_acc=acc[tag];		
	    		
        //ATTESA: ASPETTO DI POTER FARE LE OPERAZIONI
        if(eqv_state==ATTESA)
        
            begin

			    //GESTIONE SOMMA DATI
    			carrier2 = 0;
                carrier1 = 0;
                total_data = 0;  
                            
                //GESTIONE READ		
                if(status[tag]==1)
                    for(j=0;j<=PORTS-1;j=j+1)
                        eqv_read[j]=0;
                else
                    for(j=0;j<=PORTS-1;j=j+1)
                        eqv_read[j]=1;
            
                //GESTIONE WRITE
		        out0_wr=0;
	        
    		    //GESTIONE ACCUMULAZIONI E CONTEGGIO 
	       	    eqv_accnxt=eqv_acc; 
    		    eqv_cntnxt=eqv_cnt;
	
	       	    //GESTIONE USCITA 
    		    out0_data={tag,eqv_acc};
    	       
	       	    //GESTIONE PASSAGGIO DI STATO
    		    if(status[tag]==0) 
                    eqv_statenxt=AZIONE; 
    		    else 
	       		    eqv_statenxt=ATTESA;
			    
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
            	
                //GESTIONE READ
	       	    if(status[tag]==1 | eqv_cnt==NUM | end_call==1)
                    for(j=0;j<=PORTS-1;j=j+1)
                        eqv_read[j]=0;
                else
                    for(j=0;j<=PORTS-1;j=j+1)
                        eqv_read[j]=1;
			 
    		    //GESTIONE WRITE, ACCUMULAZIONI, CONTEGGIO ED USCITA 
	       	    if(eqv_cnt==NUM & out0_full==0)    
    			    begin
	       			    out0_data={tag,(eqv_acc+total_data)}; 
    				    out0_wr=1; 
    				    eqv_cntnxt=0;
	       			    eqv_accnxt=0;
    			    end
    		    else if(eqv_cnt==NUM & out0_full==1) 
    			    begin 
    				    out0_data={tag,eqv_acc}; 
	       			    out0_wr=0;
    				    eqv_cntnxt=eqv_cnt; 
    				    eqv_accnxt=eqv_acc;
    			    end
    		    else 
	       		    begin 
    				    out0_data={tag,eqv_acc+total_data}; 
	       			    out0_wr=0; 
			     	    eqv_cntnxt=eqv_cnt+1; 
    				    eqv_accnxt=eqv_acc+total_data;
	       		    end
                	       		    
    		    //GESTIONE PASSAGGIO DI STATO
    		    if(((status[tag]==1) & ~(eqv_cnt==NUM) | end_call==1) | (eqv_cnt==NUM & out0_full==0)) 
                    eqv_statenxt=ATTESA;    
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

    end

//LOGICA SEQUENZIALE 
always@(posedge ck or posedge rst)
    if(rst==1) 
    	begin
            for(i=0;i<=FLUX-1;i=i+1)
                begin
                    state[i]<=ATTESA;
                    cnt[i]<=0;
                    acc[i]<=0;
                end
            old_tag<=0;
    	end
    else 
    	begin
            state[tag]<=eqv_statenxt;
            cnt[tag]<=eqv_cntnxt;
            acc[tag]<=eqv_accnxt;
            old_tag<=tag; 
    	end
	
endmodule