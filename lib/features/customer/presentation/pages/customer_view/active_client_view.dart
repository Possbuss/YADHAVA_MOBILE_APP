import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../data/client_active_inactive_model.dart';
import '../../bloc/client_bloc/client_list_bloc.dart';

class ActiveClientListScreen extends StatefulWidget {
  const ActiveClientListScreen({super.key});

  @override
  State<ActiveClientListScreen> createState() => _ActiveClientListScreenState();
}

class _ActiveClientListScreenState extends State<ActiveClientListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    context.read<ClientListBloc>().add(const GetActiveClientListEvent());
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return '-';
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd MMM yyyy').format(parsed);
    } catch (_) {
      return date;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Clients'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              // 🔄 Trigger refresh (call your event)
              context
                  .read<ClientListBloc>()
                  .add(const GetActiveClientListEvent(forceRefresh: true));
            },
          ),
        ],
      ),
      body: BlocBuilder<ClientListBloc, ClientListState>(
        builder: (context, state) {
          if (state is ClientListActiveLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ClientListActiveLoaded) {
            final clients = state.clientList;
            final filteredClients = _query.isEmpty
                ? clients
                : clients.where((client) {
                    final name = client.clientName ?? '';
                    return name.toLowerCase().contains(_query);
                  }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onChanged: (value) {
                      setState(() => _query = value.trim().toLowerCase());
                    },
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search clients',
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _query = '');
                              },
                              icon: const Icon(Icons.clear),
                            ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: filteredClients.isEmpty
                      ? const Center(
                          child: Text(
                            'No active clients found.',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemCount: filteredClients.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final ClientActiveInActiveModel client =
                                filteredClients[index];
                            return Card(
                              elevation: theme.cardTheme.elevation ?? 1,
                              shape: theme.cardTheme.shape ??
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor:
                                          colors.primaryContainer,
                                      child: Icon(
                                        Icons.person,
                                        color: colors.onPrimaryContainer,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            client.clientName ??
                                                'Unnamed Client',
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                size: 14,
                                                color: theme.textTheme.bodySmall
                                                        ?.color ??
                                                    colors.onSurfaceVariant,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Invoice: ${formatDate(client.invoiceDate)}',
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                  color: theme.textTheme
                                                          .bodySmall?.color ??
                                                      colors.onSurfaceVariant,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          }

          if (state is ClientListError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: colors.error),
              ),
            );
          }

          return const Center(child: Text('Tap sync to load clients.'));
        },
      ),
    );
  }
}
