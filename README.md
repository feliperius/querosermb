# 🚀 QueroSerMB - Desafio Flutter Mercado Bitcoin

<div align="center">
  <h3>🏆 Aplicativo desenvolvido para o desafio técnico do Mercado Bitcoin</h3>
  <p>Explore exchanges de criptomoedas com dados em tempo real da CoinMarketCap</p>
</div>

---

## 📱 Sobre o Projeto

O **QueroSerMB** é um aplicativo Flutter que permite consultar e visualizar informações detalhadas sobre exchanges de criptomoedas utilizando a API da CoinMarketCap. O projeto foi desenvolvido seguindo as melhores práticas de arquitetura clean. 

### ✨ Funcionalidades

- 📊 **Lista de Exchanges**: Visualize todas as exchanges disponíveis
- 🔍 **Detalhes Completos**: Informações detalhadas de cada exchange
- 💰 **Moedas Suportadas**: Lista de criptomoedas com preços em USD
- 🎨 **Interface Intuitiva**: Design moderno seguindo Material Design 3
- ⚡ **Performance Otimizada**: Cache de imagens e carregamento eficiente
---

## 🏗️ Arquitetura

O projeto segue os princípios da **Clean Architecture** com **Flutter BLoC** para gerenciamento de estado:

```
lib/
├── core/
│   └── dependency_injection.dart
├── features/
│   └── exchanges/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── bloc/
│           └── pages/
└── main.dart
```

## 🚀 Como Executar

### Pré-requisitos

- Flutter SDK (versão 3.8.1 ou superior)
- Dart SDK
- Android Studio / VS Code
- API Key da CoinMarketCap

### 📦 Instalação

1. **Clone o repositório**
   ```bash
   git clone https://github.com/feliperius/querosermb.git
   cd querosermb
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Execute o aplicativo**
   ```bash
   flutter run
   ```

---

## 👨‍💻 Desenvolvedor
**Felipe Perius**
Desenvolvedor Mobile com 10+ anos de experiência, sou entusiasta do mundo cripto, já trabalhei em aplicativos de grandes empresas brasileira como Pagbank,XP,Rico,Caixa Seguros entre outros. Estou entusiasmado com a oportunidade de contribuir com o time do Mercado Bitcoin.
## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---