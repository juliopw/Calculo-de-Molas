//
//  AppDelegate.swift
//  Molas
//
//  Created on 5/18/15.
//  Copyright (c) 2015 EMaq. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var window: NSWindow!
    
    
    
    // Declaração dos campos de texto, botões e tabela
    
    @IBOutlet weak var textField1: NSTextField!
    @IBOutlet weak var label1: NSTextField! // Força aplicada
    @IBOutlet weak var menuUnidadeForca: NSPopUpButton!
    
    @IBOutlet weak var textField2: NSTextField!
    @IBOutlet weak var label2: NSTextField! // Diâmetro da Espira
    @IBOutlet weak var menuUnidadeD: NSPopUpButton!
    
    @IBOutlet weak var textField3: NSTextField!
    @IBOutlet weak var label3: NSTextField! // Diâmetro do fio
    @IBOutlet weak var menuUnidadeDiametroFio: NSPopUpButton!
    
    @IBOutlet weak var textField4: NSTextField!
    @IBOutlet weak var label4: NSTextField! // Deformação Máxima
    @IBOutlet weak var menuUnidadeDeformacao: NSPopUpButton!
    
    @IBOutlet weak var textField5: NSTextField!
    @IBOutlet weak var label5: NSTextField! // Módulo de Elasticidade (E)
    @IBOutlet weak var menuUnidadeModuloE: NSPopUpButton!
    
    @IBOutlet weak var textField6: NSTextField!
    @IBOutlet weak var label6: NSTextField! // Módulo de Rigidez (G)
    @IBOutlet weak var menuUnidadeModuloG: NSPopUpButton!
    
    @IBOutlet weak var calcular: NSButton! // Botão que chama a função calcularMola
    
    @IBOutlet weak var menuEscolherMaterial: NSPopUpButton!
    @IBOutlet weak var labelMaterial: NSTextField! // Escolha do material
    
    @IBOutlet weak var menuEscolherFixacao: NSPopUpButton!
    @IBOutlet weak var labelFixacao: NSTextField! // Excolha do tipo de fixação
    
    
    @IBOutlet weak var menuExtremidade: NSPopUpButton!
    @IBOutlet weak var labelExtremidade: NSTextField! // Excolha do tipo de extremidade
    
    @IBOutlet weak var myTableView: NSTableView!

    
    // ------------ TABELA -------------
    
    var resultado: [NSArray] = [] // Resultado do cálculo. Variável vazia que é preenchida pela função CalcularMola
    
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int
    {
        return 9 // Numero de linhas
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        var result: AnyObject = ""
        var linhas = ["d", "D", "C", "OD", "Na", "Lo", "Ls", "Locr", "fom"]
        
        var columnIdentifier = tableColumn!.identifier
        
        if columnIdentifier == "0" {
            result = linhas[row]
        }
        
        if resultado.count != 0 {
           
            if columnIdentifier == "1" {
                result = resultado[0][row][0]
            }
            if columnIdentifier == "2" {
                result = resultado[1][row][0]
            }
            if columnIdentifier == "3" {
                result = resultado[2][row][0]
            }
            if columnIdentifier == "4" {
                result = resultado[3][row][0]
            }
            if columnIdentifier == "5" {
                result = resultado[4][row][0]
            }
        }
        
        return result
    }
    
    // ------------ FIM DA TABELA -------------
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Código executado ao iniciar a aplicação
        
        // Atribui os valores aos respectivos campos de texto
        label1.stringValue = "Força Máxima"
        label2.stringValue = "Diâmetro da Espira"
        label3.stringValue = "Diâmetro do Fio"
        label4.stringValue = "Deformação Máxima"
        label5.stringValue = "Módulo de Elasticidade (E)"
        label6.stringValue = "Módulo de Rigidez (G)"
        labelMaterial.stringValue = "Material"
        labelFixacao.stringValue = "Fixação"
        labelExtremidade.stringValue = "Extremidade"
        
        
        unidades()
        var modulos = retornarModulos("batata")
        self.menuEscolherMaterial.selectItemWithTitle("Personalizado")
        var fixacao = retornarFixacao("batata")
        
        menuExtremidade.addItemWithTitle("Plana")
        menuExtremidade.addItemWithTitle("Plana e Esmerilhada")
        menuExtremidade.addItemWithTitle("Esquadrada ou Fechada")
        menuExtremidade.addItemWithTitle("Esquadrada ou Esmerilhada")
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        
    }
    
    func applicationShouldHandleReopen(theApplication: NSApplication,hasVisibleWindows flag: Bool) -> Bool {
        window.makeKeyAndOrderFront(self)
        return true
    }   // Faz com que a janela do aplicativo retorne após fechada
    

    
    func unidades() {
        
        menuUnidadeForca.addItemWithTitle("N")
        menuUnidadeForca.addItemWithTitle("kN") // Força
        
        menuUnidadeD.addItemWithTitle("mm") // Espira
        menuUnidadeD.addItemWithTitle("m")
        
        menuUnidadeDiametroFio.addItemWithTitle("mm") // Fio
        menuUnidadeDiametroFio.addItemWithTitle("m")
        
        menuUnidadeDeformacao.addItemWithTitle("mm") // Deformação
        menuUnidadeDeformacao.addItemWithTitle("m")
        
        menuUnidadeModuloE.addItemWithTitle("GPa")
        menuUnidadeModuloE.addItemWithTitle("MPa")
        menuUnidadeModuloE.addItemWithTitle("Pa") // Modulo de Elasticidade
        
        menuUnidadeModuloG.addItemWithTitle("GPa")
        menuUnidadeModuloG.addItemWithTitle("MPa")
        menuUnidadeModuloG.addItemWithTitle("Pa") // Modulo de Rigidez
    }
    
    func retornarModulos(matEscolhido: NSString) -> NSArray {
        // Busca no arquivo Materiais.plist as informações relativas a cada material
        
        
        var localMateriais = NSBundle.mainBundle().pathForResource("Materiais", ofType: "plist")
        var materiais = NSDictionary(contentsOfFile: localMateriais!)
        // Salva as informações do arquivo numa variável
        
        
        var moduloElasticidade = materiais?.objectForKey("Modulo Elasticidade") as! NSDictionary
        var moduloRigidez = materiais?.objectForKey("Modulo Rigidez") as! NSDictionary
        var custoRelativo = materiais?.objectForKey("Custo Relativo") as! NSDictionary
        // Busca na lista de materiais as propriedades E e G
        
        if menuEscolherMaterial.numberOfItems == 0 {
            var numeroDeMateriais = moduloElasticidade.count
            
            for var i = 0; i < numeroDeMateriais; i++ {
                
                if i == 0 {
                    menuEscolherMaterial.addItemWithTitle("Personalizado")
                    var tituloMaterial = Array(moduloElasticidade)[i].0 as! String
                    menuEscolherMaterial.addItemWithTitle(tituloMaterial)
                } else {
                    var tituloMaterial = Array(moduloElasticidade)[i].0 as! String
                    menuEscolherMaterial.addItemWithTitle(tituloMaterial)
                }
            }
        }
        
        var materialEscolhido: NSArray
        
        if matEscolhido == "batata" {
            materialEscolhido = [moduloElasticidade.objectForKey(Array(moduloElasticidade)[0].0 as! String) as! Double,
                                 moduloRigidez.objectForKey(Array(moduloRigidez)[0].0 as! String) as! Double,
                                 custoRelativo.objectForKey(Array(custoRelativo)[0].0 as! String) as! Double]
        } else {
            materialEscolhido = [moduloElasticidade.objectForKey(matEscolhido) as! Double,
                                 moduloRigidez.objectForKey(matEscolhido) as! Double,
                                 custoRelativo.objectForKey(matEscolhido) as! Double]
        }   // Contém E e G e Custo Relativo, respectivmente, no formato [E, G, custoRelativo]

        return (materialEscolhido)
    }
    
    
    
    @IBAction func menuEscolherMaterial(sender: NSPopUpButton) {
        var itemSelecionado: String = menuEscolherMaterial.selectedItem!.title
        
        if itemSelecionado == "Personalizado" {
            self.textField5.enabled = true
            self.menuUnidadeModuloE.enabled = true
            self.textField6.enabled = true
            self.menuUnidadeModuloG.enabled = true
        } else {
            var modulos = retornarModulos(itemSelecionado)
            textField5.stringValue = "\(modulos[0])"
            self.menuUnidadeModuloE.enabled = false
            self.menuUnidadeModuloE.selectItemWithTitle("GPa")
            self.textField5.enabled = false
            textField6.stringValue = "\(modulos[1])"
            self.menuUnidadeModuloG.selectItemWithTitle("GPa")
            self.menuUnidadeModuloG.enabled = false
            self.textField6.enabled = false
        }
        
    }
    
    func retornarFixacao(fixEscolhida: NSString) -> Double {
        // Busca no arquivo Extremidades.plist as informações relativas a cada material
        
        
        var localFixacao = NSBundle.mainBundle().pathForResource("Fixacao", ofType: "plist")
        var fixacao = NSDictionary(contentsOfFile: localFixacao!)
        // Salva as informações do arquivo numa variável
        
        
        var valorAlfa = fixacao?.objectForKey("Valor de alfa") as! NSDictionary
        // Busca na lista de fixação os valores de alfa
        
        
        if menuEscolherFixacao.numberOfItems == 0 {
            var numeroDeTipos = valorAlfa.count
            
            for var i = 0; i < numeroDeTipos; i++ {

                    var tituloFixacão = Array(valorAlfa)[i].0 as! String
                    menuEscolherFixacao.addItemWithTitle(tituloFixacão)
            }
        }
        
        var fixacaoEscolhida: Double = 0
        
        if fixEscolhida == "batata" {
            fixacaoEscolhida = valorAlfa.objectForKey(Array(valorAlfa)[0].0 as! String) as! Double
        } else {
            fixacaoEscolhida = valorAlfa.objectForKey(fixEscolhida) as! Double
        }
        
        return (fixacaoEscolhida)
    }
    
    
    @IBAction func calcularMola(sender: AnyObject) {
        
        var forcaMax = textField1.doubleValue
        var D = textField2.doubleValue / 1000
        var diametroFio = textField3.doubleValue / 1000
        var deformacaoMax = textField4.doubleValue / 1000
        var moduloE = textField5.doubleValue * pow(10, 9)
        var moduloG = textField6.doubleValue * pow(10, 9)
        var custoRelativo: Double
        
        var valorSubtracao = [0.4 / 1000, 0.2 / 1000]
        
        if menuUnidadeForca.selectedItem?.title == "kN" {
            forcaMax = 1000 * textField1.doubleValue
        }
        
        if menuUnidadeD.selectedItem?.title == "m" {
            D = textField2.doubleValue
        }
        
        if menuUnidadeDiametroFio.selectedItem?.title == "m" {
            diametroFio = textField3.doubleValue
            valorSubtracao = [0.4, 0.2]
        }
        
        if menuUnidadeDeformacao.selectedItem?.title == "m" {
            deformacaoMax = textField4.doubleValue
        }
        
        if menuUnidadeModuloE.selectedItem?.title == "Pa" {
            moduloE = textField5.doubleValue
        } else if menuUnidadeModuloE.selectedItem?.title == "MPa" {
            moduloE = textField5.doubleValue * pow(10, 6)
        }
        
        if menuUnidadeModuloG.selectedItem?.title == "Pa" {
            moduloG = textField6.doubleValue
        } else if menuUnidadeModuloG.selectedItem?.title == "MPa" {
            moduloG = textField6.doubleValue * pow(10, 6)
        }
        
        if menuEscolherMaterial.selectedItem!.title == "Personalizado" {
            custoRelativo = 1
        } else {
            custoRelativo = retornarModulos(menuEscolherMaterial.selectedItem!.title)[2] as! Double
        }
        
        
        var α = retornarFixacao(menuEscolherFixacao.selectedItem!.title) as Double
        
        let ε = 0.15
        let π = M_PI
        
        var d: Double
        var C: Double
        var k: Double
        var Fs: Double
        var Na: Double
        var Kb: Double
        var T: Double
        var OD: Double
        var ID: Double
        var Ne: Int = 0
        var Nt: Double = 0
        var Lo: Double = 0
        var Ls: Double = 0
        var p: Double = 0
        var Locr: Double
        var fom: Double
        
        var resultadoIteracao: [NSArray] = []
        resultado = []
        
        
        
        
        for var i = 0; i < 5; i++ {
            
            d = (abs(diametroFio - valorSubtracao[0]))
            valorSubtracao[0] = valorSubtracao[0] - valorSubtracao[1]
            
            C = D/d
            
            k = forcaMax/deformacaoMax
            
            Fs = (1 + ε)*forcaMax
            
            Na = (moduloG*pow(d, 4))/(8*pow(D, 3)*k)
            
            Kb = (4*C + 2)/(4*C - 3)
            
            T = Kb*8*(1+ε)*((forcaMax*D)*(π*pow(d, 3))) // Pa
            
            OD = D + d
            
            ID = D - d
            
            Locr = 2.63*(D/α)
            
            if menuExtremidade.selectedItem?.title == "Plana" {
                
                Ne = 0
                
                Nt = Na
                
                Ls = d*(Nt + 1)
                
                Lo = deformacaoMax + Ls
                
                p = (Lo - d)/Na
                
            } else if menuExtremidade.selectedItem?.title == "Plana e Esmerilhada" {
                
                Ne = 1
                
                Nt = Na+1
                
                Ls = d*Nt
                
                Lo = deformacaoMax + Ls
                
                p = (Lo/(Na+1))
                
            } else if menuExtremidade.selectedItem?.title == "Esquadrada ou Fechada" {
                
                Ne = 2
                
                Nt = Na+2
                
                Ls = d*(Nt + 1)
                
                Lo = deformacaoMax + Ls
                
                p = (Lo - 3*d)/Na
                
            } else if menuExtremidade.selectedItem?.title == "Esquadrada ou Esmerilhada" {
                
                Ne = 2
                
                Nt = Na+2
                
                Ls = d*Nt
                
                Lo = deformacaoMax + Ls
                
                p = (Lo - 2*d)/Na
                
            }
            
            println(Nt)
            
            fom = -(pow(π, 2)*pow(d, 2)*Nt*D)/4;
            
            resultadoIteracao =        [[d],                // [i][0][0]
                                        [D],                // [i][1][0]
                                        [C],                // [i][2][0]
                                        [OD],               // [i][3][0]
                                        [Na],               // [i][4][0]
                                        [Lo],               // [i][5][0]
                                        [Ls],               // [i][6][0]
                                        [Locr],             // [i][7][0]
                                        [fom]]              // [i][8][0]
                
            
            resultado += [resultadoIteracao] as [NSArray]
            
            println(resultado[i][0][0])
            
            self.myTableView.reloadData()
        }
        
    }

}