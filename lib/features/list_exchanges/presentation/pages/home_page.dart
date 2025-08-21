import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:querosermb/features/list_exchanges/presentation/widgets/error_widget.dart';
import 'package:querosermb/features/list_exchanges/presentation/widgets/exchange_list_widget.dart';
import 'package:querosermb/features/list_exchanges/presentation/widgets/home_app_bar.dart';
import 'package:querosermb/features/list_exchanges/presentation/widgets/loading_widgets.dart';
import '../../../../core/theme/theme.dart';
import '../bloc/exchange_bloc.dart';
import '../bloc/exchange_event.dart';
import '../bloc/exchange_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ExchangeBloc>().add(const LoadMoreExchanges());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const HomeAppBar(),
      body: BlocBuilder<ExchangeBloc, ExchangeState>(
        builder: (context, state) => _buildBody(state),
      ),
    );
  }

  Widget _buildBody(ExchangeState state) {
    if (state is ExchangeInitial) {
      context.read<ExchangeBloc>().add(const LoadExchanges());
      return const LoadingWidget();
    }

    if (state is ExchangeLoading) {
      return const LoadingWidget();
    }

    if (state is ExchangeError) {
      return ExchangeErrorWidget(
        message: state.message,
        onRetry: () => context.read<ExchangeBloc>().add(const LoadExchanges()),
      );
    }

    if (state is ExchangeLoaded || state is ExchangeLoadingMore) {
      final exchanges = state is ExchangeLoaded
          ? state.exchanges
          : (state as ExchangeLoadingMore).currentExchanges;

      final hasReachedMax = state is ExchangeLoaded
          ? state.hasReachedMax
          : false;

      return ExchangeListWidget(
        exchanges: exchanges,
        hasReachedMax: hasReachedMax,
        scrollController: _scrollController,
      );
    }

    return const SizedBox.shrink();
  }
}
