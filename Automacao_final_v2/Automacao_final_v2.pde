#include "pitches.h"
#include <WProgram.h> // Biblioteca para o infra vermelho.
#include <NECIRrcv.h>
#include <Client.h>
#include <Ethernet.h>
#include <Server.h>
#include <Udp.h>
#include <SPI.h>
#define InfraVermelho 9

/*
 RFID, IR, LCD, Relay, Speaker, LDR Customizado por Fabiano Silva - fabianoacsx@gmail.com - Finalizado em 02/10/2012
 */
#include <SPI.h>
#include <LiquidCrystal.h> //biblioteca LCD

#define	uchar	unsigned char
#define	uint	unsigned int
#define MAX_LEN 16

const int chipSelectPin = 53;
const int NRSTPD = 6;

#define PCD_IDLE              0x00               
#define PCD_AUTHENT           0x0E               
#define PCD_RECEIVE           0x08               
#define PCD_TRANSMIT          0x04               
#define PCD_TRANSCEIVE        0x0C               
#define PCD_RESETPHASE        0x0F               
#define PCD_CALCCRC           0x03               


#define PICC_REQIDL           0x26               
#define PICC_REQALL           0x52               
#define PICC_ANTICOLL         0x93               
#define PICC_SElECTTAG        0x93               
#define PICC_AUTHENT1A        0x60               
#define PICC_AUTHENT1B        0x61               
#define PICC_READ             0x30               
#define PICC_WRITE            0xA0               
#define PICC_DECREMENT        0xC0               
#define PICC_INCREMENT        0xC1               
#define PICC_RESTORE          0xC2               
#define PICC_TRANSFER         0xB0               
#define PICC_HALT             0x50               

#define MI_OK                 0
#define MI_NOTAGERR           1
#define MI_ERR                2


//------------------MFRC522---------------
//Page 0:Command and Status
#define     Reserved00            0x00    
#define     CommandReg            0x01    
#define     CommIEnReg            0x02    
#define     DivlEnReg             0x03    
#define     CommIrqReg            0x04    
#define     DivIrqReg             0x05
#define     ErrorReg              0x06    
#define     Status1Reg            0x07    
#define     Status2Reg            0x08    
#define     FIFODataReg           0x09
#define     FIFOLevelReg          0x0A
#define     WaterLevelReg         0x0B
#define     ControlReg            0x0C
#define     BitFramingReg         0x0D
#define     CollReg               0x0E
#define     Reserved01            0x0F
//Page 1:Command     
#define     Reserved10            0x10
#define     ModeReg               0x11
#define     TxModeReg             0x12
#define     RxModeReg             0x13
#define     TxControlReg          0x14
#define     TxAutoReg             0x15
#define     TxSelReg              0x16
#define     RxSelReg              0x17
#define     RxThresholdReg        0x18
#define     DemodReg              0x19
#define     Reserved11            0x1A
#define     Reserved12            0x1B
#define     MifareReg             0x1C
#define     Reserved13            0x1D
#define     Reserved14            0x1E
#define     SerialSpeedReg        0x1F
//Page 2:CFG    
#define     Reserved20            0x20  
#define     CRCResultRegM         0x21
#define     CRCResultRegL         0x22
#define     Reserved21            0x23
#define     ModWidthReg           0x24
#define     Reserved22            0x25
#define     RFCfgReg              0x26
#define     GsNReg                0x27
#define     CWGsPReg	          0x28
#define     ModGsPReg             0x29
#define     TModeReg              0x2A
#define     TPrescalerReg         0x2B
#define     TReloadRegH           0x2C
#define     TReloadRegL           0x2D
#define     TCounterValueRegH     0x2E
#define     TCounterValueRegL     0x2F
//Page 3:TestRegister     
#define     Reserved30            0x30
#define     TestSel1Reg           0x31
#define     TestSel2Reg           0x32
#define     TestPinEnReg          0x33
#define     TestPinValueReg       0x34
#define     TestBusReg            0x35
#define     AutoTestReg           0x36
#define     VersionReg            0x37
#define     AnalogTestReg         0x38
#define     TestDAC1Reg           0x39  
#define     TestDAC2Reg           0x3A   
#define     TestADCReg            0x3B   
#define     Reserved31            0x3C   
#define     Reserved32            0x3D   
#define     Reserved33            0x3E   
#define     Reserved34			  0x3F
//-----------------------------------------------

uchar serNum[5];

