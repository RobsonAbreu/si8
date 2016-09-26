package br.com.fabianoacsx;

//Desenvolvido por Fabiano Silva
//fabianoacsx@gmail.com
//Finalizado em 13/11/2012


import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;


import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.os.Bundle;
import android.speech.RecognizerIntent;
import android.view.View;
import android.widget.Button;


public class App_CasaControl_v1Activity extends Activity {
	
	private static final int REQUEST_CODE = 1234;
    private String resultado1;
	Button botao1, botaoLigar, BotaoDesligar, botaoLampada;
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
     chama_principal();   
        	
    }
    
    public void chama_principal()
    {
        setContentView(R.layout.main);
        
        
        Button speakButton = (Button) findViewById(R.id.btComando);
        
        Button ChamaLamp = (Button) findViewById(R.id.btLampada);
        
        Button ChamaAlarme = (Button) findViewById(R.id.btAlarme);
        
        Button ChamaTemp = (Button) findViewById(R.id.btTemperatura);
        
        
        
        ChamaTemp.setOnClickListener(new View.OnClickListener() {
			
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				ClienteHttpGet clienteOFF = new ClienteHttpGet("http://192.168.0.155:8090/?CMD=TEMP"); //IP do arduino, requisição http para executar o comando
			}
		});
        
        ChamaAlarme.setOnClickListener(new View.OnClickListener() {
			
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				setContentView(R.layout.alarme);
				
				Button btVoltarMenu = (Button) findViewById(R.id.btVoltarMenu);
				
				btVoltarMenu.setOnClickListener(new View.OnClickListener() {
					
					public void onClick(View arg0) {
						// TODO Auto-generated method stub
						chama_principal();
					}
				});
				
				Button btAlarme1 = (Button) findViewById(R.id.btalarmeon);
		        Button btAlarme2 = (Button)findViewById(R.id.btalarmeoff);
		        
		        btAlarme1.setOnClickListener(new View.OnClickListener() {
					
					public void onClick(View arg0) {
						// TODO Auto-generated method stub
						ClienteHttpGet clienteOFF = new ClienteHttpGet("http://192.168.0.155:8090/?CMD=ALARMEON");
					}
				});
		        btAlarme2.setOnClickListener(new View.OnClickListener() {
					
					public void onClick(View arg0) {
						// TODO Auto-generated method stub
						ClienteHttpGet clienteOFF = new ClienteHttpGet("http://192.168.0.155:8090/?CMD=ALARMEOFF");
					}
				});
			}
		});
        
        ChamaLamp.setOnClickListener(new View.OnClickListener() {
			
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				setContentView(R.layout.lampada);
                Button btVoltarMenu1 = (Button) findViewById(R.id.btVoltarMenu1);
				
				btVoltarMenu1.setOnClickListener(new View.OnClickListener() {
					
					public void onClick(View arg0) {
						// TODO Auto-generated method stub
						chama_principal();
					}
				});
				
				Button btLigar = (Button) findViewById(R.id.button1);
		        Button btDesligar = (Button)findViewById(R.id.button2);
		        
		        Button btLigar2 = (Button) findViewById(R.id.button3);
		        Button btDesligar2 = (Button)findViewById(R.id.button4);
		        
		        
		        
		        btDesligar2.setOnClickListener(new View.OnClickListener() {
					
					public void onClick(View arg0) {
						// TODO Auto-generated method stub
						ClienteHttpGet clienteOFF = new ClienteHttpGet("http://192.168.0.155:8090/?CMD=L2OFF");
					}
				});
		        
		        btDesligar.setOnClickListener(new View.OnClickListener() {
					
					public void onClick(View arg0) {
						// TODO Auto-generated method stub
						ClienteHttpGet clienteOFF = new ClienteHttpGet("http://192.168.0.155:8090/?CMD=L1OFF");
					}
				});
		        
		        btLigar2.setOnClickListener(new View.OnClickListener() {
					
					public void onClick(View arg0) {
						// TODO Auto-generated method stub
						ClienteHttpGet clienteON = new ClienteHttpGet("http://192.168.0.155:8090/?CMD=L2ON");
					}
				});
		        
		        btLigar.setOnClickListener(new View.OnClickListener() {
					
					public void onClick(View arg0) {
						// TODO Auto-generated method stub
						ClienteHttpGet clienteON = new ClienteHttpGet("http://192.168.0.155:8090/?CMD=L1ON");
					}
				});
			}
		});
		
        PackageManager pm = getPackageManager();
        List<ResolveInfo> activities = pm.queryIntentActivities(
                new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH), 0);
        if (activities.size() == 0)
        {
            speakButton.setEnabled(false);
            speakButton.setText("Recurso Inativo!");
        }
        
    }
    
    /**
     * Handle the action of the button being clicked
     */
    public void speakButtonClicked(View v)
    {
        startVoiceRecognitionActivity();
    }
 
    /**
     * Fire an intent to start the voice recognition activity.
     */
    private void startVoiceRecognitionActivity()
    {
        Intent intent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL,
                RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
        intent.putExtra(RecognizerIntent.EXTRA_PROMPT, "Aguardando Comando...");
        startActivityForResult(intent, REQUEST_CODE);
    }
 
    /**
     * Comando de voz para executar comandos no arduino
     */
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data)
    {
        if (requestCode == REQUEST_CODE && resultCode == RESULT_OK)
        {   
        	        	
        	// Populate the wordsList with the String values the recognition engine thought it heard
            ArrayList<String> matches = data.getStringArrayListExtra(
                    RecognizerIntent.EXTRA_RESULTS);
                
                resultado1 = matches.toString();
                String resultadosSeparados[] = resultado1.split(Pattern.quote(","));
                
                String resulSeparado1 = resultadosSeparados[0];
                String resulSeparado2 = resultadosSeparados[1];
                String resulSeparado3 = resultadosSeparados[2];
                
                                
                           
                String abrirPortas1 = "acender lâmpada";
                String abrirPortas2 = "acender lampada";
                String abrirPortas3 = "[acender lâmpada";
                String abrirPortas4 = "liga";
                
                String desligaLampada1 = "apagar lâmpada";
                String desligaLampada2 = "apagar lampada";
                String desligaLampada3 = "[apagar lâmpada";
                String desligaLampada4 = "desliga";
                
                              
                if(        resulSeparado1.equalsIgnoreCase(abrirPortas1) 
                		|| resulSeparado1.equalsIgnoreCase(abrirPortas2)
                		|| resulSeparado1.equalsIgnoreCase(abrirPortas3)
                		|| resulSeparado1.equalsIgnoreCase(abrirPortas4)
                		
                		|| resulSeparado2.equalsIgnoreCase(abrirPortas1)
                		|| resulSeparado2.equalsIgnoreCase(abrirPortas2)
                		|| resulSeparado2.equalsIgnoreCase(abrirPortas3)
                		|| resulSeparado2.equalsIgnoreCase(abrirPortas4)
                		
                		|| resulSeparado3.equalsIgnoreCase(abrirPortas1)
                		|| resulSeparado3.equalsIgnoreCase(abrirPortas2)
                		|| resulSeparado3.equalsIgnoreCase(abrirPortas3)
                		|| resulSeparado3.equalsIgnoreCase(abrirPortas4)
                )
                {
                	msgReconhecimento("Executando", "Comando Aceito!");
                	
                	ClienteHttpGet clienteON = new ClienteHttpGet("http://192.168.0.155:8090/?CMD=L1ON");
                    clienteON.fim();
                	
                }                
                else if(resulSeparado1.equalsIgnoreCase(desligaLampada1) 
                		|| resulSeparado1.equalsIgnoreCase(desligaLampada2)
                		|| resulSeparado1.equalsIgnoreCase(desligaLampada3)
                		|| resulSeparado1.equalsIgnoreCase(desligaLampada4)
                		|| resulSeparado2.equalsIgnoreCase(desligaLampada1)
                		|| resulSeparado2.equalsIgnoreCase(desligaLampada2)
                		|| resulSeparado2.equalsIgnoreCase(desligaLampada3)
                		|| resulSeparado2.equalsIgnoreCase(desligaLampada4)
                		|| resulSeparado3.equalsIgnoreCase(desligaLampada1)
                		|| resulSeparado3.equalsIgnoreCase(desligaLampada2)
                		|| resulSeparado3.equalsIgnoreCase(desligaLampada3)
                		|| resulSeparado3.equalsIgnoreCase(desligaLampada4)
                )
                {
                	msgReconhecimento("Executando", "Comando Aceito! 2");
                	
                	ClienteHttpGet clienteOFF = new ClienteHttpGet("http://192.168.0.155:8090/?CMD=L1OFF");
                    clienteOFF.fim();
                }
                else
                {
                	msgReconhecimento("Aviso", "Não reconheceu o Comando!");
                }
                          
            }
            
        
        super.onActivityResult(requestCode, resultCode, data);
    }
    
    public void msgReconhecimento(String titulo, String texto)
    {
    	AlertDialog.Builder mensagem = new AlertDialog.Builder(App_CasaControl_v1Activity.this);
    	mensagem.setTitle(titulo);
    	mensagem.setMessage(texto);
    	mensagem.setNeutralButton("Ok", null);
    	mensagem.show();
    	
    }   
}
