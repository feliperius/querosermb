# Golden Tests

Este diretório contém os golden tests (testes de regressão visual) para o projeto QueroSerMB.

## Estrutura

```
test/golden/
├── README.md                          # Este arquivo
├── golden_test_helper.dart           # Utilitários para golden tests
├── goldens/                          # Imagens de referência
├── widgets/                          # Testes de widgets individuais
│   ├── exchange_list_item_golden_test.dart
│   ├── loading_widgets_golden_test.dart
│   └── error_widget_golden_test.dart
└── screens/                          # Testes de telas completas
    └── home_page_golden_test.dart
```

## O que são Golden Tests?

Golden tests são testes que comparam a renderização visual atual de um widget com uma imagem de referência (golden file). Eles são úteis para:

- **Detectar regressões visuais**: Mudanças não intencionais na UI
- **Documentar aparência**: Servem como documentação visual
- **Validar temas**: Garantir consistência visual
- **Testar layouts responsivos**: Verificar diferentes tamanhos de tela

## Como Executar

### Executar todos os golden tests
```bash
flutter test test/golden/
```

### Executar testes específicos
```bash
# Widgets individuais
flutter test test/golden/widgets/

# Telas completas
flutter test test/golden/screens/

# Teste específico
flutter test test/golden/widgets/exchange_list_item_golden_test.dart
```

### Gerar/Atualizar imagens golden
```bash
# Primeira execução ou quando precisar atualizar as imagens
flutter test --update-goldens test/golden/

# Atualizar apenas um teste específico
flutter test --update-goldens test/golden/widgets/exchange_list_item_golden_test.dart
```

## Boas Práticas

### 1. Estrutura dos Testes
- Use `GoldenTestHelper.wrapWidget()` para widgets isolados
- Use `GoldenTestHelper.wrapListItem()` para itens de lista
- Use `GoldenTestHelper.wrapScreen()` para telas completas

### 2. Tamanhos Fixos
Sempre defina tamanhos fixos para garantir consistência:
```dart
final widget = GoldenTestHelper.wrapWidget(
  SizedBox(
    width: 400,
    height: 200,
    child: MyWidget(),
  ),
);
```

### 3. Dados de Teste
Use dados consistentes e representativos:
```dart
const exchange = Exchange(
  id: 1,
  name: 'Binance',
  logo: 'https://example.com/binance.png',
  spotVolumeUsd: 1000000000.0,
  // ...
);
```

### 4. Múltiplos Cenários
Teste diferentes estados do widget:
- Estado normal
- Estado com dados mínimos
- Estado com dados máximos
- Estados de erro
- Estados de loading

## Organização dos Arquivos

### Naming Convention
- Arquivo de teste: `{widget_name}_golden_test.dart`
- Imagem golden: `goldens/{widget_name}_{scenario}.png`

Exemplos:
- `exchange_list_item_golden_test.dart`
- `goldens/exchange_list_item_complete.png`
- `goldens/exchange_list_item_minimal.png`

### Cenários Testados

#### ExchangeListItem
- ✅ `complete`: Dados completos
- ✅ `minimal`: Dados mínimos (sem logo, volume, etc.)
- ✅ `long_name`: Nome muito longo
- ✅ `zero_volume`: Volume zero

#### Loading Widgets
- ✅ `loading_widget`: Widget de loading principal
- ✅ `loading_more_widget`: Widget de loading para paginação

#### Error Widgets
- ✅ `error_widget_short`: Mensagem de erro curta
- ✅ `error_widget_long`: Mensagem de erro longa

#### HomePage
- ✅ `loading`: Estado de carregamento
- ✅ `loaded`: Lista de exchanges carregada
- ✅ `error`: Estado de erro
- ✅ `empty`: Lista vazia

## Troubleshooting

### Teste falhando após mudança na UI
1. Verifique se a mudança é intencional
2. Se sim, atualize os goldens:
   ```bash
   flutter test --update-goldens test/golden/
   ```

### Inconsistências entre plataformas
Golden tests podem ter pequenas diferenças entre macOS, Linux e Windows devido a:
- Renderização de fontes
- Anti-aliasing
- Cores do sistema

**Solução**: Execute os testes na mesma plataforma do CI/CD.

### Imagens muito grandes
- Use tamanhos específicos e menores
- Teste apenas a parte relevante do widget
- Considere quebrar em testes menores

## Integração com CI/CD

No CI/CD, execute:
```bash
# Falha se há diferenças visuais
flutter test test/golden/

# NUNCA execute --update-goldens no CI
```

## Manutenção

### Quando atualizar goldens?
- Mudanças intencionais no design
- Atualizações do Flutter que afetam renderização
- Mudanças no tema da aplicação

### Revisão de goldens
- Sempre revise as imagens antes de commitar
- Compare lado a lado: antes vs depois
- Verifique se a mudança faz sentido

## Ferramentas Úteis

### Helper Methods
```dart
// Wrapper básico
GoldenTestHelper.wrapWidget(widget)

// Wrapper para itens de lista
GoldenTestHelper.wrapListItem(widget)

// Wrapper para telas
GoldenTestHelper.wrapScreen(screen)

// Pump and settle
GoldenTestHelper.pumpAndSettle(tester, widget)
```

### Dados de Teste
```dart
// Dados mock consistentes
final testData = GoldenTestHelper.createTestData();
```

## Próximos Passos

### Widgets para adicionar golden tests:
- [ ] ExchangeDetailPage
- [ ] ExchangeAssetsWidget
- [ ] SimpleExchangeAssetsWidget
- [ ] Asset list items
- [ ] Skeleton loading widgets
- [ ] App bar widgets

### Melhorias:
- [ ] Testes para diferentes tamanhos de tela
- [ ] Testes para modo escuro vs claro
- [ ] Testes de acessibilidade visual
- [ ] Automação de geração de goldens