uchar  writeData[16]={0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100};  
uchar  moneyConsume = 18 ;  
uchar  moneyAdd = 10 ;  

 uchar sectorKeyA[16][16] = {{0x19, 0x84, 0x07, 0x15, 0x76, 0x14},
                             {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF},
                             {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF},
                             {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF},
                            };
 uchar sectorNewKeyA[16][16] = {{0x19, 0x84, 0x07, 0x15, 0x76, 0x14},
                                {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xff,0x07,0x80,0x69, 0x19,0x84,0x07,0x15,0x76,0x14},
                                {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xff,0x07,0x80,0x69, 0x19,0x33,0x07,0x15,0x34,0x14},
                                {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xff,0x07,0x80,0x69, 0x19,0x33,0x07,0x15,0x34,0x14},
                               };
      //Infravermelho                               
      unsigned long capturaCodigo = 0; 
      
      NECIRrcv ir(InfraVermelho) ; // Função da biblioteca                               


      //declarando os pinos para cada função
      int lazer = 23;
      int luminaria = 22;
      int vent = 24;
      int led = 25;
      int buzzer = 8;

      int lampada1 = A10;
      int lampada2 = A11;

      
      //sensor de temperatura
      int pinoSensor = A8; //pino que está ligado o terminal central do LM35 (porta analogica 0)
      int valorLido_temp = 0; //valor lido na entrada analogica
      float temperatura = 0; //valorLido convertido para temperatura
      
      //sensor de luminosidade
      const int LDR = 0;
      int valorLido_luminosidade = 0;

      //alarme
      int status_alarme = 0;
      
      //parametros web_ethernet
      byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
      byte ip[] = { 192, 168, 0, 155 }; // definição do ip do arduino
      Server server(8090); // porta do roteador
      int conta_caracter=0 ;
      int max_linha = 80 ;
      String linha_de_entrada = String(max_linha) ;
      boolean LEDON = false ;
      String txtWebLcd1=String(16); //variavel Linha1 valor recebido do form pro display
      String txtWebLcd2=String(16); //variavel Linha2 valor recebido do form pro display
      int corigeIniTxt=0;
      
      LiquidCrystal lcd(12, 11, 4, 3, 2, 6); //pinos usados no LCD

//Musica
  int melody[] = {
  NOTE_FS4, NOTE_FS4, NOTE_FS4, NOTE_FS4,
  NOTE_FS4, NOTE_FS4, NOTE_FS4, NOTE_FS4};
  int noteDurations[] = {4, 8, 8,8,8,8,4,4,4,4 };


void setup() {
  Ethernet.begin(mac, ip); // inicia ethernet shield  
  ir.begin() ; //inicia IR  
  lcd.begin(16, 2);
  Serial.begin(9600);                       // RFID reader SOUT pin connected to Serial RX pin at 2400bps 
 // start the SPI library:
  SPI.begin();
  Serial.println(valorLido_luminosidade);
 //sensor de luminosidade
  valorLido_luminosidade = analogRead(LDR);

 // Temperatura
  valorLido_temp = analogRead(pinoSensor);
  temperatura = (valorLido_temp * 0.00488);  // 5V / 1023 = 0.00488 (precisão do A/D)
  temperatura = temperatura * 100; //Conv

  //Sensor IR
  capturaCodigo = ir.read() ; 

  
  pinMode(lazer, OUTPUT);
  pinMode(luminaria, OUTPUT);
  pinMode(lampada1, OUTPUT);
  pinMode(lampada2, OUTPUT);
  pinMode(vent, OUTPUT);
  pinMode(led, OUTPUT);
  digitalWrite(led, HIGH);
  digitalWrite(vent, HIGH);  
  digitalWrite(lampada1, HIGH);
  digitalWrite(lampada2, HIGH);
  digitalWrite(lazer, HIGH);  
  digitalWrite(luminaria, HIGH);


  
  pinMode(chipSelectPin,OUTPUT);             // Set digital pin 10 as OUTPUT to connect it to the RFID /ENABLE pin 
  digitalWrite(chipSelectPin, LOW);          // Activate the RFID reader
  pinMode(NRSTPD,OUTPUT);               // Set digital pin 10 , Not Reset and Power-down
  digitalWrite(NRSTPD, HIGH);

  MFRC522_Init();  
}


