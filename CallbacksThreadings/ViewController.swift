//
//  ViewController.swift
//  CallbacksThreadings
//
//  Created by Lucas Caron Albarello on 02/12/17.
//  Copyright © 2017 Lucas Caron Albarello. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var produtosNome = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //getProdutos()
        getProdutos { (success, response, error) in
            if success {
                guard let nomes = response as? [String] else{return}
                self.produtosNome = nomes
                self.tableView.reloadData()
            } else {
                print(error)
            }
        }
    }

    func getProdutos(completion: @escaping (Bool, Any?, Error? )-> Void){
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            guard let path = Bundle.main.path(forResource: "data", ofType: "txt") else {return}
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                guard let array = json as? [[String: Any]] else {return}
                var nomes = [String]()
                for produto in array{
                    guard let nome = produto["nome"] as? String else {continue}
                    nomes.append(nome)
                }
                DispatchQueue.main.async {
                    completion(true, nomes, nil )
                }
                //print(nomes)
            } catch  {
                print(error)
                DispatchQueue.main.async {
                    completion(false, nil, error)
                }
                
            }
        }

        }
        
}

extension ViewController : UITableViewDataSource{
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.produtosNome.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = produtosNome[indexPath.row]
        return cell
    }
}
