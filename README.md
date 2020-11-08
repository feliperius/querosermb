# **DESAFIO Quero Ser MB - Felipe Perius**

Objetivo do projeto é testar os conhecimentos do canditado sobre a estrutura MVVM e consumo assíncrono de APIs e habilidades para construção de aplicativos para plataforma iOS .

## Começando
Estas instruções irão levá-lo a uma cópia do projeto em funcionamento em sua máquina local para fins de desenvolvimento e teste.

### Pré-requisitos
O que você precisa para construir, executar e testar o aplicativo:
Xcode 11.0 ou posterior. 
O Deployment target está configurando pra suporta iOS 11.0 ou posterior.

Faça o clone do repositório em sua máquina local.

 Depois será necessario a instalação das dependências com o comando:
```bash
$ pod install
```

Em seguida, abra o projeto no Xcode:
open QueroSerMBDesafio.xcworkspace Agora você está pronto para começar.

# Quero ser MB

### **O MB**
Somos a maior plataforma de negociação de criptomoedas e ativos alternativos da América Latina, criada para elevar a experiência de quem vivencia essa revolução, entregando o melhor serviço de negociação de ativos alternativos, com liberdade, segurança e liquidez. Sendo assim, nós existimos para mudar a maneira como as pessoas lidam com o dinheiro através da tecnologia.

### **Desafio**
Criar um aplicativo para consultar a [CoinAPI.io](https://docs.coinapi.io/#list-all-exchanges) e trazer as moedas em forma de lista. Fique livre para criar, porém pode também utilizar como base a tela principal do MB atualmente:

![Simulator Screen Shot - iPhone 11 Pro Max - 2020-07-08 at 17 25 15](https://user-images.githubusercontent.com/63304092/86969836-c711f080-c144-11ea-8421-796efd4a3011.png)

### **Must Have**
-   **Lista de moedas**
	- Paginação com scroll infinito
    - Pull to refresh
    - Exibir, pelo menos, os campos: "name", "exchange_id" e "volume_1day_usd"
    - Ao tocar em um item, deve mostrar os detalhes da moeda
-   **Detalhe da moeda**
    - Criar uma tela que mostre mais informações sobre a moeda

### **Nice to Have**
- Adicionar imagens para as moedas e mantê-las em cache

### **Requisitos Técnicos (iOS)**
- MVVM-C
- Swift 5
- i18n (Localizable)
- View Code
- CocoaPods com Alamofire
- Codable
- Testes UI/Unitários
- Versão mínima: iOS 11
- gitignore

### **Processo de Submissão**
O candidato deverá implementar a solução e enviar um pull request para este repositório com a solução.

O processo de Pull Request funciona da seguinte maneira:
1.  O candidato fará um fork desse repositório **(não irá clonar direto!)**
2.  Fará seu projeto nesse fork
3.  Fará um commit e subirá as alterações para o  **SEU**  fork
4.  Enviar um pull request pela interface do Github

### **PS**
Importante frisar que esse código não será usado em nenhuma hipótese para qualquer fim a não ser o de avaliação dos conhecimentos do candidato.