void loop()
{
  // Mensagem inicial
               lcd.clear();
               lcd.setCursor(1,0);
               lcd.print("Sistema de");
               lcd.setCursor(2,1);
               lcd.print("Automacao - ON");


 
 //Alarme
           
//           while(status_alarme == 10){ 
//           
//  
//            }
//     
 
 
         // IR Controle remoto
           ir.available();
            capturaCodigo = ir.read() ; 
            Serial.println(capturaCodigo); 
// botão SRC 3843707565        
// botao PAUSE 2807583405
// botao DISP 2456637615
// botao A  4060959405
// seta baixa 3191952045
// botao F 2556907695
// botao seta esquerda 3175240365
// botao seta direita 3158528685
// botao B 3977401005
// botao seta cima 3208663725
// botao ATT 4077671085
// botao volume - 4094382765
// botao volume + 4111094445
       
            if (capturaCodigo == 2623798020) 
            { // botao ATT 4077671085
                 temp_atual();
                 
            }
            if (capturaCodigo == 2389834500)
            { // botao volume - 4094382765
             alarme_on();
           }
            if (capturaCodigo == 4144560900)
            { // botao volume + 4111094445
               
            }
            if (capturaCodigo == 4244830980)
            { // botao seta cima volume
               lampada1_on();
            }
            if (capturaCodigo == 4278254340)
            { // botao seta cima CH
                lampada2_on();
            }
            if (capturaCodigo == 4228119300)
            { // botao seta baixo volume
                lampada1_off();
            }
            if (capturaCodigo == 4261542660)
            { // botao seta baixo CH
                lampada2_off();
            }            
            if (capturaCodigo == 3994155780)
            { // botao F 2556907695
                digitalWrite(vent, LOW);            
            }                       
            if (capturaCodigo == 3977444100)
            { // seta baixa 3191952045
                digitalWrite(vent, HIGH);            
            }                       
            if (capturaCodigo == 4060959405)
            { // botao A  4060959405
            }                       
            if (capturaCodigo == 2456637615)
            { // botao DISP 2456637615
            }                               
            if (capturaCodigo == 2389834500)
            { // botão SRC 3843707565        
                status_alarme = 10;
            }
           if (capturaCodigo == 2373122820)
            { // botao PAUSE 2807583405
                  alarme_off();                              
            }            

// parametros web client
            Client client = server.available();
              if (client) {
                // an http request ends with a blank line
                boolean current_line_is_blank = true;
                conta_caracter=0 ;
                linha_de_entrada="" ;
                
                while (client.connected()) {
                  if (client.available()) {
                    // recebe um caracter enviado pelo browser
                    char c = client.read();
                    // se a linha não chegou ao máximo do armazenamento
                    // então adiciona a linha de entrada
                    if(linha_de_entrada.length() < max_linha) {
                      linha_de_entrada.concat(c) ;
                    }
             
                    // Se foi recebido um caracter linefeed - LF
                    // e a linha está em branco , a requisição http encerrou.
                    // Assim é possivel iniciar o envio da resposta
                    
                    if (c == '\n' && current_line_is_blank) {
                      // envia uma resposta padrão ao header http recebido
                      client.println("HTTP/1.1 200 OK");
                      client.println("Content-Type: text/html");
                      client.println();
                      // começa a enviar o formulário
                      client.print("<html>") ;
                      client.print("<body>");
                      
                      client.println("<br>") ;
                      client.println("<h2>CONTROLE DO LED</h2><hr/>");
                      client.println("<form method=get name=LED>") ;
                      
                      client.println("LIGA <input ") ;
                      // verifica o status do led e ativa o radio button
                      // correspondente
                      if(LEDON) {
                        client.println("checked='checked'") ;
                      }
                      client.println("name='LED' value='1' type='radio' >");
                      
                      client.println("DESLIGA <input ") ;
                      if(!LEDON) {
                        client.println("checked='checked'") ;
                      }
                      client.println("name='LED' value='0' type='radio' >");
                      // exibe o botão do formulário
                      client.println("<br><br><br><input type=submit value='ATUALIZA'></form>") ;
                      client.println("<br><font color='blue' size='3'>Acesse <a href=http://www.arduino4fun.wordpress.com/>www.arduino4fun.wordpress.com</a>");
                      client.println("</body>") ;
                      client.println("</html>");
            
                      break;
                    }
                    
                    if (c == '\n') {
                      // se o caracter recebido é um linefeed então estamos começando a receber uma
                      // nova linha de caracteres
                      // os codigos de impressão abaixo são para depuração e visualizar no monitor serial
                      // o que está chegando do browser
                      Serial.print(linha_de_entrada.length()) ;
                      Serial.print("->") ;
                      Serial.print(linha_de_entrada) ;
                      // Analise aqui o conteudo enviado pelo submit
                      if(linha_de_entrada.indexOf("GET") != -1 ){
                        // se a linha recebida contem GET e LED=ON enão guarde o status do led
                        // Liga a lampada1
                        if(linha_de_entrada.indexOf("CMD=L1ON") != -1 ){
                          lampada1_on() ;
                         }
                        if(linha_de_entrada.indexOf("CMD=L1OFF") != -1 ){
                        // se a linha recebida contem GET e LED=OFF enão guarde o status do led
                          lampada1_off();
                        }
                        if(linha_de_entrada.indexOf("CMD=L2ON") != -1 ){
                          lampada2_on() ;
                         }
                        if(linha_de_entrada.indexOf("CMD=L2OFF") != -1 ){
                        // se a linha recebida contem GET e LED=OFF enão guarde o status do led
                          lampada2_off() ;
                        }
                        if(linha_de_entrada.indexOf("CMD=ALARMEON") != -1 ){
                          alarme_on();
                         }
                        if(linha_de_entrada.indexOf("CMD=ALARMEOFF") != -1 ){
                        // se a linha recebida contem GET e LED=OFF enão guarde o status do led
                          alarme_off();
                        }
                        if(linha_de_entrada.indexOf("CMD=TEMP") != -1 ){
                        // se a linha recebida contem GET e LED=OFF enão guarde o status do led
                          temp_atual();
                        }
                      }
                      
                                 
                      current_line_is_blank = true;
                      linha_de_entrada="" ;
                      
                    } else if (c != '\r') {
                      // recebemos um carater que não é linefeed ou retorno de carro
                      // então recebemos um caracter e a linha de entrada não está mais vazia
                      current_line_is_blank = false;
                    }
                  }
                }
                // dá um tempo para o browser receber os caracteres
                delay(1);
                client.stop();
              }// fim parametros web client






  	uchar i,tmp;
	uchar status;
        uchar str[MAX_LEN];
        uchar RC_size;
        uchar blockAddr;	
        
        int pNum1;
        
        // Parametros Cartão RFID
        		
		status = MFRC522_Request(PICC_REQIDL, str);	
		if (status == MI_OK)
		{
                        Serial.println("Find out a card ");
			Serial.print(str[0],BIN);
                        Serial.print(" , ");
			Serial.print(str[1],BIN);
                        Serial.println(" ");
		}

		status = MFRC522_Anticoll(str);
		memcpy(serNum, str, 5);
		if (status == MI_OK)
		{

                        Serial.println("The card's number is  : ");
			Serial.print(serNum[0],BIN);
                        Serial.print(" , ");
			Serial.print(serNum[1],BIN);
                        Serial.print(" , ");
			Serial.print(serNum[2],BIN);
                        Serial.print(" , ");
			Serial.print(serNum[3],BIN);
                        Serial.print(" , ");
			Serial.print(serNum[4],BIN);
                        Serial.println(" ");
                        
                        Serial.println("Meu numero do Cartao: ");
                        pNum1 = serNum[0];
                        int pNum2 = serNum[1];
                        int pNum3 = serNum[2];
                        int pNum4 = serNum[3];
                        int pNum5 = serNum[4];

                        Serial.print(pNum1);
                        Serial.print(" , ");
                        Serial.print(pNum2);
                        Serial.print(" , ");
                        Serial.print(pNum3);
                        Serial.print(" , ");
                        Serial.print(pNum4);
                        Serial.print(" , ");
                        Serial.print(pNum5);
                        
                        Serial.println(" ");
                        
                        Serial.print(pNum1,HEX);
                        Serial.print(" , ");
                        Serial.print(pNum2,HEX);
                        Serial.print(" , ");
                        Serial.print(pNum3,HEX);
                        Serial.print(" , ");
                        Serial.print(pNum4,HEX);
                        Serial.print(" , ");
                        Serial.print(pNum5,HEX);
                        Serial.println(" ");
                        
                        //liga led verde
                         if (pNum1 == 237 && pNum2 == 78 && pNum3 == 160)
                          {
                                Serial.println("Cartao Branco do FABI");
                                 lcd.clear();
                                 lcd.setCursor(0,0);
                                 lcd.print("Bem-Vindo");
                                 lcd.setCursor(5,1);
                                 lcd.print("Fabiano");                                 
                                 delay(2000);
                                 ativa_alarme();


                          }
                          if(pNum1 == 85)
                          {
                                 lcd.clear();
                                 lcd.setCursor(2,0);
                                 lcd.print("Ola Aluno da");
                                 lcd.setCursor(0,1);
                                 lcd.print("UNISAL de LORENA");                                 
                                 delay(3000);

                           }
                           if(pNum1 != 85 && pNum1 !=237)
                           {
                                 
                                 lcd.clear();
                                 lcd.setCursor(0,0);
                                 lcd.print("Cartao Desconhecido");
                                 lcd.setCursor(0,1);
                                 lcd.print("Tente outra vez");                                 
                                 
                                 delay(3000);
                                 
                           
                           }
                        
		}

		RC_size = MFRC522_SelectTag(serNum);
		if (RC_size != 0)

		{
                        Serial.print("The size of the card is  :   ");
			Serial.print(RC_size,DEC);
                        Serial.println(" K ");
		}
                
		
		blockAddr = 11;				
		status = MFRC522_Auth(PICC_AUTHENT1A, blockAddr, sectorKeyA[blockAddr/4], serNum);	
		if (status == MI_OK)
		{
			
			status = MFRC522_Write(blockAddr, sectorNewKeyA[blockAddr/4]);
                        Serial.print("set the new card password, and can modify the data of the Sector ");
                        Serial.print(blockAddr/4,DEC);
                        Serial.println(" : ");
			for (i=0; i<6; i++)
		        {
              		    Serial.print(sectorNewKeyA[blockAddr/4][i],HEX);
                            Serial.print(" , ");
		        }
                        Serial.println(" ");
                        blockAddr = blockAddr - 3 ; 
                        status = MFRC522_Write(blockAddr, writeData);
                        if(status == MI_OK)
                        {
                           Serial.println("You are B2CQSHOP VIP Member, The card has  $100 !");
                        }
		}

		
		blockAddr = 11;				
		status = MFRC522_Auth(PICC_AUTHENT1A, blockAddr, sectorNewKeyA[blockAddr/4], serNum);	
		if (status == MI_OK)
		{
			
                        blockAddr = blockAddr - 3 ; 
                        status = MFRC522_Read(blockAddr, str);
			if (status == MI_OK)
			{
                                Serial.println("Read from the card ,the data is : ");
				for (i=0; i<16; i++)
				{
              			      Serial.print(str[i],DEC);
                                      Serial.print(" , ");
				}
                                Serial.println(" ");
			}
		}

               
		blockAddr = 11;				
		status = MFRC522_Auth(PICC_AUTHENT1A, blockAddr, sectorNewKeyA[blockAddr/4], serNum);	
		if (status == MI_OK)
		{
			
                        blockAddr = blockAddr - 3 ;
			status = MFRC522_Read(blockAddr, str);
			if (status == MI_OK)
			{
                          if( str[15] < moneyConsume )
                          {
                              Serial.println(" The money is not enough !");
                          }
                          else
                          {
                              str[15] = str[15] - moneyConsume;
                              status = MFRC522_Write(blockAddr, str);
                              if(status == MI_OK)
                              {
                                 Serial.print("You pay $18 for items in B2CQSHOP.COM . Now, Your money balance is :   $");
              			 Serial.print(str[15],DEC);
                                 Serial.println(" ");
                              }
                          }
			}
		}

                	
		blockAddr = 11;				
		status = MFRC522_Auth(PICC_AUTHENT1A, blockAddr, sectorNewKeyA[blockAddr/4], serNum);
		if (status == MI_OK)
		{
			
                        blockAddr = blockAddr - 3 ;
			status = MFRC522_Read(blockAddr, str);
			if (status == MI_OK)
			{
                          tmp = (int)(str[15] + moneyAdd) ;
                          //Serial.println(tmp,DEC);
                          if( tmp < (char)254 )
                          {
                              Serial.println(" The money of the card can not be more than 255 !");
                          }
                          else
                          {
                              str[15] = str[15] + moneyAdd ;
                              status = MFRC522_Write(blockAddr, str);
                              if(status == MI_OK)
                              {
                                 Serial.print("You add $10 to your card in B2CQSHOP.COM , Your money balance is :  $");
              			 Serial.print(str[15],DEC);
                                 Serial.println(" ");
                              }
                          }
			}
		}
                Serial.println(" ");
		MFRC522_Halt();			            
          


/*
 * Write_MFRC5200
 * 
 * 
 *
 */}
