import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:movies/features/search/presentation/view_models/search_view_model.dart';

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchViewModel(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Consumer<SearchViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                const SizedBox(height: 20),
                // Stylized Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF282A28), // Dark grey bar
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    onChanged: viewModel.updateSearchQuery,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'search'.tr(),
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),

                const Spacer(),

                // Empty State Illustration (only if not searching/no results)
                if (!viewModel.isSearching)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/no_results.png',
                        width: 200,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.movie_creation_outlined,
                              size: 100,
                              color: Colors.white24,
                            ),
                      ),
                    ],
                  ),

                // If searching, show results list (placeholder)
                if (viewModel.isSearching)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Searching...',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),

                const Spacer(),
              ],
            );
          },
        ),
      ),
    );
  }
}
