import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import '../../viewmodel/map_notifier.dart';
import '../../../../core/auth/viewmodel/auth_notifier.dart';
import 'area_card_form.dart';
import 'area_card_info.dart';

class AreaCard extends ConsumerStatefulWidget {
  final AppLocalizations t;
  final String segmentId;
  final String name;
  final String terrain;
  final String danger;
  final VoidCallback onAdd;
  final VoidCallback onClose;
  final List<SnowType> snowTypes;
  final List<String> hazards;
  final GuideUpdateRequestOutput? guideUpdate;
  final List<SegmentUserReview> userReviews;
  const AreaCard({
    required this.t,
    required this.segmentId,
    required this.name,
    required this.terrain,
    required this.danger,
    required this.onAdd,
    required this.onClose,
    required this.snowTypes,
    required this.hazards,
    required this.userReviews,
    required this.guideUpdate,
    super.key,
  });
  @override
  ConsumerState<AreaCard> createState() => _AreaCardState();
}

class _AreaCardState extends ConsumerState<AreaCard> {
  int step = 0;
  String? selectedCategoryId;
  String? selectedSnowTypeId;
  List<String> selectedHazards = [];
  void _start() => setState(() => step = 1);
  void _backTo0() => setState(() => step = 0);
  void _toStep2(String id) => setState(() {
    selectedCategoryId = id;
    selectedSnowTypeId = id;
    step = 2;
  });
  void _pickType(String id) => setState(() => selectedSnowTypeId = id);
  void _toggleHazard(String value) => setState(() {
    if (selectedHazards.contains(value)) {
      selectedHazards = selectedHazards.where((e) => e != value).toList();
    } else {
      selectedHazards = [...selectedHazards, value];
    }
  });
  void _backTo1() => setState(() {
    selectedSnowTypeId = null;
    selectedHazards = [];
    step = 1;
  });
  void _submit() {
    if (selectedSnowTypeId == null) return;
    final selectedHazardEnums = selectedHazards
        .map((h) => Hazard.values.byName(h))
        .toList();
    final request = ApiV1SegmentsIdReviewsPostRequest(
      snowType: selectedSnowTypeId!,
      hazards: selectedHazardEnums,
    );
    ref
        .read(reviewNotifierProvider.notifier)
        .submit(segmentId: widget.segmentId, review: request);
    setState(() {
      step = 0;
      selectedCategoryId = null;
      selectedSnowTypeId = null;
      selectedHazards = [];
    });
  }

  Widget _buildStep(bool canAddObservation) {
    switch (step) {
      case 0:
        return AreaCardInfo(
          t: widget.t,
          danger: widget.danger,
          snowTypes: widget.snowTypes,
          guideUpdate: widget.guideUpdate,
          userReviews: widget.userReviews,
          onAdd: _start,
          onClose: widget.onClose,
          canAddObservation: canAddObservation,
        );
      case 1:
        return AreaCardSelectCategoryStep(
          t: widget.t,
          snowTypes: widget.snowTypes
              .where((st) => st.primarySnowTypeId == null)
              .toList(),
          onPick: _toStep2,
          onBack: _backTo0,
        );
      default:
        return AreaCardSpecifyTypeStep(
          t: widget.t,
          segmentId: widget.segmentId,
          allTypes: widget.snowTypes,
          selectedCategoryId: selectedCategoryId,
          selectedSnowTypeId: selectedSnowTypeId,
          hazards: widget.hazards,
          selectedHazards: selectedHazards,
          onPickType: _pickType,
          onToggleHazard: _toggleHazard,
          onBack: _backTo1,
          onSubmit: _submit,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(loggedInRoleProvider);
    final canAddObservation = role != null;
    final maxHeight = MediaQuery.of(context).size.height * 0.8;
    final maxWidth = MediaQuery.of(context).size.width * 0.8;
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(widget.terrain, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Flexible(
                child: SingleChildScrollView(
                  child: _buildStep(canAddObservation),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