void Write_MFRC522(uchar addr, uchar val)
{
	digitalWrite(chipSelectPin, LOW);

	
	SPI.transfer((addr<<1)&0x7E);	
	SPI.transfer(val);
	
	digitalWrite(chipSelectPin, HIGH);
}


/*
 * Read_MFRC522
 * 
 * 
 * 
 */
uchar Read_MFRC522(uchar addr)
{
	uchar val;

	digitalWrite(chipSelectPin, LOW);

	
	SPI.transfer(((addr<<1)&0x7E) | 0x80);	
	val =SPI.transfer(0x00);
	
	digitalWrite(chipSelectPin, HIGH);
	
	return val;	
}

/*
 *SetBitMask
 * 
 * 
 * 
 */
void SetBitMask(uchar reg, uchar mask)  
{
    uchar tmp;
    tmp = Read_MFRC522(reg);
    Write_MFRC522(reg, tmp | mask);  // set bit mask
}


/*
 * ClearBitMask
 * 
 * 
 * 
 */
void ClearBitMask(uchar reg, uchar mask)  
{
    uchar tmp;
    tmp = Read_MFRC522(reg);
    Write_MFRC522(reg, tmp & (~mask));  // clear bit mask
} 


/*
 * AntennaOn
 * 
 *
 * 
 */
