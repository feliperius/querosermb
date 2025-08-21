class AppStrings {
  // App
  static const String appTitle = 'QueroSerMB';
  
  // Home
  static const String homeTitle = 'Desafio MB';
  static const String refreshTooltip = 'Atualizar';
  
  // Exchange Details
  static const String exchangeDetailsTitle = 'Detalhes da Exchange';
  static const String loadingExchange = 'Carregando Exchange';
  static const String searchingDetailedInfo = 'Buscando informações detalhadas...';
  static const String errorLoadingDetails = 'Erro ao carregar detalhes';
  static const String tryAgain = 'Tentar novamente';
  static const String unrecognizedState = 'Estado não reconhecido';
  
  // Skeleton Loading
  static const String informationsSkeleton = 'Informações';
  static const String feesSkeleton = 'Taxas';
  static const String assetsSkeletonTitle = 'Assets da Exchange';
  
  // Loading Steps
  static const String dataStep = 'Dados';
  static const String assetsStep = 'Assets';
  static const String uiStep = 'UI';
  
  // Exchange Information
  static const String idLabel = 'ID: ';
  static const String launchedAtLabel = 'Lançado em: ';
  static const String makerFeeLabel = 'Maker Fee';
  static const String takerFeeLabel = 'Taker Fee';
  static const String coinsLabel = 'Moedas';
  static const String informationsTitle = 'Informações';
  static const String descriptionLabel = 'Descrição';
  static const String websiteLabel = 'Website';
  static const String launchDateLabel = 'Data de Lançamento';
  static const String feesTitle = 'Taxas';
  static const String notAvailable = 'N/A';
  
  // Assets
  static const String assetsTitle = 'Assets da Exchange';
  static const String loadingAssets = 'Carregando assets...';
  static const String errorLoadingAssets = 'Erro ao carregar assets';
  static const String noAssetsFound = 'Nenhum asset encontrado';
  static const String noAssetsAvailable = 'Esta exchange não possui assets disponíveis no momento.';
  static const String assetsSingular = 'asset';
  static const String assetsPlural = 'assets';
  static const String foundSingular = 'encontrado';
  static const String foundPlural = 'encontrados';
  static const String viewAllAssets = 'Ver todos os ';
  static const String allAssets = 'Todos os Assets (';
  static const String perUnit = 'Por unidade';
  static const String balance = 'Saldo';
  static const String totalValue = 'Valor Total';
  static const String platform = 'Plataforma';
  static const String walletAddress = 'Endereço da Carteira';
  static const String usdCurrency = 'USD';
  
  // Exchange List
  static const String loadingExchanges = 'Carregando exchanges...';
  static const String errorLoadingExchanges = 'Erro ao carregar exchanges';
  static const String volumeLabel = 'Vol: ';
  
  // Common
  static const String percentSymbol = '%';
  static const String dollarSymbol = '\$';
  static const String closingParenthesis = ')';
  
  // Pluralization helpers
  static String getAssetsCount(int count) {
    final assetWord = count == 1 ? assetsSingular : assetsPlural;
    final foundWord = count == 1 ? foundSingular : foundPlural;
    return '$count $assetWord $foundWord';
  }
  
  static String getCoinsCount(int count) {
    return '$coinsLabel ($count)';
  }
  
  static String getAllAssetsTitle(int count) {
    return '$allAssets$count$closingParenthesis';
  }
  
  static String getViewAllAssetsLabel(int count) {
    return '$viewAllAssets$count $assetsPlural';
  }
  
  static String formatPercentage(double? value) {
    return value != null ? '${value}$percentSymbol' : notAvailable;
  }
  
  static String formatCurrency(double value) {
    if (value >= 1000000000000) { // Trilhões
      return '\$${(value / 1000000000000).toStringAsFixed(2)}T';
    } else if (value >= 1000000000) { // Bilhões
      return '\$${(value / 1000000000).toStringAsFixed(2)}B';
    } else if (value >= 1000000) { // Milhões
      return '\$${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value >= 1000) { // Milhares
      return '\$${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return '\$${value.toStringAsFixed(2)}';
    }
  }
  
  static String formatId(int id) {
    return '$idLabel$id';
  }
  
  static String formatLaunchedAt(String date) {
    return '$launchedAtLabel$date';
  }
  
  static String formatVolume(double? volume) {
    if (volume == null) return '$volumeLabel$notAvailable';
    return '$volumeLabel${formatCurrency(volume)}';
  }
}
