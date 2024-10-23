import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_flutter_app/modules/movie/movie_list/state/movie_list_state.dart';
import 'package:learning_flutter_app/core/providers/movie_provider.dart';

class DisplayModeTitle extends ConsumerWidget {
  const DisplayModeTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieState = ref.watch(movieListViewModelProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Movies',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          _buildDisplayModeToggle(context, ref, movieState.currentMode),
        ],
      ),
    );
  }

 Widget _buildDisplayModeToggle(BuildContext context, WidgetRef ref, MovieDisplayMode displayMode) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[100]!.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Expanded(
              child: _buildSegmentButton(
                context,
                ref,
                'Popular',
                MovieDisplayMode.popular,
                displayMode == MovieDisplayMode.popular,
              ),
            ),
            Expanded(
              child: _buildSegmentButton(
                context,
                ref,
                'Now Showing',
                MovieDisplayMode.nowShowing,
                displayMode == MovieDisplayMode.nowShowing,
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildSegmentButton(BuildContext context, WidgetRef ref, String title, MovieDisplayMode mode, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          ref.read(movieListViewModelProvider.notifier).changeDisplayMode(mode);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[700] : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blue[300]!.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.blue[700],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