void AntennaOn(void)
{
	uchar temp;

	temp = Read_MFRC522(TxControlReg);
	if (!(temp & 0x03))
	{
		SetBitMask(TxControlReg, 0x03);
	}
}


/*
 *：AntennaOff
 * 
 * 
 * 
 */
void AntennaOff(void)
{
	ClearBitMask(TxControlReg, 0x03);
}


/*
 * ResetMFRC522
 *
 * 
 * 
 */
void MFRC522_Reset(void)
{
    Write_MFRC522(CommandReg, PCD_RESETPHASE);
}


/*
 * InitMFRC522
 * 
 * 
 * 
 */
void MFRC522_Init(void)
{
	digitalWrite(NRSTPD,HIGH);

	MFRC522_Reset();
	 	
	//Timer: TPrescaler*TreloadVal/6.78MHz = 24ms
    Write_MFRC522(TModeReg, 0x8D);		//Tauto=1; f(Timer) = 6.78MHz/TPreScaler
    Write_MFRC522(TPrescalerReg, 0x3E);	//TModeReg[3..0] + TPrescalerReg
    Write_MFRC522(TReloadRegL, 30);           
    Write_MFRC522(TReloadRegH, 0);
	
	Write_MFRC522(TxAutoReg, 0x40);		//100%ASK
	Write_MFRC522(ModeReg, 0x3D);		

	//ClearBitMask(Status2Reg, 0x08);		//MFCrypto1On=0
	//Write_MFRC522(RxSelReg, 0x86);		//RxWait = RxSelReg[5..0]
	//Write_MFRC522(RFCfgReg, 0x7F);   		//RxGain = 48dB

	AntennaOn();		
}


