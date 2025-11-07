import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinestex_flutter_demo/content/cubit/default_cubit.dart';
import 'package:kinestex_sdk_flutter/kinestex_sdk.dart';
import 'package:kinestex_flutter_demo/content/content_detail_view.dart';

class ContentView extends StatefulWidget {
  const ContentView({super.key});

  @override
  State<ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  ContentType _selectedContent = ContentType.workout;
  FilterType _selectedFilter = FilterType.none;
  SearchType _selectedSearchType = SearchType.findById;
  List<BodyPart> _selectedBodyParts = [];
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DefaultCubit, DefaultState>(
      listenWhen: (previous, current) =>
          (previous.workouts.isEmpty && current.workouts.isNotEmpty) ||
          (previous.exercises.isEmpty && current.exercises.isNotEmpty) ||
          (previous.plans.isEmpty && current.plans.isNotEmpty),
      listener: (context, state) {
        if (state.workouts.isNotEmpty ||
            state.exercises.isNotEmpty ||
            state.plans.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContentDetailView(
                title: _selectedContent.name[0].toUpperCase() +
                    _selectedContent.name.substring(1),
                contentType: _selectedContent,
              ),
            ),
          ).then((value) {
            context.read<DefaultCubit>().clearWorkouts();
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildContentTypeSelection(),
                  _buildFilterTypeSelection(),
                  if (_selectedFilter == FilterType.none)
                    _buildSearchTypeSelection(),
                  _selectedFilter != FilterType.bodyParts
                      ? _buildEnterPlanWidget()
                      : _buildSelectBodyParts(),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      color: Colors.blue,
                      child: state.isLoading
                          ? CupertinoActivityIndicator(color: Colors.white)
                          : Text(
                              "View ${_selectedContent.name[0].toUpperCase() + _selectedContent.name.substring(1)}",
                              style: TextStyle(color: Colors.white),
                            ),
                      onPressed: () => _fetchContent(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContentTypeSelection() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Content Type:",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: CupertinoSlidingSegmentedControl<ContentType>(
              groupValue: _selectedContent,
              padding: const EdgeInsets.all(6),
              children: {
                ContentType.workout: const Text("Workout"),
                ContentType.plan: const Text("Plan"),
                ContentType.exercise: const Text("Exercise"),
              },
              onValueChanged: (v) {
                setState(() => _selectedContent = v!);
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      );

  Widget _buildFilterTypeSelection() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filter By:",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: CupertinoSlidingSegmentedControl<FilterType>(
              groupValue: _selectedFilter,
              padding: const EdgeInsets.all(6),
              children: {
                FilterType.none: const Text("None"),
                FilterType.category: const Text("Category"),
                FilterType.bodyParts: const Text("Body Parts"),
              },
              onValueChanged: (v) {
                setState(() => _selectedFilter = v!);
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      );

  Widget _buildSearchTypeSelection() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Serach By:",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: CupertinoSlidingSegmentedControl<SearchType>(
              groupValue: _selectedSearchType,
              padding: const EdgeInsets.all(6),
              children: {
                SearchType.findById: const Text("Find By ID"),
                SearchType.findByTitle: const Text("Find By Title"),
              },
              onValueChanged: (v) {
                setState(() => _selectedSearchType = v!);
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      );

  Widget _buildEnterPlanWidget() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getEnterPlanTitle(),
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          ),
          const SizedBox(height: 8),
          CupertinoTextField(
            placeholder: "Cardio",
            controller: _searchController,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          ),
          const SizedBox(height: 24),
        ],
      );

  String getEnterPlanTitle() {
    return "Enter ${_selectedFilter == FilterType.none ? "${_selectedContent.name[0].toUpperCase() + _selectedContent.name.substring(1)} ${_selectedSearchType == SearchType.findById ? "ID" : "Title"}" : "Category"}";
  }

  Widget _buildSelectBodyParts() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter Body Parts",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: kToolbarHeight - 16,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: BodyPart.values
                  .map(
                    (e) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          onPressed: () {
                            if (!_selectedBodyParts.contains(e)) {
                              setState(() {
                                _selectedBodyParts.add(e);
                              });
                            } else {
                              setState(() {
                                _selectedBodyParts.remove(e);
                              });
                            }
                          },
                          color: _selectedBodyParts.contains(e)
                              ? Colors.blue
                              : Colors.grey,
                          child: Center(
                            child: Text(
                              e.name[0].toUpperCase() + e.name.substring(1),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 24),
        ],
      );

  void _fetchContent() {
    final cubit = context.read<DefaultCubit>();

    String? id;
    String? title;
    String? category;
    List<BodyPart>? bodyParts;

    if (_selectedFilter == FilterType.none) {
      if (_selectedSearchType == SearchType.findById) {
        id = _searchController.text.isNotEmpty ? _searchController.text : null;
      } else if (_selectedSearchType == SearchType.findByTitle) {
        title =
            _searchController.text.isNotEmpty ? _searchController.text : null;
      }
    }

    if (_selectedFilter == FilterType.category) {
      category =
          _searchController.text.isNotEmpty ? _searchController.text : null;
    }

    if (_selectedFilter == FilterType.bodyParts) {
      bodyParts = _selectedBodyParts.isNotEmpty ? _selectedBodyParts : null;
    }

    cubit.getWorkouts(id, title, _selectedContent, category, bodyParts);
  }
}