/*
 * 函 数 名：MFRC522_Request
 * 
 *			 	0x4400 = Mifare_UltraLight
 *				0x0400 = Mifare_One(S50)
 *				0x0200 = Mifare_One(S70)
 *				0x0800 = Mifare_Pro(X)
 *				0x4403 = Mifare_DESFire
 * 
 */
uchar MFRC522_Request(uchar reqMode, uchar *TagType)
{
	uchar status;  
	uint backBits;			

	Write_MFRC522(BitFramingReg, 0x07);		//TxLastBists = BitFramingReg[2..0]	???
	
	TagType[0] = reqMode;
	status = MFRC522_ToCard(PCD_TRANSCEIVE, TagType, 1, TagType, &backBits);

	if ((status != MI_OK) || (backBits != 0x10))
	{    
		status = MI_ERR;
	}
   
	return status;
}


/*
 * MFRC522_ToCard
 *
 */
uchar MFRC522_ToCard(uchar command, uchar *sendData, uchar sendLen, uchar *backData, uint *backLen)
{
    uchar status = MI_ERR;
    uchar irqEn = 0x00;
    uchar waitIRq = 0x00;
    uchar lastBits;
    uchar n;
    uint i;

    switch (command)
    {
        case PCD_AUTHENT:		
		{
			irqEn = 0x12;
			waitIRq = 0x10;
			break;
		}
		case PCD_TRANSCEIVE:	
		{
			irqEn = 0x77;
			waitIRq = 0x30;
			break;
		}
		default:
			break;
    }
   
    Write_MFRC522(CommIEnReg, irqEn|0x80);	
    ClearBitMask(CommIrqReg, 0x80);			
    SetBitMask(FIFOLevelReg, 0x80);			//FlushBuffer=1, 
    
	Write_MFRC522(CommandReg, PCD_IDLE);	//NO action

	
    for (i=0; i<sendLen; i++)
    {   
		Write_MFRC522(FIFODataReg, sendData[i]);    
	}

	
	Write_MFRC522(CommandReg, command);
    if (command == PCD_TRANSCEIVE)
    {    
		SetBitMask(BitFramingReg, 0x80);		//StartSend=1,transmission of data starts  
	}   
    
	
	i = 2000;	
    do 
    {
		//CommIrqReg[7..0]
		//Set1 TxIRq RxIRq IdleIRq HiAlerIRq LoAlertIRq ErrIRq TimerIRq
        n = Read_MFRC522(CommIrqReg);
        i--;
    }
    while ((i!=0) && !(n&0x01) && !(n&waitIRq));

    ClearBitMask(BitFramingReg, 0x80);			//StartSend=0
	
    if (i != 0)
    {    
        if(!(Read_MFRC522(ErrorReg) & 0x1B))	//BufferOvfl Collerr CRCErr ProtecolErr
        {
            status = MI_OK;
            if (n & irqEn & 0x01)
            {   
				status = MI_NOTAGERR;			//??   
			}

            if (command == PCD_TRANSCEIVE)
            {
               	n = Read_MFRC522(FIFOLevelReg);
              	lastBits = Read_MFRC522(ControlReg) & 0x07;
                if (lastBits)
                {   
					*backLen = (n-1)*8 + lastBits;   
				}
                else
                {   
					*backLen = n*8;   
				}

                if (n == 0)
                {   
					n = 1;    
				}
                if (n > MAX_LEN)
                {   
					n = MAX_LEN;   
				}
				
				
                for (i=0; i<n; i++)
                {   
					backData[i] = Read_MFRC522(FIFODataReg);    
				}
            }
        }
        else
        {   
			status = MI_ERR;  
		}
        
    }
	
    //SetBitMask(ControlReg,0x80);           //timer stops
    //Write_MFRC522(CommandReg, PCD_IDLE); 

    return status;
}


/*
 *MFRC522_Anticoll
 * 
 */
uchar MFRC522_Anticoll(uchar *serNum)
{
    uchar status;
    uchar i;
	uchar serNumCheck=0;
    uint unLen;
    

    //ClearBitMask(Status2Reg, 0x08);		//TempSensclear
    //ClearBitMask(CollReg,0x80);			//ValuesAfterColl
	Write_MFRC522(BitFramingReg, 0x00);		//TxLastBists = BitFramingReg[2..0]
 
    serNum[0] = PICC_ANTICOLL;
    serNum[1] = 0x20;
    status = MFRC522_ToCard(PCD_TRANSCEIVE, serNum, 2, serNum, &unLen);

    if (status == MI_OK)
	{
		
		for (i=0; i<4; i++)
		{   
		 	serNumCheck ^= serNum[i];
		}
		if (serNumCheck != serNum[i])
		{   
			status = MI_ERR;    
		}
    }

    //SetBitMask(CollReg, 0x80);		//ValuesAfterColl=1

    return status;
} 


/*
 * CalulateCRC
 * 
 */
void CalulateCRC(uchar *pIndata, uchar len, uchar *pOutData)
{
    uchar i, n;

    ClearBitMask(DivIrqReg, 0x04);			//CRCIrq = 0
    SetBitMask(FIFOLevelReg, 0x80);			
    //Write_MFRC522(CommandReg, PCD_IDLE);

		
    for (i=0; i<len; i++)
    {   
		Write_MFRC522(FIFODataReg, *(pIndata+i));   
	}
    Write_MFRC522(CommandReg, PCD_CALCCRC);

	
    i = 0xFF;
    do 
    {
        n = Read_MFRC522(DivIrqReg);
        i--;
    }
    while ((i!=0) && !(n&0x04));			//CRCIrq = 1

	
    pOutData[0] = Read_MFRC522(CRCResultRegL);
    pOutData[1] = Read_MFRC522(CRCResultRegM);
}


/*
 *MFRC522_SelectTag
 * 
 */
uchar MFRC522_SelectTag(uchar *serNum)
{
    uchar i;
	uchar status;
	uchar size;
    uint recvBits;
    uchar buffer[9]; 

	//ClearBitMask(Status2Reg, 0x08);			//MFCrypto1On=0

    buffer[0] = PICC_SElECTTAG;
    buffer[1] = 0x70;
    for (i=0; i<5; i++)
    {
    	buffer[i+2] = *(serNum+i);
    }
	CalulateCRC(buffer, 7, &buffer[7]);		//??
    status = MFRC522_ToCard(PCD_TRANSCEIVE, buffer, 9, buffer, &recvBits);
    
    if ((status == MI_OK) && (recvBits == 0x18))
    {   
		size = buffer[0]; 
	}
    else
    {   
		size = 0;    
	}

    return size;
}


/*
 * MFRC522_Auth
 * 
 * 
 */
uchar MFRC522_Auth(uchar authMode, uchar BlockAddr, uchar *Sectorkey, uchar *serNum)
{
    uchar status;
    uint recvBits;
    uchar i;
	uchar buff[12]; 

	
    buff[0] = authMode;
    buff[1] = BlockAddr;
    for (i=0; i<6; i++)
    {    
		buff[i+2] = *(Sectorkey+i);   
	}
    for (i=0; i<4; i++)
    {    
		buff[i+8] = *(serNum+i);   
	}
    status = MFRC522_ToCard(PCD_AUTHENT, buff, 12, buff, &recvBits);

    if ((status != MI_OK) || (!(Read_MFRC522(Status2Reg) & 0x08)))
    {   
		status = MI_ERR;   
	}
    
    return status;
}


/*
 * MFRC522_Read
 * 
 */
uchar MFRC522_Read(uchar blockAddr, uchar *recvData)
{
    uchar status;
    uint unLen;

    recvData[0] = PICC_READ;
    recvData[1] = blockAddr;
    CalulateCRC(recvData,2, &recvData[2]);
    status = MFRC522_ToCard(PCD_TRANSCEIVE, recvData, 4, recvData, &unLen);

    if ((status != MI_OK) || (unLen != 0x90))
    {
        status = MI_ERR;
    }
    
    return status;
}


/*
 * MFRC522_Write
 * 
 */
uchar MFRC522_Write(uchar blockAddr, uchar *writeData)
{
    uchar status;
    uint recvBits;
    uchar i;
	uchar buff[18]; 
    
    buff[0] = PICC_WRITE;
    buff[1] = blockAddr;
    CalulateCRC(buff, 2, &buff[2]);
    status = MFRC522_ToCard(PCD_TRANSCEIVE, buff, 4, buff, &recvBits);

    if ((status != MI_OK) || (recvBits != 4) || ((buff[0] & 0x0F) != 0x0A))
    {   
		status = MI_ERR;   
	}
        
    if (status == MI_OK)
    {
        for (i=0; i<16; i++)		
        {    
        	buff[i] = *(writeData+i);   
        }
        CalulateCRC(buff, 16, &buff[16]);
        status = MFRC522_ToCard(PCD_TRANSCEIVE, buff, 18, buff, &recvBits);
        
		if ((status != MI_OK) || (recvBits != 4) || ((buff[0] & 0x0F) != 0x0A))
        {   
			status = MI_ERR;   
		}
    }
    
    return status;
}


/*
 * MFRC522_Halt
 * 
 */
void MFRC522_Halt(void)
{
	uchar status;
    uint unLen;
    uchar buff[4]; 

    buff[0] = PICC_HALT;
    buff[1] = 0;
    CalulateCRC(buff, 2, &buff[2]);
 
    status = MFRC522_ToCard(PCD_TRANSCEIVE, buff, 4, buff,&unLen);
}

 //Musica
 void som_alarme(){
   for (int thisNote = 0; thisNote < 8; thisNote++) {
    int noteDuration = 1000/noteDurations[thisNote];
    tone(8, melody[thisNote],noteDuration);
    int pauseBetweenNotes = noteDuration * 1.30;
    delay(pauseBetweenNotes);
    noTone(8);
  }
}



//Alarme
 void ativa_alarme(){
           digitalWrite(luminaria, LOW);
           valorLido_luminosidade = analogRead(LDR);
           lcd.clear();
           lcd.setCursor(0,0);
           lcd.print("Alarme Ativado");
           delay(200);
           while(valorLido_luminosidade < 100){
                
                for (int thisNote = 0; thisNote < 8; thisNote++) {
                int noteDuration = 1000/noteDurations[thisNote];
                tone(8, melody[thisNote],noteDuration);
                int pauseBetweenNotes = noteDuration * 1.30;
                delay(pauseBetweenNotes);
                noTone(8);
                }
                 digitalWrite(luminaria, HIGH);
                 lcd.clear();
                 lcd.setCursor(0,0);
                 lcd.print("Invasor");
                 lcd.setCursor(4,1);
                 lcd.print("Detectado");
                 delay(1000);


            }
            
           
      
 }
 
void lcd_alarme(){

}
 void desativa_alarme(){
//                status_alarme = 0;
                 digitalWrite(luminaria, HIGH);
                 lcd.clear();
                 lcd.setCursor(0,0);
                 lcd.print("Alarme");
                 lcd.setCursor(4,1);
                 lcd.print("Desativado");
                 delay(1000);              

}
void alarme_on(){
             digitalWrite(luminaria, LOW);
             valorLido_luminosidade = analogRead(LDR);
             lcd.clear();
             lcd.setCursor(0,0);
             lcd.print("Alarme Ativado");
             delay(2000);
//             digitalWrite(buzzer, LOW);
//             if (valorLido_luminosidade > 50){
//              digitalWrite(buzzer, HIGH);
//              }
//              else{
//              digitalWrite(buzzer, LOW);
//              }
}
void alarme_off(){
                 digitalWrite(luminaria, HIGH);
                 lcd.clear();
                 lcd.setCursor(0,0);
                 lcd.print("Alarme");
                 lcd.setCursor(4,1);
                 lcd.print("Desativado");
                 delay(1000);
}
void lampada1_on(){
 digitalWrite(lampada1, LOW);
}
void lampada1_off(){
digitalWrite(lampada1, HIGH);
}
void lampada2_on(){
digitalWrite(lampada2, LOW);
}
void lampada2_off(){
digitalWrite(lampada2, HIGH);
}
void lazer_on(){

}
void lazer_off(){

}
void lumi_on(){

}
void lumi_off(){

}
void temp_atual(){
                 valorLido_temp = analogRead(pinoSensor);
                 temperatura = (valorLido_temp * 0.00488);  // 5V / 1023 = 0.00488 (precisão do A/D)
                 temperatura = temperatura * 100; //Conv
                 lcd.clear();
                 lcd.setCursor(0,0);
                 lcd.print("Temperatura");
                 lcd.setCursor(2,1);
                 lcd.print("Atual");
                 lcd.setCursor(8,1);
                 lcd.print(temperatura);
                 lcd.setCursor(14,1);
                 lcd.print("C");
                 delay(2000);
}
